{ Модуль для хранения данных проекта - также производит необходимые вычисления }
unit dataproj;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Graphics;

const
  C_PROJ_VERSION = 5;
  C_INI_SIZE = 10; // базовый размер окна для нулевого масштаба = 10м (все значения в м)
  C_POINT_RADIUS = 3;
  C_MESH_POINT_RADIUS = 1;
  C_MESH_MAX_POINTS = 100; // ?максимальное количество точек в направлении одной оси
  C_MESH_DELTA_CORRECTION = 1.1; // во сколько раз корректировать примагничивание относительно попадания в точку
  C_PT = 5; // диапазон для попадания в точку
  C_ANGLE = 20; // 20 градусов и меньше - угол при добавлении точек

  C_STORAGES = 50;

  cProjectColorNames: array[0..7]of string = (
    'Фон',
    'Точки',
    'Линейка линия',
    'Линейка текст',
    'Точка базовая',
    'Точка расчётная',
    'Точка сетки',
    ''
  );

type
  TFPointType = double;
  TFPoint = record
    x: TFPointType;
    y: TFPointType;
  end;

  // all coordinates in mm
  TProjColors = (
    pcolBackground,
    pcolPoint,
    pcolRulerLine,
    pcolRulerText,
    pcolPointBase,
    pcolPointCalc,
    pcolMeshPoint,
    pcol7
  );

  { TProjObject }

  TProjObject = class
  private
    // base
    FActive: boolean;      // видимость
    FName: string;  // имя
    FDescr: string; // описание
    // special
    FWidth: TFPointType; // ширина всей дороги (линии)
    FClosed: boolean;
    FFilled: boolean;
    FFixed: boolean;
    // points
    FCount: integer;
    FPointX: array of TFPointType;
    FPointY: array of TFPointType;
    // area colors and draw styles
    FColor: TColor;
    FFillColor: TColor;
    FPenStyle: TPenStyle;
    FBrushStyle: TBrushStyle;
    // title - координаты для центра, надпись не вращается, надпись=FName
    FTitleVisible: boolean;
    FTitlePointX: TFPointType;
    FTitlePointY: TFPointType;
    FTitleSize: integer;
    FTitleColor: TColor;

    function GetArea(): double;
    function GetPerimeter(): double;

    procedure Clear;
    procedure Grow;
    function GetX(AIndex: integer): TFPointType;
    function GetY(AIndex: integer): TFPointType;
    procedure SetX(AIndex: integer; AValue: TFPointType);
    procedure SetY(AIndex: integer; AValue: TFPointType);
    procedure SetTitleVisible(AValue: boolean);
  protected
    procedure StoreTo(AStream: TStream);
    procedure ReadFrom(AStream: TStream);
  public
    constructor Create();
    destructor Destroy; override;

    procedure Rotate(AAngle: double);
    procedure Translate(AX, AY: TFPointType);
    procedure AddPoint(APoint: TFPoint); overload;
    procedure AddPoint(AX, AY: TFPointType; ADelta: double); overload;
    procedure DelPoint(AX, AY: TFPointType; ADelta: double);
    function MovePoint(APoint, ANewPoint: TFPoint; ADelta: double): boolean;
    function IsPointInside(AX, AY: TFPointType; ADelta: double): boolean;
    class function IsScriptCorrect(const AScript: string): boolean;
    procedure FillPoints(ABasePoint: TFPoint; const AScript: string);

    property Area: double read GetArea;
    property Perimeter: double read GetPerimeter;
    property Active: boolean read FActive write FActive;
    property Name: string read FName write FName;
    property Descr: string read FDescr write FDescr;

    ///////
    property Count: integer read FCount;
    ///
    property Width: TFPointType read FWidth write FWidth;
    property Closed: boolean read FClosed write FClosed;
    property Filled: boolean read FFilled write FFilled;
    property Fixed: boolean read FFixed write FFixed;
    ///
    property Color: TColor read FColor write FColor;
    property FillColor: TColor read FFillColor write FFillColor;
    property PenStyle: TPenStyle read FPenStyle write FPenStyle;
    property BrushStyle: TBrushStyle read FBrushStyle write FBrushStyle;
    ///
    property TitleVisible: boolean read FTitleVisible write SetTitleVisible;
    property TitlePointX: TFPointType read FTitlePointX write FTitlePointX;
    property TitlePointY: TFPointType read FTitlePointY write FTitlePointY;
    property TitleSize: integer read FTitleSize write FTitleSize;
    property TitleColor: TColor read FTitleColor write FTitleColor;
    ///
    property X[AIndex: integer]: TFPointType read GetX write SetX;
    property Y[AIndex: integer]: TFPointType read GetY write SetY;
  end;

  { TProjLayer }

  TProjLayer = class
  private
    FActive: boolean;
    FName: string;
    // список объектов
    FObjects: TList;
  public
    constructor Create();
    destructor Destroy; override;

    procedure StoreTo(AStream: TStream);
    procedure ReadFrom(AStream: TStream);

    property Active: boolean read FActive write FActive;
    property Name: string read FName write FName;
    property Objects: TList read FObjects;
  end;

  { TProjData }

  TProjData = class
  private
    FColors: array[TProjColors] of TColor;
    FScale: integer;
    FTransX: double;
    FTransY: double;
    FAngle: double;
    // hexagonal mesh
    FMeshVisible: boolean; // видимость сетки, когда видна точки примагничиваются к ней
    FMeshCenterX: double;
    FMeshCenterY: double;
    FMeshEdge: double; // длина ребра сетки
    FMeshArea: double; // зона распространения сетки
    FMeshAzimuth: integer; // азимут сетки
    FMeshType: integer; // 0=сотовая, 1=прямоугольная
    // project description
    FDescr: string;
    // список слоев
    FLayers: TList;
    function GetColor(AIndex: TProjColors): TColor;
    procedure SetColor(AIndex: TProjColors; AValue: TColor);
    function CorrectPointToMesh(APoint: TFPoint; ADelta: double): TFPoint;
  private
    FStoragesCount: integer;
    FStorages: array[0..C_STORAGES-1] of TMemoryStream;
    FCommitStarted: boolean;
    procedure GrowStorages();
    procedure InnerLoad(AStream: TStream);
    procedure InnerSave(AStream: TStream);
  public
    constructor Create();
    destructor Destroy; override;

    procedure CommitInit();
    procedure CommitStart();
    procedure CommitFinish();
    procedure Commit();
    procedure Rollback();
    property StoragesCount: integer read FStoragesCount;

    procedure Clear;
    procedure Load(const AFileName: string);
    procedure Save(const AFileName: string);
    function FindPoint(AX, AY: TFPointType; ADelta: double; var AOb: TProjObject; var AIndex: integer): boolean;
    function MovePointWithMesh(AObject: TProjObject; APoint, ANewPoint: TFPoint; ADelta: double): boolean;
    procedure TranslateWithMesh(AObject: TProjObject; APoint, ANewPoint: TFPoint; ADelta: double);

    property Scale: integer read FScale write FScale;
    property TransX: double read FTransX write FTransX;
    property TransY: double read FTransY write FTransY;
    property Angle: double read FAngle write FAngle;
    property Description: string read FDescr write FDescr;

    property MeshVisible: boolean read FMeshVisible write FMeshVisible;
    property MeshCenterX: double read FMeshCenterX write FMeshCenterX;
    property MeshCenterY: double read FMeshCenterY write FMeshCenterY;
    property MeshEdge: double read FMeshEdge write FMeshEdge;
    property MeshArea: double read FMeshArea write FMeshArea;
    property MeshAzimuth: integer read FMeshAzimuth write FMeshAzimuth;
    property MeshType: integer read FMeshType write FMeshType;

    property Layers: TList read FLayers;
    property Colors[AIndex: TProjColors]: TColor read GetColor write SetColor;
  public
    class var Ver: integer;
  end;

  { TProjTree }

  TProjTree = class
  private
    FName: string;
    FDescr: string;
    FColor: TColor;
    FFillColor: TColor;
    FRadius: double;
  public
    constructor Create();

    procedure StoreTo(AStream: TStream);
    procedure ReadFrom(AStream: TStream);

    property Name: string read FName write FName;
    property Descr: string read FDescr write FDescr;
    property Color: TColor read FColor write FColor;
    property FillColor: TColor read FFillColor write FFillColor;
    property Radius: double read FRadius write FRadius;
  end;

  { TProjTreeData }

  TProjTreeData = class
  private
    FTrees: TList;
    FFileName: string;
    procedure LoadBase();
  public
    constructor Create(const AFileName: string);
    destructor Destroy; override;
    procedure SaveBase();

    property Trees: TList read FTrees;
  end;


function FPoint(AX, AY: TFPointType): TFPoint; overload;
function FPoint(APoint: TPoint): TFPoint; overload;
function AzimuthToAngle(AAzimuth: double): double;

implementation

uses
  math;

// преобразование азимута в угол относительно горизонтали
// азимут задается в градусах
// результат в радианах
function AzimuthToAngle(AAzimuth: double): double;
begin
  Result := (90 - AAzimuth) / 180 * pi;
end;

function FPoint(APoint: TPoint): TFPoint;
begin
  Result.x := APoint.x;
  Result.y := APoint.y;
end;

function FPoint(AX, AY: TFPointType): TFPoint;
begin
  Result.x := AX;
  Result.y := AY;
end;

{File operations}
procedure WriteString(AStream: TStream; const AText: string);
begin
  AStream.WriteAnsiString(AText);
end;

procedure WriteBool(AStream: TStream; const AValue: boolean);
begin
  if AValue then
    AStream.WriteByte(1)
  else
    AStream.WriteByte(0);
end;

procedure WriteInteger(AStream: TStream; const AValue: integer);
begin
  AStream.WriteBuffer(AValue, sizeof(AValue));
end;

procedure WriteDouble(AStream: TStream; const AValue: double);
begin
  AStream.WriteBuffer(AValue, sizeof(AValue));
end;

function ReadString(AStream: TStream): string;
begin
  Result := AStream.ReadAnsiString();
end;

function ReadBool(AStream: TStream): boolean;
var
  b: byte;
begin
  b := AStream.ReadByte;
  Result := (b = 1);
end;

function ReadInteger(AStream: TStream): integer;
var
  i: integer;
begin
  i := 0;
  AStream.ReadBuffer(i, sizeof(integer));
  Result := i;
end;

function ReadDouble(AStream: TStream): double;
var
  d: double;
begin
  d := 0;
  AStream.ReadBuffer(d, sizeof(double));
  Result := d;
end;

{ TProjObject }

function TProjObject.GetArea(): double;
var
  i: integer;
  r: double;
begin
  Result := 0;
  if (FCount = 1) and (FWidth > 0) then
  begin
    r := FWidth/2;
    Result := pi*r*r;
  end
  else if FClosed then
  begin
    for i := 0 to FCount - 2 do
    begin
      r := FPointX[i+1]*FPointY[i]-FPointX[i]*FPointY[i+1];
      Result := Result + r;
    end;
    r := FPointX[0]*FPointY[FCount-1]-FPointX[FCount-1]*FPointY[0];
    Result := Abs(Result + r)/2;
  end;
end;

function TProjObject.GetPerimeter(): double;
var
  i: integer;
  r: double;
begin
  Result := 0;
  if (FCount = 1) and (FWidth > 0) then
  begin
    r := FWidth/2;
    Result := 2*pi*r;
  end
  else
  begin
    for i := 0 to FCount - 2 do
    begin
      r := sqrt(sqr(FPointX[i+1]-FPointX[i])+sqr(FPointY[i+1]-FPointY[i]));
      Result := Result + r;
    end;
    if FClosed then
    begin
      r := sqrt(sqr(FPointX[0]-FPointX[FCount-1])+sqr(FPointY[0]-FPointY[FCount-1]));
      Result := Result + r;
    end;
  end;
end;

procedure TProjObject.Clear;
begin
  FCount := 0;
  SetLength(FPointX, 0);
  SetLength(FPointY, 0);
end;

procedure TProjObject.Grow;
begin
  if FCount > Length(FPointX) then
  begin
    SetLength(FPointX, FCount + 4);
    SetLength(FPointY, FCount + 4);
  end;
end;

function TProjObject.GetX(AIndex: integer): TFPointType;
begin
  Result := FPointX[AIndex];
end;

function TProjObject.GetY(AIndex: integer): TFPointType;
begin
  Result := FPointY[AIndex];
end;

procedure TProjObject.SetX(AIndex: integer; AValue: TFPointType);
begin
  FPointX[AIndex] := AValue;
end;

procedure TProjObject.SetY(AIndex: integer; AValue: TFPointType);
begin
  FPointY[AIndex] := AValue;
end;

procedure TProjObject.SetTitleVisible(AValue: boolean);
var
  i: integer;
  x0, y0: TFPointType;
begin
  if FTitleVisible = AValue then
    Exit;
  FTitleVisible := AValue;
  if FTitleVisible and (FCount > 0) then
  begin
    x0 := 0;
    y0 := 0;
    for i := 0 to FCount - 1 do
    begin
      x0 += FPointX[i];
      y0 += FPointY[i];
    end;
    x0 /= FCount;
    y0 /= FCount;
    FTitlePointX := x0;
    FTitlePointY := y0;
  end;
end;

constructor TProjObject.Create();
begin
  FCount := 0;
  Grow();
  FActive := True;
  FName := '<Новый объект>';
  FDescr := '';
  FWidth := 0;
  FColor := clBlack;
  FFillColor := clWhite;
  FClosed := False;
  FFilled := False;
  FFixed := False;
  FTitleVisible := False;
  FTitleColor := clBlack;
  FTitleSize := 10;
end;

destructor TProjObject.Destroy;
begin
  Clear();
  FPointX := nil;
  FPointY := nil;
  inherited Destroy;
end;

procedure TProjObject.Rotate(AAngle: double);
var
  cx, cy, px, py: double;
  i: integer;
begin
  if FCount < 2 then
    Exit;
  cx := 0;
  cy := 0;
  for i := 0 to FCount - 1 do
  begin
    cx := cx + FPointX[i];
    cy := cy + FPointY[i];
  end;
  cx := cx / FCount;
  cy := cy / FCount;
  for i := 0 to FCount - 1 do
  begin
    px := FPointX[i];
    py := FPointY[i];
    FPointX[i] := cx + (px-cx)*cos(AAngle)-(py-cy)*sin(AAngle);
    FPointY[i] := cy + (px-cx)*sin(AAngle)+(py-cy)*cos(AAngle);
  end;
end;

procedure TProjObject.Translate(AX, AY: TFPointType);
var
  i: integer;
begin
  for i := 0 to FCount - 1 do
  begin
    FPointX[i] := FPointX[i] + AX;
    FPointY[i] := FPointY[i] + AY;
  end;
end;

procedure TProjObject.AddPoint(APoint: TFPoint);
begin
  FCount := FCount + 1;
  Grow;
  FPointX[FCount-1] := APoint.x;
  FPointY[FCount-1] := APoint.y;
end;

procedure TProjObject.AddPoint(AX, AY: TFPointType; ADelta: double);
var
  vx1, vx2, vy1, vy2: double;
  r1, r2, phi: double;
  ix, i: integer;
begin
  // ищем куда вставить - делаем через поиск угла между новой точкой и имеющимся ребром
  ix := -1;
  for i := 0 to FCount - 2 do
  begin
    vx1 := AX-FPointX[i];
    vy1 := AY-FPointY[i];
    vx2 := FPointX[i+1]-FPointX[i];
    vy2 := FPointY[i+1]-FPointY[i];
    r1 := sqrt(sqr(vx1)+sqr(vy1));
    r2 := sqrt(sqr(vx2)+sqr(vy2));
    phi := arccos( (vx1*vx2 + vy1*vy2) / (r1*r2));
    if (Abs(phi) < C_ANGLE/180*pi) and (r1 < r2) then
    begin
      ix := i;
      break;
    end;
  end;

  if ix = -1 then
  begin
    FCount := FCount + 1;
    Grow;
    FPointX[FCount-1] := AX;
    FPointY[FCount-1] := AY;
  end
  else
  begin
    FCount := FCount + 1;
    Grow;
    for i := FCount-1 downto ix+2 do
    begin
      FPointX[i] := FPointX[i-1];
      FPointY[i] := FPointY[i-1];
    end;
    FPointX[ix+1] := AX;
    FPointY[ix+1] := AY;
  end;
end;

procedure TProjObject.DelPoint(AX, AY: TFPointType; ADelta: double);
var
  i, ix: integer;
  r: double;
begin
  ix := -1;
  for i := 0 to FCount - 1 do
  begin
    r := sqrt(sqr(FPointX[i]-AX) + sqr(FPointY[i]-AY));
    if r <= ADelta then
    begin
      ix := i;
      break;
    end;
  end;

  if ix <> -1 then
  begin
    for i := ix to FCount-2 do
    begin
      FPointX[i] := FPointX[i+1];
      FPointY[i] := FPointY[i+1];
    end;
    FCount := FCount - 1;
  end;
end;

function TProjObject.MovePoint(APoint, ANewPoint: TFPoint; ADelta: double): boolean;
var
  i, ix: integer;
  r: double;
begin
  ix := -1;
  for i := 0 to FCount - 1 do
  begin
    r := sqrt(sqr(FPointX[i]-APoint.x) + sqr(FPointY[i]-APoint.y));
    if r <= ADelta then
    begin
      ix := i;
      break;
    end;
  end;

  Result := ix <> -1;
  if Result then
  begin
    FPointX[ix] := ANewPoint.x;
    FPointY[ix] := ANewPoint.y;
  end;
end;

function TProjObject.IsPointInside(AX, AY: TFPointType; ADelta: double): boolean;
var
  r, x1, x2, y1, y2: double;
  xnew, ynew: double;
  xold,yold: double;
  i: Integer;
begin
  Result := False;
  if FCount = 0 then
    Exit;
  if FCount = 1 then
  begin
    // check inside circle
    r := sqrt(sqr(AX-FPointX[0])+sqr(AY-FPointY[0]));
    if r <= FWidth/2 then
      Result := True;
  end
  else
  begin
    if FClosed and (FCount > 2) then
    begin
      // check inside area
      xold := FPointX[FCount-1];
      yold := FPointY[FCount-1];
      for i := 0 to FCount - 1 do
      begin
        xnew := FPointX[i];
        ynew := FPointY[i];
        if (xnew > xold) then
        begin
          x1:=xold;
          x2:=xnew;
          y1:=yold;
          y2:=ynew;
        end
        else
        begin
          x1:=xnew;
          x2:=xold;
          y1:=ynew;
          y2:=yold;
        end;
        if ((xnew < AX) = (AX <= xold)) and  // edge "open" at left end
           ((AY-y1)*(x2-x1) < (y2-y1)*(AX-x1))
        then
          Result := not Result;
        xold:=xnew;
        yold:=ynew;
      end;
    end
    else
    begin
      // check near line
      for i := 0 to FCount-2 do
      begin
        x1 := FPointX[i];
        y1 := FPointY[i];
        x2 := FPointX[i+1];
        y2 := FPointY[i+1];
        r := sqrt (sqr(x1-x2) + sqr(y1-y2));
        if r > 1e-9 then
          if ((x1-ax)*(x2-ax) <= 0) or ((abs(x1-x2) < 1e-9) and (abs(x1-ax) < ADelta)) then
            if ((y1-ay)*(y2-ay) <= 0)  or ((abs(y1-y2) < 1e-9) and (abs(y1-ay) < ADelta))then
              if Abs((ay-y1)*(x2-x1) - (ax-x1)*(y2-y1))/r < ADelta then
              begin
                Result := True;
                break;
              end;
      end;
    end;
  end;
end;

class function TProjObject.IsScriptCorrect(const AScript: string): boolean;
var
  cmd: boolean;
  v: double;
  i, iprev: integer;
  s: string;
begin
  Result := False;
  if Length(AScript) = 0 then
    Exit;

  if not (AScript[1] in ['a', 'm']) then
    Exit;

  Result := True;
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
        s := TRim(Copy(AScript, iprev+1, i-iprev-1));
        if not TryStrToFloat(s, v) then
        begin
          Result := False;
          break;
        end;
      end;
      iprev := i;
    end;
  end;
  if not cmd then
  begin
    s := Trim(Copy(AScript, iprev+1));
    if not TryStrToFloat(s, v) then
      Result := False;
  end;
end;

procedure TProjObject.FillPoints(ABasePoint: TFPoint; const AScript: string);
var
  cmd: boolean;
  v, a: double;
  i, iprev: integer;
  s: string;
begin
  FCount := FCount + 1;
  Grow;
  FPointX[FCount-1] := ABasePoint.x;
  FPointY[FCount-1] := ABasePoint.y;

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
          FCount := FCount + 1;
          Grow;
          FPointX[FCount-1] := FPointX[FCount-2] + v * cos(AzimuthToAngle(a));
          FPointY[FCount-1] := FPointY[FCount-2] + v * sin(AzimuthToAngle(a));
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
      FCount := FCount + 1;
      Grow;
      FPointX[FCount-1] := FPointX[FCount-2] + v * cos(AzimuthToAngle(a));
      FPointY[FCount-1] := FPointY[FCount-2] + v * sin(AzimuthToAngle(a));
    end;
  end;
end;

procedure TProjObject.StoreTo(AStream: TStream);
var
  i: integer;
begin
  WriteBool(AStream, FActive);
  WriteString(AStream, FName);
  WriteString(AStream, FDescr);

  WriteDouble(AStream, FWidth);
  WriteBool(AStream, FClosed);
  WriteBool(AStream, FFilled);
  WriteBool(AStream, FFixed);

  WriteInteger(AStream, FColor);
  WriteInteger(AStream, FFillColor);
  WriteInteger(AStream, ord(FPenStyle));
  WriteInteger(AStream, ord(FBrushStyle));

  WriteBool(AStream, FTitleVisible);
  WriteDouble(AStream, FTitlePointX);
  WriteDouble(AStream, FTitlePointY);
  WriteInteger(AStream, FTitleSize);
  WriteInteger(AStream, FTitleColor);

  WriteInteger(AStream, FCount);
  for i := 0 to FCount - 1 do
  begin
    WriteDouble(AStream, FPointX[i]);
    WriteDouble(AStream, FPointY[i]);
  end;
end;

procedure TProjObject.ReadFrom(AStream: TStream);
var
  i: integer;
begin
  FActive := ReadBool(AStream);
  FName := ReadString(AStream);
  FDescr := ReadString(AStream);

  FWidth := ReadDouble(AStream);
  FClosed := ReadBool(AStream);
  FFilled := ReadBool(AStream);
  FFixed := False;
  if TProjData.Ver >= 4 then
    FFixed := ReadBool(AStream);

  FColor := ReadInteger(AStream);
  FFillColor := ReadInteger(AStream);
  FPenStyle := TPenStyle(ReadInteger(AStream));
  FBrushStyle := TBrushStyle(ReadInteger(AStream));

  FTitleVisible := ReadBool(AStream);
  FTitlePointX := ReadDouble(AStream);
  FTitlePointY := ReadDouble(AStream);
  FTitleSize := ReadInteger(AStream);
  FTitleColor := ReadInteger(AStream);

  FCount := ReadInteger(AStream);
  Grow;
  for i := 0 to FCount - 1 do
  begin
    FPointX[i] := ReadDouble(AStream);
    FPointY[i] := ReadDouble(AStream);
  end;
end;

{ TProjLayer }

constructor TProjLayer.Create();
//var
//  ob: TProjObject;
begin
  FActive := True;
  FName := 'Новый слой';
  FObjects := TList.Create();
  //ob := TProjObject.Create();
  //FObjects.Add(ob);
  //ob.FCount := 4;
  //ob.Grow;
  //ob.FPointX[0] := 0;
  //ob.FPointY[0] := 0;
  //
  //ob.FPointX[1] := 0;
  //ob.FPointY[1] := 2;
  //
  //ob.FPointX[2] := 4;
  //ob.FPointY[2] := 2;
  //
  //ob.FPointX[3] := 4;
  //ob.FPointY[3] := 0;
end;

destructor TProjLayer.Destroy;
var
  i: integer;
begin
  for i := 0 to FObjects.Count - 1 do
    TProjObject(FObjects[i]).Free;
  FObjects.Free;
  inherited Destroy;
end;

procedure TProjLayer.StoreTo(AStream: TStream);
var
  i: integer;
begin
  WriteBool(AStream, FActive);
  WriteString(AStream, FName);

  WriteInteger(AStream, FObjects.Count);
  for i := 0 to FObjects.Count - 1 do
    TProjObject(FObjects[i]).StoreTo(AStream);
end;

procedure TProjLayer.ReadFrom(AStream: TStream);
var
  i, num: integer;
  o: TProjObject;
begin
  FActive := ReadBool(AStream);
  FName := ReadString(AStream);

  num := ReadInteger(AStream);
  for i := 0 to num - 1 do
  begin
    o := TProjObject.Create;
    o.ReadFrom(AStream);
    FObjects.Add(o);
  end;
end;

{ TProjData }

function TProjData.GetColor(AIndex: TProjColors): TColor;
begin
  Result := FColors[AIndex];
end;

procedure TProjData.SetColor(AIndex: TProjColors; AValue: TColor);
begin
  FColors[AIndex] := AValue;
end;

constructor TProjData.Create();
var
  i: integer;
begin
  FLayers := TList.Create;
  Clear;
  FStoragesCount := 0;
  for i := 0 to C_STORAGES-1 do
    FStorages[i] := nil;
end;

destructor TProjData.Destroy;
var
  i: integer;
begin
  Clear();
  FLayers.Free;
  for i := 0 to C_STORAGES-1 do
    if FStorages[i] <> nil then
      FStorages[i].Free;
  inherited Destroy;
end;

procedure TProjData.Clear;
var
  i: integer;
begin
  FColors[pcolBackground] := clGray;
  FColors[pcolPoint] := clBlack;
  FColors[pcolRulerLine] := clBlack;
  FColors[pcolRulerText] := clBlack;
  FColors[pcolPointBase] := $b5ff00;
  FColors[pcolPointCalc] := $0098ff;

  FScale := 0;
  FTransX := 0;
  FTransY := 0;
  FAngle := 0;

  FMeshVisible := False;
  FMeshCenterX := 0;
  FMeshCenterY := 0;
  FMeshEdge := 0;
  FMeshArea := 0;
  FMeshType := 0;
  FMeshAzimuth := 0;

  for i := 0 to FLayers.Count - 1 do
    TProjLayer(FLayers[i]).Free;
  FLayers.Clear;
end;

procedure TProjData.GrowStorages();
var
  i: integer;
begin
  if FStoragesCount = C_STORAGES then
  begin
    FStorages[0].Free;
    for i := 1 to C_STORAGES - 1 do
      FStorages[i-1] := FStorages[i];
    FStorages[FStoragesCount-1] := nil;
  end
  else
    FStoragesCount := FStoragesCount + 1;
end;

procedure TProjData.CommitInit();
var
  i: integer;
begin
  // чистим все коммиты до этого
  for i := 0 to C_STORAGES - 1 do
    if FStorages[i] <> nil then
    begin
      FStorages[i].Free;
      FStorages[i] := nil;
    end;
  FStoragesCount := 0;

  // делаем новый первый
  Commit();
end;

procedure TProjData.CommitStart();
begin
  FCommitStarted := True;
end;

procedure TProjData.CommitFinish();
begin
  if FCommitStarted then
    Commit();
end;

procedure TProjData.Commit();
var
  ms: TMemoryStream;
begin
  GrowStorages();

  ms := TMemoryStream.Create;
  InnerSave(ms);
  FStorages[FStoragesCount-1] := ms;
  FCommitStarted := False;
end;

procedure TProjData.Rollback();
begin
  if FStoragesCount <= 1 then
    Exit;

  Clear();
  InnerLoad(FStorages[FStoragesCount-2]);
  FStorages[FStoragesCount-1].Free;
  FStorages[FStoragesCount-1] := nil;
  FStoragesCount := FStoragesCount - 1;
  FCommitStarted := False;
end;

procedure TProjData.InnerLoad(AStream: TStream);
var
  i, num: integer;
  cl: TProjColors;
  lay: TProjLayer;
begin
  AStream.Position := 0;

  // шапка с версией
  TProjData.Ver := ReadInteger(AStream);
  ReadInteger(AStream);
  ReadInteger(AStream);
  ReadInteger(AStream);

  // данные проекта
  for cl := low(FColors) to high(FColors) do
    FColors[cl] := ReadInteger(AStream);

  FDescr := ReadString(AStream);
  ReadInteger(AStream);
  ReadInteger(AStream);
  ReadInteger(AStream);

  // слои
  num := ReadInteger(AStream);
  for i := 0 to num - 1 do
  begin
    lay := TProjLayer.Create();
    lay.ReadFrom(AStream);
    FLayers.Add(lay);
  end;

  // сетка
  FMeshVisible := False;
  FMeshCenterX := 0;
  FMeshCenterY := 0;
  FMeshEdge := 0;
  FMeshArea := 0;
  FMeshType := 0;
  FMeshAzimuth := 0;
  if TProjData.Ver > 4 then
  begin
    FMeshVisible := ReadBool(AStream);
    FMeshCenterX := ReadDouble(AStream);
    FMeshCenterY := ReadDouble(AStream);
    FMeshEdge := ReadDouble(AStream);
    FMeshArea := ReadDouble(AStream);
    FMeshAzimuth := ReadInteger(AStream);
    FMeshType := ReadInteger(AStream);
  end;
end;

procedure TProjData.Load(const AFileName: string);
var
  ms: TMemoryStream;
begin
  ms := TMemoryStream.Create();
  try
    ms.LoadFromFile(AFileName);
    InnerLoad(ms);
  finally
    ms.Free;
  end;
end;

procedure TProjData.InnerSave(AStream: TStream);
var
  i: integer;
  cl: TProjColors;
begin
  // шапка с версией
  WriteInteger(AStream, C_PROJ_VERSION);
  WriteInteger(AStream, 0);
  WriteInteger(AStream, 0);
  WriteInteger(AStream, 0);

  // данные проекта
  for cl := low(FColors) to high(FColors) do
    WriteInteger(AStream, FColors[cl]);

  WriteString(AStream, FDescr);
  WriteInteger(AStream, 0);
  WriteInteger(AStream, 0);
  WriteInteger(AStream, 0);

  // слои
  WriteInteger(AStream, FLayers.Count);
  for i := 0 to FLayers.Count - 1 do
    TProjLayer(FLayers[i]).StoreTo(AStream);

  // сетка
  WriteBool(AStream, FMeshVisible);
  WriteDouble(AStream, FMeshCenterX);
  WriteDouble(AStream, FMeshCenterY);
  WriteDouble(AStream, FMeshEdge);
  WriteDouble(AStream, FMeshArea);
  WriteInteger(AStream, FMeshAzimuth);
  WriteInteger(AStream, FMeshType);
end;

procedure TProjData.Save(const AFileName: string);
var
  ms: TMemoryStream;
begin
  ms := TMemoryStream.Create();
  try
    InnerSave(ms);
    ms.SaveToFile(AFileName);
  finally
    ms.Free;
  end;
end;

function TProjData.FindPoint(AX, AY: TFPointType; ADelta: double; var AOb: TProjObject; var AIndex: integer): boolean;
var
  i, j, k: integer;
  lay: TProjLayer;
  ob: TProjObject;
  r: double;
begin
  AOb := nil;
  AIndex := -1;
  Result := False;
  for i := FLayers.Count-1 downto 0 do
  begin
    lay := TProjLayer(FLayers[i]);
    if lay.Active then
      for j := lay.FObjects.Count - 1 downto 0 do
      begin
        ob := TProjObject(lay.FObjects[j]);
        if ob.Active then
          for k := 0 to ob.FCount - 1 do
          begin
            r := sqrt(sqr(ob.FPointX[k]-AX) + sqr(ob.FPointY[k]-AY));
            if r <= ADelta then
            begin
              Result := True;
              AOb := ob;
              AIndex := k;
              break;
            end;
          end;

        if Result then
          break;
      end;

    if Result then
      break;
  end;
end;

function TProjData.CorrectPointToMesh(APoint: TFPoint; ADelta: double): TFPoint;
var
  n, i, j: integer;
  x, y, x1, y1, cx, cy, a, r: double;
  found: boolean;
begin
  Result := APoint;
  if FMeshVisible and (FMeshEdge >= 1e-6) then
  begin
    // исходные параметры
    n := Trunc(FMeshArea / FMeshEdge / 2);
    if n > (C_MESH_MAX_POINTS div 2) then
      n := C_MESH_MAX_POINTS div 2;
    cx := FMeshCenterX;
    cy := FMeshCenterY;
    a := FMeshAzimuth / 180 * pi;
    found := false;
    for i := -n to n do
    begin
      for j := -n to n do
      begin
        // координаты сетки
        x := 0;
        y := 0;
        if FMeshType = 0 then
        begin
          // сотовая сетка
          if odd(j) then
            x := (cx + FMeshEdge/2) + i * FMeshEdge
          else
            x := cx + i * FMeshEdge;
          y := cy + j * (FMeshEdge * sqrt(3) / 2);
        end
        else if FMeshType = 1 then
        begin
          // прямоугольная сетка
          x := cx + i * FMeshEdge;
          y := cy + j * FMeshEdge;
        end;

        // вращение координат
        x1 := cx + (x-cx)*cos(a)-(y-cy)*sin(a);
        y1 := cy + (x-cx)*sin(a)+(y-cy)*cos(a);

        // проверка по расстоянию
        r := sqrt(sqr(APoint.x - x1) + sqr(APoint.y - y1));
        if r < ADelta then
        begin
          found := true;
          Result.x := x1;
          Result.y := y1;
          break;
        end;
      end;
      if found then
        break;
    end;
  end;
end;

function TProjData.MovePointWithMesh(AObject: TProjObject; APoint, ANewPoint: TFPoint; ADelta: double): boolean;
var
  p: TFPoint;
begin
  p := CorrectPointToMesh(ANewPoint, ADelta*C_MESH_DELTA_CORRECTION);
  Result := AObject.MovePoint(APoint, p, ADelta);
end;

procedure TProjData.TranslateWithMesh(AObject: TProjObject; APoint, ANewPoint: TFPoint; ADelta: double);
var
  p: TFPoint;
begin
  p := ANewPoint;
  if AObject.Count = 1 then
  begin
    p.x := ANewPoint.x - APoint.x + AObject.X[0];
    p.y := ANewPoint.y - APoint.y + AObject.Y[0];

    p := CorrectPointToMesh(p, ADelta*C_MESH_DELTA_CORRECTION);

    p.x := p.x + APoint.x - AObject.X[0];
    p.y := p.y + APoint.y - AObject.Y[0];
  end;
  AObject.Translate(p.x-APoint.x, p.y-APoint.y);
end;

{%Region 'TProjTree'}
constructor TProjTree.Create();
begin
  FName := '<Новое дерево>';
  FDescr := '';
  FColor := $004000;
  FFillColor := $63BB63;
  FRadius := 1.5;
end;

procedure TProjTree.StoreTo(AStream: TStream);
begin
  WriteString(AStream, FName);
  WriteString(AStream, FDescr);

  WriteInteger(AStream, FColor);
  WriteInteger(AStream, FFillColor);
  WriteDouble(AStream, FRadius);
end;

procedure TProjTree.ReadFrom(AStream: TStream);
begin
  FName := ReadString(AStream);
  FDescr := ReadString(AStream);

  FColor := ReadInteger(AStream);
  FFillColor := ReadInteger(AStream);
  FRadius := ReadDouble(AStream);
end;
{%EndRegion}

{%Region 'TProjTreeData'}
procedure TProjTreeData.LoadBase();
var
  ms: TMemoryStream;
  i, cnt: integer;
  tree: TProjTree;
begin
  ms := TMemoryStream.Create();
  try
    if FileExists(FFileName) then
    begin
      ms.LoadFromFile(FFileName);

      ReadInteger(ms); // version
      ReadInteger(ms);
      ReadInteger(ms);
      ReadInteger(ms);

      ReadString(ms); // 'trees'
      cnt := ReadInteger(ms);
      for i := 0 to cnt - 1 do
      begin
        tree := TProjTree.Create();
        tree.ReadFrom(ms);
        FTrees.Add(tree);
      end;
    end;
  finally
    ms.Free;
  end;
end;

procedure TProjTreeData.SaveBase();
var
  ms: TMemoryStream;
  i: integer;
begin
  ms := TMemoryStream.Create();
  try
    WriteInteger(ms, 1); // version
    WriteInteger(ms, 0); // reserved
    WriteInteger(ms, 0);
    WriteInteger(ms, 0);

    WriteString(ms, 'trees');
    WriteInteger(ms, FTrees.Count);
    for i := 0 to FTrees.Count - 1 do
      TProjTree(FTrees[i]).StoreTo(ms);

    ms.SaveToFile(FFileName);
  finally
    ms.Free;
  end;
end;

constructor TProjTreeData.Create(const AFileName: string);
begin
  FFileName := AFileName;
  FTrees := TList.Create();
  LoadBase();
end;

destructor TProjTreeData.Destroy;
var
  i: integer;
begin
  for i := 0 to FTrees.Count - 1 do
    TProjTree(FTrees[i]).Free;
  FTrees.Free;
  inherited Destroy;
end;
{%EndRegion}

end.

