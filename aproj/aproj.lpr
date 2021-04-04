program aproj;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Interfaces, // this includes the LCL widgetset
  Forms, mainproj, dataproj, graphproj, aboutproj, propsproj, pfunc,
  simpleobject, treebase, meshcontrol, dialogfiles
  { you can add units after this };

{$R *.res}

begin
  Randomize;
  RequireDerivedFormResource:=True;
  Application.Initialize;
  Application.CreateForm(TfmMainProj, fmMainProj);
  Application.CreateForm(TfmDialogFiles, fmDialogFiles);
  Application.Run;
end.

