unit bktransstart;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, DateTimePicker, Forms, Controls, Graphics,
  Dialogs, ExtCtrls, StdCtrls,

  bkdata;

type

  { TfmTransStart }

  TfmTransStart = class(TForm)
    btCancel: TButton;
    btOK: TButton;
    cbAccount: TComboBox;
    edDate: TDateTimePicker;
    edValue: TEdit;
    gbMain: TGroupBox;
    Label1: TLabel;
    lbDate: TLabel;
    lbValue: TLabel;
    pnlControl: TPanel;
    procedure btCancelClick(Sender: TObject);
    procedure btOKClick(Sender: TObject);
    procedure edDateChange(Sender: TObject);
  private
    FBk: TbkData;
    FAccounts: array of TbkAccount;
    FTrans: TbkTrans;
  public
    procedure Init(ADate: TDate; ABK: TbkData; ATrans: TbkTrans);
    function Account(): TbkAccount;
    function Modified(): boolean;
  end;

var
  fmTransStart: TfmTransStart;

implementation

{$R *.lfm}

{ TfmTransStart }

procedure TfmTransStart.edDateChange(Sender: TObject);
var
  i, j, ix, len: integer;
  oldAcc: TbkAccount;
  grAcc: TbkAccountGroup;
  acc: TbkAccount;
begin
  oldAcc := Account();

  len := 0;
  for i := 0 to FBk.Accounts.Count - 1 do
    len += TbkAccountGroup(FBk.Accounts[i]).Accounts.Count;

  // set length for maximum
  SetLength(FAccounts, len);

  cbAccount.Items.Clear;
  ix := -1;
  len := 0;
  for i := 0 to FBk.Accounts.Count - 1 do
  begin
    grAcc := TbkAccountGroup(FBk.Accounts[i]);
    for j := 0 to grAcc.Accounts.Count - 1 do
    begin
      acc := TbkAccount(grAcc.Accounts[j]);
      if acc.InPeriod(edDate.Date, edDate.Date) then
      begin
        FAccounts[len] := acc;
        if oldAcc = acc then
          ix := len;
        cbAccount.Items.Add(acc.FullName);
        len += 1;
      end;
    end;
  end;

  //
  SetLength(FAccounts, len);
  if ix <> -1 then
    cbAccount.ItemIndex := ix
  else if cbAccount.Items.Count > 0 then
    cbAccount.ItemIndex := 0;
end;

procedure TfmTransStart.btCancelClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TfmTransStart.btOKClick(Sender: TObject);
begin
  if {(edValue.Text = '0') or }(Trim(edValue.Text) = '') then
  begin
    ShowMessage('Необходимо задать не пустую сумму');
  end
  else
    ModalResult := mrOK;
end;

procedure TfmTransStart.Init(ADate: TDate; ABK: TbkData; ATrans: TbkTrans);
begin
  FBk := ABk;
  FTrans := ATrans;

  if FTrans = nil then
  begin
    edDate.Date := ADate;
    edDateChange(edDate);

    edValue.Text := '0';
  end
  else
  begin
    edDate.Date := FTrans.Date;
    edDateChange(edDate);

    cbAccount.Text := FTrans.Account.FullName();
    edValue.Text := IntToStr(FTrans.Value);
  end;
  ActiveControl := cbAccount;
end;

function TfmTransStart.Account(): TbkAccount;
begin
  Result := nil;
  if (cbAccount.ItemIndex >=0) and (cbAccount.ItemIndex < Length(FAccounts)) then
    Result := FAccounts[cbAccount.ItemIndex];
end;

function TfmTransStart.Modified(): boolean;
begin
  if FTrans = nil then
    Result := True
  else
    Result :=
      (edDate.Date <> FTrans.Date) or
      (Account() <> FTrans.Account) or
      (StrToIntDef(edValue.Text, 0) <> FTrans.Value);
end;

end.

