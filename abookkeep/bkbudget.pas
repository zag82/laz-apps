unit bkbudget;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, StdCtrls,
  bkdata;

type

  { TfmBudget }

  TfmBudget = class(TForm)
    btCancel: TButton;
    btOK: TButton;
    cbType: TComboBox;
    cbReady: TCheckBox;
    edReady: TEdit;
    edName: TEdit;
    edValue: TEdit;
    gbMain: TGroupBox;
    lbReady: TLabel;
    lbAccount: TLabel;
    lbName: TLabel;
    lbValue: TLabel;
    pnlControl: TPanel;
    procedure btCancelClick(Sender: TObject);
    procedure btOKClick(Sender: TObject);
    procedure cbReadyChange(Sender: TObject);
    procedure cbTypeChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    FBL: TbkBudgetLine;
  public
    procedure Init(ABudgetLine: TbkBudgetLine);

    property BL: TbkBudgetLine read FBL;
  end;

var
  fmBudget: TfmBudget;

implementation

{$R *.lfm}

{ TfmBudget }

procedure TfmBudget.Init(ABudgetLine: TbkBudgetLine);
begin
  if Assigned(ABudgetLine) then
  begin
    FBL.Name := ABudgetLine.Name;
    FBL.Value := ABudgetLine.Value;
    FBL.Typ := ABudgetLine.Typ;
    FBL.Ready := ABudgetLine.Ready;
    FBL.ReadyValue := ABudgetLine.ReadyValue;
  end;
  edName.Text := FBL.Name;
  edValue.Text := IntToStr(FBL.Value);
  cbType.ItemIndex := Ord(FBL.Typ);
  cbReady.Checked := FBL.Ready;
  edReady.Text := IntToStr(FBL.ReadyValue);
  cbTypeChange(cbType);
end;

procedure TfmBudget.FormCreate(Sender: TObject);
begin
  FBL := TbkBudgetLine.Create;
end;

procedure TfmBudget.FormDestroy(Sender: TObject);
begin
  FBL.Free;
end;

procedure TfmBudget.btOKClick(Sender: TObject);
begin
  FBL.Name := edName.Text;
  FBL.Value := StrToInt(edValue.Text);
  FBL.Typ := TbkBudgetLineType(cbType.ItemIndex);
  if FBL.Typ = bltSimple then
  begin
    FBL.Ready := cbReady.Checked;
    if FBL.Ready then
      FBL.ReadyValue := 0
    else
      FBL.ReadyValue := StrToInt(edReady.Text);;
  end
  else
  begin
    FBL.Ready := False;
    FBL.ReadyValue := 0;
  end;
  ModalResult := mrOk;
end;

procedure TfmBudget.btCancelClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TfmBudget.cbReadyChange(Sender: TObject);
begin
  edReady.Enabled := not cbReady.Checked;
end;

procedure TfmBudget.cbTypeChange(Sender: TObject);
begin
  cbReady.Enabled := cbType.ItemIndex = 0;
  edReady.Enabled := cbType.ItemIndex = 0;
end;

end.

