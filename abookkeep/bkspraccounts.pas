unit bkspraccounts;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, DateTimePicker, Forms, Controls, Graphics,
  Dialogs, ExtCtrls, StdCtrls, ComCtrls, ActnList, bkdata;

type

  { TfmSprAccounts }

  TfmSprAccounts = class(TForm)
    actAddGroup: TAction;
    actDelGroup: TAction;
    actAddItem: TAction;
    actDelItem: TAction;
    actMoveUp: TAction;
    actMoveDown: TAction;
    acts: TActionList;
    bvPeriods: TBevel;
    cbFromEmpty: TCheckBox;
    cbToEmpty: TCheckBox;
    cbCurrency: TComboBox;
    edFrom: TDateTimePicker;
    edTo: TDateTimePicker;
    edName: TEdit;
    imgs: TImageList;
    imgsTree: TImageList;
    lbName: TLabel;
    lbDescr: TLabel;
    lbCurrency: TLabel;
    lbFrom: TLabel;
    lbTo: TLabel;
    mmDescr: TMemo;
    pnlTree: TPanel;
    pnlMain: TPanel;
    tbTree: TToolBar;
    btAddGroup: TToolButton;
    btDelGroup: TToolButton;
    tbt1: TToolButton;
    btAddItem: TToolButton;
    btDelItem: TToolButton;
    tbt2: TToolButton;
    btMoveUp: TToolButton;
    btMoveDown: TToolButton;
    tv: TTreeView;
    procedure actAddGroupExecute(Sender: TObject);
    procedure actAddGroupUpdate(Sender: TObject);
    procedure actAddItemExecute(Sender: TObject);
    procedure actAddItemUpdate(Sender: TObject);
    procedure actDelGroupExecute(Sender: TObject);
    procedure actDelGroupUpdate(Sender: TObject);
    procedure actDelItemExecute(Sender: TObject);
    procedure actDelItemUpdate(Sender: TObject);
    procedure actMoveDownExecute(Sender: TObject);
    procedure actMoveDownUpdate(Sender: TObject);
    procedure actMoveUpExecute(Sender: TObject);
    procedure actMoveUpUpdate(Sender: TObject);
    procedure cbCurrencyChange(Sender: TObject);
    procedure cbFromEmptyClick(Sender: TObject);
    procedure cbToEmptyClick(Sender: TObject);
    procedure edFromChange(Sender: TObject);
    procedure edNameChange(Sender: TObject);
    procedure edToChange(Sender: TObject);
    procedure mmDescrChange(Sender: TObject);
    procedure tvSelectionChanged(Sender: TObject);
  private
    FBk: TbkData;
    FIsFilling: boolean;
    FModified: boolean;
    function CanMove(AIsDown: boolean): boolean;
    procedure DoMove(AIsDown: boolean);
  public
    procedure Init(ABk: TbkData);
    function IsModified(): boolean;
  end;

var
  fmSprAccounts: TfmSprAccounts;

implementation

{$R *.lfm}

{ TfmSprAccounts }

procedure TfmSprAccounts.Init(ABk: TbkData);
var
  ct: TbkCurrencyTypes;
  i, j: integer;
  grAcc: TbkAccountGroup;
  acc: TbkAccount;
  nd, nd2: TTreeNode;
begin
  FBk := ABk;
  FModified := False;

  FIsFilling := True;
  try
    edName.Text := '';
    mmDescr.Lines.Clear;
    cbCurrency.Items.Clear;
    for ct := Low(TbkCurrencyTypes) to high(TbkCurrencyTypes) do
      cbCurrency.Items.Add(cCurrencyNames[ct]);

    tv.Items.Clear;
    for i := 0 to Fbk.Accounts.Count - 1 do
    begin
      grAcc := TbkAccountGroup(FBk.Accounts[i]);
      nd := tv.Items.AddChildObject(nil, grAcc.Name, grAcc);
      nd.StateIndex := 0;
      for j := 0 to grAcc.Accounts.Count - 1 do
      begin
        acc := TbkAccount(grAcc.Accounts[j]);
        nd2 := tv.Items.AddChildObject(nd, acc.Name, acc);
        nd2.StateIndex := 1;
      end;
    end;

  finally
    FIsFilling := False;
  end;
  if tv.Items.Count > 0 then
    tv.Selected := tv.Items[0];
end;

function TfmSprAccounts.IsModified(): boolean;
begin
  Result := FModified;
end;

procedure TfmSprAccounts.tvSelectionChanged(Sender: TObject);
var
  acc: TbkAccount;
begin
  if FIsFilling then Exit;

  if tv.Selected <> nil then
  begin
    lbDescr.Visible := tv.Selected.Level > 0;
    mmDescr.Visible := tv.Selected.Level > 0;
    lbCurrency.Visible := tv.Selected.Level > 0;
    cbCurrency.Visible := tv.Selected.Level > 0;
    lbFrom.Visible := tv.Selected.Level > 0;
    lbTo.Visible := tv.Selected.Level > 0;
    cbFromEmpty.Visible := tv.Selected.Level > 0;
    cbToEmpty.Visible := tv.Selected.Level > 0;
    edFrom.Visible := tv.Selected.Level > 0;
    edTo.Visible := tv.Selected.Level > 0;
    bvPeriods.Visible := tv.Selected.Level > 0;

    if tv.Selected.Level = 0 then
    begin
      FIsFilling := True;
      edName.Text := TbkAccountGroup(tv.Selected.Data).Name;
      FIsFilling := False;
    end
    else
    begin
      FIsFilling := True;
      try
        acc := TbkAccount(tv.Selected.Data);
        edName.Text := acc.Name;
        mmDescr.Text := acc.Descr;
        cbCurrency.Text := cCurrencyNames[acc.Currency];
        edFrom.Date := acc.D1;
        edTo.Date := acc.D2;
        cbFromEmpty.Checked := (acc.D1 = 0);
        cbToEmpty.Checked := (acc.D2 = 0);
      finally
        FIsFilling := False;
      end;
      cbFromEmptyClick(cbFromEmpty);
      cbToEmptyClick(cbToEmpty);
    end;
  end;
end;

procedure TfmSprAccounts.edNameChange(Sender: TObject);
var
  nd: TTreeNode;
begin
  if FIsFilling then Exit;

  nd := tv.Selected;
  if nd <> nil then
  begin
    nd.Text := edName.Text;
    if nd.Level > 0 then
      TbkAccount(nd.Data).Name := edName.Text
    else
      TbkAccountGroup(nd.Data).Name := edName.Text;
    FModified := True;
  end;
end;

procedure TfmSprAccounts.edToChange(Sender: TObject);
var
  nd: TTreeNode;
begin
  if FIsFilling then Exit;

  nd := tv.Selected;
  if (nd <> nil) and (nd.Level > 0) then
  begin
    TbkAccount(nd.Data).D2 := edTo.Date;
    FModified := True;
  end;
end;

procedure TfmSprAccounts.mmDescrChange(Sender: TObject);
var
  nd: TTreeNode;
begin
  if FIsFilling then Exit;

  nd := tv.Selected;
  if (nd <> nil) and (nd.Level > 0) then
  begin
    TbkAccount(nd.Data).Descr := mmDescr.Text;
    FModified := True;
  end;
end;

procedure TfmSprAccounts.cbCurrencyChange(Sender: TObject);
var
  nd: TTreeNode;
begin
  if FIsFilling then Exit;

  nd := tv.Selected;
  if (nd <> nil) and (nd.Level > 0) then
  begin
    TbkAccount(nd.Data).Currency := TbkCurrencyTypes(cbCurrency.ItemIndex);
    FModified := True;
  end;
end;

procedure TfmSprAccounts.cbFromEmptyClick(Sender: TObject);
begin
  edFrom.Enabled := not cbFromEmpty.Checked;
  if cbFromEmpty.Checked then
  begin
    edFrom.Date := 0;
    edFromChange(edFrom);
  end;
end;

procedure TfmSprAccounts.cbToEmptyClick(Sender: TObject);
begin
  edTo.Enabled := not cbToEmpty.Checked;
  if cbToEmpty.Checked then
  begin
    edTo.Date := 0;
    edToChange(edTo);
  end;
end;

procedure TfmSprAccounts.edFromChange(Sender: TObject);
var
  nd: TTreeNode;
begin
  if FIsFilling then Exit;

  nd := tv.Selected;
  if (nd <> nil) and (nd.Level > 0) then
  begin
    TbkAccount(nd.Data).D1 := edFrom.Date;
    FModified := True;
  end;
end;


{$Region 'Actions'}
procedure TfmSprAccounts.actAddGroupExecute(Sender: TObject);
var
  nd: TTreeNode;
  grAcc: TbkAccountGroup;
begin
  grAcc := TbkAccountGroup.Create();
  grAcc.Name := 'Новая группа';
  FBk.Accounts.Add(grAcc);

  nd := tv.Items.AddChild(nil, grAcc.Name);
  nd.Data := grAcc;
  nd.StateIndex := 0;
  tv.Selected := nd;
  tv.Selected.MakeVisible;
end;

procedure TfmSprAccounts.actAddGroupUpdate(Sender: TObject);
begin
  (Sender as TAction).Enabled := True;
end;

procedure TfmSprAccounts.actAddItemExecute(Sender: TObject);
var
  nd, node: TTreeNode;
  grAcc: TbkAccountGroup;
  acc: TbkAccount;
begin
  node := tv.Selected;
  if node.Level > 0 then
    node := node.Parent;
  grAcc := TbkAccountGroup(node.Data);

  acc := TbkAccount.Create();
  acc.Name := 'Новый счёт';
  acc.Group := grAcc;
  grAcc.Accounts.Add(acc);

  nd := tv.Items.AddChild(node, acc.Name);
  nd.Data := acc;
  nd.StateIndex := 1;
  tv.Selected := nd;
  tv.Selected.MakeVisible;
end;

procedure TfmSprAccounts.actAddItemUpdate(Sender: TObject);
begin
  (Sender as TAction).Enabled := (tv.Selected <> nil);
end;

procedure TfmSprAccounts.actDelGroupExecute(Sender: TObject);
var
  i, j: integer;
  used: boolean;
  nd: TTreeNode;
  grAcc: TbkAccountGroup;
  acc: TbkAccount;
begin
  if MessageDlg('Подтверждение', 'Удалить группу?', mtConfirmation, mbYesNo, 0) = mrYes then
  begin
    nd := tv.Selected;
    grAcc := TbkAccountGroup(nd.Data);

    // check using in transactions
    used := False;
    for i := 0 to FBk.Trans.Count - 1 do
    begin
      for j := 0 to grAcc.Accounts.Count - 1 do
      begin
        acc := TbkAccount(grAcc.Accounts[j]);
        if (TbkTrans(FBk.Trans[i]).Account = acc) or
           (TbkTrans(FBk.Trans[i]).Account_to = acc)
        then
        begin
          used := True;
          break;
        end;
      end;
      if used then
        break;
    end;

    if used then
      ShowMessage('Счёт используется в транзакциях и не может быть удалён!')
    else
    begin
      FBk.Accounts.Remove(grAcc);
      grAcc.Free;
      nd.Delete;
      FModified := True;
    end;
  end;
end;

procedure TfmSprAccounts.actDelGroupUpdate(Sender: TObject);
begin
  (Sender as TAction).Enabled := (tv.Selected <> nil) and (tv.Selected.Level = 0);
end;

procedure TfmSprAccounts.actDelItemExecute(Sender: TObject);
var
  i: integer;
  used: boolean;
  nd: TTreeNode;
  acc: TbkAccount;
begin
  if MessageDlg('Подтверждение', 'Удалить элемент?', mtConfirmation, mbYesNo, 0) = mrYes then
  begin
    nd := tv.Selected;
    acc := TbkAccount(nd.Data);

    // check using in transactions
    used := False;
    for i := 0 to FBk.Trans.Count - 1 do
      if (TbkTrans(FBk.Trans[i]).Account = acc) or
         (TbkTrans(FBk.Trans[i]).Account_to = acc)
      then
      begin
        used := True;
        break;
      end;

     if used then
       ShowMessage('Счёт используется в транзакциях и не может быть удалён!')
     else
     begin
       acc.Group.Accounts.Remove(acc);
       acc.Free;
       nd.Delete;
       FModified := True;
     end;
  end;
end;

procedure TfmSprAccounts.actDelItemUpdate(Sender: TObject);
begin
  (Sender as TAction).Enabled := (tv.Selected <> nil) and (tv.Selected.Level > 0);
end;

function TfmSprAccounts.CanMove(AIsDown: boolean): boolean;
var
  node, ndParent: TTreeNode;
begin
  Result := False;

  node := tv.Selected;
  if node <> nil then
  begin
    if node.Level = 0 then
    begin
      if (not AIsDown) and (node.GetPrevSibling <> nil) then
        Result := True;
      if (AIsDown) and (node.GetNextSibling <> nil) then
        Result := True;
    end
    else
    begin
      ndParent := node.Parent;
      if AIsDown then
      begin
        if node.GetNextSibling <> nil then
          Result := True
        else if ndParent.GetNextSibling <> nil then
          Result := True;
      end
      else
      begin
        if node.GetPrevSibling <> nil then
          Result := True
        else if ndParent.GetPrevSibling <> nil then
          Result := True;
      end;
    end;
  end;
end;

procedure TfmSprAccounts.DoMove(AIsDown: boolean);
var
  node, ndParent, node2: TTreeNode;
  grAcc, grAcc2: TbkAccountGroup;
  acc: TbkAccount;
  ix: integer;
begin
  node := tv.Selected;
  if node <> nil then
  begin
    if node.Level = 0 then
    begin
      grAcc := TbkAccountGroup(node.Data);
      ix := FBk.Accounts.IndexOf(grAcc);
      if AIsDown then
      begin
        FBk.Accounts.Move(ix, ix+1);
        node.MoveTo(node.GetNextSibling, TNodeAttachMode.naInsertBehind);
      end
      else
      begin
        FBk.Accounts.Move(ix, ix-1);
        node.MoveTo(node.GetPrevSibling, TNodeAttachMode.naInsert);
      end;
      FModified := True;
    end
    else
    begin
      ndParent := node.Parent;
      grAcc := TbkAccountGroup(ndParent.Data);
      acc := TbkAccount(node.Data);
      ix := grAcc.Accounts.IndexOf(acc);
      if AIsDown then
      begin
        node2 := node.GetNextSibling;
        if node2 <> nil then
        begin
          grAcc.Accounts.Move(ix, ix+1);
          node.MoveTo(node2, TNodeAttachMode.naInsertBehind);
        end
        else
        begin
          node2 := ndParent.GetNextSibling;
          if node2 <> nil then
          begin
            grAcc2 := TbkAccountGroup(node2.Data);
            grAcc2.Accounts.Insert(0, acc);
            grAcc.Accounts.Delete(ix);
            node.MoveTo(node2, TNodeAttachMode.naAddChildFirst);
          end;
        end;
      end
      else
      begin
        node2 := node.GetPrevSibling;
        if node2 <> nil then
        begin
          grAcc.Accounts.Move(ix, ix-1);
          node.MoveTo(node2, TNodeAttachMode.naInsert);
        end
        else
        begin
          node2 := ndParent.GetPrevSibling;
          if node2 <> nil then
          begin
            grAcc2 := TbkAccountGroup(node2.Data);
            grAcc2.Accounts.Add(acc);
            grAcc.Accounts.Delete(ix);
            node.MoveTo(node2, TNodeAttachMode.naAddChild);
          end;
        end;
      end;
      FModified := True;
    end;
  end;
end;

procedure TfmSprAccounts.actMoveDownExecute(Sender: TObject);
begin
  DoMove(True);
end;

procedure TfmSprAccounts.actMoveDownUpdate(Sender: TObject);
begin
  (Sender as TAction).Enabled := CanMove(True);
end;

procedure TfmSprAccounts.actMoveUpExecute(Sender: TObject);
begin
  DoMove(False);
end;

procedure TfmSprAccounts.actMoveUpUpdate(Sender: TObject);
begin
  (Sender as TAction).Enabled := CanMove(False);
end;
{$EndRegion}

end.

