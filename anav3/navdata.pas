unit navdata;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils;

type

  { TNavParam }

  TNavParam = class
  private
    FName: string; // for file is name
    FValue: string; // for file is content
    FIsFile: boolean;
  public
    constructor Create();
    property Name: string read FName write FName;
    property Value: string read FValue write FValue;
    property IsFile: boolean read FIsFile write FIsFile;
  end;

  { TNavItem }

  TNavItem = class
  private
    FName: string;
    FParams: TList;
  public
    constructor Create();
    destructor Destroy; override;

    procedure Copy(AItem: TNavItem);

    property Name: string read FName write FName;
    property Params: TList read FParams;
  end;

  { TNavGroup }

  TNavGroup = class
  private
    FName: string;
    FItems: TList;
  public
    constructor Create();
    destructor Destroy; override;

    property Name: string read FName write FName;
    property Items: TList read FItems;
  end;

  { TNavData }

  TNavData = class
  private
    FFileName: string;
    FError: boolean;
    FPass: string;
    FPassEdit: string;
    FGroups: TList;
    function doLoad(): boolean;
    procedure LoadFrom(AStream: TStream);
    procedure StoreTo(AStream: TStream);
  public
    constructor Create(const AFileName: string; ALoadData: boolean = True);
    destructor Destroy; override;

    function CheckPassword(AIndex: integer; const APass: string): boolean;
    procedure CreateNew(const APass, APassEdit: string);
    procedure Save();

    property Error: boolean read FError;
    property Groups: TList read FGroups;
  end;


implementation

uses
  BlowFish;

const
  C_KEY: integer = $08021982;
  C_CURRENT_FILE_VERSION = 3;

{ File operations }
procedure WriteString(AStream: TStream; const AText: string);
begin
  AStream.WriteAnsiString(AText);
end;

procedure WriteInteger(AStream: TStream; const AValue: integer);
begin
  AStream.WriteBuffer(AValue, sizeof(AValue));
end;

function ReadString(AStream: TStream): string;
begin
  Result := AStream.ReadAnsiString();
end;

function ReadInteger(AStream: TStream): integer;
var
  i: integer;
begin
  i := 0;
  AStream.ReadBuffer(i, sizeof(integer));
  Result := i;
end;

{ TNavParam }

constructor TNavParam.Create();
begin
  FName := '';
  FValue := '';
  FIsFile := False;
end;

{ TNavGroup }

constructor TNavGroup.Create();
begin
  FItems := TList.Create();
end;

destructor TNavGroup.Destroy;
var
  i: integer;
begin
  for i := 0 to FItems.Count - 1 do
    TNavItem(FItems[i]).Free;
  FItems.Free;
  inherited Destroy;
end;

{ TNavItem }

constructor TNavItem.Create();
begin
  FParams := TList.Create();
end;

destructor TNavItem.Destroy;
var
  i: integer;
begin
  for i := 0 to FParams.Count - 1 do
    TNavParam(FParams[i]).Free;
  FParams.Free;
  inherited Destroy;
end;

procedure TNavItem.Copy(AItem: TNavItem);
var
  i: integer;
  p: TNavParam;
begin
  FName := AItem.Name;
  for i := 0 to FParams.Count - 1 do
    TNavParam(FParams[i]).Free;
  FParams.Clear;
  for i := 0 to AItem.FParams.Count - 1 do
  begin
    p := TNavParam.Create();
    p.FName := TNavParam(AItem.FParams[i]).FName;
    p.FValue := TNavParam(AItem.FParams[i]).FValue;
    FParams.Add(p);
  end;
end;

{ TNavData }

constructor TNavData.Create(const AFileName: string; ALoadData: boolean = True);
begin
  FGroups := TList.Create;
  FFileName := AFileName;
  FError := True;

  if ALoadData then
    if FileExists(FFileName) then
      FError := not doLoad();
end;

destructor TNavData.Destroy;
var
  i: integer;
begin
  for i := 0 to FGroups.Count - 1 do
    TNavGroup(FGroups[i]).Free;
  FGroups.Free;
  inherited Destroy;
end;

function TNavData.CheckPassword(AIndex: integer; const APass: string): boolean;
var
  ms: TMemoryStream;
  de: TBlowFishDeCryptStream;
  s: string;
  d: double;
  k1, k2: integer;
begin
  Result := False;
  if AIndex = 0 then
  begin
    // check decryption with specified password
    FPass := APass;
    if Trim(FPass) = '' then
      Result := False
    else
    begin
      s := FPass;
      while Length(s) < 56 do
        s := s + FPass;

      ms := TMemoryStream.Create();
      de := TBlowFishDeCryptStream.Create(s, ms);
      try
        // read data
        try
          ms.LoadFromFile(FFileName);
          // header
          d := 0;
          de.Read(d, sizeof(d));
          k1 := ReadInteger(de);
          if k1 = C_KEY then
          begin
            FPassEdit := ReadString(de);

            // body
            LoadFrom(de);

            // final key
            k2 := ReadInteger(de);

            Result := (k1 = C_KEY) and (k2 = C_KEY);
          end
          else
            Result := False;
        except
          Result := false;
        end;
      finally
        de.Free;
        ms.Free;
      end;
    end;
  end
  else if AIndex = 1 then
  begin
    // check editing password
    Result := APass = FPassEdit;
  end;
end;

procedure TNavData.CreateNew(const APass, APassEdit: string);
begin
  // new data file generation
  FPass := APass;
  FPassEdit := APassEdit;
  Save();
end;

procedure TNavData.LoadFrom(AStream: TStream);
var
  i, j, k, nGroups, nItems, nParams, v, fl: integer;
  g: TNavGroup;
  itm: TNavItem;
  p: TNavParam;
begin
  // header
  v := ReadInteger(AStream);
  ReadInteger(AStream);
  ReadInteger(AStream);
  ReadInteger(AStream);

  // data
  nGroups := ReadInteger(AStream);
  for i := 0 to nGroups - 1 do
  begin
    g := TNavGroup.Create();;
    g.Name := ReadString(AStream);
    nItems := ReadInteger(AStream);
    for j := 0 to nItems - 1 do
    begin
      itm := TNavItem.Create;
      itm.Name := ReadString(AStream);
      nParams := ReadInteger(AStream);
      for k := 0 to nParams - 1 do
      begin
        p := TNavParam.Create();
        p.Name := ReadString(AStream);
        p.Value := ReadString(AStream);
        if v = 3 then
        begin
          fl := ReadInteger(AStream);
          p.IsFile := (fl = 1);
        end;
        itm.Params.Add(p);
      end;
      g.Items.Add(itm);
    end;
    FGroups.Add(g);
  end;
  if v = 2 then
    ReadInteger(AStream);
end;

procedure TNavData.StoreTo(AStream: TStream);
var
  i, j, k: integer;
  g: TNavGroup;
  itm: TNavItem;
  p: TNavParam;
  d: double;
begin
  // header
  d := random;
  AStream.WriteBuffer(d, sizeof(d));
  WriteInteger(AStream, C_KEY);
  WriteString(AStream, FPassEdit);
  WriteInteger(AStream, C_CURRENT_FILE_VERSION);
  WriteInteger(AStream, 0);
  WriteInteger(AStream, 0);
  WriteInteger(AStream, 0);

  // data
  WriteInteger(AStream, FGroups.Count);
  for i := 0 to FGroups.Count - 1 do
  begin
    g := TNavGroup(FGroups[i]);
    WriteString(AStream, g.Name);
    WriteInteger(AStream, g.Items.Count);
    for j := 0 to g.FItems.Count - 1 do
    begin
      itm := TNavItem(g.FItems[j]);
      WriteString(AStream, itm.Name);
      WriteInteger(AStream, itm.Params.Count);
      for k := 0 to itm.Params.Count - 1 do
      begin
        p := TNavParam(itm.Params[k]);
        WriteString(AStream, p.Name);
        WriteString(AStream, p.Value);
        if p.IsFile then
          WriteInteger(AStream, 1)
        else
          WriteInteger(AStream, 0);
      end;
    end;
  end;
  WriteInteger(AStream, C_KEY);
end;

function TNavData.doLoad(): boolean;
var
  ms: TMemoryStream;
begin
  Result := True;
  // try to read file
  ms := TMemoryStream.Create();
  try
    try
      ms.LoadFromFile(FFileName);
    except
      Result := False;
    end;
  finally
    ms.Free;
  end;
end;

procedure TNavData.Save();
var
  ms: TMemoryStream;
  en: TBlowFishEncryptStream;
  s: string;
begin
  s := FPass;
  while Length(s) < 56 do
    s := s + FPass;

  ms := TMemoryStream.Create();
  en := TBlowFishEncryptStream.Create(s, ms);
  try
    // save data
    StoreTo(en);
    en.Flush;

    ms.SaveToFile(FFileName);
  finally
    en.Free;
    ms.Free;
  end;
end;

end.

