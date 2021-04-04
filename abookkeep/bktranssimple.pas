unit bktranssimple;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, DateTimePicker, Forms, Controls, Graphics,
  Dialogs, ExtCtrls, StdCtrls, bkdata;

type

  { TfmTransSimple }

  TfmTransSimple = class(TForm)
    btOK: TButton;
    btCancel: TButton;
    cbAccount: TComboBox;
    cbCategory: TComboBox;
    edDate: TDateTimePicker;
    edName: TEdit;
    edValue: TEdit;
    gbMain: TGroupBox;
    lbCategory: TLabel;
    lbName: TLabel;
    lbAccount: TLabel;
    lbDate: TLabel;
    lbValue: TLabel;
    pnlControl: TPanel;
    procedure btCancelClick(Sender: TObject);
    procedure btOKClick(Sender: TObject);
    procedure edDateChange(Sender: TObject);
  private
    FBk: TbkData;
    FTrans: TbkTrans;
    FAccounts: array of TbkAccount;
    FCategories: array of TbkCategory;
  public
    procedure Init(ADate: TDate; ABK: TbkData; ATrans: TbkTrans);
    function Account(): TbkAccount;
    function Category(): TbkCategory;
    function Modified(): boolean;
  end;

var
  fmTransSimple: TfmTransSimple;

implementation

{$R *.lfm}

{ TfmTransSimple }

procedure TfmTransSimple.Init(ADate: TDate; ABK: TbkData; ATrans: TbkTrans);
begin
  FBk := ABk;
  FTrans := ATrans;

  if FTrans = nil then
  begin
    edDate.Date := ADate;
    edDateChange(edDate);

    edValue.Text := '0';
    edName.Text := '';
  end
  else
  begin
    edDate.Date := FTrans.Date;
    edDateChange(edDate);
    cbAccount.Text := FTrans.Account.FullName();
    edValue.Text := IntToStr(FTrans.Value);
    edName.Text := FTrans.Name;
    cbCategory.Text := FTrans.Category.Name;
  end;
  ActiveControl := cbAccount;
end;

function TfmTransSimple.Account(): TbkAccount;
begin
  Result := nil;
  if (cbAccount.ItemIndex >=0) and (cbAccount.ItemIndex < Length(FAccounts)) then
    Result := FAccounts[cbAccount.ItemIndex];

end;

function TfmTransSimple.Category(): TbkCategory;
begin
  Result := nil;
  if (cbCategory.ItemIndex >=0) and (cbCategory.ItemIndex < Length(FCategories)) then
    Result := FCategories[cbCategory.ItemIndex];
end;

function TfmTransSimple.Modified(): boolean;
begin
  if FTrans = nil then
    Result := True
  else
    Result :=
      (edDate.Date <> FTrans.Date) or
      (Account() <> FTrans.Account) or
      (Category() <> FTrans.Category) or
      (edName.Text <> FTrans.Name) or
      (StrToIntDef(edValue.Text, 0) <> FTrans.Value);
end;

procedure TfmTransSimple.edDateChange(Sender: TObject);
var
  i, j, ix, len: integer;
  oldAcc: TbkAccount;
  oldCat: TbkCategory;
  grAcc: TbkAccountGroup;
  grCat: TbkCategoryGroup;
  acc: TbkAccount;
  cat: TbkCategory;
begin
  oldAcc := Account();
  oldCat := Category();

  {$region 'accounts'}
  len := 0;
  for i := 0 to FBk.Accounts.Count - 1 do
    len += TbkAccountGroup(FBk.Accounts[i]).Accounts.Count;

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
  SetLength(FAccounts, len);
  if ix <> -1 then
    cbAccount.ItemIndex := ix
  else if cbAccount.Items.Count > 0 then
    cbAccount.ItemIndex := 0;
  {$EndRegion}

  {$Region 'categories'}
  len := 0;
  for i := 0 to FBk.Categories.Count - 1 do
    len += TbkCategoryGroup(FBk.Categories[i]).Categories.Count;
  SetLength(FCategories, len);
  cbCategory.Items.Clear;
  ix := -1;
  len := 0;
  for i := 0 to FBk.Categories.Count - 1 do
  begin
    grCat := TbkCategoryGroup(FBk.Categories[i]);
    for j := 0 to grCat.Categories.Count - 1 do
    begin
      cat := TbkCategory(grCat.Categories[j]);
      if cat.InPeriod(edDate.Date, edDate.Date) then
      begin
        FCategories[len] := cat;
        if oldCat = cat then
          ix := len;
        cbCategory.Items.Add(cat.Name);
        len += 1;
      end;
    end;
  end;
  SetLength(FCategories, len);
  if ix <> -1 then
    cbCategory.ItemIndex := ix
  else if cbCategory.Items.Count > 0 then
    cbCategory.ItemIndex := 0;
  {$EndRegion}
end;

procedure TfmTransSimple.btCancelClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TfmTransSimple.btOKClick(Sender: TObject);
begin
  if (edValue.Text = '0') or (Trim(edName.Text) = '') or (Trim(edValue.Text) = '')then
    ShowMessage('Необходимо задать сумму и наименование для транзакции')
  else
    ModalResult := mrOK;
end;

end.

