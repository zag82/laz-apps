unit pfunc;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, Buttons,
  ExtCtrls, graphproj, dataproj;

type

  { TfmPFunc }

  TfmPFunc = class(TForm)
    bv2: TBevel;
    bv1: TBevel;
    btMove: TButton;
    btMoveObject: TButton;
    cbCatet1: TCheckBox;
    cbCatet2: TCheckBox;
    cbMirror: TCheckBox;
    cbPolar: TCheckBox;
    edDist1: TEdit;
    edDist2: TEdit;
    edAngle: TEdit;
    gb: TGroupBox;
    lbAngle: TLabel;
    lbPointChange: TLabel;
    lbInfoChange: TLabel;
    lbDist1: TLabel;
    lbInfo1: TLabel;
    lbPoint2: TLabel;
    lbInfo2: TLabel;
    lbPoint1: TLabel;
    lbDist2: TLabel;
    btPointChange: TSpeedButton;
    btPoint1: TSpeedButton;
    btPoint2: TSpeedButton;
    tm: TTimer;
    procedure btMoveClick(Sender: TObject);
    procedure btMoveObjectClick(Sender: TObject);
    procedure btPoint1Click(Sender: TObject);
    procedure btPoint2Click(Sender: TObject);
    procedure btPointChangeClick(Sender: TObject);
    procedure cbMirrorClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure tmTimer(Sender: TObject);
  private
    FGraph: TProjGraph;
    FFilling: boolean;
    procedure UpdateValues();
  public
    procedure Init(AGraph: TProjGraph);
  end;

var
  fmPFunc: TfmPFunc;

implementation

uses
  LCLType, mainproj;

{$R *.lfm}

{ TfmPFunc }

procedure TfmPFunc.Init(AGraph: TProjGraph);
begin
  FFilling := False;
  FGraph := AGraph;
  FGraph.PFunc := True;
  FGraph.FuncClear();
  UpdateValues();
  FGraph.Paint();
  tm.Enabled := True;
end;

procedure TfmPFunc.UpdateValues();
begin
  FFilling := True;
  try
    // активности
    cbMirror.Enabled := not cbPolar.Checked;
    cbCatet1.Enabled := not cbPolar.Checked;
    cbCatet2.Enabled := not cbPolar.Checked;

    edDist1.Enabled := True; //cbPolar.Checked or (not cbCatet2.Checked);
    edDist2.Enabled := (not cbPolar.Checked) and (not cbCatet1.Checked);
    edAngle.Enabled := cbPolar.Checked;
    btPoint2.Enabled := not cbPolar.Checked;

    // информация по точкам
    lbInfo1.Caption := FGraph.FuncCaption(1);
    lbInfo2.Caption := FGraph.FuncCaption(2);
    lbInfoChange.Caption := FGraph.FuncCaption(0);
  finally
    FFilling := False;
  end;
end;

procedure TfmPFunc.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  tm.Enabled := False;
  CloseAction := caFree;
  FGraph.PFunc := False;
  FGraph.Paint();
  fmPFunc := nil;
end;

procedure TfmPFunc.btMoveClick(Sender: TObject);
begin
  FGraph.FuncMove(False);
  FGraph.FuncClear();
  UpdateValues();
  FGraph.Paint();
  fmMainProj.SetModified();
end;

procedure TfmPFunc.btMoveObjectClick(Sender: TObject);
begin
  FGraph.FuncMove(True);
  FGraph.FuncClear();
  UpdateValues();
  FGraph.Paint();
  fmMainProj.SetModified();
end;

procedure TfmPFunc.btPoint1Click(Sender: TObject);
begin
  btPointChange.Caption := '...';
  btPoint1.Caption := 'o';
  btPoint2.Caption := '...';
  FGraph.FuncSelectPoint(1);
  UpdateValues();
end;

procedure TfmPFunc.btPoint2Click(Sender: TObject);
begin
  btPointChange.Caption := '...';
  btPoint1.Caption := '...';
  btPoint2.Caption := 'o';
  FGraph.FuncSelectPoint(2);
  UpdateValues();
end;

procedure TfmPFunc.btPointChangeClick(Sender: TObject);
begin
  btPointChange.Caption := 'o';
  btPoint1.Caption := '...';
  btPoint2.Caption := '...';
  FGraph.FuncSelectPoint(0);
  UpdateValues();
end;

procedure TfmPFunc.cbMirrorClick(Sender: TObject);
begin
  if FFilling then
    Exit;
  FGraph.FuncCalc(
    cbMirror.Checked,
    cbPolar.Checked,
    cbCatet1.Checked,
    cbCatet2.Checked,
    StrToFloatDef(edDist1.Text, 0),
    StrToFloatDef(edDist2.Text, 0),
    StrToFloatDef(edAngle.Text, 0)
  );
  UpdateValues();
end;

procedure TfmPFunc.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_ESCAPE then
    Close;
end;

procedure TfmPFunc.tmTimer(Sender: TObject);
begin
  if FGraph.FuncPoint() then
  begin
    btPointChange.Caption := '...';
    btPoint1.Caption := '...';
    btPoint2.Caption := '...';
    UpdateValues();
    cbMirrorClick(Self);
  end;
end;

end.

