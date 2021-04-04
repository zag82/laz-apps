program amenu;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Interfaces, // this includes the LCL widgetset
  Forms, mainmenu, UniqueInstanceBase, uniqueinstanceraw;

{$R *.res}

begin
  if InstanceRunning('amenu') then
    Exit;

  RequireDerivedFormResource := True;
  Application.Initialize;
  Application.CreateForm(TfmMainMenu, fmMainMenu);
  Application.Run;
end.

