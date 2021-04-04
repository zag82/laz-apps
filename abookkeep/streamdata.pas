unit streamdata;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils;

procedure WriteString(AStream: TStream; const AText: string);
procedure WriteInteger(AStream: TStream; const AValue: integer);
procedure WriteDouble(AStream: TStream; const AValue: double);
procedure WriteBoolean(AStream: TStream; const AValue: boolean);

function ReadString(AStream: TStream): string;
function ReadInteger(AStream: TStream): integer;
function ReadDouble(AStream: TStream): double;
function ReadBoolean(AStream: TStream): boolean;

function ElfHash(const AValue: string): Integer;

implementation


function ElfHash(const AValue: string): Integer;
var
  i, x: Integer;
begin
  Result := 0;
  {$R-}
  for i := 1 to Length(AValue) do
  begin
    Result := (Result shl 4) + Ord(AValue[i]);
    x := Result and $F0000000;
    if (x <> 0) then
      Result := Result xor (x shr 24);
    Result := Result and (not x);
  end;
  {$R+}
end;

{ File operations }
procedure WriteString(AStream: TStream; const AText: string);
begin
  AStream.WriteAnsiString(AText);
end;

procedure WriteInteger(AStream: TStream; const AValue: integer);
begin
  AStream.WriteBuffer(AValue, sizeof(AValue));
end;

procedure WriteDouble(AStream: TStream; const AValue: double);
begin
  AStream.WriteBuffer(AValue, sizeof(AValue));
end;

procedure WriteBoolean(AStream: TStream; const AValue: boolean);
begin
  if AValue then
    WriteInteger(AStream, 1)
  else
    WriteInteger(AStream, 0);
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

function ReadDouble(AStream: TStream): double;
var
  d: double;
begin
  d := 0;
  AStream.ReadBuffer(d, sizeof(double));
  Result := d;
end;

function ReadBoolean(AStream: TStream): boolean;
begin
  Result := ReadInteger(AStream) = 1;
end;

end.

