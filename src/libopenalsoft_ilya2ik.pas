{ This file was automatically created by Lazarus. Do not edit!
  This source is only used to compile and install the package.
 }

unit libopenalsoft_ilya2ik;

{$warn 5023 off : no warning about unused units}
interface

uses
  libOpenALsoft_dyn, OGLOpenALWrapper, OALWavDataHelpers, LazarusPackageIntf;

implementation

procedure Register;
begin
end;

initialization
  RegisterPackage('libopenalsoft_ilya2ik', @Register);
end.
