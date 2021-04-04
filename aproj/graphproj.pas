{ Модуль для отображения данных на экране }
unit graphproj;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Graphics, Controls, ExtCtrls,

  dataproj;

type

  { TProjGraph }

  TProjGraph = class
  private
    // данные проекта
    FProj: TProjData;
    FCur: TProjObject;
    // где рисуем
    FPaintBox: TPaintBox;
    // линейка и её крайние точки
    FRuler: boolean;
    rp1: TFPoint;
    rp2: TFPoint;
    // запомненные данные
    oldX: integer;
    oldY: integer;
    startX: integer;
    startY: integer;
    bt: TMouseButton;
    capt: boolean;
    // функция точки
    FPFunc: boolean;
    fpOb: TProjObject;
    fpObIx: integer;
    fp0: TFPoint;
    fp1: TFPoint;
    fp2: TFPoint;
    fpAssigned0: boolean;
    fpAssigned1: boolean;
    fpAssigned2: boolean;
    fpSelIndex: integer;
    fpSelected: boolean;

    // сетка
    FPMesh: boolean;
    mpSelected: boolean;
    mp1: TFPoint;

    procedure SetPMesh(AValue: boolean);
    procedure SetPFunc(AValue: boolean);

    // линейка
    procedure SetRuler(AValue: boolean);
    procedure MoveRulerPoint(APoint, ANewPoint: TFPoint; ADelta: double);
    // преобразования координат
    function getScaleFactor(AScale: integer): double;
    function getScreenCoef(): double;
    function coordX(ACoord: double): integer;
    function coordY(ACoord: double): integer;
    function rotateCore(APoint: TPoint; ABasePoint: TPoint; AAngle: double): TPoint;
    function rotate(APoint: TPoint): TPoint;
    function coord(x, y: TFPointType): TPoint;
    function screen2coord(APoint: TPoint): TFPoint;
    // рисования
    procedure drawObject(AObject: TProjObject; AIsActive: boolean=False);
    procedure drawPoints(const APoints: array of TPoint);
    procedure drawTitle(AObject: TProjObject);
    procedure drawRuler();
    procedure drawMesh();
  public
    constructor Create(AProj: TProjData; APaintBox: TPaintBox);
    destructor Destroy; override;

    procedure Paint();
    procedure MouseDown(AX, AY: Integer; AButton: TMouseButton; Shift: TShiftState);
    procedure MouseUp(AX, AY: Integer; AButton: TMouseButton; Shift: TShiftState; var AModified: boolean; var ASelObject: TProjObject);
    procedure MouseMove(AX, AY: Integer; Shift: TShiftState; var AModified: boolean);
    procedure MouseWheel(AX, AY: Integer; AWheelDelta: integer; Shift: TShiftState; var AModified: boolean);

    property Cur: TProjObject read FCur write FCur;
    property Ruler: boolean read FRuler write SetRuler;
    property PFunc: boolean read FPFunc write SetPFunc;
    property PMesh: boolean read FPMesh write SetPMesh;

    function CenterPoint(): TFPoint;
    // Функция точки
    procedure FuncMove(AWithObject: boolean);
    procedure FuncClear();
    procedure FuncCalc(AMirror, APolar, ACatet1, ACatet2: boolean; ADist1, ADist2: double; AAngle: double);
    function FuncPoint(): boolean;
    procedure FuncSelectPoint(AIndex: integer);
    function FuncCaption(AIndex: integer): string;

    // точка сетки
    function MeshPoint(): boolean;
    function MeshCaption(): string;
  end;

implementation

uses
  math;

{ TProjGraph }

constructor TProjGraph.Create(AProj: TProjData; APaintBox: TPaintBox);
begin
  FProj := AProj;
  FPaintBox := APaintBox;
  FCur := nil;

  FPMesh := False;

  oldX := 0;
  oldY := 0;
  startX := 0;
  startY := 0;
  bt := mbLeft;
  capt := False;
end;

destructor TProjGraph.Destroy;
begin
  inherited Destroy;
end;

function TProjGraph.getScaleFactor(AScale: integer): double;
const
  base = 1.0602;
begin
  Result := exp(AScale * ln(base));
end;

function TProjGraph.getScreenCoef(): double;
begin
  // считаем коэффициент преобразования
  if (C_INI_SIZE / FPaintBox.Width) > (C_INI_SIZE / FPaintBox.Height) then
    Result := FPaintBox.Width / C_INI_SIZE * 0.9
  else
    Result := FPaintBox.Height / C_INI_SIZE * 0.9;
end;

function TProjGraph.coordX(ACoord: double): integer;
begin
  Result := Round((ACoord + FProj.TransX) * getScreenCoef() * getScaleFactor(FProj.Scale)) + (FPaintBox.Width div 2);
end;

function TProjGraph.coordY(ACoord: double): integer;
begin
  Result := -Round((ACoord + FProj.TransY) * getScreenCoef() * getScaleFactor(FProj.Scale)) + (FPaintBox.Height div 2);
end;

function TProjGraph.rotateCore(APoint: TPoint; ABasePoint: TPoint; AAngle: double): TPoint;
var
  x0, y0: integer;
begin
  // in pixels
  x0 := ABasePoint.X;
  y0 := ABasePoint.Y;
  Result.X := Round((APoint.X - x0) * cos(AAngle) - (APoint.Y - y0) * sin(AAngle)) + x0;
  Result.Y := Round((APoint.X - x0) * sin(AAngle) + (APoint.Y - y0) * cos(AAngle)) + y0;
end;

function TProjGraph.rotate(APoint: TPoint): TPoint;
begin
  // in pixels
  Result := rotateCore(APoint, Point(FPaintBox.Width div 2, FPaintBox.Height div 2), FProj.Angle);
end;

function TProjGraph.coord(x, y: TFPointType): TPoint;
var
  px, py: integer;
begin
  // from real coords to pixels
  px := coordX(x);
  py := coordY(y);
  Result := rotate(Point(px, py));
end;

function TProjGraph.screen2coord(APoint: TPoint): TFPoint;
var
  p: TPoint;
  kf: double;
begin
  // from pixels to real coords
  p := rotateCore(APoint, Point(FPaintBox.Width div 2, FPaintBox.Height div 2), -FProj.Angle);
  kf := getScreenCoef() * getScaleFactor(FProj.Scale);
  Result.x := (p.x - (FPaintBox.Width div 2)) / kf - FProj.TransX;
  Result.y := ((FPaintBox.Height div 2) - p.y) / kf - FProj.TransY;
end;

procedure TProjGraph.drawTitle(AObject: TProjObject);
var
  c: TCanvas;
  hh, ww: integer;
  p: TPoint;
begin
  if not AObject.TitleVisible then
    Exit;
  if AObject.Count < 1 then
    Exit;
  c := FPaintBox.Canvas;
  c.Font.Color := AObject.TitleColor;
  c.Font.Size := AObject.TitleSize;
  ww := c.TextWidth(AObject.Name);
  hh := c.TextHeight(AObject.Name);
  p := coord(AObject.TitlePointX, AObject.TitlePointY);

  c.Brush.Style := bsClear;
  c.TextOut(p.x-(ww div 2), p.y-(hh div 2), AObject.Name);
end;

procedure TProjGraph.drawPoints(const APoints: array of TPoint);
var
  i: integer;
  c: TCanvas;
begin
  c := FPaintBox.Canvas;
  // points
  c.Pen.Color := FProj.Colors[pcolPoint];
  c.Pen.Style := psSolid;
  c.Brush.Color := FProj.Colors[pcolPoint];
  c.Brush.Style := bsSolid;
  for i := 0 to high(APoints) do
    c.Ellipse(
      APoints[i].x - C_POINT_RADIUS,
      APoints[i].y - C_POINT_RADIUS,
      APoints[i].x + C_POINT_RADIUS+1,
      APoints[i].y + C_POINT_RADIUS+1
    );
end;

procedure TProjGraph.drawObject(AObject: TProjObject; AIsActive: boolean=False);
var
  c: TCanvas;
  pts: array of TPoint;
  rpts: array[0..3]of TPoint;
  x1, x2, y1, y2, dx, dy, dx0, dy0, dist: TFPointType;
  i: integer;
  p: TPoint;
  r: integer;
begin
  c := FPaintBox.Canvas;
  if AIsActive then
    c.Pen.Width := 3
  else
    c.Pen.Width := 1;

  c.Pen.Color := AObject.Color;
  c.Pen.Style := AObject.PenStyle;
  c.Brush.Color := AObject.FillColor;
  c.Brush.Style := AObject.BrushStyle;

  if AObject.Count = 1 then
  begin
    // circle
    p := coord(AObject.X[0], AObject.Y[0]);
    r := abs(coordX(AObject.X[0]) - coordX(AObject.X[0] + AObject.Width/2));
    if r < 5 then
      r := 5;

    c.Ellipse(p.X-r, p.y-r, p.x+r+1, p.y+r+1);
    if AIsActive then
      drawPoints([p]);
  end

  else
  if AObject.Closed then
  begin
    if AObject.Filled then
    begin
      pts := nil;
      SetLength(pts, AObject.Count);
      for i := 0 to AObject.Count - 1 do
        pts[i] := coord(AObject.X[i], AObject.Y[i]);
      c.Polygon(pts);
      if AIsActive then
        drawPoints(pts);
      pts := nil;
    end
    else
    begin
      SetLength(pts, AObject.Count+1);
      for i := 0 to AObject.Count - 1 do
        pts[i] := coord(AObject.X[i], AObject.Y[i]);
      pts[AObject.Count] := pts[0];
      c.Polyline(pts);
      if AIsActive then
        drawPoints(pts);
      pts := nil;
    end;
  end
  else
  begin
    if AObject.Width > 1e-9 then
    begin
      // широкая линия
      dx0 := 0;
      dy0 := 0;
      c.Pen.Color := c.Brush.Color;
      for i := 0 to AObject.Count - 2 do
      begin
        // vector
        x1 := AObject.X[i];
        y1 := AObject.Y[i];
        x2 := AObject.X[i+1];
        y2 := AObject.Y[i+1];
        dist := sqrt(sqr(x2-x1) + sqr(y2-y1));
        // width
        dx := -(y2-y1)*AObject.Width/2/dist;
        dy :=  (x2-x1)*AObject.Width/2/dist;

        if (i > 0) then
        begin
          // link areas
          rpts[0] := coord(x1+dx0, y1+dy0);
          rpts[1] := coord(x1+dx, y1+dy);
          rpts[2] := coord(x1-dx, y1-dy);
          rpts[3] := coord(x1-dx0, y1-dy0);
          c.Polygon(rpts);
        end;
        // polygon
        rpts[0] := coord(x1+dx, y1+dy);
        rpts[1] := coord(x1-dx, y1-dy);
        rpts[2] := coord(x2-dx, y2-dy);
        rpts[3] := coord(x2+dx, y2+dy);
        c.Polygon(rpts);

        dx0 := dx;
        dy0 := dy;
      end;
      c.Pen.Color := AObject.Color;
    end;
    // линия
    SetLength(pts, AObject.Count);
    for i := 0 to AObject.Count - 1 do
      pts[i] := coord(AObject.X[i], AObject.Y[i]);
    c.Polyline(pts);
    if AIsActive then
      drawPoints(pts);
    pts := nil;
  end;
  c.Pen.Width := 1;
end;

procedure TProjGraph.drawRuler();
var
  c: TCanvas;
  p1, p2: TPoint;
  r: double;
  old_size, x, y: integer;
begin
  if not FRuler then
    Exit;
  if FPFunc then
    Exit;
  if FPMesh then
    Exit;

  r := sqrt(sqr(rp1.x-rp2.x) + sqr(rp1.y-rp2.y));
  p1 := coord(rp1.x, rp1.y);
  p2 := coord(rp2.x, rp2.y);
  c := FPaintBox.Canvas;
  // линия
  c.Pen.Width := 2;
  c.Pen.Color := FProj.Colors[pcolRulerLine];
  c.Brush.Color := not c.Pen.Color;
  c.Brush.Style := bsSolid;
  c.Line(p1, p2);
  c.Pen.Width := 1;
  c.Rectangle(p1.x-C_PT, p1.y-C_PT, p1.x+C_PT+1, p1.y+C_PT+1);
  c.Rectangle(p2.x-C_PT, p2.y-C_PT, p2.x+C_PT+1, p2.y+C_PT+1);

  // надпись
  c.Brush.Style := bsClear;
  old_size := c.Font.Size;
  try
    c.Font.Size := 10;
    c.Font.Color := FProj.Colors[pcolRulerText];
    if p1.x > p2.x then
    begin
      x := p1.x + C_PT + 2;
      y := p1.y;
    end
    else
    begin
      x := p2.x + C_PT + 2;
      y := p2.y;
    end;
    c.TextOut(x, y-(c.TextHeight('0') div 2), FloatToStrF(r, ffFixed, 6, 3) + ' м');
  finally
    c.Font.Size := old_size;
  end;
end;

procedure TProjGraph.drawMesh();
var
  c: TCanvas;
  p: TPoint;
  n, i, j: integer;
  x, y, x1, y1, cx, cy, angle: double;
begin
  if Fproj.MeshEdge < 1e-6 then
    Exit;

  c := FPaintBox.Canvas;
  // points
  c.Pen.Color := FProj.Colors[pcolMeshPoint];
  c.Pen.Style := psSolid;
  c.Brush.Color := FProj.Colors[pcolMeshPoint];
  c.Brush.Style := bsSolid;

  // исходные параметры
  n := Trunc(FProj.MeshArea / FProj.MeshEdge / 2);
  if n > (C_MESH_MAX_POINTS div 2) then
    n := C_MESH_MAX_POINTS div 2;
  cx := Fproj.MeshCenterX;
  cy := Fproj.MeshCenterY;
  angle := FProj.MeshAzimuth / 180 * pi;

  for i := -n to n do
    for j := -n to n do
    begin
      // координаты сетки
      x := 0;
      y := 0;
      if FProj.MeshType = 0 then
      begin
        // сотовая сетка
        if odd(j) then
          x := (cx + FProj.MeshEdge/2) + i * FProj.MeshEdge
        else
          x := cx + i * FProj.MeshEdge;
        y := cy + j * (FProj.MeshEdge * sqrt(3) / 2);
      end
      else if FProj.MeshType = 1 then
      begin
        // прямоугольная сетка
        x := cx + i * FProj.MeshEdge;
        y := cy + j * FProj.MeshEdge;
      end;

      // вращение координат
      x1 := cx + (x-cx)*cos(angle)-(y-cy)*sin(angle);
      y1 := cy + (x-cx)*sin(angle)+(y-cy)*cos(angle);

      // перевод в экранные и отрисовка
      p := coord(x1, y1);
      c.Ellipse(
        p.x - C_MESH_POINT_RADIUS,
        p.y - C_MESH_POINT_RADIUS,
        p.x + C_MESH_POINT_RADIUS+1,
        p.y + C_MESH_POINT_RADIUS+1
      );
    end;
end;

procedure TProjGraph.Paint();
  function ScaleHuman(AScale: double): string;
  const
    sfx: array[-3..1]of string = (
      'нм',  // -3
      'мкм', // -2
      'мм',  // -1
      'м',   // 0
      'км'   // 1
    );
  var
    sc, idx: integer;
  begin
    // initial scale in mm
    idx := floor(log10(AScale) / 3);

    if idx < low(sfx) then
      idx := low(sfx)
    else if idx > high(sfx) then
      idx := high(sfx);

    sc := Round(AScale / power(10, idx*3));
    Result := IntToStr(sc) + ' ' + sfx[idx];
  end;
var
  c: TCanvas;
  i, j, k: integer;
  p1, p2: TPoint;
  x0, y0: integer;
  dh, dw: integer;
  scale, kf: double;
  lay: TProjLayer;
  ob: TProjObject;
begin
  c := FPaintBox.Canvas;

  // общие настройки
  c.Font.Style:=[fsBold];

  // задаем фон
  c.Pen.Color := FProj.Colors[pcolBackground];
  c.Pen.Style:= psSolid;
  c.Brush.Color:= FProj.Colors[pcolBackground];
  c.Brush.Style:=bsSolid;
  c.Rectangle(0, 0, FPaintBox.Width, FPaintBox.Height);

  // рисуем объекты по слоям
  for i := 0 to FProj.Layers.Count - 1 do
  begin
    lay := TProjLayer(FProj.Layers[i]);
    if lay.Active then
      for j := 0 to lay.Objects.Count - 1 do
      begin
        ob := TProjObject(lay.Objects[j]);
        if ob.Active then
        begin
          drawObject(ob);
          drawTitle(ob);
        end;
      end;
  end;
  if (FCur <> nil) and (not FPFunc) and (not FPMesh) then
    if FCur.Active then
    begin
      drawObject(FCur, True);
      drawTitle(FCur);
    end;

  // рисуем сетку
  if FProj.MeshVisible then
    drawMesh();

  // для режима функции точки и точки сетки - рисуем все видимые точки
  if FPFunc or FPMesh then
  begin
    c.Pen.Color := FProj.Colors[pcolPoint];
    c.Pen.Style := psSolid;
    c.Brush.Color := FProj.Colors[pcolPoint];
    c.Brush.Style := bsSolid;
    for i := 0 to FProj.Layers.Count - 1 do
    begin
      lay := TProjLayer(FProj.Layers[i]);
      if lay.Active then
        for j := 0 to lay.Objects.Count - 1 do
        begin
          ob := TProjObject(lay.Objects[j]);
          if ob.Active then
            for k := 0 to ob.Count - 1 do
            begin
              p1 := coord(ob.X[k], ob.Y[k]);
              c.Ellipse(p1.x - C_POINT_RADIUS-1, p1.y - C_POINT_RADIUS-1, p1.x + C_POINT_RADIUS, p1.y + C_POINT_RADIUS);
            end;
        end;
    end;
  end;
  if FPFunc then
  begin
    // связь 1
    if fpAssigned0 and fpAssigned1 then
    begin
      p1 := coord(fp1.x, fp1.y);
      p2 := coord(fp0.x, fp0.y);
      c.Pen.Color := FProj.Colors[pcolPointBase];
      c.Line(p1, p2);
    end;
    // связь 2
    if fpAssigned0 and fpAssigned2 then
    begin
      p1 := coord(fp2.x, fp2.y);
      p2 := coord(fp0.x, fp0.y);
      c.Pen.Color := FProj.Colors[pcolPointBase];
      c.Line(p1, p2);
    end;
    // сами точки
    if fpAssigned1 then
    begin
      p1 := coord(fp1.x, fp1.y);
      c.Pen.Color := FProj.Colors[pcolPointBase];
      c.Brush.Color := c.Pen.Color;
      c.Ellipse(p1.x - C_POINT_RADIUS, p1.y - C_POINT_RADIUS, p1.x + C_POINT_RADIUS+1, p1.y + C_POINT_RADIUS+1);
    end;
    if fpAssigned2 then
    begin
      p1 := coord(fp2.x, fp2.y);
      c.Pen.Color := FProj.Colors[pcolPointBase];
      c.Brush.Color := c.Pen.Color;
      c.Ellipse(p1.x - C_POINT_RADIUS, p1.y - C_POINT_RADIUS, p1.x + C_POINT_RADIUS+1, p1.y + C_POINT_RADIUS+1);
    end;
    if fpAssigned0 then
    begin
      p1 := coord(fp0.x, fp0.y);
      c.Pen.Color := FProj.Colors[pcolPointCalc];
      c.Brush.Color := c.Pen.Color;
      c.Ellipse(p1.x - C_POINT_RADIUS, p1.y - C_POINT_RADIUS, p1.x + C_POINT_RADIUS+1, p1.y + C_POINT_RADIUS+1);
    end;
    if (fpOb <> nil) and (fpObIx <> -1) then
    begin
      p1 := coord(fpOb.X[fpObIx], fpOb.Y[fpObIx]);
      c.Pen.Color := FProj.Colors[pcolPointCalc];
      c.Brush.Color := c.Pen.Color;
      c.Ellipse(p1.x - C_POINT_RADIUS, p1.y - C_POINT_RADIUS, p1.x + C_POINT_RADIUS+1, p1.y + C_POINT_RADIUS+1);
    end;
  end;

  // рисуем масштаб
  c.Font.Color := clBlack;
  c.Font.Size := 11;
  k := 1;
  scale := 1E9;
  kf := getScreenCoef() * getScaleFactor(FProj.Scale);
  while Round(scale * kf) > (FPaintBox.Width div 5) do
  begin
    if k = 1 then
      scale := scale / 2
    else if k = 2 then
      scale := scale / 2.5
    else if k = 3 then
      scale := scale / 2;
    k := k + 1;
    if k > 3 then
      k := 1;
  end;
  dh := 4;
  dw := Round(scale * kf / 2);
  x0 := FPaintBox.Width - 20;
  y0 := FPaintBox.Height - 20;
  // панели
  c.Pen.Color := clBlack;
  c.Pen.Style := psSolid;
  c.Brush.Color := clBlack;
  c.Brush.Style := bsSolid;
  c.Rectangle(x0 - dw * 2, y0 - dh * 2, x0 - dw * 1, y0 - dh * 1);
  c.Rectangle(x0 - dw * 1, y0 - dh * 1, x0 - dw * 0, y0 - dh * 0);
  c.Brush.Color := clWhite;
  c.Rectangle(x0 - dw * 1, y0 - dh * 2, x0 - dw * 0, y0 - dh * 1);
  c.Rectangle(x0 - dw * 2, y0 - dh * 1, x0 - dw * 1, y0 - dh * 0);
  // пишем масштаб
  c.Font.Style:=[];
  c.Brush.Style := bsClear;
  c.TextOut(x0 - dw * 2, y0 + 1, ScaleHuman(scale));
  c.TextOut(x0 - 8, y0 + 1, '0');

  // компас
  x0 := FPaintBox.Width - 30;
  y0 := 30;
  c.Pen.Style := psSolid;
  c.Brush.Style := bsSolid;
  // окружность
  c.Pen.Color := clBlack;
  c.Brush.Color := clSilver;
  c.Ellipse(x0-24, y0-24, x0+25, y0+25);
  // север
  c.Pen.Color := clNavy;
  c.Brush.Color := clNavy;
  c.Polygon([
      rotateCore(Point(x0 - 6, y0), Point(x0, y0), FProj.Angle),
      rotateCore(Point(x0, y0 - 18), Point(x0, y0), FProj.Angle),
      rotateCore(Point(x0 + 6, y0), Point(x0, y0), FProj.Angle)
  ]);
  // юг
  c.Pen.Color := clRed;
  c.Brush.Color := clRed;
  c.Polygon([
      rotateCore(Point(x0 - 6, y0), Point(x0, y0), FProj.Angle),
      rotateCore(Point(x0, y0 + 18), Point(x0, y0), FProj.Angle),
      rotateCore(Point(x0 + 6, y0), Point(x0, y0), FProj.Angle)
  ]);
  // рисуем линейку
  drawRuler();
end;

procedure TProjGraph.MouseDown(AX, AY: Integer; AButton: TMouseButton; Shift: TShiftState);
begin
  bt := AButton;
  oldX := AX;
  oldY := AY;
  startX := AX;
  startY := AY;
  capt := True;
end;

procedure TProjGraph.MouseUp(AX, AY: Integer; AButton: TMouseButton; Shift: TShiftState; var AModified: boolean; var ASelObject: TProjObject);
var
  p, p2: TFPoint;
  r: double;
  i, j, ix: integer;
  lay: TProjLayer;
  ob: TProjObject;
  sel: boolean;
begin
  if (AButton = bt) then
    if (abs (startX-AX) < C_PT) and (abs(startY-AY) < C_PT) then
    begin
      if FPFunc then
      begin
        // обработка функции точки
        if (bt = mbRight) and (fpSelIndex <> -1) then
        begin
          p := screen2coord(Point(AX, AY));
          p2:= screen2coord(Point(AX+C_PT, AY));
          r := sqrt(sqr(p2.x-p.x) + sqr(p2.y-p.y)); // delta

          ob := nil;
          ix := -1;
          if FProj.FindPoint(p.x, p.y, r, ob, ix) then
          begin
            Case fpSelIndex of
              0:
                begin
                  fpOb := ob;
                  fpObIx := ix;
                end;
              1:
                begin
                  fpAssigned1 := True;
                  fp1 := FPoint(ob.X[ix], ob.Y[ix]);
                end;
              2:
                begin
                  fpAssigned2 := True;
                  fp2 := FPoint(ob.X[ix], ob.Y[ix]);
                end;
            end;
            fpSelected := True;
            fpSelIndex := -1;
          end;
          FPaintBox.Update;
        end;
      end
      else if FPMesh then
      begin
        // обработка выбора центра сетки
        if (bt = mbRight) then
        begin
          p := screen2coord(Point(AX, AY));
          p2:= screen2coord(Point(AX+C_PT, AY));
          r := sqrt(sqr(p2.x-p.x) + sqr(p2.y-p.y)); // delta

          ob := nil;
          ix := -1;
          if FProj.FindPoint(p.x, p.y, r, ob, ix) then
          begin
            mpSelected := True;
            mp1 := FPoint(ob.X[ix], ob.Y[ix]);
          end;
          FPaintBox.Update;
        end;
      end
      else
      begin
        // click on surface
        if (ssCtrl in Shift) and (FCur <> nil) and (FCur.Active) and (not FCur.Fixed) then
        begin
          // point in object
          p := screen2coord(Point(AX, AY));
          p2:= screen2coord(Point(AX+C_PT, AY));
          r := sqrt(sqr(p2.x-p.x) + sqr(p2.y-p.y)); // delta

          if bt = mbLeft then
          begin
            FCur.AddPoint(p.x, p.y, r);
            AModified := True;
            FProj.CommitStart();
          end
          else if bt = mbRight then
          begin
            FCur.DelPoint(p.x, p.y, r);
            AModified := True;
            Fproj.CommitStart();
          end;
          FPaintBox.Update;
        end
        else if (ssShift in Shift) and (bt = mbLeft) then
        begin
          // try select object (Shift+Left Mouse)
          p := screen2coord(Point(AX, AY));
          p2:= screen2coord(Point(AX+C_PT, AY));
          r := sqrt(sqr(p2.x-p.x) + sqr(p2.y-p.y)); // delta
          sel := False;
          for i := FProj.Layers.Count-1 downto 0 do
          begin
            lay := TProjLayer(FProj.Layers[i]);
            if lay.Active then
              for j := lay.Objects.Count - 1 downto 0 do
              begin
                ob := TProjObject(lay.Objects[j]);
                if ob.Active then
                  if ob.IsPointInside(p.x, p.y, r) then
                  begin
                    ASelObject := ob;
                    sel:= True;
                    break;
                  end;
              end;

            if sel then
              break;
          end;
        end;
      end;
    end;
  bt := mbLeft;
  oldX := 0;
  oldY := 0;
  startX := 0;
  startY := 0;
  capt := False;
  FProj.CommitFinish();
end;

procedure TProjGraph.MouseMove(AX, AY: Integer; Shift: TShiftState; var AModified: boolean);
  function inTitle(): boolean;
  var
    c: TCanvas;
    old_size, ww, hh: integer;
    p: TPoint;
  begin
    Result := False;
    if FCur = nil then
      Exit;
    if not FCur.TitleVisible then
      Exit;

    c := FPaintBox.Canvas;
    old_size := c.Font.Size;
    try
      c.Font.Size := FCur.TitleSize;
      p := coord(FCur.TitlePointX, FCur.TitlePointY);
      ww := c.TextWidth(FCur.Name) div 2;
      hh := c.TextHeight(FCur.Name) div 2;
      Result := (p.x-ww <= oldX) and (oldX <= p.x+ww) and
                (p.y-hh <= oldY) and (oldY <= p.y+hh);
    finally
      c.Font.Size := old_size;
    end;
  end;
var
  p1, p2, pd: TFPoint;
  r: double;
  change: boolean;
begin
  if capt then
  begin
    // не реагируем, если совсем ничего
    if (abs (startX-AX) < C_PT) and (abs(startY-AY) < C_PT) then
      Exit;
    if bt = mbLeft then
    begin
      // left button - translating area
      p1 := screen2coord(Point(oldX, oldY));
      p2 := screen2coord(Point(AX, AY));
      pd := screen2coord(Point(AX+C_PT, AY));
      r := sqrt(sqr(p2.x-pd.x) + sqr(p2.y-pd.y)); // delta

      if (ssShift in Shift) then
      begin
        if (not FPFunc) and (not FPMesh) and (FCur <> nil) and (FCur.Active) and (not FCur.Fixed) and (FCur.IsPointInside(p1.x, p1.y, r)) then
        begin
          // move object
          FProj.TranslateWithMesh(FCur, p1, p2, r);
          AModified := true;
          Fproj.CommitStart();
        end;
      end
      else if ssCtrl in Shift then
      begin
        // try to move points in object
        if (not FPFunc) and (not FPMesh) and (FCur <> nil) and (FCur.Active) and (not FCur.Fixed) then
        begin
          if inTitle() then
          begin
            FCur.TitlePointX := p2.x;
            FCur.TitlePointY := p2.y;
            AModified := True;
            Fproj.CommitStart();
          end
          else
          begin
            change := FProj.MovePointWithMesh(FCur, p1, p2, r);
            AModified := change or AModified;
            if change then
              Fproj.CommitStart();
          end;
        end;
      end
      else
      begin
        // move all area
        FProj.TransX := FProj.TransX + (p2.x-p1.x);
        FProj.TransY := FProj.TransY + (p2.y-p1.y);
      end;
      oldX := AX;
      oldY := AY;
      FPaintBox.Update;
    end
    else if bt = mbRight then
    begin
      if (not FPFunc) and (not FPMesh) and FRuler then
      begin
        // ruler
        p1 := screen2coord(Point(oldX, oldY));
        p2 := screen2coord(Point(AX, AY));
        pd := screen2coord(Point(AX+C_PT, AY));
        r := sqrt(sqr(p2.x-pd.x) + sqr(p2.y-pd.y)); // delta

        MoveRulerPoint(p1, p2, r);
        oldX := AX;
        oldY := AY;
        FPaintBox.Update;
      end;
    end;
  end;
end;

procedure TProjGraph.MouseWheel(AX, AY: Integer; AWheelDelta: integer; Shift: TShiftState; var AModified: boolean);
begin
  if ssCtrl in Shift then
  begin
    // rotate full area
    FProj.Angle := FProj.Angle - pi/120*Sign(AWheelDelta);
    FPaintBox.Update;
  end
  else
  if ssShift in Shift then
  begin
    // rotate selected object
    if (not FPFunc) and (not FPMesh) and (FCur <> nil) and (FCur.Active) and (not FCur.Fixed) then
    begin
      FCur.Rotate(pi/120*Sign(AWheelDelta));
      FPaintBox.Update;
      AModified := True;
      FProj.Commit();
    end;
  end
  else
  begin
    // zoom area
    FProj.Scale := FProj.Scale + 4*Sign(AWheelDelta);
    FPaintBox.Update;
  end;
end;

procedure TProjGraph.SetRuler(AValue: boolean);
begin
  if FRuler = AValue then
    Exit;
  FRuler := AValue;
  if FRuler then
  begin
    rp1 := screen2coord(Point(3 * FPaintBox.Width div 8, FPaintBox.Height div 2));
    rp2 := screen2coord(Point(5 * FPaintBox.Width div 8, FPaintBox.Height div 2));
  end;
end;

procedure TProjGraph.MoveRulerPoint(APoint, ANewPoint: TFPoint; ADelta: double);
var
  r1, r2: double;
begin
  r1 := sqrt(sqr(rp1.x-APoint.x) + sqr(rp1.y-APoint.y));
  r2 := sqrt(sqr(rp2.x-APoint.x) + sqr(rp2.y-APoint.y));
  if r1 <= ADelta then
  begin
    rp1.x := ANewPoint.x;
    rp1.y := ANewPoint.y;
  end
  else if r2 <= ADelta then
  begin
    rp2.x := ANewPoint.x;
    rp2.y := ANewPoint.y;
  end;
end;

function TProjGraph.CenterPoint(): TFPoint;
begin
  Result := screen2coord(Point(FPaintBox.Width div 2, FPaintBox.Height div 2));
end;

{%Region 'Point Function'}
procedure TProjGraph.SetPFunc(AValue: boolean);
begin
  if FPFunc = AValue then
    Exit;
  FPFunc := AValue;
  if not FPFunc then
    FuncClear();
end;

procedure TProjGraph.FuncMove(AWithObject: boolean);
var
  i: integer;
  p: TFPoint;
begin
  if fpObIx = -1 then
    Exit;
  if not fpAssigned0 then
    Exit;
  if (fpOb <> nil) and (not fpOb.Fixed) and (fpob.Active) then
  begin
    if AWithObject then
    begin
      p.x := fpOb.X[fpObIx];
      p.y := fpOb.Y[fpObIx];
      for i := 0 to fpOb.Count - 1 do
      begin
        fpOb.X[i] := fpOb.X[i] + fp0.x - p.x;
        fpOb.Y[i] := fpOb.Y[i] + fp0.y - p.y;
      end;
      FProj.Commit();
    end
    else
    begin
      fpOb.X[fpObIx] := fp0.x;
      fpOb.Y[fpObIx] := fp0.y;
      FProj.Commit();
    end;
  end;
end;

procedure TProjGraph.FuncClear();
begin
  fpAssigned1 := False;
  fpAssigned2 := False;
  fpAssigned0 := False;
  fpOb := nil;
  fpObIx := -1;
  fpSelected := False;
  fpSelIndex := -1;
end;

procedure TProjGraph.FuncCalc(AMirror, APolar, ACatet1, ACatet2: boolean; ADist1, ADist2: double; AAngle: double);
var
  x1, x2, y1, y2: TFPointType;
  r, az, ph, beta: double;
  d1, d2: double;
begin
  if APolar then
  begin
    if not fpAssigned1 then
      Exit;
    // полярные координаты
    fp0.x := fp1.x + ADist1 * cos(AzimuthToAngle(AAngle));
    fp0.y := fp1.y + ADist1 * sin(AzimuthToAngle(AAngle));
    fpAssigned0 := True;
    FPaintBox.Update;
  end
  else
  begin
    if (not fpAssigned1) or (not fpAssigned2) then
      Exit;
    // есть вторая привязка
    x1 := fp1.x;
    y1 := fp1.y;
    x2 := fp2.x;
    y2 := fp2.y;

    r := sqrt(sqr(x1-x2) + sqr(y1 - y2));
    if r < 1e-9 then
      Exit;
    // расстояния +  учет катетов
    d1 := ADist1;
    d2 := ADist2;
    if ACatet1 and ACatet2 then
    begin
      if d1 > r then
        d1 := r;
      d2 := sqrt(sqr(r) - sqr(d1));
    end
    else if ACatet1 then
    begin
      d2 := sqrt(sqr(d1) + sqr(r));
    end
    else if ACatet2 then
    begin
      d1 := sqrt(sqr(d2) + sqr(r));
    end;

    ph := arccos((y2-y1)/r);
    if x2 < x1 then
      ph := -ph;
    if Abs((sqr(r) + sqr(d1) - sqr(d2)) / (2 * r * d1)) > 1.0 then
    begin
      // пропорционально
      if (d1 + d2) > 0 then
      begin
        fp0.x :=  x1 + d1 * (x2-x1) / (d1 + d2);
        fp0.y :=  y1 + d1 * (y2-y1) / (d1 + d2);
      end;
    end
    else
    begin
      beta := arccos((sqr(r) + sqr(d1) - sqr(d2)) / (2 * r * d1));
      if not AMirror then
        az := ph + beta
      else
        az := ph - beta;
      fp0.x := x1 + d1 * cos(pi/2 - az);
      fp0.y := y1 + d1 * sin(pi/2 - az);
    end;
    fpAssigned0 := True;
    FPaintBox.Update;
  end;
end;

function TProjGraph.FuncPoint(): boolean;
begin
  Result := fpSelected;
  if Result then
  begin
    fpSelected := False;
    fpSelIndex := -1;
  end;
end;

procedure TProjGraph.FuncSelectPoint(AIndex: integer);
begin
  fpSelected := False;
  fpSelIndex := AIndex;
  Case AIndex of
    0:
      begin
        fpOb := nil;
        fpObIx := -1;
        fpAssigned0 := False;
      end;
    1:
      begin
        fpAssigned1 := False;
        fpAssigned0 := False;
      end;
    2:
      begin
        fpAssigned2 := False;
        fpAssigned0 := False;
      end;
  end;
  FPaintBox.Update;
end;

function TProjGraph.FuncCaption(AIndex: integer): string;
begin
  Result := '---';
  Case AIndex of
    0:
      begin
        if fpAssigned0 and (fpOb <> nil) and (fpObIx <> -1) then
          Result := '('+FloatToStrF(fpOb.X[fpObIx],ffFixed,6,3)+', '+FloatToStrF(fpOb.Y[fpObIx],ffFixed,6,3)+')' +
                    ' -> ' + LineEnding +
                    '('+FloatToStrF(fp0.x,ffFixed,6,3)+', '+FloatToStrF(fp0.y,ffFixed,6,3)+')';
      end;
    1:
      begin
        if fpAssigned1 then
          Result := '('+FloatToStrF(fp1.x,ffFixed,6,3)+', '+FloatToStrF(fp1.y,ffFixed,6,3)+')';
      end;
    2:
      begin
        if fpAssigned2 then
          Result := '('+FloatToStrF(fp2.x,ffFixed,6,3)+', '+FloatToStrF(fp2.y,ffFixed,6,3)+')';
      end;
  end;
end;

{%EndRegion}

{%Region 'Mesh point'}
procedure TProjGraph.SetPMesh(AValue: boolean);
begin
  if FPMesh = AValue then
    Exit;
  FPMesh := AValue;
  if not FPMesh then
    mpSelected := False;
  FPaintBox.Update();
end;

function TProjGraph.MeshPoint(): boolean;
begin
  Result := mpSelected;
  if Result then
    PMesh := False;
end;

function TProjGraph.MeshCaption(): string;
begin
  Result := FloatToStrF(mp1.x,ffFixed,6,3)+', '+FloatToStrF(mp1.y,ffFixed,6,3);
end;

{%EndRegion}

end.

