program player;

uses
  {$ifdef LINUX}
  cthreads,
  {$endif}
  Classes, SysUtils, OGLOpenALWrapper, OALWavDataHelpers;

const cPlaybackFile = '..'+DirectorySeparator+
                                          'media'+DirectorySeparator+'back.wav';
      {$ifdef Windows}
      cOALDLL = '..\libs\soft_oal.dll';
      {$endif}

var
  OALPlayer : TOALPlayer;
begin
  {$ifdef Windows}
  if TOpenAL.OALLibsLoad([cOALDLL]) then
  {$else}
  if TOpenAL.OALLibsLoadDefault then
  {$endif}
  begin
    OALPlayer := TOALPlayer.Create;
    try
      try
        OALPlayer.DataSourceClass := TOALWavDataSource;
        OALPlayer.Init;
        if OALPlayer.LoadFromFile(cPlayBackFile) then
        begin
          OALPlayer.Play;

          while (OALPlayer.Status = oalsPlaying) do begin
            OALPlayer.Stream.Proceed;
            TThread.Sleep(10);
          end;

          WriteLn('Playing completed successfully!');

        end else
          WriteLn('Cant load wav file');

      except
        on e : Exception do WriteLn(e.ToString);
      end;
    finally
      OALPlayer.Free;
    end;
    TOpenAL.OALLibsUnLoad;
  end else
    WriteLn('Cant load libraries');
  ReadLn;
end.


