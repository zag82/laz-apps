unit propsproj;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  ExtCtrls, Grids, dataproj, Types;

type

  { TfmPropsProj }

  TfmPropsProj = class(TForm)
    btOk: TButton;
    btCancel: TButton;
    cDlg: TColorDialog;
    gbMain: TGroupBox;
    lbColors: TLabel;
    lbDescr: TLabel;
    mmDescr: TMemo;
    pnlControl: TPanel;
    sgColors: TStringGrid;
    procedure btCancelClick(Sender: TObject);
    procedure btOkClick(Sender: TObject);
    procedure sgColorsClick(Sender: TObject);
    procedure sgColorsDrawCell(Sender: TObject; aCol, aRow: Integer; aRect: TRect; aState: TGridDrawState);
  private
    FData: TProjData;
  public
    procedure Init(AData: TProjData);
  end;

var
  fmPropsProj: TfmPropsProj;

implementation

{$R *.lfm}

{ TfmPropsProj }

procedure TfmPropsProj.Init(AData: TProjData);
var
  i: integer;
begin
  FData := AData;
  mmDescr.Text := FData.Description;
  sgColors.RowCount := Length(cProjectColorNames)+1;
  for i := 0 to high(cProjectColorNames) do
  begin
    sgColors.Cells[0, i+1] := cProjectColorNames[i];
    sgColors.Cells[1, i+1] := IntToStr(FData.Colors[TProjColors(i)]);
  end;
end;

procedure TfmPropsProj.sgColorsClick(Sender: TObject);
begin
  if sgColors.Col = 1 then
  begin
    cDlg.Color := STrToInt(sgColors.Cells[1, sgColors.Row]);
    if cDlg.Execute then
      sgColors.Cells[1, sgColors.Row] := IntToStr(cDlg.Color);
    sgColors.Update;
  end;
end;

procedure TfmPropsProj.sgColorsDrawCell(Sender: TObject; aCol, aRow: Integer;
  aRect: TRect; aState: TGridDrawState);
var
  c: TColor;
begin
  if (aCol = 1) and (aRow > 0) then
  begin
    c := StrToInt(sgColors.Cells[aCol, aRow]);
    sgColors.Canvas.Brush.Style := bsSolid;
    sgColors.Canvas.Brush.Color := c;
    sgColors.Canvas.FillRect(aRect);
  end;
end;

procedure TfmPropsProj.btOkClick(Sender: TObject);
var
  c: TProjColors;
begin
  FData.Description := mmDescr.Text;
  for c := low(TProjColors) to high(TProjColors) do
    FData.Colors[c] := StrToInt(sgColors.Cells[1, ord(c)+1]);
  ModalResult := mrOK;
end;

procedure TfmPropsProj.btCancelClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

end.

