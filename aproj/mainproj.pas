unit mainproj;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs,
  Menus, ActnList, ComCtrls, ExtCtrls, StdCtrls,

  dataproj, graphproj, Types;

type

  { TfmMainProj }

  TfmMainProj = class(TForm)
    actAbout: TAction;
    actUndo: TAction;
    actMesh: TAction;
    actObjectAddSimple: TAction;
    actTreeBase: TAction;
    actPFunc: TAction;
    actLayerAdd: TAction;
    actViewScale: TAction;
    actLayerDel: TAction;
    actObjectAdd: TAction;
    actObjectDel: TAction;
    actMoveUp: TAction;
    actMoveDown: TAction;
    actRuler: TAction;
    actViewNormal: TAction;
    actViewNorth: TAction;
    actNewDoc: TAction;
    actOpenDoc: TAction;
    actSaveDoc: TAction;
    actSaveAsDoc: TAction;
    actExportDoc: TAction;
    actProps: TAction;
    actQuit: TAction;
    acts: TActionList;
    cbLayerActive: TCheckBox;
    cbObjectActive: TCheckBox;
    cbTitleVisible: TCheckBox;
    cbObjectLineClosed: TCheckBox;
    cbObjectAreaFilled: TCheckBox;
    cDlg: TColorDialog;
    cbPenStyle: TComboBox;
    cbBrushStyle: TComboBox;
    cbFixed: TCheckBox;
    edLayerName: TEdit;
    edObjectName: TEdit;
    edTitleSIze: TEdit;
    edObjectLineWidth: TEdit;
    gbDraw: TGroupBox;
    gbTitle: TGroupBox;
    gbSummary: TGroupBox;
    imgsTree: TImageList;
    imgsSmall: TImageList;
    imgs: TImageList;
    lbToolObject: TLabel;
    lbTooLayers: TLabel;
    lbToolTools: TLabel;
    lbToolView: TLabel;
    lbPerimeter: TLabel;
    lbArea: TLabel;
    lbLayerName: TLabel;
    lbObjectLineWidth: TLabel;
    lbObjectName: TLabel;
    lbObjectDescr: TLabel;
    lbColor: TLabel;
    lbFillColor: TLabel;
    lbPenStyle: TLabel;
    lbBrushStyle: TLabel;
    lbTitleSize: TLabel;
    lbTitleColor: TLabel;
    N6: TMenuItem;
    miPopupMoveUp: TMenuItem;
    miPopupMoveDown: TMenuItem;
    miPopupAddLayer: TMenuItem;
    miPopupDelLayer: TMenuItem;
    N5: TMenuItem;
    miPopupAddOnbject: TMenuItem;
    miPopupConstructObject: TMenuItem;
    miPopupDelObject: TMenuItem;
    miUndo: TMenuItem;
    N4: TMenuItem;
    miExportJson: TMenuItem;
    miMesh: TMenuItem;
    miTreeBase: TMenuItem;
    miObjectAddSimple: TMenuItem;
    miPFunc: TMenuItem;
    mmObjectDescr: TMemo;
    miLayerAdd: TMenuItem;
    miLayerDel: TMenuItem;
    miObjectAdd: TMenuItem;
    miObjectDel: TMenuItem;
    miMoveUp: TMenuItem;
    miMoveDown: TMenuItem;
    miRuler: TMenuItem;
    N3: TMenuItem;
    N2: TMenuItem;
    N1: TMenuItem;
    miViewScale: TMenuItem;
    miViewNormalize: TMenuItem;
    miViewNorth: TMenuItem;
    miView: TMenuItem;
    miQuit: TMenuItem;
    miSep3: TMenuItem;
    miProps: TMenuItem;
    miSep2: TMenuItem;
    miExport: TMenuItem;
    miSep1: TMenuItem;
    miSaveAsDoc: TMenuItem;
    miSaveDoc: TMenuItem;
    miOpenDoc: TMenuItem;
    miAbout: TMenuItem;
    miNewDoc: TMenuItem;
    mmenu: TMainMenu;
    miFile: TMenuItem;
    miTools: TMenuItem;
    miHelp: TMenuItem;
    pcObjects: TPageControl;
    pb: TPaintBox;
    pmTree: TPopupMenu;
    spColor: TShape;
    spFillColor: TShape;
    spTitleColor: TShape;
    split: TSplitter;
    splitProps: TSplitter;
    status: TStatusBar;
    btLayerAdd: TToolButton;
    btLayerDel: TToolButton;
    bt2: TToolButton;
    btObjectAdd: TToolButton;
    btObjectDel: TToolButton;
    bt3: TToolButton;
    btMoveUp: TToolButton;
    btMoveDown: TToolButton;
    bt4: TToolButton;
    btViewNormalize: TToolButton;
    btViewNorth: TToolButton;
    bt5: TToolButton;
    btViewScale: TToolButton;
    btRuller: TToolButton;
    bt6: TToolButton;
    btPFunc: TToolButton;
    btObjectAddSimple: TToolButton;
    btTreeBase: TToolButton;
    btMesh: TToolButton;
    tbUndo: TToolButton;
    tsLayers: TTabSheet;
    tsObjects: TTabSheet;
    tb: TToolBar;
    tbOpen: TToolButton;
    tbSave: TToolButton;
    tbProps: TToolButton;
    bt1: TToolButton;
    tv: TTreeView;
    procedure actAboutExecute(Sender: TObject);
    procedure actExportDocExecute(Sender: TObject);
    procedure actLayerAddExecute(Sender: TObject);
    procedure actLayerAddUpdate(Sender: TObject);
    procedure actLayerDelExecute(Sender: TObject);
    procedure actLayerDelUpdate(Sender: TObject);
    procedure actMeshExecute(Sender: TObject);
    procedure actMoveDownExecute(Sender: TObject);
    procedure actMoveDownUpdate(Sender: TObject);
    procedure actMoveUpExecute(Sender: TObject);
    procedure actMoveUpUpdate(Sender: TObject);
    procedure actNewDocExecute(Sender: TObject);
    procedure actObjectAddExecute(Sender: TObject);
    procedure actObjectAddSimpleExecute(Sender: TObject);
    procedure actObjectAddUpdate(Sender: TObject);
    procedure actObjectDelExecute(Sender: TObject);
    procedure actObjectDelUpdate(Sender: TObject);
    procedure actOpenDocExecute(Sender: TObject);
    procedure actPFuncExecute(Sender: TObject);
    procedure actPFuncUpdate(Sender: TObject);
    procedure actPropsExecute(Sender: TObject);
    procedure actQuitExecute(Sender: TObject);
    procedure actRulerExecute(Sender: TObject);
    procedure actSaveAsDocExecute(Sender: TObject);
    procedure actSaveAsDocUpdate(Sender: TObject);
    procedure actSaveDocExecute(Sender: TObject);
    procedure actSaveDocUpdate(Sender: TObject);
    procedure actTreeBaseExecute(Sender: TObject);
    procedure actUndoExecute(Sender: TObject);
    procedure actUndoUpdate(Sender: TObject);
    procedure actViewNormalExecute(Sender: TObject);
    procedure actViewNorthExecute(Sender: TObject);
    procedure actViewScaleExecute(Sender: TObject);
    procedure cbLayerActiveClick(Sender: TObject);
    procedure cbObjectActiveClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure miExportJsonClick(Sender: TObject);
    procedure pbMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure pbMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure pbMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure pbMouseWheel(Sender: TObject; Shift: TShiftState;
      WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
    procedure pbPaint(Sender: TObject);
    procedure spColorMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure tvKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure tvSelectionChanged(Sender: TObject);
  private
    FRootPath: string;
    FDataPath: string;
    FFilesPath: string;
    FExportPath: string;
    FProj: TProjData;
    FGraph: TProjGraph;
    FFileName: string;
    FModified: boolean;
    FFilling: boolean;
    function doStopActionOnModified(): boolean;
    procedure doOpen();
    procedure doSave();
    procedure doUpdateStatus();
    procedure doRebuildTree();
    function canMove(ADir: integer): boolean;
    procedure doMove(ADir: integer);
  public
    property Proj: TProjData read FProj;
    property Graph: TProjGraph read FGraph;
    property RootPath: string read FRootPath;
    property DataPath: string read FDataPath;
    property FilesPath: string read FFilesPath;
    property ExportPath: string read FExportPath;

    procedure AddTree(ATree: TProjTree);
    procedure SetModified();
  end;

var
  fmMainProj: TfmMainProj;

implementation

uses
  LCLType,
  aboutproj,
  propsproj,
  pfunc,
  simpleobject,
  treebase,
  meshcontrol,
  dialogfiles;


{$R *.lfm}

{ TfmMainProj }

{%Region 'Form'}
procedure TfmMainProj.FormCreate(Sender: TObject);
  function processPath(const APath: string): string;
  begin
    Result := APath;
    if not DirectoryExists(APath) then
      ForceDirectories(APath);
    Result := APath + PathDelim;
  end;

begin
  FFilling := False;
  FRootPath := ExtractFilePath(Application.ExeName);
  FDataPath := processPath(FRootPath + 'aproj.data');
  FFilesPath := processPath(FDataPath + 'files');
  FExportPath := processPath(FDataPath + 'exports');
  pcObjects.ShowTabs := False;

  FProj := TProjData.Create;
  FGraph := TProjGraph.Create(FProj, pb);
  FModified := False;

  pb.Canvas.AntialiasingMode := TAntialiasingMode.amOn;
  tb.Height := 68;

  actNewDocExecute(Self);
end;

procedure TfmMainProj.FormDestroy(Sender: TObject);
begin
  FreeAndNil(FProj);
  FreeAndNil(FGraph);
end;

function gen_uuid(): string;
begin
  Result :=
    IntToHex((random($ffff) + (random($ffff) shl 16)) and $00000000ffffffff, 8) +
    '-' +
    IntToHex(random($ffff), 4) +
    '-' +
    IntToHex((4 shl 12) or random($1000), 4) +
    '-' +
    IntToHex((1 shl 7) or random(128), 2) +
    IntToHex(random(255), 2) +
    '-' +
    IntToHex(random(255), 2) +
    IntToHex(random(255), 2) +
    IntToHex(random(255), 2) +
    IntToHex(random(255), 2) +
    IntToHex(random(255), 2) +
    IntToHex(random(255), 2);
end;

procedure TfmMainProj.miExportJsonClick(Sender: TObject);
  function colorToHexString(AColor: TColor): string;
  var
    r, g, b: byte;
  begin
    r := AColor and $0000ff;
    g := (AColor and $00ff00) shr 8;
    b := (AColor and $ff0000) shr 16;
    Result := '#' + IntToHex(r, 2) + IntToHex(g, 2)+IntToHex(b, 2);
  end;
  function getBool(AValue: boolean): string;
  begin
    if AValue then
      Result := 'true'
    else
      Result := 'false';
  end;
  function getIsLast(AItem: integer; ACount: integer): string;
  begin
    if AItem = ACount-1 then
      Result := ''
    else
      Result := ',';
  end;

  function getExportFileID(): string;
  begin
    Result := LowerCase(gen_uuid());
  end;

  function getExportFileName(): string;
  begin
    Result := Trim(ChangeFileExt(ExtractFileName(FFileName), ''));
  end;

var
  fileName: string;
  f: TextFile;
  i, j, k, cnt: integer;
  lay: TProjLayer;
  ob: TProjObject;
  uid: string;
begin
  // спрашиваем куда
  uid := getExportFileID();
  fileName := ExtractFilePath(FFileName) + uid + '.json';
  AssignFile(f, fileName);
  Rewrite(f);

  writeln(f, '{');
  writeln(f, '  "id": "'+uid+'",');
  writeln(f, '  "name": "'+getExportFileName()+'",');
  writeln(f, '  "version": '+IntToStr(C_PROJ_VERSION)+',');
  writeln(f, '  "colors": [');
  cnt := 0;
  for i := 0 to high(cProjectColorNames) do
    if cProjectColorNames[i] <> '' then
      cnt := cnt + 1;
  for i := 0 to high(cProjectColorNames) do
    if cProjectColorNames[i] <> '' then
    begin
      writeln(f, '    {');
      writeln(f, '      "param": "'+cProjectColorNames[i]+'",');
      writeln(f, '      "value": "'+colorToHexString(FProj.Colors[TProjColors(i)])+'"');
      writeln(f, '    }'+getIsLast(i, cnt));
    end;
  writeln(f, '  ],');
  writeln(f, '  "description": "'+Trim(FProj.Description)+'",');

  // layers
  writeln(f, '  "layers": [');
  for i := 0 to FProj.Layers.Count - 1 do
  begin
    lay := TProjLayer(FProj.Layers[i]);
    writeln(f, '    {');
    writeln(f, '      "active": '+getBool(lay.Active)+',');
    writeln(f, '      "name": "'+lay.Name+'",');

    // objects in layer
    writeln(f, '      "objects": [');
    for j := 0 to lay.Objects.Count - 1 do
    begin
      ob := TProjObject(lay.Objects[j]);
      writeln(f, '      {');
      writeln(f, '        "active": '+getBool(ob.Active)+',');
      writeln(f, '        "name": "'+ob.Name+'",');
      writeln(f, '        "description": "'+TRim(ob.Descr)+'",');

      writeln(f, '        "width": '+ob.Width.ToString()+',');
      writeln(f, '        "closed": '+getBool(ob.Closed)+',');
      writeln(f, '        "filled": '+getBool(ob.Filled)+',');
      writeln(f, '        "fixed": '+getBool(ob.Fixed)+',');

      writeln(f, '        "color": "'+colorToHexString(ob.Color)+'",');
      writeln(f, '        "fillcolor": "'+colorToHexString(ob.FillColor)+'",');
      writeln(f, '        "penstyle": '+ord(ob.PenStyle).ToString()+',');
      writeln(f, '        "brushstyle": '+ord(ob.BrushStyle).ToString()+',');

      writeln(f, '        "title": {');
      writeln(f, '          "visible": '+getBool(ob.TitleVisible)+',');
      writeln(f, '          "x": '+ob.TitlePointX.ToString()+',');
      writeln(f, '          "y": '+ob.TitlePointY.ToString()+',');
      writeln(f, '          "size": '+ob.TitleSize.ToString()+',');
      writeln(f, '          "color": "'+colorToHexString(ob.TitleColor)+'"');
      writeln(f, '        },');

      writeln(f, '        "points": [');
      for k := 0 to ob.Count - 1 do
      begin
        writeln(f, '          {');
        writeln(f, '            "x": '+ob.X[k].ToString()+',');
        writeln(f, '            "y": '+ob.Y[k].ToString());
        writeln(f, '          }'+getIsLast(k, ob.Count));
      end;
      writeln(f, '        ]');
      writeln(f, '      }'+getIsLast(j, lay.Objects.Count));
    end;
    writeln(f, '      ]');
    writeln(f, '    }'+getIsLast(i, FProj.Layers.Count));
  end;
  writeln(f, '  ]');
  writeln(f, '}');

  CloseFile(f);
end;

procedure TfmMainProj.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  if doStopActionOnModified() then
  begin
    CloseAction := TCloseAction.caNone;
    Exit;
  end;
  // закрываемся
  CloseAction := TCloseAction.caFree;
end;

{%EndRegion}

{%Region 'App logic'}
function TfmMainProj.doStopActionOnModified(): boolean;
begin
  Result := False;
  if FModified then
  begin
    // нужно спросить про сохранение
    if MessageDlg('Подтверждение', 'Проект не сохранен. Желаете сохранить?', mtConfirmation, mbYesNo, 0) = mrYes then
    begin
      actSaveDocExecute(Self);
      if FModified then // не сохраняли, т.е. нажали Отмена в диалоге сохранения
        Result := True;
    end;
  end;
end;

procedure TfmMainProj.doOpen();
begin
  FModified := False;
  FProj.Clear;
  FProj.Load(FFileName);
  FGraph.Ruler := False;
  actRuler.Caption := 'Линейка (выкл)';
  if Assigned(fmPFunc) then
    fmPFunc.Close;

  doRebuildTree();
  doUpdateStatus();
  pb.Update();
end;

procedure TfmMainProj.doSave();
begin
  FModified := False;
  FProj.Save(FFileName);

  doUpdateStatus();
  pb.Update;
end;

procedure TfmMainProj.doUpdateStatus();
begin
  if FFileName = '' then
  begin
    Caption := 'aproj - <Новый проект>';
    status.SimpleText := '<Новый проект>*';
  end
  else
  begin
    Caption := 'aproj - ' + FFileName;
    status.SimpleText := FFileName;
    if FModified then
      status.SimpleText := status.SimpleText + '*';
  end;
end;

procedure TfmMainProj.doRebuildTree();
var
  i, j: integer;
  nd, nd2: TTreeNode;
  layer: TProjLayer;
  ob: TProjObject;
begin
  tv.BeginUpdate;
  try
    tv.Items.Clear;
    for i := 0 to FProj.Layers.Count - 1 do
    begin
      layer := TProjLayer(FProj.Layers[i]);
      nd := tv.Items.AddChild(nil, layer.Name);
      if layer.Active then
        nd.StateIndex := 1
      else
        nd.StateIndex := 0;
      nd.Data := layer;

      for j := 0 to layer.Objects.Count - 1 do
      begin
        ob := TProjObject(layer.Objects[j]);
        nd2 := tv.Items.AddChild(nd, ob.Name);
        if ob.Active then
          nd2.StateIndex := 1
        else
          nd2.StateIndex := 0;
        nd2.Data := ob;
      end;
      nd.Expand(True);
    end;
    if tv.Items.Count > 0 then
      tv.Items[0].Selected := True;
  finally
    tv.EndUpdate;
  end;
end;

{%EndRegion}

{%Region 'Actions'}
procedure TfmMainProj.actQuitExecute(Sender: TObject);
begin
  Close;
end;

procedure TfmMainProj.actRulerExecute(Sender: TObject);
begin
  FGraph.Ruler := not FGraph.Ruler;
  if FGraph.Ruler then
    actRuler.Caption := 'Линейка (вкл)'
  else
    actRuler.Caption := 'Линейка (выкл)';
  pb.Update;
end;

procedure TfmMainProj.actSaveAsDocExecute(Sender: TObject);
begin
  fmDialogFiles := TfmDialogFiles.Create(Application);
  fmDialogFiles.Init(FFilesPath, True, FFileName);
  if fmDialogFiles.ShowModal = mrOK then
  begin
    FFileName := fmDialogFiles.FileName;
    doSave();
  end;
  fmDialogFiles.Free;
end;

procedure TfmMainProj.actSaveAsDocUpdate(Sender: TObject);
begin
  (Sender as TAction).Enabled := True;
end;

procedure TfmMainProj.actSaveDocExecute(Sender: TObject);
begin
  if FFileName = '' then
    actSaveAsDocExecute(self)
  else
    doSave();
end;

procedure TfmMainProj.actSaveDocUpdate(Sender: TObject);
begin
  (Sender as TAction).Enabled := FModified;
end;

procedure TfmMainProj.actTreeBaseExecute(Sender: TObject);
begin
  //
  if not Assigned(fmTreeBase) then
  begin
    fmTreeBase := TfmTreeBase.Create(Application);
    fmTreeBase.Show;
  end;
end;

procedure TfmMainProj.actUndoExecute(Sender: TObject);
begin
  FModified := True;
  FProj.Rollback();
  if Assigned(fmPFunc) then
    fmPFunc.Close;
  doRebuildTree();
  doUpdateStatus();
  pb.Update();
  if fmMeshControl <> nil then
    fmMeshControl.UpdateData();
end;

procedure TfmMainProj.actUndoUpdate(Sender: TObject);
begin
  (Sender as TAction).Enabled := FProj.StoragesCount > 1;
end;

procedure TfmMainProj.actMeshExecute(Sender: TObject);
begin
  if not Assigned(fmMeshControl) then
  begin
    fmMeshControl := TfmMeshControl.Create(Application);
    fmMeshControl.Show;
  end;
end;

procedure TfmMainProj.actViewNormalExecute(Sender: TObject);
begin
  FProj.Angle := 0;
  FProj.Scale := 0;
  FProj.TransX := 0;
  FProj.TransY := 0;
  pb.Update;
end;

procedure TfmMainProj.actViewNorthExecute(Sender: TObject);
begin
  FProj.Angle := 0;
  pb.Update;
end;

procedure TfmMainProj.actViewScaleExecute(Sender: TObject);
begin
  FProj.Scale := 0;
  pb.Update;
end;

procedure TfmMainProj.actNewDocExecute(Sender: TObject);
begin
  if doStopActionOnModified() then
    Exit;
  FFileName := '';
  FModified := False;
  FProj.Clear;
  FProj.Layers.Add(TProjLayer.Create());
  FGraph.Ruler:= False;
  actRuler.Caption := 'Линейка (выкл)';

  doRebuildTree();
  doUpdateStatus();
  pb.Update();
  Fproj.CommitInit();
  if fmMeshControl <> nil then
    fmMeshControl.UpdateData();
end;

procedure TfmMainProj.actObjectAddExecute(Sender: TObject);
var
  ob: TProjObject;
  lay: TProjLayer;
  nd, nd2: TTreeNode;
begin
  nd := tv.Selected;
  if nd.Level > 0 then
    nd := nd.Parent;
  lay := TProjLayer(nd.Data);

  ob := TProjObject.Create();
  lay.Objects.Add(ob);

  nd2 := tv.Items.AddChild(nd, ob.Name);
  nd2.Data := ob;
  nd2.StateIndex := 1;
  tv.Selected := nd2;
  FModified := True;
  pb.Update;
  FProj.Commit();
end;

procedure TfmMainProj.actObjectAddSimpleExecute(Sender: TObject);
var
  ob: TProjObject;
  lay: TProjLayer;
  nd, nd2: TTreeNode;
begin
  fmSimpleObject := TfmSimpleObject.Create(Application);
  if fmSimpleObject.ShowModal = mrOK then
  begin
    nd := tv.Selected;
    if nd.Level > 0 then
      nd := nd.Parent;
    lay := TProjLayer(nd.Data);

    ob := TProjObject.Create();
    ob.Name := fmSimpleObject.edName.Text;
    ob.FillPoints(FGraph.CenterPoint(), fmSimpleObject.edScript.Text);
    lay.Objects.Add(ob);

    nd2 := tv.Items.AddChild(nd, ob.Name);
    nd2.Data := ob;
    nd2.StateIndex := 1;
    tv.Selected := nd2;
    FModified := True;
    pb.Update;
    FProj.Commit();
  end;
  fmSimpleObject.Free;
end;

procedure TfmMainProj.AddTree(ATree: TProjTree);
var
  ob: TProjObject;
  lay: TProjLayer;
  nd, nd2: TTreeNode;
begin
  nd := tv.Selected;
  if nd.Level > 0 then
    nd := nd.Parent;
  lay := TProjLayer(nd.Data);

  ob := TProjObject.Create();
  ob.Name := ATree.Name;
  ob.Width := 2 * ATree.Radius;
  ob.Descr := ATree.Descr;
  ob.AddPoint(FGraph.CenterPoint());
  ob.Color := ATree.Color;
  ob.FillColor := ATree.FillColor;
  lay.Objects.Add(ob);

  nd2 := tv.Items.AddChild(nd, ob.Name);
  nd2.Data := ob;
  nd2.StateIndex := 1;
  tv.Selected := nd2;
  FModified := True;
  pb.Update;
  FProj.Commit();
end;

procedure TfmMainProj.SetModified();
begin
  FModified := True;
end;

procedure TfmMainProj.actObjectAddUpdate(Sender: TObject);
begin
  (Sender as TAction).Enabled := True;
end;

procedure TfmMainProj.actObjectDelExecute(Sender: TObject);
var
  nd, nd2, ndNew: TTreeNode;
  ob: TProjObject;
  lay: TProjLayer;
begin
  if MessageDlg('Подтверждение', 'Удалить выбранный объект?', mtConfirmation, mbYesNo, 0) = mrYes then
  begin
    nd := tv.Selected;
    nd2 := nd.Parent;

    ndNew := nd.GetNextSibling;
    if ndNew = nil then
      ndNew := nd.GetPrevSibling;
    if ndNew = nil then
      ndNew := nd2;
    tv.Selected := ndNew;

    ob := TProjObject(nd.Data);
    lay := TProjLayer(nd2.Data);
    lay.Objects.Remove(ob);
    ob.Free;
    nd.Delete;
    FModified := True;
    pb.Update;
    FProj.Commit();
  end;
end;

procedure TfmMainProj.actObjectDelUpdate(Sender: TObject);
begin
  (Sender as TAction).Enabled := (tv.Selected <> nil) and (tv.Selected.Level = 1);
end;

procedure TfmMainProj.actExportDocExecute(Sender: TObject);
var
  png: TPortableNetworkGraphic;
  bmp: TBitmap;
  fn: string;
begin
  // экспортирование в картинку
  bmp := TBitmap.Create;
  png := TPortableNetworkGraphic.Create;
  try
    // сперва в битмап
    bmp.Width := pb.Width;
    bmp.Height := pb.Height;
    bmp.Canvas.CopyRect(Rect(0, 0, pb.Width, pb.Height), pb.Canvas, Rect(0, 0, pb.Width, pb.Height));
    // переводим в конечный формат
    png.Assign(bmp);
    // куда
    fn := FExportPath + 'aproj_' + DateTimeToStr(Now) + '.png';
    png.SaveToFile(fn);
  finally
    png.Free;
    bmp.Free;
  end;
end;

procedure TfmMainProj.actLayerAddExecute(Sender: TObject);
var
  lay: TProjLayer;
  nd: TTreeNode;
begin
  lay := TProjLayer.Create();
  FProj.Layers.Add(lay);
  nd := tv.Items.AddChild(nil, lay.Name);
  nd.Data := lay;
  nd.StateIndex := 1;
  tv.Selected := nd;
  FModified := True;
  pb.Update;
  FProj.Commit();
end;

procedure TfmMainProj.actLayerAddUpdate(Sender: TObject);
begin
  (sender as TAction).Enabled := True;
end;

procedure TfmMainProj.actLayerDelExecute(Sender: TObject);
var
  lay: TProjLayer;
  nd, nd2: TTreeNode;
begin
  if MessageDlg('Подтверждение', 'Удалить выбранный слой?', mtConfirmation, mbYesNo, 0) = mrYes then
  begin
    nd := tv.Selected;
    nd2 := nd.GetNextSibling;
    lay := TProjLayer(nd.Data);
    FProj.Layers.Remove(lay);
    lay.Free;
    nd.Delete;
    if nd2 <> nil then
      tv.Selected := nd2
    else
      tv.Selected := tv.Items.GetLastNode;
    FModified := True;
    pb.Update;
    FProj.Commit();
  end;
end;

procedure TfmMainProj.actLayerDelUpdate(Sender: TObject);
begin
  (sender as TAction).Enabled := (tv.Selected <> nil) and (tv.Selected.Level = 0) and (FProj <> nil) and (FProj.Layers.Count > 1);
end;

function TfmMainProj.canMove(ADir: integer): boolean;
var
  nd: TTreeNode;
begin
  Result := True;
  if tv.Selected.Level = 0 then
  begin
    if ADir < 0 then
      nd := tv.Selected.GetPrevSibling
    else
      nd := tv.Selected.GetNextSibling;
  end
  else
  begin
    if ADir < 0 then
    begin
      nd := tv.Selected.GetPrevSibling;
      if nd = nil then
        nd := tv.Selected.Parent.GetPrevSibling;
    end
    else
    begin
      nd := tv.Selected.GetNextSibling;
      if nd = nil then
        nd := tv.Selected.Parent.GetNextSibling;
    end;
  end;
  Result := nd <> nil;
end;

procedure TfmMainProj.doMove(ADir: integer);
var
  nd1, nd2: TTreeNode;
  lay, lay2: TProjLayer;
  i1, i2: integer;
begin
  nd1 := tv.Selected;
  if ADir < 0 then
  begin
    nd2 := nd1.GetPrevSibling;
    if nd2 <> nil then
    begin
      nd1.MoveTo(nd2, naInsert);
      if nd1.Level = 0 then
      begin
        // layers
        i1 := FProj.Layers.IndexOf(TProjLayer(nd1.Data));
        i2 := FProj.Layers.IndexOf(TProjLayer(nd2.Data));
        FProj.Layers.Move(i1, i2);
      end
      else
      begin
        // items
        lay := TProjLayer(nd1.Parent.Data);
        i1 := lay.Objects.IndexOf(TProjObject(nd1.Data));
        i2 := lay.Objects.IndexOf(TProjObject(nd2.Data));
        lay.Objects.Move(i1, i2);
      end;
    end
    else if nd1.Level > 0 then
    begin
      // items from one group to another
      nd2 := nd1.Parent.GetPrevSibling;
      if nd2 <> nil then
      begin
        // groups
        lay := TProjLayer(nd1.Parent.Data);
        lay2 := TProjLayer(nd2.Data);
        lay2.Objects.Add(TProjObject(nd1.Data));
        lay.Objects.Remove(nd1.Data);
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
      begin
        // layers
        i1 := FProj.Layers.IndexOf(TProjLayer(nd1.Data));
        i2 := FProj.Layers.IndexOf(TProjLayer(nd2.Data));
        FProj.Layers.Move(i1, i2);
      end
      else
      begin
        // items
        lay := TProjLayer(nd1.Parent.Data);
        i1 := lay.Objects.IndexOf(TProjObject(nd1.Data));
        i2 := lay.Objects.IndexOf(TProjObject(nd2.Data));
        lay.Objects.Move(i1, i2);
      end;
    end
    else if nd1.Level > 0 then
    begin
      // items from one group to another
      nd2 := nd1.Parent.GetNextSibling;
      if nd2 <> nil then
      begin
        // layers
        lay := TProjLayer(nd1.Parent.Data);
        lay2 := TProjLayer(nd2.Data);
        lay2.Objects.Insert(0, nd1.Data);
        lay.Objects.Remove(nd1.Data);
        // movement
        nd1.MoveTo(nd2, naAddChildFirst);
      end;
    end;
  end;
  FModified := True;
  pb.Update;
  FProj.Commit();
end;

procedure TfmMainProj.actMoveDownExecute(Sender: TObject);
begin
  doMove(1);
end;

procedure TfmMainProj.actMoveDownUpdate(Sender: TObject);
begin
  (Sender as TAction).Enabled := Assigned(tv.Selected) and canMove(1);
end;

procedure TfmMainProj.actMoveUpExecute(Sender: TObject);
begin
  doMove(-1);
end;

procedure TfmMainProj.actMoveUpUpdate(Sender: TObject);
begin
  (Sender as TAction).Enabled := Assigned(tv.Selected) and canMove(-1);
end;

procedure TfmMainProj.actAboutExecute(Sender: TObject);
begin
  if fmAboutProj = nil then
    fmAboutProj := TfmAboutProj.Create(Application);
  fmAboutProj.BringToFront;
  fmAboutProj.Show;
end;

procedure TfmMainProj.actOpenDocExecute(Sender: TObject);
begin
  if doStopActionOnModified() then
    Exit;

  fmDialogFiles := TfmDialogFiles.Create(Application);
  fmDialogFiles.Init(FFilesPath, False, '');
  if fmDialogFiles.ShowModal = mrOK then
  begin
    FFileName := fmDialogFiles.FileName;
    doOpen();
    FProj.CommitInit();
    if fmMeshControl <> nil then
      fmMeshControl.UpdateData();
  end;
  fmDialogFiles.Free;
end;

procedure TfmMainProj.actPropsExecute(Sender: TObject);
begin
  fmPropsProj := TfmPropsProj.Create(Application);
  fmPropsProj.Init(FProj);
  if fmPropsProj.ShowModal = mrOK then
  begin
    FModified := True;
    pb.Update;
    FProj.Commit();
  end;
  fmPropsProj.Free;
end;

procedure TfmMainProj.actPFuncExecute(Sender: TObject);
begin
  if not Assigned(fmPFunc) then
  begin
    fmPFunc := TfmPFunc.Create(Application);
    fmPFunc.Init(FGraph);
    fmPFunc.Show;
  end;
end;

procedure TfmMainProj.actPFuncUpdate(Sender: TObject);
begin
  (Sender as TAction).Enabled := True;
end;

{%EndRegion}

{%Region 'ComponentEvents'}
procedure TfmMainProj.pbMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  FGraph.MouseDown(X, Y, Button, Shift);
end;

procedure TfmMainProj.pbMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  FGraph.MouseMove(X, Y, Shift, FModified);
end;

procedure TfmMainProj.pbMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  sel, sel2: TProjObject;
  i, j: integer;
  nd: TTreeNode;
begin
  if tv.Selected = nil then
    Exit;
  sel := nil;
  sel2 := nil;
  if tv.Selected.Level = 1 then
    sel := TProjObject(tv.Selected.Data);
  FGraph.MouseUp(X, Y, Button, Shift, FModified, sel2);
  if (sel <> sel2) and (sel2 <> nil) then
  begin
    for i := 0 to tv.Items.Count - 1 do
    begin
      nd := tv.Items[i];
      for j := 0 to nd.Count - 1 do
        if TProjObject(nd.Items[j].Data) = sel2 then
        begin
          tv.Selected := nd.Items[j];
          tv.Selected.MakeVisible;
          Exit;
        end;
    end;
  end;
end;

procedure TfmMainProj.pbMouseWheel(Sender: TObject; Shift: TShiftState;
  WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
begin
  FGraph.MouseWheel(MousePos.x, MousePos.y, WheelDelta, Shift, FModified);
end;

procedure TfmMainProj.pbPaint(Sender: TObject);
begin
  FGraph.Paint();
  if FGraph.Cur <> nil then
  begin
    lbPerimeter.Caption := Format('Периметр: %.3f м', [FGraph.Cur.Perimeter]);
    lbArea.Caption := Format('Площадь: %.6f м2', [FGraph.Cur.Area]);
  end;
end;

procedure TfmMainProj.tvKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (Key = VK_SPACE) and Assigned(tv.Selected) then
    if tv.Selected <> nil then
    begin
      tv.Selected.StateIndex := 1 - tv.Selected.StateIndex;
      TProjObject(tv.Selected.Data).Active := tv.Selected.StateIndex=1;
      tvSelectionChanged(tv);
      FModified := True;
      pb.Update;
      FProj.Commit();
    end;
end;

procedure TfmMainProj.tvSelectionChanged(Sender: TObject);
var
  lay: TProjLayer;
  ob: TProjObject;
begin
  if tv.Selected <> nil then
  begin
    pcObjects.ActivePageIndex := tv.Selected.Level;
    if tv.Selected.Level = 0 then
    begin
      FGraph.Cur := nil;
      FFilling := True;
      try
        lay := TProjLayer(tv.Selected.Data);
        cbLayerActive.Checked := lay.Active;
        edLayerName.Text := lay.Name;
      finally
        FFilling := False;
      end;
    end
    else
    begin
      FGraph.Cur := TProjObject(tv.Selected.Data);
      FFilling := True;
      try
        ob := TProjObject(tv.Selected.Data);
        cbObjectActive.Checked := ob.Active;
        edObjectName.Text := ob.Name;
        mmObjectDescr.Text := ob.Descr;
        cbObjectLineClosed.Checked := ob.Closed;
        cbObjectAreaFilled.Checked := ob.Filled;
        edObjectLineWidth.Text := FloatToStr(ob.Width);
        cbFixed.Checked := ob.Fixed;
        spColor.Brush.Color := ob.Color;
        spFillColor.Brush.Color := ob.FillColor;
        cbPenStyle.ItemIndex := ord(ob.PenStyle);
        cbBrushStyle.ItemIndex := ord(ob.BrushStyle);
        cbTitleVisible.Checked := ob.TitleVisible;
        spTitleColor.Brush.Color := ob.TitleColor;
        edTitleSIze.Text := IntToStr(ob.TitleSize);
      finally
        FFilling := False;
      end;
    end;
    pb.Update;
  end;
end;

{%EndRegion}

{%Region 'Layers'}
procedure TfmMainProj.cbLayerActiveClick(Sender: TObject);
var
  lay: TProjLayer;
begin
  if FFilling then
    Exit;
  if (tv.Selected <> nil) and (tv.Selected.Level = 0) then
  begin
    lay := TProjLayer(tv.Selected.Data);
    lay.Active := cbLayerActive.Checked;
    lay.Name := edLayerName.Text;
    tv.Selected.Text := lay.Name;
    if cbLayerActive.Checked then
      tv.Selected.StateIndex := 1
    else
      tv.Selected.StateIndex := 0;
    FModified := True;
    pb.Update;
    FProj.Commit();
  end;
end;
{%EndRegion}

{%Region 'Objects'}
procedure TfmMainProj.cbObjectActiveClick(Sender: TObject);
var
  ob: TProjObject;
begin
  if FFilling then
    Exit;
  if (tv.Selected <> nil) and (tv.Selected.Level = 1) then
  begin
    ob := TProjObject(tv.Selected.Data);
    ob.Active := cbObjectActive.Checked;
    ob.Name := edObjectName.Text;
    tv.Selected.Text := ob.Name;
    if cbObjectActive.Checked then
      tv.Selected.StateIndex := 1
    else
      tv.Selected.StateIndex := 0;
    ob.Descr := mmObjectDescr.Text;
    ob.Closed := cbObjectLineClosed.Checked;
    ob.Filled := cbObjectAreaFilled.Checked;
    ob.Width := StrToFloatDef(edObjectLineWidth.Text, 0.0);
    ob.Fixed := cbFixed.Checked;
    ob.Color := spColor.Brush.Color;
    ob.FillColor := spFillColor.Brush.Color;
    ob.PenStyle := TPenStyle(cbPenStyle.ItemIndex);
    ob.BrushStyle := TBrushStyle(cbBrushStyle.ItemIndex);
    ob.TitleVisible := cbTitleVisible.Checked;
    ob.TitleColor := spTitleColor.Brush.Color;
    ob.TitleSize := StrToIntDef(edTitleSIze.Text, 10);
    FModified := True;
    pb.Update;
    FProj.Commit();
  end;
end;

procedure TfmMainProj.spColorMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  cDlg.Color := (Sender as TShape).Brush.Color;
  if cDlg.Execute then
  begin
    (Sender as TShape).Brush.Color := cDlg.Color;
    cbObjectActiveClick(Sender);
  end;
end;

{%EndRegion}
end.

