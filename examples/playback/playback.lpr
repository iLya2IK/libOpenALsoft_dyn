program playback;

uses 
  {$ifdef LINUX}
  cthreads,
  {$endif}   
  Classes, OGLOpenALWrapper, fpwavformat, fpwavreader;

const MAX_READ_CHUNK = 20 * 1024*1024;
      cPlaybackFile = '..'+DirectorySeparator+
                                          'media'+DirectorySeparator+'back.wav';
      {$ifdef Windows}
      cOALDLL = '..\libs\soft_oal.dll';
      {$endif}

var
  OALDevice : IOALDevice;
  OALContext : IOALContext;
  OALListener : IOALListener;
  OALSource : IOALSource;
  OALBuffer : IOALBuffer;

  WavFile : TWavReader;
  fmt : TOALFormat;

  WavBuffer : Pointer;
  WavSize : Integer;

  SL : TStringList;
  i : integer;
begin
  {$ifdef Windows}
  if TOpenAL.OALLibsLoad([cOALDLL]) then
  {$else}
  if TOpenAL.OALLibsLoadDefault then
  {$endif}
  begin
    SL := TOpenAL.ListOfAllOutputDevices;
    if Assigned(SL) then
    begin
      if SL.Count > 0 then
      begin
        WriteLn('Avaible Devices (cnt = ', SL.Count, ') :');
        for i := 0 to SL.Count-1 do
          WriteLn(SL[i]);
        try
          OALDevice := TOpenAL.OpenOutputDevice(SL[0]);
          if OALDevice.Valid then
          begin
            OALContext := TOpenAL.CreateContext(OALDevice);
            if OALContext.Valid then
            begin
              if OALContext.MakeCurrent then
              begin
                OALListener := OALContext.Listener;
                OALListener.SetPosition(TOpenAL.Vector(0,0,1));
                OALListener.SetVelocity(TOpenAL.ZeroVector);
                OALListener.SetOrientation(TOpenAL.VectorPair(0,0,1,0,1,0));

                OALSource := OALContext.GenSource;
                OALSource.Pitch := 1.0;
                OALSource.Gain := 1.0;
                OALSource.Position := TOpenAL.ZeroVector;
                OALSource.Velocity := TOpenAL.ZeroVector;
                OALSource.Looping := false;

                OALBuffer := TOpenAL.GenBuffer;

                WavFile := TWavReader.Create;
                try
                  if WavFile.LoadFromFile(cPlayBackFile) then
                  begin
                    fmt := TOpenAL.OALFormat(WavFile.fmt.Channels,
                                             WavFile.fmt.BitsPerSample);

                    WavBuffer := GetMem(MAX_READ_CHUNK);

                    try
                      WavSize := WavFile.ReadBuf(WavBuffer^, MAX_READ_CHUNK);
                      OALBuffer.Data(fmt, WavBuffer, WavSize, WavFile.fmt.SampleRate);
                    finally
                      FreeMem(WavBuffer);
                    end;

                    OALSource.SetBuffer(OALBuffer);

                    OALSource.Play;

                    while (OALSource.State = oalsPlaying) do begin
                      TThread.Sleep(10); 
                    end;

                    WriteLn('Playing completed successfully!');

                  end else
                    WriteLn('Cant load wav file');
                finally
                  WavFile.Free;
                end;
              end else
                WriteLn('Cant make context current');
            end else
              WriteLn('Cant create context');
          end else
            WriteLn('Cant open device ', SL[0]);
        finally
          SL.Free;
        end;
      end else
        WriteLn('No devices found');
    end;
    TOpenAL.OALLibsUnLoad;
  end else
    WriteLn('Cant load libraries');
  ReadLn;
end.

