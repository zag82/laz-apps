unit treebase;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ExtCtrls,
  ComCtrls, Buttons, dataproj;

type

  { TfmTreeBase }

  TfmTreeBase = class(TForm)
    btOk: TButton;
    btCancel: TButton;
    btAddToProject: TButton;
    btTreeAdd: TButton;
    btTreeDel: TButton;
    cDlg: TColorDialog;
    edName: TEdit;
    edRadius: TEdit;
    gbParams: TGroupBox;
    gbList: TGroupBox;
    lbName: TLabel;
    lbDescr: TLabel;
    lbRadius: TLabel;
    lbColor: TLabel;
    lbFill: TLabel;
    mmDescr: TMemo;
    pnlControl: TPanel;
    spColor: TShape;
    spFill: TShape;
    tv: TTreeView;
    procedure btAddToProjectClick(Sender: TObject);
    procedure btCancelClick(Sender: TObject);
    procedure btOkClick(Sender: TObject);
    procedure btTreeAddClick(Sender: TObject);
    procedure btTreeDelClick(Sender: TObject);
    procedure edNameChange(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure spColorMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure spFillMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure tvDblClick(Sender: TObject);
    procedure tvSelectionChanged(Sender: TObject);
  private
    FTrees: TProjTreeData;
    FFilling: boolean;
  public
  end;

var
  fmTreeBase: TfmTreeBase;

implementation

uses
  mainproj;

{$R *.lfm}

{ TfmTreeBase }

procedure TfmTreeBase.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  CloseAction := caFree;
  fmTreeBase := nil;
end;

procedure TfmTreeBase.FormCreate(Sender: TObject);
var
  i: integer;
  tree: TProjTree;
  nd: TTreeNode;
begin
  FTrees := TProjTreeData.Create(fmMainProj.DataPath + 'treedata');
  FFilling := False;

  tv.Items.Clear;
  for i := 0 to FTrees.Trees.Count - 1 do
  begin
    tree := TProjTree(FTrees.Trees[i]);
    nd := tv.Items.AddChild(nil, tree.Name);
    nd.Data := tree;
  end;
  if tv.Items.Count > 0 then
    tv.Selected := tv.Items[0];
  tvSelectionChanged(tv);
end;

procedure TfmTreeBase.FormDestroy(Sender: TObject);
begin
  FTrees.Free;
end;

procedure TfmTreeBase.btCancelClick(Sender: TObject);
begin
  Close;
end;

procedure TfmTreeBase.btOkClick(Sender: TObject);
begin
  FTrees.SaveBase();
  //Close;
end;

procedure TfmTreeBase.btAddToProjectClick(Sender: TObject);
begin
  if tv.Selected <> nil then
    fmMainProj.AddTree(TProjTree(tv.Selected.Data));
end;

{%Region 'Actions'}
procedure TfmTreeBase.btTreeAddClick(Sender: TObject);
var
  tree: TProjTree;
  nd: TTreeNode;
begin
  tree := TProjTree.Create();
  FTrees.Trees.Add(tree);
  nd := tv.Items.AddChild(nil, tree.Name);
  nd.Data := tree;
  tv.Selected := nd;
end;

procedure TfmTreeBase.btTreeDelClick(Sender: TObject);
var
  nd, nd2: TTreeNode;
  tree: TProjTree;
begin
  nd := tv.Selected;
  nd2 := nd.GetNextSibling;
  tree := TProjTree(nd.Data);
  FTrees.Trees.Remove(tree);
  tree.Free;
  nd.Delete;
  if nd2 <> nil then
    tv.Selected := nd2
  else
    tv.Selected := tv.Items.GetLastNode;
end;

procedure TfmTreeBase.edNameChange(Sender: TObject);
var
  nd: TTreeNode;
  tree: TProjTree;
begin
  if FFilling then
    Exit;
  nd := tv.Selected;
  if nd = nil then Exit;
  tree := TProjTree(nd.Data);
  tree.Name := edName.Text;
  tree.Descr := mmDescr.Text;
  tree.Radius := StrToFloatDef(edRadius.Text, 0);
  tree.Color := spColor.Brush.Color;
  tree.FillColor := spFill.Brush.Color;
  nd.Text := tree.Name;
end;

procedure TfmTreeBase.spColorMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if FFilling then Exit;
  cDlg.Color := spColor.Brush.Color;
  if cDlg.Execute then
  begin
    spColor.Brush.Color := cDlg.Color;
    edNameChange(Sender);
  end;
end;

procedure TfmTreeBase.spFillMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if FFilling then Exit;
  cDlg.Color := spFill.Brush.Color;
  if cDlg.Execute then
  begin
    spFill.Brush.Color := cDlg.Color;
    edNameChange(Sender);
  end;
end;

procedure TfmTreeBase.tvDblClick(Sender: TObject);
begin
  btAddToProjectClick(btAddToProject);
end;

procedure TfmTreeBase.tvSelectionChanged(Sender: TObject);
var
  nd: TTreeNode;
  tree: TProjTree;
begin
  nd := tv.Selected;

  FFilling := True;
  try
    edName.Enabled := (nd <> nil);
    mmDescr.Enabled := (nd <> nil);
    edRadius.Enabled := (nd <> nil);
    spColor.Enabled := (nd <> nil);
    spFill.Enabled := (nd <> nil);

    if nd <> nil then
    begin
      tree := TProjTree(nd.Data);
      edName.Text := tree.Name;
      mmDescr.Text := tree.Descr;
      edRadius.Text := FloatToStr(tree.Radius);
      spColor.Brush.Color := tree.Color;
      spFill.Brush.Color := tree.FillColor;
    end;
  finally
    FFilling := False;
  end;
end;
{%Endregion}

end.

