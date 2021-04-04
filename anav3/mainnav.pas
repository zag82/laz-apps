unit mainnav;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, TreeFilterEdit, SynEdit, Forms, Controls,
  Graphics, Dialogs, LCLType, ExtCtrls, ComCtrls, Grids, Menus, ActnList,
  StdCtrls, navdata;

type
  TNavState = (nstNone, nstLogin, nstEdit, nstView, nstFile);

  { TfmMainNav3 }

  TfmMainNav3 = class(TForm)
    actEdit: TAction;
    actExit: TAction;
    actEditInTree: TAction;
    actFileImport: TAction;
    actFileExport: TAction;
    actShowFiles: TAction;
    actListCopyItem: TAction;
    actSave: TAction;
    actListAddGroup: TAction;
    actDetailsMoveDown: TAction;
    actDetailsCopy: TAction;
    actListDelGroup: TAction;
    actListAddItem: TAction;
    actListDelItem: TAction;
    actListMoveUp: TAction;
    actListMoveDown: TAction;
    actDetailsAdd: TAction;
    actDetailsDel: TAction;
    actDetailsMoveUp: TAction;
    acts: TActionList;
    btOk: TButton;
    btCancel: TButton;
    btClose: TButton;
    edFile: TEdit;
    edPass: TEdit;
    mmFile: TMemo;
    oDlg: TOpenDialog;
    pnlFile: TPanel;
    sDlg: TSaveDialog;
    tm: TIdleTimer;
    imgsSmall: TImageList;
    imgs: TImageList;
    lbCapPwd1: TStaticText;
    pnlError: TPanel;
    pnlList: TPanel;
    pnlDetails: TPanel;
    pnlPassword: TPanel;
    lbCapPwd: TStaticText;
    stBar: TStatusBar;
    sgDetails: TStringGrid;
    tbList: TToolBar;
    tbDetails: TToolBar;
    tbMenu: TToolBar;
    miEdit: TToolButton;
    miMoveDownItem: TToolButton;
    miAddDetail: TToolButton;
    miDelDetail: TToolButton;
    tb3: TToolButton;
    miMoveUpDetail: TToolButton;
    miMoveDownDetail: TToolButton;
    miExit: TToolButton;
    miAddGroup: TToolButton;
    miDelGroup: TToolButton;
    tb1: TToolButton;
    miAddItem: TToolButton;
    miDelItem: TToolButton;
    tb2: TToolButton;
    miMoveUpItem: TToolButton;
    edList: TTreeFilterEdit;
    miSave: TToolButton;
    miCopyItem: TToolButton;
    miShowFiles: TToolButton;
    miFileImport: TToolButton;
    miFileExport: TToolButton;
    tb4: TToolButton;
    tvList: TTreeView;
    procedure actDetailsAddExecute(Sender: TObject);
    procedure actDetailsAddUpdate(Sender: TObject);
    procedure actDetailsCopyExecute(Sender: TObject);
    procedure actDetailsCopyUpdate(Sender: TObject);
    procedure actDetailsDelExecute(Sender: TObject);
    procedure actDetailsDelUpdate(Sender: TObject);
    procedure actDetailsMoveDownExecute(Sender: TObject);
    procedure actDetailsMoveDownUpdate(Sender: TObject);
    procedure actDetailsMoveUpExecute(Sender: TObject);
    procedure actDetailsMoveUpUpdate(Sender: TObject);
    procedure actEditExecute(Sender: TObject);
    procedure actEditInTreeExecute(Sender: TObject);
    procedure actEditUpdate(Sender: TObject);
    procedure actExitExecute(Sender: TObject);
    procedure actFileExportExecute(Sender: TObject);
    procedure actFileExportUpdate(Sender: TObject);
    procedure actFileImportExecute(Sender: TObject);
    procedure actFileImportUpdate(Sender: TObject);
    procedure actListAddGroupExecute(Sender: TObject);
    procedure actListAddGroupUpdate(Sender: TObject);
    procedure actListAddItemExecute(Sender: TObject);
    procedure actListAddItemUpdate(Sender: TObject);
    procedure actListCopyItemExecute(Sender: TObject);
    procedure actListCopyItemUpdate(Sender: TObject);
    procedure actListDelGroupExecute(Sender: TObject);
    procedure actListDelGroupUpdate(Sender: TObject);
    procedure actListDelItemExecute(Sender: TObject);
    procedure actListDelItemUpdate(Sender: TObject);
    procedure actListMoveDownExecute(Sender: TObject);
    procedure actListMoveDownUpdate(Sender: TObject);
    procedure actListMoveUpExecute(Sender: TObject);
    procedure actListMoveUpUpdate(Sender: TObject);
    procedure actSaveExecute(Sender: TObject);
    procedure actSaveUpdate(Sender: TObject);
    procedure actShowFilesExecute(Sender: TObject);
    procedure actShowFilesUpdate(Sender: TObject);
    procedure btCancelClick(Sender: TObject);
    procedure btCloseClick(Sender: TObject);
    procedure btOkClick(Sender: TObject);
    procedure edListKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure sgDetailsEditingDone(Sender: TObject);
    procedure sgDetailsKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure sgDetailsSelectEditor(Sender: TObject; aCol, aRow: Integer;
      var Editor: TWinControl);
    procedure tmTimer(Sender: TObject);
    procedure tvListEdited(Sender: TObject; Node: TTreeNode; var S: string);
    procedure tvListKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure tvListSelectionChanged(Sender: TObject);
  private
    // state
    nstate: TNavState;
    prevNState: TNavState;
    FData: TNavData;

    function CanMoveList(ADir: integer): boolean;
    procedure doMoveList(ADir: integer);

    procedure UpdatePanels(ADialog: boolean);
    procedure ShowPassDialog();
    procedure EndPassDialog(AResult: boolean; const AText: string);
    procedure UpdateParamsdata(AItem: TNavItem);
  public

  end;

var
  fmMainNav3: TfmMainNav3;

implementation

uses
  Clipbrd,
  settings;

const
  C_FILE_MARKER = '__FILE__';

{$R *.lfm}

{ TfmMainNav3 }

{%Region 'Events'}
procedure TfmMainNav3.FormCreate(Sender: TObject);
begin
  FData := TNavData.Create(navSettings.FileName);

  prevNState := nstNone;
  nstate := nstLogin;
  pnlList.Width := ClientWidth div 3;
  pnlFile.Align := alClient;
  mmFile.ReadOnly := True;
  edFile.ReadOnly := True;

  ShowPassDialog();
end;

procedure TfmMainNav3.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  CloseAction := caFree;
  FData.Free;
end;

procedure TfmMainNav3.tvListEdited(Sender: TObject; Node: TTreeNode;
  var S: string);
begin
  if Node <> nil then
    if Node.Level = 0 then
      TNavGroup(Node.Data).Name := s
    else
      TNavItem(Node.Data).Name := s;
end;

procedure TfmMainNav3.tvListKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (nstate = nstView) and (Key = VK_F) then
  begin
    edList.SetFocus;
    Key := 0;
  end;

  if nstate = nstEdit then
  begin
    // insert
    if (Key = VK_INSERT) then
    begin
      if ssShift in Shift then
      begin
        if actListAddGroup.Enabled then
          actListAddGroupExecute(actListAddGroup);
      end
      else
      begin
        if actListAddItem.Enabled then
          actListAddItemExecute(actListAddItem);
      end;
      Key := 0;
    end;

    // delete
    if (Key = VK_DELETE) then
    begin
      if actListDelGroup.Enabled then
        actListDelGroupExecute(actListDelGroup)

      else
      if actListDelItem.Enabled then
        actListDelItemExecute(actListDelItem);

      Key := 0;
    end;

    // move up
    if (Key = VK_UP) and (ssCtrl in Shift) then
    begin
      if actListMoveUp.Enabled then
        actListMoveUpExecute(actListMoveUp);
      Key := 0;
    end;

    // move down
    if (Key = VK_DOWN) and (ssCtrl in Shift) then
    begin
      if actListMoveDown.Enabled then
        actListMoveDownExecute(actListMoveDown);
      Key := 0;
    end;
  end;
end;

procedure TfmMainNav3.tvListSelectionChanged(Sender: TObject);
var
  nd: TTreeNode;
  itm: TNavItem;
begin
  nd := tvList.Selected;
  if (nd = nil) or (nd.Level = 0) then
    sgDetails.RowCount := 1
  else
  begin
    itm := TNavItem(nd.Data);
    UpdateParamsdata(itm);
  end;
end;

procedure TfmMainNav3.sgDetailsEditingDone(Sender: TObject);
var
  ix: integer;
  itm: TNavItem;
  p: TNavParam;
begin
  if nstate <> nstEdit then
    Exit;
  ix := sgDetails.Selection.Top - 1;
  itm := TNavItem(tvList.Selected.Data);
  if (ix >= 0) and (ix < itm.Params.Count) then
  begin
    p := TNavParam(itm.Params[ix]);
    if not p.IsFile then
    begin
      p.Name  := sgDetails.Cells[0, ix+1];
      p.Value := sgDetails.Cells[1, ix+1];
    end;
  end;
end;

procedure TfmMainNav3.sgDetailsKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (nstate = nstView) and (Key = VK_F) then
  begin
    edList.SetFocus;
    Key := 0;
  end;
  if nstate = nstEdit then
  begin
    // insert
    if (Key = VK_INSERT) then
    begin
      if actDetailsAdd.Enabled then
        actDetailsAddExecute(actDetailsAdd);
      Key := 0;
    end;

    // delete
    if (Key = VK_DELETE) then
    begin
      if actDetailsDel.Enabled then
        actDetailsDelExecute(actDetailsDel);
      Key := 0;
    end;

    // move up
    if (Key = VK_UP) and (ssCtrl in Shift) then
    begin
      if actDetailsMoveUp.Enabled then
        actDetailsMoveUpExecute(actDetailsMoveUp);
      Key := 0;
    end;

    // move down
    if (Key = VK_DOWN) and (ssCtrl in Shift) then
    begin
      if actDetailsMoveDown.Enabled then
        actDetailsMoveDownExecute(actDetailsMoveDown);
      Key := 0;
    end;
  end;
end;

procedure TfmMainNav3.sgDetailsSelectEditor(Sender: TObject; aCol,
  aRow: Integer; var Editor: TWinControl);
var
  nd: TTreeNode;
  itm: TNavItem;
  p: TNavParam;
begin
  if (nstate <> nstEdit) then
  begin
    Editor := nil;
    Exit;
  end;

  nd := tvList.Selected;
  if (nd <> nil) and (nd.Level > 0) then
  begin
    itm := TNavItem(nd.Data);
    if (arow > 0) and (arow <= itm.Params.Count) then
    begin
      p := TNavParam(itm.Params[aRow-1]);
      if p.IsFile then
        Editor := nil;
    end;
  end;
end;

procedure TfmMainNav3.tmTimer(Sender: TObject);
begin
  if nstate in [nstView, nstEdit] then
  begin
    if sgDetails.Focused then
    begin
      sgDetails.Options := sgDetails.Options + [goDrawFocusSelected];
      tvList.SelectionColor := clMenuHighlight;
    end
    else
    begin
      sgDetails.Options := sgDetails.Options - [goDrawFocusSelected];
      tvList.SelectionColor := clHighlight;
    end;

    if nstate = nstView then
      // menu
      stBar.SimpleText := 'Menu:  View File=F3, Edit=F4, Save changes=Ctrl+S,  Exit=Ctrl+Q (F10)'

    else if sgDetails.Focused then
      // details
      stBar.SimpleText := 'Parameters:  Add=INS,  Delete=DEL,  Move up=Ctrl+Up,  Move down=Ctrl+Down'
    else
      // list
      stBar.SimpleText := 'Tree:  Add group=Shift+INS,  Add item=INS,  Delete=DEL,  Move up=Ctrl+Up,  Move down=Ctrl+Down';
  end
  else if nstate = nstFile then
    // file
    stBar.SimpleText := 'F3 = Close file preview';
end;

{%EndRegion}

{%Region 'Actions'}
procedure TfmMainNav3.btCancelClick(Sender: TObject);
begin
  EndPassDialog(False, '');
end;

procedure TfmMainNav3.btCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TfmMainNav3.btOkClick(Sender: TObject);
begin
  EndPassDialog(True, edPass.Text);
end;

procedure TfmMainNav3.edListKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_ESCAPE then
  begin
    edList.Clear;
    tvList.SetFocus;
  end
  else if Key = VK_RETURN then
    tvList.SetFocus;
end;

procedure TfmMainNav3.actExitExecute(Sender: TObject);
begin
  Close;
end;

procedure TfmMainNav3.actListAddGroupExecute(Sender: TObject);
var
  nd: TTreeNode;
  g: TNavGroup;
begin
  // data
  g := TNavGroup.Create();
  g.Name := '(New group)';
  FData.Groups.Add(g);

  // visual components
  nd := tvList.Items.AddChild(nil, g.Name);
  nd.Data := g;
  nd.ImageIndex := 16;
  nd.SelectedIndex := 16;
  tvList.Selected := nd;
  nd.EditText;
end;

procedure TfmMainNav3.actListAddGroupUpdate(Sender: TObject);
begin
  (Sender as TAction).Enabled :=
    (nstate = nstEdit) and
    (tvList.Focused);
end;

procedure TfmMainNav3.actListAddItemExecute(Sender: TObject);
var
  nd, nd2: TTreeNode;
  g: TNavGroup;
  itm: TNavItem;
begin
  // data
  nd := tvList.Selected;
  if nd.Level = 1 then
    nd := nd.Parent;

  g := TNavGroup(nd.Data);
  itm := TNavItem.Create();
  itm.Name := '(New element)';
  g.Items.Add(itm);

  // visual
  nd2 := tvList.Items.AddChild(nd, itm.Name);
  nd2.Data := itm;
  nd2.ImageIndex := 15;
  nd2.SelectedIndex := 15;
  tvList.Selected := nd2;
  nd2.EditText;
end;

procedure TfmMainNav3.actListAddItemUpdate(Sender: TObject);
begin
  (Sender as TAction).Enabled :=
    (nstate = nstEdit) and
    (tvList.Focused) and
    (tvList.Selected <> nil);
end;

procedure TfmMainNav3.actListCopyItemExecute(Sender: TObject);
var
  nd, nd2: TTreeNode;
  g: TNavGroup;
  itm: TNavItem;
begin
  // data
  nd := tvList.Selected;

  g := TNavGroup(nd.Parent.Data);
  itm := TNavItem.Create();
  itm.Copy(TNavItem(nd.Data));
  g.Items.Add(itm);

  // visual
  nd2 := tvList.Items.AddChild(nd.Parent, itm.Name);
  nd2.Data := itm;
  nd2.ImageIndex := 15;
  nd2.SelectedIndex := 15;
  tvList.Selected := nd2;
  //nd2.EditText;
end;

procedure TfmMainNav3.actListCopyItemUpdate(Sender: TObject);
begin
  (Sender as TAction).Enabled :=
    (nstate = nstEdit) and
    (tvList.Focused) and
    (tvList.Selected <> nil) and
    (tvList.Selected.Level = 1);
end;

procedure TfmMainNav3.actListDelGroupExecute(Sender: TObject);
var
  nd, nd2: TTreeNode;
  g: TNavGroup;
begin
  nd := tvList.Selected;
  nd2 := nd.GetNextSibling;
  g := TNavGroup(nd.Data);
  FData.Groups.Remove(g);
  g.Free;
  nd.Delete;
  if tvList.Items.Count > 0 then
  begin
    if nd2 <> nil then
      tvList.Selected := nd2
    else
      tvList.Selected := tvList.Items.GetLastNode;
  end;
end;

procedure TfmMainNav3.actListDelGroupUpdate(Sender: TObject);
begin
  (Sender as Taction).Enabled :=
    (nstate = nstEdit) and
    (tvList.Focused) and
    (tvList.Selected <> nil) and
    (tvList.Selected.Level = 0);
end;

procedure TfmMainNav3.actListDelItemExecute(Sender: TObject);
var
  nd, nd2, ndNew: TTreeNode;
  itm: TNavItem;
  g: TNavGroup;
begin
  nd := tvList.Selected;
  nd2 := nd.Parent;

  ndNew := nd.GetNextSibling;
  if ndNew = nil then
    ndNew := nd.GetPrevSibling;
  if ndNew = nil then
    ndNew := nd2;
  tvList.Selected := ndNew;

  itm := TNavItem(nd.Data);
  g := TNavGroup(nd2.Data);
  g.Items.Remove(itm);
  itm.Free;
  nd.Delete;
end;

procedure TfmMainNav3.actListDelItemUpdate(Sender: TObject);
begin
  (Sender as TAction).Enabled :=
    (nstate = nstEdit) and
    (tvList.Focused) and
    (tvList.Selected <> nil) and
    (tvList.Selected.Level = 1);
end;

function TfmMainNav3.CanMoveList(ADir: integer): boolean;
var
  nd: TTreeNode;
begin
  Result := True;
  if tvList.Selected.Level = 0 then
  begin
    if ADir < 0 then
      nd := tvList.Selected.GetPrevSibling
    else
      nd := tvList.Selected.GetNextSibling;
  end
  else
  begin
    if ADir < 0 then
    begin
      nd := tvList.Selected.GetPrevSibling;
      if nd = nil then
        nd := tvList.Selected.Parent.GetPrevSibling;
    end
    else
    begin
      nd := tvList.Selected.GetNextSibling;
      if nd = nil then
        nd := tvList.Selected.Parent.GetNextSibling;
    end;
  end;
  Result := nd <> nil;
end;

procedure TfmMainNav3.doMoveList(ADir: integer);
var
  nd1, nd2: TTreeNode;
  g, g2: TNavGroup;
  i1, i2: integer;
begin
  nd1 := tvList.Selected;
  if ADir < 0 then
  begin
    nd2 := nd1.GetPrevSibling;
    if nd2 <> nil then
    begin
      nd1.MoveTo(nd2, naInsert);
      if nd1.Level = 0 then
        // groups
        FData.Groups.Move(FData.Groups.IndexOf(TNavGroup(nd1.Data)), FData.Groups.IndexOf(TNavGroup(nd2.Data)))
      else
      begin
        // items
        g := TNavGroup(nd1.Parent.Data);
        i1 := g.Items.IndexOf(TNavItem(nd1.Data));
        i2 := g.Items.IndexOf(TNavItem(nd2.Data));
        g.Items.Move(i1, i2);
      end;
    end
    else if nd1.Level > 0 then
    begin
      // items from one group to another
      nd2 := nd1.Parent.GetPrevSibling;
      if nd2 <> nil then
      begin
        // groups
        g := TNavGroup(nd1.Parent.Data);
        g2 := TNavGroup(nd2.Data);
        g2.Items.Add(TNavItem(nd1.Data));
        g.Items.Remove(nd1.Data);
        // movement
        nd1.MoveTo(nd2, naAddChild);
      end;
    end;
  end
  else
  begin
    nd2 := nd1.GetNextSibling;
    if nd2 <> nil then
    begin
      nd1.MoveTo(nd2, naInsertBehind);
      if nd1.Level = 0 then
        // groups
        FData.Groups.Move(FData.Groups.IndexOf(TNavGroup(nd1.Data)), FData.Groups.IndexOf(TNavGroup(nd2.Data)))
      else
      begin
        // items
        g := TNavGroup(nd1.Parent.Data);
        i1 := g.Items.IndexOf(TNavItem(nd1.Data));
        i2 := g.Items.IndexOf(TNavItem(nd2.Data));
        g.Items.Move(i1, i2);
      end;
    end
    else if nd1.Level > 0 then
    begin
      // items from one group to another
      nd2 := nd1.Parent.GetNextSibling;
      if nd2 <> nil then
      begin
        // groups
        g := TNavGroup(nd1.Parent.Data);
        g2 := TNavGroup(nd2.Data);
        g2.Items.Insert(0, nd1.Data);
        g.Items.Remove(nd1.Data);
        // movement
        nd1.MoveTo(nd2, naAddChildFirst);
      end;
    end;
  end;
end;

procedure TfmMainNav3.actListMoveDownExecute(Sender: TObject);
begin
  doMoveList(1);
end;

procedure TfmMainNav3.actListMoveDownUpdate(Sender: TObject);
begin
  (Sender as TAction).Enabled :=
    (nstate = nstEdit) and
    (tvList.Focused) and
    (tvList.Selected <> nil) and
    (CanMoveList(1));
end;

procedure TfmMainNav3.actListMoveUpExecute(Sender: TObject);
begin
  doMoveList(-1);
end;

procedure TfmMainNav3.actListMoveUpUpdate(Sender: TObject);
begin
  (Sender as TAction).Enabled :=
    (nstate = nstEdit) and
    (tvList.Focused) and
    (tvList.Selected <> nil) and
    (CanMoveList(-1));
end;

procedure TfmMainNav3.actSaveExecute(Sender: TObject);
begin
  FData.Save();
  nstate := nstView;
  UpdatePanels(False);
end;

procedure TfmMainNav3.actSaveUpdate(Sender: TObject);
begin
  (Sender as TAction).Enabled := nstate in [nstEdit];
end;

procedure TfmMainNav3.actShowFilesExecute(Sender: TObject);
var
  nd: TTreeNode;
  itm: TNavItem;
  p: TNavParam;
begin
  edFile.Text := '';
  mmFile.Lines.Clear;

  if nstate = nstFile then
  begin
    nstate := prevNState;
    prevNState := nstNone;
  end
  else
  begin
    prevNState := nstate;
    nstate := nstFile;

    nd := tvList.Selected;
    if (nd <> nil) and (nd.Level > 0) then
    begin
      itm := TNavItem(nd.Data);
      if (sgDetails.Row > 0) and (sgDetails.Row <= itm.Params.Count) then
      begin
        p := TNavParam(itm.Params[sgDetails.Row-1]);
        if p.IsFile then
        begin
          edFile.Text := p.Name;
          mmFile.Lines.Clear;
          mmFile.Lines.Text := p.Value;
        end;
      end;
    end;
  end;

  UpdatePanels(False);
  if nstate <> nstFile then
    sgDetails.SetFocus
  else
    mmFile.SetFocus;
end;

procedure TfmMainNav3.actShowFilesUpdate(Sender: TObject);
var
  nd: TTreeNode;
  itm: TNavItem;
  isFile: boolean;
begin
  isFile := False;
  nd := tvList.Selected;
  if (nd <> nil) and (nd.Level > 0) then
  begin
    itm := TNavItem(nd.Data);
    if sgDetails.Selection.Top > 0 then
      isFile := TNavParam(itm.Params[sgDetails.Selection.Top-1]).IsFile;
  end;

  (Sender as TAction).Enabled :=
    (nstate in [nstEdit, nstView, nstFile]) and
    isFile;
end;

procedure TfmMainNav3.actEditExecute(Sender: TObject);
begin
  nstate := nstEdit;

  ShowPassDialog();
end;

procedure TfmMainNav3.actEditInTreeExecute(Sender: TObject);
begin
  if tvList.Focused then
    if nstate = nstEdit then
      if tvList.Selected <> nil then
        tvList.Selected.EditText;
end;

procedure TfmMainNav3.actEditUpdate(Sender: TObject);
begin
  (Sender as TAction).Enabled := nstate in [nstView];
end;

procedure TfmMainNav3.actDetailsAddExecute(Sender: TObject);
var
  itm: TNavItem;
  p: TNavParam;
begin
  sgDetails.RowCount := sgDetails.RowCount + 1;
  sgDetails.Col := 0;
  sgDetails.Row := sgDetails.RowCount-1;
  sgDetails.EditorMode := True;
  itm := TNavItem(tvList.Selected.Data);
  p := TNavParam.Create();
  itm.Params.Add(p);
end;

procedure TfmMainNav3.actDetailsAddUpdate(Sender: TObject);
begin
  (Sender as TAction).Enabled :=
    (nstate = nstEdit) and
    (sgDetails.Focused) and
    (tvList.Selected <> nil) and
    (tvList.Selected.Level > 0);
end;

procedure TfmMainNav3.actDetailsCopyExecute(Sender: TObject);
begin
  Clipboard.AsText := sgDetails.Cells[sgDetails.Col, sgDetails.Row];
end;

procedure TfmMainNav3.actDetailsCopyUpdate(Sender: TObject);
begin
  (Sender as TAction).Enabled :=
    (nstate in [nstEdit, nstView]) and
    (sgDetails.Focused) and
    (sgDetails.Selection.Top > 0);
end;

procedure TfmMainNav3.actDetailsDelExecute(Sender: TObject);
var
  ix, i: integer;
  itm: TNavItem;
begin
  ix := sgDetails.Selection.Top-1;

  itm := TNavItem(tvList.Selected.Data);
  itm.Params.Delete(ix);

  for i := ix+1 to sgDetails.RowCount-2 do
  begin
    sgDetails.Cells[0, i] := sgDetails.Cells[0, i+1];
    sgDetails.Cells[1, i] := sgDetails.Cells[1, i+1];
  end;
  sgDetails.RowCount := sgDetails.RowCount - 1;
end;

procedure TfmMainNav3.actDetailsDelUpdate(Sender: TObject);
begin
  (Sender as TAction).Enabled :=
    (nstate = nstEdit) and
    (sgDetails.Focused) and
    (sgDetails.Selection.Top > 0);
end;

procedure TfmMainNav3.actDetailsMoveDownExecute(Sender: TObject);
var
  ix: integer;
  itm: TNavItem;
begin
  ix := sgDetails.Selection.Top - 1;
  itm := TNavItem(tvList.Selected.Data);
  itm.Params.Move(ix, ix+1);
  UpdateParamsdata(itm);
  sgDetails.Row := sgDetails.Row+1;
end;

procedure TfmMainNav3.actDetailsMoveDownUpdate(Sender: TObject);
begin
  (Sender as TAction).Enabled :=
    (nstate = nstEdit) and
    (sgDetails.Focused) and
    (sgDetails.Selection.Top < sgDetails.RowCount-1);
end;

procedure TfmMainNav3.actDetailsMoveUpExecute(Sender: TObject);
var
  ix: integer;
  itm: TNavItem;
begin
  ix := sgDetails.Selection.Top - 1;
  itm := TNavItem(tvList.Selected.Data);
  itm.Params.Move(ix, ix-1);
  UpdateParamsdata(itm);
  sgDetails.Row := sgDetails.Row-1;
end;

procedure TfmMainNav3.actDetailsMoveUpUpdate(Sender: TObject);
begin
  (Sender as TAction).Enabled :=
    (nstate = nstEdit) and
    (sgDetails.Focused) and
    (sgDetails.Selection.Top > 1);
end;

procedure TfmMainNav3.actFileExportExecute(Sender: TObject);
var
  sl: TStringList;
  itm: TNavItem;
  p: TNavParam;
begin
  itm := TNavItem(tvList.Selected.Data);
  p := TNavParam(itm.Params[sgDetails.Selection.Top-1]);
  if not p.IsFile then
    Exit;

  sDlg.FileName := p.Name;
  if sDlg.Execute then
  begin
    sl := TStringList.Create;
    try
      sl.Text := p.Value;
      sl.SaveToFile(sDlg.FileName);
    finally
      sl.Free;
    end;
  end;
end;

procedure TfmMainNav3.actFileExportUpdate(Sender: TObject);
begin
  (Sender as TAction).Enabled :=
    (nstate in [nstEdit, nstView]) and
    (sgDetails.Focused) and
    (sgDetails.Selection.Top > 0) and
    (tvList.Selected <> nil) and
    (tvList.Selected.Level > 0) and
    (TNavParam(TNavItem(tvList.Selected.Data).Params[sgDetails.Selection.Top-1]).IsFile);
end;

procedure TfmMainNav3.actFileImportExecute(Sender: TObject);
var
  sl: TStringList;
  itm: TNavItem;
  p: TNavParam;
begin
  if oDlg.Execute then
  begin
    sl := TStringList.Create();
    try
      sl.LoadFromFile(oDlg.FileName);

      sgDetails.RowCount := sgDetails.RowCount + 1;
      sgDetails.Col := 0;
      sgDetails.Row := sgDetails.RowCount-1;

      itm := TNavItem(tvList.Selected.Data);
      p := TNavParam.Create();
      p.IsFile := True;
      p.Name := ExtractFileName(oDlg.FileName);
      p.Value := sl.Text;
      itm.Params.Add(p);

      sgDetails.Cells[0, sgDetails.Row] := C_FILE_MARKER;
      sgDetails.Cells[1, sgDetails.Row] := p.Name;
    finally
      sl.Free;
    end;
  end;
end;

procedure TfmMainNav3.actFileImportUpdate(Sender: TObject);
begin
  (Sender as TAction).Enabled :=
    (nstate = nstEdit) and
    (sgDetails.Focused);
end;

{%EndRegion}

{%Region 'Logic'}
procedure TfmMainNav3.UpdatePanels(ADialog: boolean);
begin
  tbMenu.Visible := not ADialog and (nstate <> nstFile);
  pnlList.Visible := not ADialog and (nstate <> nstFile);
  pnlDetails.Visible := not ADialog and (nstate <> nstFile);
  pnlFile.Visible := not ADialog and (nstate = nstFile);
  stBar.Visible := not ADialog;

  pnlPassword.Visible := ADialog and (not FData.Error);
  btOk.Enabled := pnlPassword.Visible;
  btCancel.Enabled := pnlPassword.Visible;
  pnlError.Visible := ADialog and FData.Error;

  if not ADialog then
  begin
    sgDetails.Columns[0].Width := Round((sgDetails.Width - 20) * 0.25);
    sgDetails.Columns[1].Width := Round((sgDetails.Width - 20) * 0.75);

    actSave.Visible := nstate = nstEdit;
    actEdit.Visible := nstate = nstView;
    actExit.Visible := nstate = nstView;

    tbDetails.Visible := nstate = nstEdit;
    tbList.Visible := nstate = nstEdit;

    edList.Visible := nstate = nstView;
    edList.Clear;

    if nstate = nstView then
    begin
      tvList.Options := tvList.Options + [tvoReadOnly];
      sgDetails.Options := sgDetails.Options - [goEditing];
    end
    else if nstate = nstEdit then
    begin
      tvList.Options := tvList.Options - [tvoReadOnly];
      sgDetails.Options := sgDetails.Options + [goEditing];
    end;
  end;
end;

procedure TfmMainNav3.ShowPassDialog();
begin
  UpdatePanels(True);

  if not FData.Error then
  begin
    pnlPassword.Left := (ClientWidth - pnlPassword.Width) div 2;
    pnlPassword.Top := (ClientHeight - pnlPassword.Height) div 2;
    edPass.Text := '';
    ActiveControl := edPass;
  end
  else
  begin
    pnlError.Left := (ClientWidth - pnlError.Width) div 2;
    pnlError.Top := (ClientHeight - pnlError.Height) div 2;
  end;
end;

procedure TfmMainNav3.EndPassDialog(AResult: boolean; const AText: string);
var
  i, j: integer;
  g: TNavGroup;
  itm: TNavItem;
  nd, nd2: TTreeNode;
begin
  if nstate = nstLogin then
  begin
    if AResult and FData.CheckPassword(0, AText) then
    begin
      nstate := nstView;
      UpdatePanels(False);
      tvList.BeginUpdate;
      try
        tvList.Items.Clear;

        // filling
        for i := 0 to FData.Groups.Count - 1 do
        begin
          // groups
          g := TNavGroup(FData.Groups[i]);
          nd := tvList.Items.AddChild(nil, g.Name);
          nd.Data := g;
          nd.ImageIndex := 16;
          nd.SelectedIndex := 16;

          // items
          for j := 0 to g.Items.Count - 1 do
          begin
            itm := TNavItem(g.Items[j]);
            nd2 := tvList.Items.AddChild(nd, itm.Name);
            nd2.Data := itm;
            nd2.ImageIndex := 15;
            nd2.SelectedIndex := 15;
          end;

          nd.Expand(True);
        end;

        // selection
        if tvList.Items.Count > 0 then
          tvList.Selected := tvList.Items[0];
      finally
        tvList.EndUpdate;
      end;
      ActiveControl := tvList;
    end
    else
      // wrong password or cancel = exit
      Close();
  end
  else if nstate = nstEdit then
  begin
    if AResult and FData.CheckPassword(1, AText) then
      UpdatePanels(False)
    else
    begin
      // wrong password - exit
      nstate := nstView;
      UpdatePanels(False);
    end;
  end;
end;

procedure TfmMainNav3.UpdateParamsdata(AItem: TNavItem);
var
  i: integer;
  p: TNavParam;
begin
  sgDetails.RowCount := AItem.Params.Count + 1;
  for i := 0 to AItem.Params.Count - 1 do
  begin
    p := TNavParam(AItem.Params[i]);
    if p.IsFile then
    begin
      sgDetails.Cells[0, i+1] := C_FILE_MARKER;
      sgDetails.Cells[1, i+1] := p.Name;
    end
    else
    begin
      sgDetails.Cells[0, i+1] := p.Name;
      sgDetails.Cells[1, i+1] := p.Value;
    end;
  end;
end;
{%EndRegion}


end.

