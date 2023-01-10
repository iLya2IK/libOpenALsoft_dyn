program recorder;

uses
  {$ifdef LINUX}
  cthreads,
  {$endif}
  Classes, SysUtils, OGLOpenALWrapper, OALWavDataHelpers;

const cCaptureFile = '..'+DirectorySeparator+
                                          'media'+DirectorySeparator+'capture.wav';
      {$ifdef Windows}
      cOALDLL = '..\libs\soft_oal.dll';
      {$endif}

var
  OALCapture : TOALCapture;
  dt: Integer;
begin
  {$ifdef Windows}
  if TOpenAL.OALLibsLoad([cOALDLL]) then
  {$else}
  if TOpenAL.OALLibsLoadDefault then
  {$endif}
  begin
    OALCapture := TOALCapture.Create;
    try
      try
        OALCapture.DataRecClass := TOALWavDataRecorder;
        OALCapture.Init;
        if OALCapture.SaveToFile(cCaptureFile) then
        begin
          OALCapture.Start;

          dt := 0;
          while dt < 1000 do begin
            OALCapture.Proceed;
            TThread.Sleep(10);
            inc(dt);
          end;

          OALCapture.Stop;

          WriteLn('Capturing completed successfully!');

        end else
          WriteLn('Cant save to wav file');

      except
        on e : Exception do WriteLn(e.ToString);
      end;
    finally
      OALCapture.Free;
    end;
    TOpenAL.OALLibsUnLoad;
  end else
    WriteLn('Cant load libraries');
  ReadLn;
end.


