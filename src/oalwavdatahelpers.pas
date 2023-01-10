{
 OALWavDataHelpers:
   Data reader/writer for WAV-format files.
   Uses source of
    fpwavreader.pas/fpwavwriter.pas - part of FPC

   Copyright (c) 2023 by Ilya Medvedkov

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
}

unit OALWavDataHelpers;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, OGLOpenALWrapper, fpwavformat;

type

  { TOALWavDataRecorder }

  TOALWavDataRecorder = class(TOALStreamDataRecorder)
  private
    FWavFormat : TWaveFormat;
    FStream    : TStream;
    FOwnStream : Boolean;
  private
    procedure CloseAudioFile;
    function FlushHeader: Boolean;
  public
    constructor Create(aFormat : TOALFormat; aFreq : Cardinal); override;
    destructor Destroy; override;
    function SaveToFile(const Fn : String) : Boolean; override;
    function SaveToStream(Str : TStream) : Boolean; override;

    procedure StopRecording; override;

    function WriteSamples(const Buffer : Pointer;
                          Count : Integer) : Integer; override;
  end;

  { TOALWavDataSource }

  TOALWavDataSource = class(TOALStreamDataSource)
  private
    DataChunk: TChunkHeader;
    ChunkPos: Int64;
    EoF: Boolean;
    FZeroChunkPos : Int64;

    fStream: TStream;
    FOwnStream: Boolean;

    FWavFormat : TWaveFormat;
    procedure ResetStream;
    procedure Clean;
  public
    constructor Create; override;
    destructor Destroy; override;
    function LoadFromFile(const Fn : String) : Boolean; override;
    function LoadFromStream(Str : TStream) : Boolean; override;

    function ReadChunk(const Buffer : Pointer;
                         Pos : Int64;
                         Sz : Integer;
                         isloop : Boolean;
                         var fmt : TOALFormat;
                         var freq : Cardinal) : Integer; override;
  end;

implementation

procedure NtoLE(var fmt: TWaveFormat); overload;
begin
  with fmt, ChunkHeader do begin
    Size := NtoLE(Size);
    Format := NtoLE(Format);
    Channels := NtoLE(Channels);
    SampleRate := NtoLE(SampleRate);
    ByteRate := NtoLE(ByteRate);
    BlockAlign := NtoLE(BlockAlign);
    BitsPerSample := NtoLE(BitsPerSample);
  end;
end;

procedure LEtoN(var fmt: TWaveFormat); overload;
begin
  with fmt, ChunkHeader do begin
    Size := LEtoN(Size);
    Format := LEtoN(Format);
    Channels := LEtoN(Channels);
    SampleRate := LEtoN(SampleRate);
    ByteRate := LEtoN(ByteRate);
    BlockAlign := LEtoN(BlockAlign);
    BitsPerSample := LEtoN(BitsPerSample);
  end;
end;

{ TOALWavDataRecorder }

procedure TOALWavDataRecorder.CloseAudioFile;
begin
  if Assigned(FStream) then
  begin
    FlushHeader;
    if FOwnStream then
      FreeAndNil(FStream) else
      FStream := nil;
  end;
end;

function TOALWavDataRecorder.FlushHeader : Boolean;
var
  riff: TRiffHeader;
  fmtLE: TWaveFormat;
  DataChunk: TChunkHeader;
  Pos: Int64;
begin
  Pos := fStream.Position;
  with riff, ChunkHeader do begin
    ID := AUDIO_CHUNK_ID_RIFF;
    Size := NtoLE(Pos - SizeOf(ChunkHeader));
    Format := AUDIO_CHUNK_ID_WAVE;
  end;
  fmtLE := FWavFormat;
  NtoLE(fmtLE);
  with fStream do begin
    Position := 0;
    Result := Write(riff, SizeOf(riff)) = SizeOf(riff);
    Result := Result and (Write(fmtLE, sizeof(fmtLE)) = SizeOf(fmtLE));
  end;
  with DataChunk do begin
    Id := AUDIO_CHUNK_ID_data;
    Size := Pos - SizeOf(DataChunk) - fStream.Position;
  end;
  with fStream do begin
    Result := Result and (Write(DataChunk, SizeOf(DataChunk)) = SizeOf(DataChunk));
  end;
end;

constructor TOALWavDataRecorder.Create(aFormat : TOALFormat; aFreq : Cardinal);
begin
  inherited Create(aFormat, aFreq);

  FStream := nil;
  FOwnStream := false;

  case aFormat of
    oalfMono8, oalfStereo8 :  FWavFormat.BitsPerSample := 8;
    oalfMono16, oalfStereo16 :  FWavFormat.BitsPerSample := 16;
  end;
  case aFormat of
    oalfStereo16, oalfStereo8 :  FWavFormat.Channels := 2;
  else
    FWavFormat.Channels := 1;
  end;
  FWavFormat.SampleRate := aFreq;
  FWavFormat.Format := WAVE_FORMAT_PCM;
end;

destructor TOALWavDataRecorder.Destroy;
begin
  CloseAudioFile;
  inherited Destroy;
end;

function TOALWavDataRecorder.SaveToFile(const Fn : String) : Boolean;
begin
  fStream := TFileStream.Create(Fn, fmCreate + fmOpenWrite);
  if Assigned(fStream) then begin
    Result := SaveToStream(fStream);
    FOwnStream := True;
  end else begin
    Result := False;
  end;
end;

function TOALWavDataRecorder.SaveToStream(Str : TStream) : Boolean;
begin
  fStream := Str;
  FOwnStream := False;
  with FWavFormat, ChunkHeader do begin
    ID := AUDIO_CHUNK_ID_fmt;
    Size := SizeOf(FWavFormat) - SizeOf(ChunkHeader);
    Format := AUDIO_FORMAT_PCM;
  end;
  Result := FlushHeader;
end;

procedure TOALWavDataRecorder.StopRecording;
begin
  CloseAudioFile;
end;

function TOALWavDataRecorder.WriteSamples(const Buffer : Pointer;
  Count : Integer) : Integer;
var
  wsz, bsz: Integer;
begin
  Result := 0;
  with fStream do begin

    bSz := SamplesToBytes(Count);

    wsz := Write(Buffer^, bSz);
    if wsz < 0 then Exit;
    Inc(Result, wsz);
  end;
end;

{ TOALWavDataSource }

procedure TOALWavDataSource.ResetStream;
begin
  DataChunk.Size := 0;
  ChunkPos := 0;
  EoF := false;
end;

procedure TOALWavDataSource.Clean;
begin
  if Assigned(fStream) and FOwnStream then
    FreeAndNil(fStream) else
    fStream := nil;
  FZeroChunkPos := 0;
  ResetStream;
end;

constructor TOALWavDataSource.Create;
begin
  fStream := nil;
  FOwnStream := false;
  FZeroChunkPos := 0;
  ResetStream;
end;

destructor TOALWavDataSource.Destroy;
begin
  Clean;
  inherited Destroy;
end;

function TOALWavDataSource.LoadFromFile(const Fn : String) : Boolean;
var Str : TStream;
begin
  Str := TFileStream.Create(fn, fmOpenRead + fmShareDenyWrite);
  if Assigned(Str) then begin
    Result := LoadFromStream(Str);
    FOwnStream := True;
    Format := TOpenAL.OALFormat(FWavFormat.Channels,
                                 FWavFormat.BitsPerSample);
    Frequency := FWavFormat.SampleRate;
  end else begin
    Result := False;
  end;
end;

function TOALWavDataSource.LoadFromStream(Str : TStream) : Boolean;
var
  riff: TRiffHeader;
begin
  Clean;
  fStream := Str;
  FOwnStream := false;
  Result := fStream.Read(riff, sizeof(riff)) = sizeof(riff);
  riff.ChunkHeader.Size := LEtoN(riff.ChunkHeader.Size);
  Result := Result and (riff.ChunkHeader.ID = AUDIO_CHUNK_ID_RIFF) and (riff.Format = AUDIO_CHUNK_ID_WAVE);
  Result := Result and (fStream.Read(FWavFormat, sizeof(FWavFormat)) = sizeof(FWavFormat));
  LEtoN(FWavFormat);
  Result := Result and (FWavFormat.ChunkHeader.ID = AUDIO_CHUNK_ID_fmt) and ((FWavFormat.ChunkHeader.Size + 8) >= sizeof(FWavFormat));
  if Result and ((FWavFormat.ChunkHeader.Size + 8) > sizeof(FWavFormat)) then
    fStream.Seek(Align((FWavFormat.ChunkHeader.Size + 8) - sizeof(FWavFormat), 2), soCurrent);
  FZeroChunkPos := fStream.Position;
end;

function Min(a, b: Integer): Integer;
begin
  if a < b then begin
    Result := a;
  end else begin
    Result := b;
  end;
end;

function TOALWavDataSource.ReadChunk(const Buffer : Pointer; Pos : Int64;
  Sz : Integer; isloop : Boolean; var fmt : TOALFormat; var freq : Cardinal
  ) : Integer;
var
  rsz: Integer;
  p: PByte absolute Buffer;
  i: Integer;
begin
  freq := Frequency;
  fmt := Format;

  if not Assigned(fStream) then Exit(-1);

  //looping magic
  if EoF and isloop then
  begin
    if fStream.Position <> FZeroChunkPos then
    begin
      fStream.Position := FZeroChunkPos;
      ResetStream;
    end;
  end;

  i := 0;
  while (not EoF) and (i < Sz) do begin
    if ChunkPos >= DataChunk.Size then begin
      rsz := fstream.Read(DataChunk, sizeof(DataChunk));
      EoF := rsz < sizeof(DataChunk);
      if not EoF then begin
        DataChunk.Size := LEtoN(DataChunk.Size);
        if DataChunk.Id <> AUDIO_CHUNK_ID_data then begin
          ChunkPos := DataChunk.Size;
          fstream.Seek(DataChunk.Size, soCurrent);
        end
        else
          ChunkPos := 0;
      end;
    end else begin
      rsz := Min(Sz, DataChunk.Size - ChunkPos);
      rsz := fStream.Read(p[i], rsz);
      EoF := rsz <= 0;
      Inc(ChunkPos, rsz);
      Inc(i, rsz);
    end;
  end;
  Result := i;
end;

end.

