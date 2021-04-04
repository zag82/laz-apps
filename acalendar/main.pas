unit main;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, Calendar, StdCtrls;

type

  { TfmMain }

  TfmMain = class(TForm)
    btToday: TButton;
    cal: TCalendar;
    lbCap: TLabel;
    procedure btTodayClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: char);
    procedure FormPaint(Sender: TObject);
  private
    FisI3: boolean;
    procedure AppDeactivate(Sender: TObject);
  end;

var
  fmMain: TfmMain;

implementation

{$R *.lfm}

{ TfmMain }

procedure TfmMain.FormKeyPress(Sender: TObject; var Key: char);
begin
  if ord(Key) = 27 then
    Close;
end;

procedure TfmMain.FormPaint(Sender: TObject);
begin
  Canvas.Pen.Color := clBlack;
  Canvas.Pen.Style := psSolid;
  Canvas.Brush.Style := bsClear;
  Canvas.Rectangle(0,0, ClientWidth, ClientHeight);
end;

procedure TfmMain.AppDeactivate(Sender: TObject);
begin
  if not FisI3 then
    Close;
end;

procedure TfmMain.FormCreate(Sender: TObject);
var
  r: TRect;
begin
  Self.ClientWidth := 356;
  Self.ClientHeight := 250;
  FisI3 := False;
  if ParamCount > 0 then
    if ParamStr(1) = 'i3' then
      FisI3 := True;
  Application.OnDeactivate := @AppDeactivate;;
  cal.DateTime := Now();

  r := Screen.MonitorFromPoint(Mouse.CursorPos).WorkareaRect;
  if FisI3 then
  begin
    Left := r.Left + ((r.Width - Width) div 2);
    Top := r.Top + ((r.Height - Height) div 2);
  end
  else
  begin
    Left := r.Right - self.Width;
    Top := r.Top;
  end;
end;

procedure TfmMain.btTodayClick(Sender: TObject);
begin
  cal.DateTime := Now();
end;

end.

