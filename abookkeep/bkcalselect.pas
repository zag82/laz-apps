unit bkcalselect;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, Calendar, StdCtrls;

type
  TOnChangeDate = procedure(ADate: TDate) of object;

  { TfmBkCalSelect }

  TfmBkCalSelect = class(TForm)
    btToday: TButton;
    btOK: TButton;
    cl: TCalendar;
    procedure btOKClick(Sender: TObject);
    procedure btTodayClick(Sender: TObject);
    procedure clDblClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormDeactivate(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: char);
    procedure FormPaint(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    FOnChangeDate: TOnChangeDate;
    FX: integer;
    FY: integer;
  public
    procedure Init(ADate: TDate; AX, AY: integer);
    property OnChangeDate: TOnChangeDate read FOnChangeDate write FOnChangeDate;
  end;

var
  fmBkCalSelect: TfmBkCalSelect;

implementation

{$R *.lfm}

{ TfmBkCalSelect }

procedure TfmBkCalSelect.FormDeactivate(Sender: TObject);
begin
  Close;
end;

procedure TfmBkCalSelect.FormKeyPress(Sender: TObject; var Key: char);
begin
  if Key = #27 then
    Close;
end;

procedure TfmBkCalSelect.FormPaint(Sender: TObject);
begin
  Canvas.Pen.Color := clBlack;
  Canvas.Pen.Style := psSolid;
  Canvas.Brush.Style := bsClear;
  Canvas.Rectangle(0,0, ClientWidth, ClientHeight);
end;

procedure TfmBkCalSelect.FormShow(Sender: TObject);
begin
  Self.Top := FY;
  Self.Left := FX;
end;

procedure TfmBkCalSelect.Init(ADate: TDate; AX, AY: integer);
begin
  FX := AX;
  FY := AY;
  cl.DateTime := ADate;
  btToday.Caption := 'Сегодня: '+ DateToStr(Date());
end;

procedure TfmBkCalSelect.clDblClick(Sender: TObject);
begin
  btOK.Click;
end;

procedure TfmBkCalSelect.FormClose(Sender: TObject;
  var CloseAction: TCloseAction);
begin
  CloseAction := caFree;
  fmBkCalSelect := nil;
end;

procedure TfmBkCalSelect.btTodayClick(Sender: TObject);
begin
  cl.DateTime := Date();
end;

procedure TfmBkCalSelect.btOKClick(Sender: TObject);
var
  d: TDate;
begin
  d := cl.DateTime;
  if Assigned(FOnChangeDate) then
    FOnChangeDate(d);
  Close;
end;


end.

