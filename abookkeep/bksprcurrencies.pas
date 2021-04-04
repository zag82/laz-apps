unit bksprcurrencies;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  StdCtrls, Grids, bkdata;

type

  { TfmSprCurrencies }

  TfmSprCurrencies = class(TForm)
    btCancel: TButton;
    btOK: TButton;
    pnlControl: TPanel;
    sg: TStringGrid;
    procedure btCancelClick(Sender: TObject);
    procedure btOKClick(Sender: TObject);
    procedure sgEditingDone(Sender: TObject);
  private

  public
    Cur: TbkCurrencyValues;
    procedure Init(ACurValues: TbkCurrencyValues);
  end;

var
  fmSprCurrencies: TfmSprCurrencies;

implementation

{$R *.lfm}

{ TfmSprCurrencies }

procedure TfmSprCurrencies.btCancelClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TfmSprCurrencies.btOKClick(Sender: TObject);
var
  i: integer;
begin
  for i := 1 to sg.RowCount-1 do
    Cur[TbkCurrencyTypes(i)] := StrToIntDef(sg.Cells[1, i], 1);
  ModalResult := mrOK;
end;

procedure TfmSprCurrencies.sgEditingDone(Sender: TObject);
begin
  sg.Cells[1, sg.Row] := IntToStr(StrToIntDef(sg.Cells[1, sg.Row], 1));
end;

procedure TfmSprCurrencies.Init(ACurValues: TbkCurrencyValues);
var
  ct: TbkCurrencyTypes;
  irow: integer;
begin
  for ct := Low(ACurValues) to High(ACurValues) do
    Cur[ct] := ACurValues[ct];

  irow := 1;
  for ct := Low(ACurValues) to High(ACurValues) do
    if ct <> curRUR then
    begin
      sg.Cells[0, irow] := cCurrencyNames[ct];
      sg.Cells[1, irow] := IntToStr(Cur[ct]);
      irow += 1;
    end;
  sg.RowCount := irow;
end;

end.

