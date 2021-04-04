program abook;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Interfaces, // this includes the LCL widgetset
  Forms, tachartlazaruspkg, datetimectrls, mainbook, bkdata,
  streamdata, bktranssimple, bktransstart, bktranstrans,
  bksprcurrencies, bkspraccounts, bksprcategories,
  bkbudget, bkcal, bkcalselect, uniqueinstancebase, uniqueinstanceraw;

{$R *.res}

begin
  if InstanceRunning('abook') then
    Exit;
  RequireDerivedFormResource:=True;
  Application.Initialize;
  Application.CreateForm(TfmMainBook, fmMainBook);
  Application.Run;
end.

