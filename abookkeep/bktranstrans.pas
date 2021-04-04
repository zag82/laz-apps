unit bktranstrans;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, DateTimePicker, Forms, Controls, Graphics,
  Dialogs, ExtCtrls, StdCtrls, bkdata;

type

  { TfmTransTrans }

  TfmTransTrans = class(TForm)
    btCancel: TButton;
    btOK: TButton;
    cbFrom: TComboBox;
    cbTo: TComboBox;
    edDate: TDateTimePicker;
    edValue: TEdit;
    edValue2: TEdit;
    gbMain: TGroupBox;
    imgTrans: TImage;
    lbDate: TLabel;
    lbValue: TLabel;
    lbFrom: TLabel;
    lbTo: TLabel;
    pnlControl: TPanel;
    procedure btCancelClick(Sender: TObject);
    procedure btOKClick(Sender: TObject);
    procedure cbFromChange(Sender: TObject);
    procedure edDateChange(Sender: TObject);
    procedure edValueChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    FBk: TbkData;
    FTrans: TbkTrans;
    FAccounts: array of TbkAccount;
    FIsFilling: boolean;
  public
    procedure Init(ADate: TDate; ABK: TbkData; ATrans: TbkTrans);
    function AccountFrom(): TbkAccount;
    function AccountTo(): TbkAccount;
    function ValueFrom(): integer;
    function ValueTo(): integer;
    function Modified(): boolean;
  end;

var
  fmTransTrans: TfmTransTrans;

implementation

{$R *.lfm}

{ TfmTransTrans }

procedure TfmTransTrans.edDateChange(Sender: TObject);
var
  i, j, ix1, ix2, len: integer;
  oldAccFrom, oldAccTo: TbkAccount;
  grAcc: TbkAccountGroup;
  acc: TbkAccount;
begin
  oldAccFrom := AccountFrom();
  oldAccTo := AccountTo();

  FIsFilling := True;
  try
    len := 0;
    for i := 0 to FBk.Accounts.Count - 1 do
      len += TbkAccountGroup(FBk.Accounts[i]).Accounts.Count;

    // set length for maximum
    SetLength(FAccounts, len);

    cbFrom.Items.Clear;
    cbTo.Items.Clear;
    ix1 := -1;
    ix2 := -1;
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
          if oldAccFrom = acc then
            ix1 := len;
          if oldAccTo = acc then
            ix2 := len;
          cbFrom.Items.Add(acc.FullName);
          cbTo.Items.Add(acc.FullName);
          len += 1;
        end;
      end;
    end;

    //
    SetLength(FAccounts, len);

    if ix1 <> -1 then
      cbFrom.ItemIndex := ix1
    else if cbFrom.Items.Count > 0 then
      cbFrom.ItemIndex := 0;

    if ix2 <> -1 then
      cbTo.ItemIndex := ix2
    else if cbTo.Items.Count > 0 then
      cbTo.ItemIndex := 0;
  finally
    FIsFilling := False;
  end;
end;

procedure TfmTransTrans.edValueChange(Sender: TObject);
var
  v: integer;
begin
  v := StrToIntDef(edValue.Text, 0);
  if AccountFrom().Currency = AccountTo().Currency then
    edValue2.Text := IntToStr(Abs(v));
end;

procedure TfmTransTrans.FormCreate(Sender: TObject);
begin
  FIsFilling := False;
end;

procedure TfmTransTrans.cbFromChange(Sender: TObject);
begin
  if FIsFilling then Exit;

  if AccountFrom().Currency = AccountTo().Currency then
  begin
    edValue2.Enabled := False;
    edValue2.Text := IntToStr(-StrToIntDef(edValue.Text, 0));
  end
  else
  begin
    edValue2.Enabled := True;
  end;
end;

procedure TfmTransTrans.btCancelClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TfmTransTrans.btOKClick(Sender: TObject);
begin
  if (edValue.Text = '0') or (edValue2.Text = '0') or
     (Trim(edValue.Text) = '') or (Trim(edValue2.Text) = '')
  then
    ShowMessage('Необходимо задать значения перевода')
  else if AccountFrom() = AccountTo() then
    ShowMessage('Счета перевода должны быть разными')
  else if (StrToIntDef(edValue.Text, 0) < 0) or (StrToIntDef(edValue2.Text, 0) < 0) then
    ShowMessage('Значения должны быть положительными')
  else
    ModalResult := mrOK;
end;

procedure TfmTransTrans.Init(ADate: TDate; ABK: TbkData; ATrans: TbkTrans);
begin
  FBk := ABk;
  FTrans := ATrans;

  if FTrans = nil then
  begin
    edDate.Date := ADate;
    edDateChange(edDate);
    cbFromChange(cbFrom);

    edValue.Text := '0';
  end
  else
  begin
    edDate.Date := FTrans.Date;
    edDateChange(edDate);
    cbFromChange(cbFrom);

    cbFrom.Text := FTrans.Account.FullName();
    cbTo.Text := FTrans.Account_to.FullName();
    edValue.Text := IntToStr(Abs(FTrans.Value));
    edValue2.Text := IntToStr(Abs(FTrans.Value_to));

    edValue2.Enabled := FTrans.Account.Currency <> FTrans.Account_to.Currency;
  end;
  ActiveControl := cbFrom;
end;

function TfmTransTrans.AccountFrom(): TbkAccount;
begin
  Result := nil;
  if (cbFrom.ItemIndex >=0) and (cbFrom.ItemIndex < Length(FAccounts)) then
    Result := FAccounts[cbFrom.ItemIndex];
end;

function TfmTransTrans.AccountTo(): TbkAccount;
begin
  Result := nil;
  if (cbTo.ItemIndex >=0) and (cbTo.ItemIndex < Length(FAccounts)) then
    Result := FAccounts[cbTo.ItemIndex];
end;

function TfmTransTrans.ValueFrom(): integer;
begin
  Result := -Abs(StrToIntDef(edValue.Text, 0));
end;

function TfmTransTrans.ValueTo(): integer;
begin
  Result := Abs(StrToIntDef(edValue2.Text, 0));
end;

function TfmTransTrans.Modified(): boolean;
begin
  if FTrans = nil then
    Result := True
  else
    Result :=
      (edDate.Date <> FTrans.Date) or
      (AccountFrom() <> FTrans.Account) or
      (AccountTo() <> FTrans.Account_to) or
      (StrToIntDef(edValue.Text, 0) <> FTrans.Value) or
      (StrToIntDef(edValue2.Text, 0) <> FTrans.Value_to);
end;

end.

