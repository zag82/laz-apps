unit simpleobject;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, StdCtrls,
  Buttons;

type

  { TfmSimpleObject }

  TfmSimpleObject = class(TForm)
    btMove: TBitBtn;
    btRotate: TBitBtn;
    btRotate90: TBitBtn;
    btRotate270: TBitBtn;
    btRotate180: TBitBtn;
    btOk: TButton;
    btCancel: TButton;
    edMove: TEdit;
    edRotate: TEdit;
    edName: TEdit;
    edScript: TEdit;
    gb: TGroupBox;
    gbPreview: TGroupBox;
    gbControl: TGroupBox;
    lbMove: TLabel;
    lbRotate: TLabel;
    lbName: TLabel;
    lbScript: TLabel;
    pbPreview: TPaintBox;
    pnlControl: TPanel;
    tm: TTimer;
    procedure btCancelClick(Sender: TObject);
    procedure btMoveClick(Sender: TObject);
    procedure btOkClick(Sender: TObject);
    procedure btRotate270Click(Sender: TObject);
    procedure btRotateClick(Sender: TObject);
    procedure pbPreviewPaint(Sender: TObject);
    procedure tmTimer(Sender: TObject);
  private

  public

  end;

var
  fmSimpleObject: TfmSimpleObject;

implementation

uses
  dataproj;

{$R *.lfm}

{ TfmSimpleObject }

procedure TfmSimpleObject.btOkClick(Sender: TObject);
begin
  if (Trim(edName.Text) <> '') and
     (Trim(edScript.Text) <> '') and
     (TProjObject.IsScriptCorrect(Trim(edScript.Text)))
  then
    ModalResult := mrOK
  else
  begin
    ShowMessage('Не верно заполнены поля формы.');
    ModalResult := mrNone;
  end;
end;

procedure TfmSimpleObject.btCancelClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TfmSimpleObject.btMoveClick(Sender: TObject);
begin
  edScript.Text := edScript.Text + 'm'+edMove.Text;
end;

procedure TfmSimpleObject.btRotateClick(Sender: TObject);
begin
  edScript.Text := edScript.Text + 'a'+edRotate.Text;
end;

procedure TfmSimpleObject.btRotate270Click(Sender: TObject);
begin
  edScript.Text := edScript.Text + 'a'+IntToStr(TBitBtn(Sender).Tag);
end;

procedure TfmSimpleObject.tmTimer(Sender: TObject);
begin
  pbPreview.Invalidate();
end;

procedure TfmSimpleObject.pbPreviewPaint(Sender: TObject);
var
  cnt: integer;
  px: array of TFPointType;
  py: array of TFPointType;
  dx, dy: TFPointType;

  procedure innerGrow();
  begin
    if cnt > Length(px) then
    begin
      SetLength(px, cnt + 4);
      SetLength(py, cnt + 4);
    end;
  end;

  procedure innerFillPoints(const AScript: string);
  var
    cmd: boolean;
    v, a: double;
    i, iprev: integer;
    s: string;
  begin
    cnt := 1;
    SetLength(px, cnt);
    SetLength(py, cnt);
    innerGrow;
    px[cnt-1] := 0;
    py[cnt-1] := 0;

    a := 0;
    iprev := -1;
    cmd := False;
    for i := 1 to Length(AScript) do
    begin
      if AScript[i] in ['a', 'm'] then
        cmd := True
      else
        cmd := False;

      if cmd then
      begin
        if i > 1 then
        begin
          s := Trim(Copy(AScript, iprev+1, i-iprev-1));
          v := StrToFloat(s);
          if AScript[iprev] = 'a' then
            a := a + v
          else if AScript[iprev] = 'm' then
          begin
            cnt := cnt + 1;
            innerGrow;
            px[cnt-1] := px[cnt-2] + v * cos(AzimuthToAngle(a));
            py[cnt-1] := py[cnt-2] + v * sin(AzimuthToAngle(a));
          end;
        end;
        iprev := i;
      end;
    end;
    if not cmd then
    begin
      s := Trim(Copy(AScript, iprev+1));
      v := StrToFloat(s);
      if AScript[iprev] = 'm' then
      begin
        cnt := cnt + 1;
        innerGrow;
        px[cnt-1] := px[cnt-2] + v * cos(AzimuthToAngle(a));
        py[cnt-1] := py[cnt-2] + v * sin(AzimuthToAngle(a));
      end;
    end;
  end;

  function max(a, b: TFPointType): TFPointType;
  begin
    if a > b then
      Result := a
    else
      Result := b;
  end;

  function coordToScreen(AX, AY: TFPointType): TPoint;
  var
    d: TFPointType;
  begin
    d := max(dx, dy);
    Result.X := Round((AX/d*0.4+0.5)*pbPreview.Width);
    Result.Y := Round((-AY/d*0.4+0.5)*pbPreview.Height);
  end;

var
  c: TCanvas;
  i: integer;
  pts: array of TPoint;
begin
  c := pbPreview.Canvas;
  if (Trim(edScript.Text) <> '') and
     (TProjObject.IsScriptCorrect(Trim(edScript.Text)))
  then
  begin
    c.Pen.Color := clBlack;
    c.Pen.Style := psSolid;
    c.Pen.Width := 3;
    c.Brush.Color := clSilver;
    c.Brush.Style := bsSolid;
    c.FillRect(0,0,pbPreview.Width,pbPreview.Height);

    // measure dimensions
    innerFillPoints(Trim(edScript.Text));
    dx := 0;
    dy := 0;
    for i := 0 to cnt - 1 do
    begin
      if abs(px[i]) > dx then dx := abs(px[i]);
      if abs(py[i]) > dy then dy := abs(py[i]);
    end;

    SetLength(pts, cnt);
    if (dx > 0) or (dy > 0) then
      for i := 0 to cnt - 1 do
        pts[i] := coordToScreen(px[i], py[i]);
    c.Polyline(pts);
    px := nil;
    py := nil;
    pts := nil;
  end
  else
  begin
    c.Pen.Color := clRed;
    c.Pen.Style := psSolid;
    c.Pen.Width := 1;
    c.Brush.Color := clRed;
    c.Brush.Style := bsSolid;

    c.FillRect(0,0,pbPreview.Width,pbPreview.Height);
  end;

end;

end.

