unit meshcontrol;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, Buttons,
  Spin, ExtCtrls;

type

  { TfmMeshControl }

  TfmMeshControl = class(TForm)
    cbMeshVisible: TCheckBox;
    cbMeshType: TComboBox;
    edMeshCenter: TEdit;
    edMeshEdge: TEdit;
    edMeshArea: TEdit;
    gbMain: TGroupBox;
    lbMeshCenter: TLabel;
    lbMeshEdge: TLabel;
    lbMeshArea: TLabel;
    lbMeshAzimuth: TLabel;
    lbMeshType: TLabel;
    btMeshCenter: TSpeedButton;
    edMeshAzimuth: TSpinEdit;
    tm: TTimer;
    procedure btMeshCenterClick(Sender: TObject);
    procedure cbMeshVisibleClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure tmTimer(Sender: TObject);
  private
    FFilling: boolean;
  public
    procedure UpdateData();
  end;

var
  fmMeshControl: TfmMeshControl;

implementation

uses
  mainproj;

{$R *.lfm}

{ TfmMeshControl }

procedure TfmMeshControl.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  tm.Enabled := False;
  CloseAction := caFree;
  fmMeshControl := nil;
end;

procedure TfmMeshControl.cbMeshVisibleClick(Sender: TObject);
var
  spoint: string;
  k: integer;
begin
  if FFilling then
    Exit;

  fmMainProj.Proj.MeshVisible := cbMeshVisible.Checked;
  fmMainProj.Proj.MeshType := cbMeshType.ItemIndex;
  spoint := edMeshCenter.Text;
  k := Pos(',', spoint);
  if k > 0 then
  begin
    fmMainProj.Proj.MeshCenterX := StrToFloatDef(Trim(Copy(spoint, 1, k-1)), 0);
    fmMainProj.Proj.MeshCenterY := StrToFloatDef(Trim(Copy(spoint, k+1)), 0);
  end;
  fmMainProj.Proj.MeshEdge := StrToFloatDef(edMeshEdge.Text, 0);
  fmMainProj.Proj.MeshArea := StrToFloatDef(edMeshArea.Text, 0);
  fmMainProj.Proj.MeshAzimuth := edMeshAzimuth.Value;

  fmMainProj.SetModified();
  fmMainProj.pb.Update;
  fmMainProj.Proj.Commit();
end;

procedure TfmMeshControl.btMeshCenterClick(Sender: TObject);
begin
  if btMeshCenter.Caption = '...' then
  begin
    btMeshCenter.Caption := 'o';
    fmMainProj.Graph.PMesh := True;
  end
  else
  begin
    btMeshCenter.Caption := '...';
    fmMainProj.Graph.PMesh := False;
  end;
end;

procedure TfmMeshControl.FormCreate(Sender: TObject);
begin
  FFilling := False;
  UpdateData();
  tm.Enabled := True;
end;

procedure TfmMeshControl.tmTimer(Sender: TObject);
begin
  if fmMainProj.Graph.MeshPoint() then
  begin
    btMeshCenter.Caption := '...';
    edMeshCenter.Text := fmMainProj.Graph.MeshCaption();
    cbMeshVisibleClick(self);
  end;
end;

procedure TfmMeshControl.UpdateData();
begin
  FFilling := True;
  try
    cbMeshVisible.Checked := fmMainProj.Proj.MeshVisible;
    cbMeshType.ItemIndex := fmMainProj.Proj.MeshType;
    edMeshCenter.Text := FloatToStrF(fmMainProj.Proj.MeshCenterX, ffFixed, 6, 3) + ', ' + FloatToStrF(fmMainProj.Proj.MeshCenterY, ffFixed, 6, 3);
    edMeshEdge.Text := FloatToStr(fmMainProj.Proj.MeshEdge);
    edMeshArea.Text := FloatToStr(fmMainProj.Proj.MeshArea);
    edMeshAzimuth.Value := fmMainProj.Proj.MeshAzimuth;
  finally
    FFilling := False;
  end;
end;

end.

