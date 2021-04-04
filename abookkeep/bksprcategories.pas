unit bksprcategories;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, DateTimePicker, Forms, Controls, Graphics,
  Dialogs, ExtCtrls, StdCtrls, ActnList, ComCtrls, bkdata;

type

  { TfmSprCategories }

  TfmSprCategories = class(TForm)
    actAddGroup: TAction;
    actAddItem: TAction;
    actDelGroup: TAction;
    actDelItem: TAction;
    actMoveDown: TAction;
    actMoveUp: TAction;
    acts: TActionList;
    btAddGroup: TToolButton;
    btAddItem: TToolButton;
    btDelGroup: TToolButton;
    btDelItem: TToolButton;
    btMoveDown: TToolButton;
    btMoveUp: TToolButton;
    bvPeriods: TBevel;
    cbFromEmpty: TCheckBox;
    cbToEmpty: TCheckBox;
    edFrom: TDateTimePicker;
    edName: TEdit;
    edTo: TDateTimePicker;
    imgs: TImageList;
    imgsTree: TImageList;
    lbDescr: TLabel;
    lbFrom: TLabel;
    lbName: TLabel;
    lbTo: TLabel;
    mmDescr: TMemo;
    pnlMain: TPanel;
    pnlTree: TPanel;
    tbt1: TToolButton;
    tbt2: TToolButton;
    tbTree: TToolBar;
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
  fmSprCategories: TfmSprCategories;

implementation

{$R *.lfm}

{ TfmSprCategories }

procedure TfmSprCategories.Init(ABk: TbkData);
var
  i, j: integer;
  grCat: TbkCategoryGroup;
  cat: TbkCategory;
  nd, nd2: TTreeNode;
begin
  FBk := ABk;
  FModified := False;

  FIsFilling := True;
  try
    edName.Text := '';
    mmDescr.Lines.Clear;

    tv.Items.Clear;
    for i := 0 to Fbk.Categories.Count - 1 do
    begin
      grCat := TbkCategoryGroup(FBk.Categories[i]);
      nd := tv.Items.AddChildObject(nil, grCat.Name, grCat);
      nd.StateIndex := 0;
      for j := 0 to grCat.Categories.Count - 1 do
      begin
        cat := TbkCategory(grCat.Categories[j]);
        nd2 := tv.Items.AddChildObject(nd, cat.Name, cat);
        nd2.StateIndex := 1;
      end;
    end;

  finally
    FIsFilling := False;
  end;
  if tv.Items.Count > 0 then
    tv.Selected := tv.Items[0];
end;

function TfmSprCategories.IsModified(): boolean;
begin
  Result := FModified;
end;

procedure TfmSprCategories.tvSelectionChanged(Sender: TObject);
var
  cat: TbkCategory;
begin
  if FIsFilling then Exit;

  if tv.Selected <> nil then
  begin
    lbDescr.Visible := tv.Selected.Level > 0;
    mmDescr.Visible := tv.Selected.Level > 0;
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
      edName.Text := TbkCategoryGroup(tv.Selected.Data).Name;
      FIsFilling := False;
    end
    else
    begin
      FIsFilling := True;
      try
        cat := TbkCategory(tv.Selected.Data);
        edName.Text := cat.Name;
        mmDescr.Text := cat.Descr;
        edFrom.Date := cat.D1;
        edTo.Date := cat.D2;
        cbFromEmpty.Checked := (cat.D1 = 0);
        cbToEmpty.Checked := (cat.D2 = 0);
      finally
        FIsFilling := False;
      end;
      cbFromEmptyClick(cbFromEmpty);
      cbToEmptyClick(cbToEmpty);
    end;
  end;
end;

procedure TfmSprCategories.edNameChange(Sender: TObject);
var
  nd: TTreeNode;
begin
  if FIsFilling then Exit;

  nd := tv.Selected;
  if nd <> nil then
  begin
    nd.Text := edName.Text;
    if nd.Level > 0 then
      TbkCategory(nd.Data).Name := edName.Text
    else
      TbkCategoryGroup(nd.Data).Name := edName.Text;
    FModified := True;
  end;
end;

procedure TfmSprCategories.edToChange(Sender: TObject);
var
  nd: TTreeNode;
begin
  if FIsFilling then Exit;

  nd := tv.Selected;
  if (nd <> nil) and (nd.Level > 0) then
  begin
    TbkCategory(nd.Data).D2 := edTo.Date;
    FModified := True;
  end;
end;

procedure TfmSprCategories.mmDescrChange(Sender: TObject);
var
  nd: TTreeNode;
begin
  if FIsFilling then Exit;

  nd := tv.Selected;
  if (nd <> nil) and (nd.Level > 0) then
  begin
    TbkCategory(nd.Data).Descr := mmDescr.Text;
    FModified := True;
  end;
end;

procedure TfmSprCategories.cbFromEmptyClick(Sender: TObject);
begin
  edFrom.Enabled := not cbFromEmpty.Checked;
  if cbFromEmpty.Checked then
    edFrom.Date := 0;
end;

procedure TfmSprCategories.cbToEmptyClick(Sender: TObject);
begin
  edTo.Enabled := not cbToEmpty.Checked;
  if cbToEmpty.Checked then
    edTo.Date := 0;
end;

procedure TfmSprCategories.edFromChange(Sender: TObject);
var
  nd: TTreeNode;
begin
  if FIsFilling then Exit;

  nd := tv.Selected;
  if (nd <> nil) and (nd.Level > 0) then
  begin
    TbkCategory(nd.Data).D1 := edFrom.Date;
    FModified := True;
  end;
end;


{$Region 'Actions'}
procedure TfmSprCategories.actAddGroupExecute(Sender: TObject);
var
  nd: TTreeNode;
  grCat: TbkCategoryGroup;
begin
  grCat := TbkCategoryGroup.Create();
  grCat.Name := 'Новая группа';
  FBk.Categories.Add(grCat);

  nd := tv.Items.AddChild(nil, grCat.Name);
  nd.Data := grCat;
  nd.StateIndex := 0;
  tv.Selected := nd;
  tv.Selected.MakeVisible;
end;

procedure TfmSprCategories.actAddGroupUpdate(Sender: TObject);
begin
  (Sender as TAction).Enabled := True;
end;

procedure TfmSprCategories.actAddItemExecute(Sender: TObject);
var
  nd, node: TTreeNode;
  grCat: TbkCategoryGroup;
  cat: TbkCategory;
begin
  node := tv.Selected;
  if node.Level > 0 then
    node := node.Parent;
  grCat := TbkCategoryGroup(node.Data);

  cat := TbkCategory.Create();
  cat.Name := 'Новая категория';
  cat.Group := grCat;
  grCat.Categories.Add(cat);

  nd := tv.Items.AddChild(node, cat.Name);
  nd.Data := cat;
  nd.StateIndex := 1;
  tv.Selected := nd;
  tv.Selected.MakeVisible;
end;

procedure TfmSprCategories.actAddItemUpdate(Sender: TObject);
begin
  (Sender as TAction).Enabled := (tv.Selected <> nil);
end;

procedure TfmSprCategories.actDelGroupExecute(Sender: TObject);
var
  i, j: integer;
  used: boolean;
  nd: TTreeNode;
  grCat: TbkCategoryGroup;
  cat: TbkCategory;
begin
  if MessageDlg('Подтверждение', 'Удалить группу?', mtConfirmation, mbYesNo, 0) = mrYes then
  begin
    nd := tv.Selected;
    grCat := TbkCategoryGroup(nd.Data);

    // check using in transactions
    used := False;
    for i := 0 to FBk.Trans.Count - 1 do
    begin
      for j := 0 to grCat.Categories.Count - 1 do
      begin
        cat := TbkCategory(grCat.Categories[j]);
        if TbkTrans(FBk.Trans[i]).Category = cat then
        begin
          used := True;
          break;
        end;
      end;
      if used then
        break;
    end;

    if used then
      ShowMessage('Категория используется в транзакциях и не может быть удалена!')
    else
    begin
      FBk.Categories.Remove(grCat);
      grCat.Free;
      nd.Delete;
      FModified := True;
    end;
  end;
end;

procedure TfmSprCategories.actDelGroupUpdate(Sender: TObject);
begin
  (Sender as TAction).Enabled := (tv.Selected <> nil) and (tv.Selected.Level = 0);
end;

procedure TfmSprCategories.actDelItemExecute(Sender: TObject);
var
  i: integer;
  used: boolean;
  nd: TTreeNode;
  cat: TbkCategory;
begin
  if MessageDlg('Подтверждение', 'Удалить элемент?', mtConfirmation, mbYesNo, 0) = mrYes then
  begin
    nd := tv.Selected;
    cat := TbkCategory(nd.Data);

    // check using in transactions
    used := False;
    for i := 0 to FBk.Trans.Count - 1 do
      if TbkTrans(FBk.Trans[i]).Category = cat then
      begin
        used := True;
        break;
      end;

     if used then
       ShowMessage('Категория используется в транзакциях и не может быть удалена!')
     else
     begin
       cat.Group.Categories.Remove(cat);
       cat.Free;
       nd.Delete;
       FModified := True;
     end;
  end;
end;

procedure TfmSprCategories.actDelItemUpdate(Sender: TObject);
begin
  (Sender as TAction).Enabled := (tv.Selected <> nil) and (tv.Selected.Level > 0);
end;

function TfmSprCategories.CanMove(AIsDown: boolean): boolean;
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

procedure TfmSprCategories.DoMove(AIsDown: boolean);
var
  node, ndParent, node2: TTreeNode;
  grCat, grCat2: TbkCategoryGroup;
  cat: TbkCategory;
  ix: integer;
begin
  node := tv.Selected;
  if node <> nil then
  begin
    if node.Level = 0 then
    begin
      grCat := TbkCategoryGroup(node.Data);
      ix := FBk.Categories.IndexOf(grCat);
      if AIsDown then
      begin
        FBk.Categories.Move(ix, ix+1);
        node.MoveTo(node.GetNextSibling, TNodeAttachMode.naInsertBehind);
      end
      else
      begin
        FBk.Categories.Move(ix, ix-1);
        node.MoveTo(node.GetPrevSibling, TNodeAttachMode.naInsert);
      end;
      FModified := True;
    end
    else
    begin
      ndParent := node.Parent;
      grCat := TbkCategoryGroup(ndParent.Data);
      cat := TbkCategory(node.Data);
      ix := grCat.Categories.IndexOf(cat);
      if AIsDown then
      begin
        node2 := node.GetNextSibling;
        if node2 <> nil then
        begin
          grCat.Categories.Move(ix, ix+1);
          node.MoveTo(node2, TNodeAttachMode.naInsertBehind);
        end
        else
        begin
          node2 := ndParent.GetNextSibling;
          if node2 <> nil then
          begin
            grCat2 := TbkCategoryGroup(node2.Data);
            grCat2.Categories.Insert(0, cat);
            grCat.Categories.Delete(ix);
            node.MoveTo(node2, TNodeAttachMode.naAddChildFirst);
          end;
        end;
      end
      else
      begin
        node2 := node.GetPrevSibling;
        if node2 <> nil then
        begin
          grCat.Categories.Move(ix, ix-1);
          node.MoveTo(node2, TNodeAttachMode.naInsert);
        end
        else
        begin
          node2 := ndParent.GetPrevSibling;
          if node2 <> nil then
          begin
            grCat2 := TbkCategoryGroup(node2.Data);
            grCat2.Categories.Add(cat);
            grCat.Categories.Delete(ix);
            node.MoveTo(node2, TNodeAttachMode.naAddChild);
          end;
        end;
      end;
      FModified := True;
    end;
  end;
end;

procedure TfmSprCategories.actMoveDownExecute(Sender: TObject);
begin
  DoMove(True);
end;

procedure TfmSprCategories.actMoveDownUpdate(Sender: TObject);
begin
  (Sender as TAction).Enabled := CanMove(True);
end;

procedure TfmSprCategories.actMoveUpExecute(Sender: TObject);
begin
  DoMove(False);
end;

procedure TfmSprCategories.actMoveUpUpdate(Sender: TObject);
begin
  (Sender as TAction).Enabled := CanMove(False);
end;
{$EndRegion}

end.

