unit settings;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils;

type

  { TNavSettings }

  TNavSettings = class sealed
  private
    FPath: string;
    FFileName: string;
    procedure LoadDefaults;
    procedure LoadFromFile(const AFileName: string);
  public
    constructor Create();

    property Path: string read FPath;
    property FileName: string read FFileName;
  end;

var
  navSettings: TNavSettings;

implementation

uses
  fpjson, jsonparser;

const
  C_SETTINGS_NAME = 'settings';
  C_DEFAULT_NAME = 'anav3.data';
  C_JSON_TAG = 'filename';

{ TNavSettings }

constructor TNavSettings.Create();
var
  fn: string;
begin
  LoadDefaults;
  fn := FPath + C_SETTINGS_NAME;
  if FileExists(fn) then
    LoadFromFile(fn);
end;

procedure TNavSettings.LoadDefaults;
begin
  FPath := ExtractFilePath(ParamStr(0));
  FFileName := FPath + C_DEFAULT_NAME;
end;

procedure TNavSettings.LoadFromFile(const AFileName: string);
var
  ms: TMemoryStream;
  jdata : TJSONObject;
  fn: string;
begin
  fn := '';
  ms := TMemoryStream.Create();
  try
    try
      ms.LoadFromFile(AFileName);
      jdata := TJsonObject(GetJSON(ms));

      if jdata.Find(C_JSON_TAG) <> nil then
        fn := jdata.Elements[C_JSON_TAG].AsString;

      if fn <> '' then
      begin
        if fn[1] = '.' then
          FFileName := ExpandFileName(FPath + fn)
        else
          FFileName := fn;
      end;
    except
      jdata := nil;
      LoadDefaults;
    end;
  finally
    ms.Free;
    if Assigned(jdata) then
      jdata.Free;
  end;
end;

initialization
  navSettings := TNavSettings.Create;

finalization;
  navSettings.Free;

end.

