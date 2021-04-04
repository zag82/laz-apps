unit mainmenu;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, LCLType;

var
  N_ITEMS: integer = 1;
  BORDER_GAP: integer = 10;
  BORDER_ITM: integer = 5;
  homePath: string = '/home/andrew';

type
  TMenuElem = record
    id: integer;
    root: boolean;
    name: string;
    command: string;
    shortcut: integer;
    shortchar: string;
  end;

  { TfmMainMenu }

  TfmMainMenu = class(TForm)
    procedure FormCreate(Sender: TObject);
    procedure FormDblClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormPaint(Sender: TObject);
  private
    items: array of TMenuElem;
    itemIndex: integer;
    itm_H: integer;
    procedure doLoadFromJson();
    function getPosition(AX, AY: integer): integer;
    procedure AppDeactivate(Sender: TObject);
  public

  end;

var
  fmMainMenu: TfmMainMenu;

implementation

uses
  strutils, process, fpjson, jsonparser;

{$R *.lfm}

{ TfmMainMenu }

procedure execApp(const ACommand: string);
var
  p: TProcess;
  cmds: TStringArray;
  i: integer;
begin
  p := TProcess.Create(nil);
  try
    cmds := ACommand.Split(' ');
    if Length(cmds) > 0 then
    begin
      // program
      p.InheritHandles := False;
      p.Options := [];
      p.ShowWindow := swoShowNormal;
      p.Executable := cmds[0];

      // environment
      for i := 1 to GetEnvironmentVariableCount do
        p.Environment.Add(GetEnvironmentString(i));

      // parameters
      for i := 1 to High(cmds) do
        p.Parameters.Add(cmds[i]);

      // run
      p.Execute;
    end;
  finally
    p.Free;
  end;
end;

procedure TfmMainMenu.FormCreate(Sender: TObject);
const
  sep = '-------------------------------------------------';
var
  r: TRect;
begin
  Application.OnDeactivate:=@AppDeactivate;
  Canvas.Font.Name := 'DejaVu Sans Mono';
  Canvas.Font.Size := 12;
  itm_H := Canvas.TextHeight(' ') + 1 * BORDER_ITM;

  // заполняем список элементов меню
  doLoadFromJson();

  // задаём размер окна и выводим его по центру экрана
  r := Screen.MonitorFromPoint(Mouse.CursorPos).WorkareaRect;
  ClientWidth := Canvas.TextWidth(sep) + 8*BORDER_GAP + 2*BORDER_ITM;
  ClientHeight := 2*BORDER_GAP + itm_H * N_ITEMS;
  Left := r.Left + ((r.Width - Width) div 2);
  Top := r.Top + ((r.Height- Height) div 2);
end;

procedure TfmMainMenu.FormDblClick(Sender: TObject);
begin
  if items[itemIndex].command <> '' then
  begin
    execApp(items[itemIndex].command);
    close();
  end;
end;

procedure TfmMainMenu.FormDestroy(Sender: TObject);
begin
  items := nil;
end;

procedure TfmMainMenu.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
  i: integer;
begin
  // закрываем по Esc
  if (Key = VK_Q) or (Key = VK_ESCAPE) then
    Close()
  // запускаем команду по Enter
  else if Key = VK_RETURN then
  begin
    // запуск конкретного процесса
    if items[itemIndex].command <> '' then
    begin
      execApp(items[itemIndex].command);
      close();
    end;
  end
  else
  begin
    for i := 0 to N_ITEMS - 1 do
    begin
      if (items[i].shortcut = Key) and (items[i].command <> '') then
      begin
        // нашли кого-то с клавишей
        execApp(items[i].command);
        close();
        break;
      end;
    end;

    // перемещаемся по стрелкам
    if (Key = VK_UP) and (itemIndex > 0) then
    begin
      itemIndex := itemIndex - 1;
      Repaint();
    end
    else if (Key = VK_DOWN) and (itemIndex < N_ITEMS-1) then
    begin
      itemIndex := itemIndex + 1;
      Repaint;
    end
    else if (Key = VK_LEFT) or (key = VK_HOME) then
    begin
      itemIndex := 0;
      Repaint();
    end
    else if (Key = VK_RIGHT) or (Key = VK_END) then
    begin
      itemIndex := N_ITEMS-1;
      Repaint();
    end;
  end;
end;

procedure TfmMainMenu.FormMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  ix: integer;
begin
  if Button = mbLeft then
  begin
    ix := getPosition(X, Y);
    if (ix >= 0) and (ix < N_ITEMS) then
    begin
      itemIndex := ix;
      Repaint();
    end;
  end;
end;

procedure TfmMainMenu.FormPaint(Sender: TObject);
var
  c: TCanvas;
  i, k, y: integer;
begin
  c := Canvas;
  c.Font.Color := $fafafa;
  c.Pen.Color := $fafafa;
  c.Pen.Style := psSolid;
  c.Brush.Color := $222827;
  c.Brush.Style := bsSolid;
  c.Rectangle(0,0,ClientWidth, ClientHeight);

  for i := 0 to N_ITEMS - 1 do
  begin
    // рисование конкретного элемента
    if i = itemIndex then
    begin
      y := BORDER_GAP + i*itm_H;
      c.Brush.Color := $a46534;
      c.FillRect(BORDER_GAP, y, ClientWidth-BORDER_GAP, y + itm_H);
    end;
    k := 4;
    if not items[i].root then
      k := 7;
    c.Brush.Style := bsClear;
    c.TextOut(BORDER_GAP*k + BORDER_ITM, BORDER_GAP + i*itm_H+BORDER_ITM-1, items[i].name);
    if items[i].shortcut <> 0 then
      c.TextOut(BORDER_GAP + BORDER_ITM, BORDER_GAP + i*itm_H+BORDER_ITM-1, items[i].shortchar);
    c.Brush.Style := bsSolid;
  end;
end;

procedure TfmMainMenu.doLoadFromJson();
var
  i: integer;
  filename: string;
  ms: TMemoryStream;

  jdata : TJSONObject;
  jitems : TJSONArray;
begin
  filename := ExtractFilePath(Application.ExeName) + 'amenu.json';
  if not FileExists(filename) then
    Exit;

  ms := TMemoryStream.Create();
  try
    ms.LoadFromFile(filename);

    jdata := TJsonObject(GetJSON(ms));
    // common
    homePath := jdata.Elements['home'].AsString;
    BORDER_GAP := jdata.Elements['BORDER_GAP'].AsInteger;
    BORDER_ITM := jdata.Elements['BORDER_ITM'].AsInteger;

    jitems := TJsonArray(jdata.Elements['items']);
    N_ITEMS := jitems.Count;
    SetLength(items, N_ITEMS);

    // elements
    for i := 0 to N_ITEMS-1 do
    begin
      items[i].id := i;
      items[i].root := TJSONObject(jitems.Items[i]).Elements['root'].AsBoolean;
      items[i].name := TJSONObject(jitems.Items[i]).Elements['name'].AsString;
      items[i].command := ReplaceStr(TJSONObject(jitems.Items[i]).Elements['command'].AsString, '~', homePath);
      items[i].shortchar := TJSONObject(jitems.Items[i]).Elements['shortcut'].AsString;
      items[i].shortcut := 0;
      if items[i].shortchar <> '' then
        items[i].shortcut := ord(AnsiUpperCase(items[i].shortchar)[1]);
    end;
  finally
    ms.Free;
    jdata.Free;
  end;
end;

function TfmMainMenu.getPosition(AX, AY: integer): integer;
var
  ps: integer;
begin
  ps := -1;
  if (AX > BORDER_GAP) and (AX < Width-BORDER_GAP) then
    if (AY > BORDER_GAP) and (AY < Height-BORDER_GAP) then
      ps := (AY - BORDER_GAP) div itm_H;
  Result := ps;
end;

procedure TfmMainMenu.AppDeactivate(Sender: TObject);
begin
  Close;
end;

end.

