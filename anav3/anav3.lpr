program anav3;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Interfaces, // this includes the LCL widgetset
  SysUtils, Forms, lazcontrols, mainnav, navdata, settings, createnav,
  uniqueinstancebase, uniqueinstanceraw;

{$R *.res}

begin
  if InstanceRunning('anav3') then
    Exit;

  Randomize;
  RequireDerivedFormResource := True;
  Application.Initialize;

  // if there are no data file then create it in interactive mode
  if not FileExists(navSettings.FileName) then
    Application.CreateForm(TfmCreateNav, fmCreateNav)
  else
    Application.CreateForm(TfmMainNav3, fmMainNav3);
  Application.Run;
end.

