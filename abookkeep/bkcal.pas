unit bkcal;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Types;

const
  week_days: array[0..6] of string = ('пн', 'вт', 'ср', 'чт', 'пт', 'сб', 'вс');
  month_names: array[0..11] of string = (
    'Январь',
    'Февраль',
    'Март',
    'Апрель',
    'Май',
    'Июнь',
    'Июль',
    'Август',
    'Сентябрь',
    'Октябрь',
    'Ноябрь',
    'Декабрь'
  );

type
  { TbkCalendarData }
  TOnChangeDate = procedure() of object;

  TbkCalendarData = class
  private
    FYear: integer;
    FMonth: integer;
    FDay: integer;

    FOnChangeDate: TOnChangeDate;
    procedure SetMonth(AValue: integer);
    procedure SetYear(AValue: integer);
    procedure SetMonthAndYear(AMonth: integer; AYear: integer);
    function GetDate(): TDate;
    function GetMonthName(): string;
    procedure SetDate(ADate: TDate);
  public
    property Year: integer read FYear write SetYear;
    property Month: integer read FMonth write SetMonth;
    property Date: TDate read GetDate write SetDate;
    property MonthName: string read GetMonthName;

    property OnChangeDate: TOnChangeDate read FOnChangeDate write FOnChangeDate;
  end;

implementation

uses
  dateutils;

{ TbkCalendarData }

procedure TbkCalendarData.SetMonth(AValue: integer);
begin
  SetMonthAndYear(AValue, FYear);
end;

procedure TbkCalendarData.SetYear(AValue: integer);
begin
  SetMonthAndYear(FMonth, AValue);
end;

procedure TbkCalendarData.SetMonthAndYear(AMonth: integer; AYear: integer);
begin
  FMonth := AMonth;
  FYear := AYear;
end;

function TbkCalendarData.GetDate(): TDate;
begin
  Result := EncodeDate(FYear, FMonth, FDay);
end;

function TbkCalendarData.GetMonthName(): string;
begin
  Result := month_names[FMonth-1];
end;

procedure TbkCalendarData.SetDate(ADate: TDate);
begin
  FYear := YearOf(ADate);
  FMonth := MonthOf(ADate);
  FDay := DayOfTheMonth(ADate);

  if Assigned(FOnChangeDate) then
    FOnChangeDate();
end;

end.


