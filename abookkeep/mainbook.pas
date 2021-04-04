unit mainbook;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, TAGraph, TARadialSeries,
  TASeries, TATransformations, TASources, Forms, Controls, Graphics, Dialogs,
  Grids, ExtCtrls, StdCtrls, ComCtrls, Buttons, ActnList, bkdata, bkcal, Types, TACustomSeries;

type

  TSummaryData = record
    group: boolean;
    data: pointer;
    values: array[0..11] of integer;
  end;

  { TfmMainBook }

  TfmMainBook = class(TForm)
    actFilterPrev: TAction;
    actBudgetAdd: TAction;
    actBudgetDel: TAction;
    actBudgetUp: TAction;
    actBudgetDown: TAction;
    actBudgetEdit: TAction;
    actBudgetClearReady: TAction;
    actQuit: TAction;
    actSave: TAction;
    actTransDelete: TAction;
    actFilterNext: TAction;
    actSprAccounts: TAction;
    actSprCategories: TAction;
    actSprCurrencies: TAction;
    actTransSimple: TAction;
    actTransTrans: TAction;
    actTransStart: TAction;
    actTransEdit: TAction;
    actsMain: TActionList;
    btMoveNext: TToolButton;
    btMovePrev: TToolButton;
    btSprCurrencies: TSpeedButton;
    btSprCategories: TSpeedButton;
    chPie: TChart;
    lbYearsCurrency: TLabel;
    pnlBudget: TPanel;
    pcMoveDetails: TPageControl;
    pnlCapBudget: TPanel;
    pnlRemains: TPanel;
    rgRemainCurency: TRadioGroup;
    rgMoveCurrency: TRadioGroup;
    rgYearsCurrency: TRadioGroup;
    serPie: TPieSeries;
    serMove: TBarSeries;
    chRemain: TChart;
    cbFilter: TComboBox;
    chMove: TChart;
    lbMoveCurrency: TLabel;
    chLabels: TListChartSource;
    serRemain: TBarSeries;
    imgs: TImageList;
    lbRemainCurrency: TLabel;
    lbRemainYear: TLabel;
    lbFilterName: TLabel;
    lbMoveYear: TLabel;
    pnlCapAccounts: TPanel;
    pc: TPageControl;
    pnlCapCurrencies: TPanel;
    pnlCapCategories: TPanel;
    pnlMain: TPanel;
    pnlControl: TPanel;
    pnlAccounts: TPanel;
    pnlCategories: TPanel;
    pnlCurrency: TPanel;
    btSprAccounts: TSpeedButton;
    sgMove: TStringGrid;
    sgMoveTrans: TStringGrid;
    splitMain: TSplitter;
    splitCategory: TSplitter;
    sgTrans: TStringGrid;
    sgAccounts: TStringGrid;
    sgCategories: TStringGrid;
    sgCurrencies: TStringGrid;
    sgRemain: TStringGrid;
    sgYears: TStringGrid;
    splitMove: TSplitter;
    Splitter1: TSplitter;
    spRemain: TSplitter;
    sgRemainDetails: TStringGrid;
    sgMoveDetails: TStringGrid;
    sgMoveChart: TStringGrid;
    sgBudget: TStringGrid;
    tbBudget: TToolBar;
    btBudgetAdd: TToolButton;
    btBudgetDel: TToolButton;
    mi6: TToolButton;
    btBudgetUp: TToolButton;
    btBudgetDown: TToolButton;
    btBudgetEdit: TToolButton;
    ToolButton1: TToolButton;
    btBudgetClearReady: TToolButton;
    tsMoveDetailsGraph: TTabSheet;
    tsMoveDetailsTrans: TTabSheet;
    tsMoveDetailChart: TTabSheet;
    tbMove: TToolBar;
    tb2: TToolButton;
    tb3: TToolButton;
    tbYears: TToolBar;
    tsYears: TTabSheet;
    tbRemain: TToolBar;
    tbFilter: TToolBar;
    btRemainPrev: TToolButton;
    ToolButton10: TToolButton;
    btSave: TToolButton;
    btRemainNext: TToolButton;
    btFilterPrev: TToolButton;
    btFilterNext: TToolButton;
    ToolButton3: TToolButton;
    btTransSimple: TToolButton;
    ToolButton4: TToolButton;
    ToolButton5: TToolButton;
    btTransStart: TToolButton;
    btTransTrans: TToolButton;
    btTransEdit: TToolButton;
    btTransDel: TToolButton;
    tsMain: TTabSheet;
    tsMove: TTabSheet;
    tsRemain: TTabSheet;
    procedure actBudgetAddExecute(Sender: TObject);
    procedure actBudgetClearReadyExecute(Sender: TObject);
    procedure actBudgetClearReadyUpdate(Sender: TObject);
    procedure actBudgetDelExecute(Sender: TObject);
    procedure actBudgetDelUpdate(Sender: TObject);
    procedure actBudgetDownExecute(Sender: TObject);
    procedure actBudgetDownUpdate(Sender: TObject);
    procedure actBudgetEditExecute(Sender: TObject);
    procedure actBudgetUpExecute(Sender: TObject);
    procedure actBudgetUpUpdate(Sender: TObject);
    procedure actFilterNextExecute(Sender: TObject);
    procedure actFilterPrevExecute(Sender: TObject);
    procedure actQuitExecute(Sender: TObject);
    procedure actSaveExecute(Sender: TObject);
    procedure actSaveUpdate(Sender: TObject);
    procedure actSprAccountsExecute(Sender: TObject);
    procedure actSprCategoriesExecute(Sender: TObject);
    procedure actSprCurrenciesExecute(Sender: TObject);
    procedure actsMainUpdate(AAction: TBasicAction; var Handled: Boolean);
    procedure actTransDeleteExecute(Sender: TObject);
    procedure actTransEditExecute(Sender: TObject);
    procedure actTransEditUpdate(Sender: TObject);
    procedure actTransSimpleExecute(Sender: TObject);
    procedure actTransStartExecute(Sender: TObject);
    procedure actTransTransExecute(Sender: TObject);
    procedure btMoveNextClick(Sender: TObject);
    procedure btMovePrevClick(Sender: TObject);
    procedure btRemainNextClick(Sender: TObject);
    procedure btRemainPrevClick(Sender: TObject);
    procedure cbBudgetLineTypeChange(Sender: TObject);
    procedure cbFilterChange(Sender: TObject);
    procedure cbMoveCurrencyChange(Sender: TObject);
    procedure cbRemainCurrencyChange(Sender: TObject);
    procedure cbYearsCurrencyChange(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure lbFilterNameClick(Sender: TObject);
    procedure pcChange(Sender: TObject);
    procedure pnlCapBudgetClick(Sender: TObject);
    procedure pnlControlResize(Sender: TObject);
    procedure pnlMoveResize(Sender: TObject);
    procedure sgAccountsDrawCell(Sender: TObject; aCol, aRow: Integer;
      aRect: TRect; aState: TGridDrawState);
    procedure sgAccountsResize(Sender: TObject);
    procedure sgBudgetDblClick(Sender: TObject);
    procedure sgBudgetDrawCell(Sender: TObject; aCol, aRow: Integer;
      aRect: TRect; aState: TGridDrawState);
    procedure sgBudgetKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure sgCategoriesDrawCell(Sender: TObject; aCol, aRow: Integer;
      aRect: TRect; aState: TGridDrawState);
    procedure sgCurrenciesDrawCell(Sender: TObject; aCol, aRow: Integer;
      aRect: TRect; aState: TGridDrawState);
    procedure sgMoveChartDrawCell(Sender: TObject; aCol, aRow: Integer;
      aRect: TRect; aState: TGridDrawState);
    procedure sgMoveDetailsDrawCell(Sender: TObject; aCol, aRow: Integer;
      aRect: TRect; aState: TGridDrawState);
    procedure sgMoveDrawCell(Sender: TObject; aCol, aRow: Integer;
      aRect: TRect; aState: TGridDrawState);
    procedure sgMoveSelection(Sender: TObject; aCol, aRow: Integer);
    procedure sgMoveTransDblClick(Sender: TObject);
    procedure sgMoveTransDrawCell(Sender: TObject; aCol, aRow: Integer;
      aRect: TRect; aState: TGridDrawState);
    procedure sgRemainDrawCell(Sender: TObject; aCol, aRow: Integer;
      aRect: TRect; aState: TGridDrawState);
    procedure sgRemainSelection(Sender: TObject; aCol, aRow: Integer);
    procedure sgTransDblClick(Sender: TObject);
    procedure sgTransDrawCell(Sender: TObject; aCol, aRow: Integer;
      aRect: TRect; aState: TGridDrawState);
    procedure sgYearsDrawCell(Sender: TObject; aCol, aRow: Integer;
      aRect: TRect; aState: TGridDrawState);
  private
    FBk: TbkData;
    FCal: TbkCalendarData;
    FModified: boolean;
    FDate1: TDate;
    FDate2: TDate;
    FTransIndexes: array of integer;
    FTransDetailIx: array of integer;
    FRemainYear: integer;
    FMoveYear: integer;
    FMonthOperations: array[0..11]of boolean;
    FRemainData: array of TSummaryData;
    FMoveData: array of TSummaryData;
    procedure OnChangeDateHandler();
    procedure OnChangeFilterDateHandler(ADate: TDate);
    procedure UpdateRemainPage();
    procedure UpdateMovePage();
    procedure UpdateYearsPage();
    procedure BuildRemainGraph();
    procedure BuildMoveGraph();
    procedure BuildMoveTransDetails();
    procedure doBudgetAddEdit(AEdit: boolean);
  public
    property Bk: TbkData read FBk;
    property Modified: boolean read FModified write FModified;
    procedure UpdateAccounts;
    procedure UpdateCategories;
    procedure UpdateCurrencies;

    procedure UpdateTransactions();
    procedure UpdateBudget();
    procedure UpdateData();
  end;

var
  fmMainBook: TfmMainBook;

implementation

uses
  dateutils, LCLType,
  bkcalselect,
  bktranssimple, bktransstart, bktranstrans,
  bkspraccounts, bksprcategories, bksprcurrencies, bkbudget;

type
  TPiePair = record
    index: integer;
    value: integer;
  end;
  PPiePair = ^TPiePair;

var
  pieColors: array[0..255] of TColor;

{$R *.lfm}

{ TfmMainBook }

procedure TfmMainBook.pcChange(Sender: TObject);
begin
  if pc.ActivePage = tsRemain then
  begin
    FRemainYear := FCal.Year;
    UpdateRemainPage();
  end
  else if pc.ActivePage = tsMove then
  begin
    FMoveYear := FCal.Year;
    UpdateMovePage();
  end
  else if pc.ActivePage = tsYears then
  begin
    UpdateYearsPage();
  end;
end;

procedure TfmMainBook.pnlCapBudgetClick(Sender: TObject);
begin
  if pnlBudget.Height = pnlCapBudget.Height then
    pnlBudget.Height := pnlMain.Height div 2
  else
    pnlBudget.Height := pnlCapBudget.Height;
end;

procedure TfmMainBook.pnlControlResize(Sender: TObject);
begin
  if pnlControl.Height > 370 then
    pnlAccounts.Height := pnlControl.Height - pnlCurrency.Height - 16 - 220
  else
    pnlAccounts.Height := (pnlControl.Height - pnlCurrency.Height - 16) div 2;
end;

procedure TfmMainBook.pnlMoveResize(Sender: TObject);
begin
  chPie.Width := chPie.Height;
end;

procedure TfmMainBook.sgAccountsDrawCell(Sender: TObject; aCol, aRow: Integer;
  aRect: TRect; aState: TGridDrawState);
begin
  if aRow > 0 then
  begin
    if Pos('[', sgAccounts.Cells[0, aRow]) = 1 then
    begin
      // group
      sgAccounts.Canvas.Brush.Color := clForm;
      sgAccounts.Canvas.Brush.Style := bsSolid;
      sgAccounts.Canvas.Pen.Color := sgAccounts.Canvas.Brush.Color;
      sgAccounts.Canvas.Rectangle(aRect);
      sgAccounts.Canvas.Font.Style := [fsBold];
      sgAccounts.DefaultDrawCell(aCol, aRow, aRect, aState);
    end
    else
    begin
      // simple
      sgAccounts.Canvas.Brush.Style := bsSolid;
      sgAccounts.Canvas.Pen.Color := sgAccounts.Canvas.Brush.Color;
      sgAccounts.Canvas.Rectangle(aRect);
      aRect.Left := aRect.Left + 24;
      sgAccounts.DefaultDrawCell(aCol, aRow, aRect, aState);
    end;
  end;
end;

procedure TfmMainBook.sgAccountsResize(Sender: TObject);
var
  sm, i: integer;
  sg: TStringGrid;
begin
  if not (Sender is TStringGrid) then
    Exit;

  sg := TStringGrid(Sender);

  sm := 0;
  for i := 0 to sg.Columns.Count - 1 do
    sm := sm + sg.Columns[i].Width;

  for i := 0 to sg.Columns.Count - 1 do
    sg.Columns[i].Width := Round((sg.Width - 16) * sg.Columns[i].Width / sm);
end;

procedure TfmMainBook.sgCategoriesDrawCell(Sender: TObject; aCol,
  aRow: Integer; aRect: TRect; aState: TGridDrawState);
begin
  if aRow > 0 then
  begin
    if Pos('[', sgCategories.Cells[0, aRow]) = 1 then
    begin
      // group
      sgCategories.Canvas.Brush.Color := clForm;
      sgCategories.Canvas.Brush.Style := bsSolid;
      sgCategories.Canvas.Pen.Color := sgCategories.Canvas.Brush.Color;
      sgCategories.Canvas.Rectangle(aRect);
      sgCategories.Canvas.Font.Style := [fsBold];
      sgCategories.DefaultDrawCell(aCol, aRow, aRect, aState);
    end
    else
    begin
      // simple
      sgCategories.Canvas.Brush.Style := bsSolid;
      sgCategories.Canvas.Pen.Color := sgCategories.Canvas.Brush.Color;
      sgCategories.Canvas.Rectangle(aRect);
      aRect.Left := aRect.Left + 24;
      sgCategories.DefaultDrawCell(aCol, aRow, aRect, aState);
    end;
  end;
end;

procedure TfmMainBook.sgCurrenciesDrawCell(Sender: TObject; aCol,
  aRow: Integer; aRect: TRect; aState: TGridDrawState);
begin
  if aRow > 0 then
  begin
    Case aRow of
      //1: sgCurrencies.Canvas.Brush.Color := $f0ffff;
      2: sgCurrencies.Canvas.Brush.Color := clForm;
      //3: sgCurrencies.Canvas.Brush.Color := clWhite;
    end;
    sgCurrencies.Canvas.Pen.Color := sgCurrencies.Canvas.Brush.Color;
    sgCurrencies.Canvas.Brush.Style := bsSolid;
    sgCurrencies.Canvas.Rectangle(aRect);
    sgCurrencies.DefaultDrawCell(aCol, aRow, aRect, aState);
  end;
end;

procedure TfmMainBook.sgTransDblClick(Sender: TObject);
begin
  if actTransEdit.Enabled then
    actTransEdit.Execute;
end;

procedure TfmMainBook.sgTransDrawCell(Sender: TObject; aCol, aRow: Integer;
  aRect: TRect; aState: TGridDrawState);
var
  ix: integer;
  tr: TbkTrans;
begin
  if aRow > 0 then
  begin
    if (gdSelected in aState) or (gdFocused in aState) then
      Exit;

    ix := FTransIndexes[ARow];
    tr := TbkTrans(FBk.Trans[ix]);
    Case tr.Typ of
      ttSimple:
        begin
          sgTrans.Canvas.Brush.Color := clDefault;
          if Pos('-', Trim(sgTrans.Cells[aCol, aRow])) = 1 then
            sgTrans.Canvas.Font.Color := clRed
          else
            sgTrans.Canvas.Font.Color := clDefault;
        end;
      ttStart:
        begin
          sgTrans.Canvas.Brush.Color := clGrayText;
          sgTrans.Canvas.Font.Color := clBlack;
        end;
      ttTransfer: sgTrans.Canvas.Brush.Color := clForm;
    end;
    sgTrans.Canvas.Pen.Color := sgTrans.Canvas.Brush.Color;
    sgTrans.Canvas.Brush.Style := bsSolid;
    sgTrans.Canvas.Rectangle(aRect);
    sgTrans.DefaultDrawCell(aCol, aRow, aRect, aState);
  end;
end;

procedure TfmMainBook.UpdateAccounts;
var
  i, j, cnt, irow: integer;
  groupEmpty: boolean;
  grAcc: TbkAccountGroup;
  acc: TbkAccount;
begin
  cnt := FBk.Accounts.Count;
  for i := 0 to FBk.Accounts.Count - 1 do
    cnt += TbkAccountGroup(FBk.Accounts[i]).Accounts.Count;
  sgAccounts.RowCount := 1 + cnt;

  irow := 0;
  for i := 0 to FBk.Accounts.Count - 1 do
  begin
    irow += 1;
    groupEmpty := True;

    grAcc := TbkAccountGroup(FBk.Accounts[i]);
    sgAccounts.Cells[0, irow] := '['+grAcc.Name+']';
    sgAccounts.Cells[1, irow] := '';

    for j := 0 to grAcc.Accounts.Count - 1 do
    begin
      acc := TbkAccount(grAcc.Accounts[j]);
      if acc.InPeriod(FDate1, FDate2) then
      begin
        groupEmpty := False;
        irow += 1;
        sgAccounts.Cells[0, irow] := acc.Name;
        sgAccounts.Cells[1, irow] := FormatValue(acc.Balance);
      end;
    end;
    if groupEmpty then
      irow -= 1;
  end;
  sgAccounts.RowCount := irow+1;
end;

procedure TfmMainBook.UpdateCategories;
var
  i, j, cnt, irow: integer;
  groupEmpty: boolean;
  grCat: TbkCategoryGroup;
  cat: TbkCategory;
begin
  cnt := FBk.Categories.Count;
  for i := 0 to FBk.Categories.Count - 1 do
    cnt += TbkCategoryGroup(FBk.Categories[i]).Categories.Count;
  sgCategories.RowCount := 1 + cnt;

  irow := 0;
  for i := 0 to FBk.Categories.Count - 1 do
  begin
    irow += 1;
    groupEmpty := True;

    grCat := TbkCategoryGroup(FBk.Categories[i]);
    sgCategories.Cells[0, irow] := '['+grCat.Name+']';
    sgCategories.Cells[1, irow] := '';

    for j := 0 to grCat.Categories.Count - 1 do
    begin
      cat := TbkCategory(grCat.Categories[j]);
      if cat.InPeriod(FDate1, FDate2) and (not cat.PaymentEmpty()) then
      begin
        groupEmpty := False;
        irow += 1;
        sgCategories.Cells[0, irow] := cat.Name;
        sgCategories.Cells[1, irow] := cat.PaymentStr();
      end;
    end;
    if groupEmpty then
      irow -= 1;
  end;
  sgCategories.RowCount := irow+1;
end;

procedure TfmMainBook.UpdateCurrencies;
var
  ct: TbkCurrencyTypes;
  i, j, sm, smAll: integer;
  grAcc: TbkAccountGroup;
  acc: TbkAccount;
  cv: TbkCurrencyValues;
begin
  for ct := Low(TbkCurrencyTypes) to High(TbkCurrencyTypes) do
    cv[ct] := 0;
  smAll := 0;
  for ct := Low(TbkCurrencyTypes) to High(TbkCurrencyTypes) do
  begin
    sgCurrencies.Cells[0, ord(ct)+1] := cCurrencyNames[ct];
    sgCurrencies.Cells[1, ord(ct)+1] := FormatValue(FBk.CurrencyValues[ct]);
    sm := 0;
    for i := 0 to FBk.Accounts.Count - 1 do
    begin
      grAcc := TbkAccountGroup(FBk.Accounts[i]);
      for j := 0 to grAcc.Accounts.Count - 1 do
      begin
        acc := TbkAccount(grAcc.Accounts[j]);
        if acc.Currency = ct then
          sm := sm + acc.Balance;
      end;
    end;
    smAll += FBk.CurrencyValues[ct] * sm;
    cv[ct] := FBk.CurrencyValues[ct] * sm;
    sgCurrencies.Cells[2, ord(ct)+1] := FormatValue(sm);
  end;
  // percent
  if smAll > 0 then
  begin
    sm := 0;
    for ct := Low(TbkCurrencyTypes) to High(TbkCurrencyTypes) do
    begin
      if ct <> curRUR then
        sm += Round(100.0 * cv[ct] / smAll);
      cv[ct] := Round(100.0 * cv[ct] / smAll);
    end;
    cv[curRUR] := 100 - sm;
  end;
  for ct := Low(TbkCurrencyTypes) to High(TbkCurrencyTypes) do
    sgCurrencies.Cells[3, ord(ct)+1] := IntToStr(cv[ct]) + '%';

  // total
  for ct := Low(TbkCurrencyTypes) to High(TbkCurrencyTypes) do
    if smAll > 0 then
      sgCurrencies.Cells[4, ord(ct)+1] := FormatValue(smAll / FBk.CurrencyValues[ct])
    else
      sgCurrencies.Cells[4, ord(ct)+1] := '0';
end;

procedure TfmMainBook.UpdateTransactions();
var
  i, irow: integer;
  tr: TbkTrans;
begin
  if Length(FTransIndexes) < FBk.Trans.Count+1 then
    SetLength(FTransIndexes, FBk.Trans.Count+1);
  sgTrans.RowCount := FBk.Trans.Count + 1;
  irow := 0;
  for i := 0 to FBk.Trans.Count - 1 do
  begin
    tr := TbkTrans(FBk.Trans[i]);
    if (FDate1 <= tr.Date) and (tr.Date <= FDate2) then
    begin
      irow += 1;
      Case tr.Typ of
        ttSimple:
          begin
            sgTrans.Cells[0, irow] := DateToStr(tr.Date);
            sgTrans.Cells[1, irow] := tr.Account.Name;
            sgTrans.Cells[2, irow] := FormatValue(tr.Value);
            sgTrans.Cells[3, irow] := tr.Name;
            sgTrans.Cells[4, irow] := tr.Category.Name;
          end;
        ttStart:
          begin
            sgTrans.Cells[0, irow] := DateToStr(tr.Date);
            sgTrans.Cells[1, irow] := tr.Account.Name;
            sgTrans.Cells[2, irow] := FormatValue(tr.Value);
            sgTrans.Cells[3, irow] := '';
            sgTrans.Cells[4, irow] := '';
          end;
        ttTransfer:
          begin
            sgTrans.Cells[0, irow] := DateToStr(tr.Date);
            sgTrans.Cells[1, irow] := tr.Account.Name;
            sgTrans.Cells[2, irow] := FormatValue(tr.Value);
            sgTrans.Cells[3, irow] := '-> ' + tr.Account_to.Name + ' (' + FormatValue(tr.Value_to) + ')';
            sgTrans.Cells[4, irow] := '';
          end;
      end;
      FTransIndexes[irow] := i;
    end;
  end;
  sgTrans.RowCount := irow + 1;
end;

procedure TfmMainBook.UpdateData();
begin
  FBk.UpdateAccountValues(FDate2);
  FBk.UpdateCategoryPayments(FDate1, FDate2);

  UpdateAccounts;
  UpdateCategories;
  UpdateCurrencies;

  UpdateTransactions();
  updateBudget();
end;

procedure TfmMainBook.cbFilterChange(Sender: TObject);
begin
  FDate1 := 0;
  FDate2 := 0;

  OnChangeDateHandler();
end;

procedure TfmMainBook.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  if FModified then
  begin
    if MessageDlg('Подтверждение', 'Данные не сохранены. Сохранить?', mtConfirmation, mbYesNo, 0) = mrYes then
      actSaveExecute(actSave);
  end;
  CloseAction := caFree;
end;

procedure TfmMainBook.OnChangeDateHandler();
begin
  if (Fdate1 <= FCal.Date) and (FCal.Date <= FDate2) then
    Exit;

  if cbFilter.ItemIndex = 0 then
  begin
    // day
    FDate1 := FCal.Date;
    FDate2 := FCal.Date;
    lbFilterName.Caption := DateToStr(FCal.Date);
  end
  else if cbFilter.ItemIndex = 1 then
  begin
    // month
    FDate1 := EncodeDate(FCal.Year, FCal.Month, 1);
    FDate2 := IncDay(IncMonth(FDate1, 1), -1);
    lbFilterName.Caption := Copy(FCal.MonthName,1, 6) + '. ' + IntToStr(FCal.Year);
  end
  else
  begin
    // year
    FDate1 := EncodeDate(FCal.Year, 1, 1);
    FDate2 := IncDay(IncYear(FDate1, 1), -1);
    lbFilterName.Caption := IntToStr(FCal.Year);
  end;

  UpdateData();
end;

procedure TfmMainBook.FormCreate(Sender: TObject);
var
  path: string;
  i: integer;
  ct: TbkCurrencyTypes;
begin
  FormatSettings.ThousandSeparator := ' ';
  path := ExtractFilePath(Application.ExeName);
  FModified := False;
  FBk := TbkData.Create(path + PathDelim + 'abook.data');

  // interface
  pc.ActivePage := tsMain;
  pnlRemains.Height := 360;
  pcMoveDetails.Height := 440;
  pcMoveDetails.ActivePage := tsMoveDetailsGraph;

  FCal := TbkCalendarData.Create();
  FCal.OnChangeDate := @OnChangeDateHandler;
  FCal.Date := Date;

  SetLength(FTransIndexes, 4096);
  SetLength(FTransDetailIx, 4096);
  UpdateData();

  for i := 0 to 255 do
    pieColors[i] := random($ffffff);

  // pages
  rgRemainCurency.Items.Clear;
  for ct := low(cCurrencyNames) to high(cCurrencyNames) do
    rgRemainCurency.Items.Add(cCurrencyNames[ct]);
  rgRemainCurency.ItemIndex := 0;

  sgRemain.Columns[0].Width := 180;
  for i := 0 to High(month_names) do
    with sgRemain.Columns.Add() do
    begin
      Alignment := taRightJustify;
      Title.Caption := month_names[i];
      Title.Alignment := taCenter;
      Title.Font.Style := [fsBold];
      Width := 80;
    end;

  rgMoveCurrency.Items.Clear;
  for ct := low(cCurrencyNames) to high(cCurrencyNames) do
    rgMoveCurrency.Items.Add(cCurrencyNames[ct]);
  rgMoveCurrency.ItemIndex := 0;

  sgMove.Columns[0].Width := 180;
  for i := 0 to High(month_names) do
    with sgMove.Columns.Add() do
    begin
      Alignment := taRightJustify;
      Title.Caption := month_names[i];
      Title.Alignment := taCenter;
      Title.Font.Style := [fsBold];
      Width := 80;
    end;
  with sgMove.Columns.Add() do
  begin
    Alignment := taRightJustify;
    Title.Caption := 'Всего';
    Title.Alignment := taCenter;
    Title.Font.Style := [fsBold];
    Width := 80;
  end;
  with sgMove.Columns.Add() do
  begin
    Alignment := taRightJustify;
    Title.Caption := 'Среднее';
    Title.Alignment := taCenter;
    Title.Font.Style := [fsBold];
    Width := 80;
  end;

  rgYearsCurrency.Items.Clear;
  for ct := low(cCurrencyNames) to high(cCurrencyNames) do
    rgYearsCurrency.Items.Add(cCurrencyNames[ct]);
  rgYearsCurrency.ItemIndex := 0;

  chLabels.Clear;
  for i := 0 to 11 do
  begin
    chLabels.Add(i, i, month_names[i]);
    sgRemainDetails.Cells[0, i+1] := month_names[i];
    sgMoveDetails.Cells[0, i+1] := month_names[i];
  end;
end;

procedure TfmMainBook.FormDestroy(Sender: TObject);
begin
  FBk.Free;
  FTransIndexes := nil;
  FTransDetailIx := nil;
  FRemainData := nil;
  FMoveData := nil;
end;

procedure TfmMainBook.FormShow(Sender: TObject);
begin
  pnlControl.Width := Round(Self.Monitor.WorkareaRect.Width / 1366 * 500);
  pnlBudget.Height := pnlMain.Height div 2; // expanded initially
end;

procedure TfmMainBook.lbFilterNameClick(Sender: TObject);
var
  pt: TPoint;
begin
  pt := lbFilterName.ClientToScreen(Point(0,lbFilterName.Height));
  fmBkCalSelect := TfmBkCalSelect.Create(Application);
  fmBkCalSelect.OnChangeDate := @OnChangeFilterDateHandler;
  fmBkCalSelect.Init(FCal.Date, pt.x, pt.y+2);
  fmBkCalSelect.Show;
end;

procedure TfmMainBook.OnChangeFilterDateHandler(ADate: TDate);
begin
  FCal.Date := ADate;
end;

{$Region 'Actions'}
procedure TfmMainBook.actFilterPrevExecute(Sender: TObject);
begin
  if cbFilter.ItemIndex = 0 then
    // day
    FCal.Date := IncDay(FCal.Date, -1)
  else if cbFilter.ItemIndex = 1 then
    // month
    FCal.Date := IncMonth(FCal.Date, -1)
  else
    // year
    FCal.Date := IncYear(FCal.Date, -1);
end;

procedure TfmMainBook.actQuitExecute(Sender: TObject);
begin
  Close;
end;

procedure TfmMainBook.actFilterNextExecute(Sender: TObject);
begin
  if cbFilter.ItemIndex = 0 then
    // day
    FCal.Date := IncDay(FCal.Date, 1)
  else if cbFilter.ItemIndex = 1 then
    // month
    FCal.Date := IncMonth(FCal.Date, 1)
  else
    // year
    FCal.Date := IncYear(FCal.Date, 1);
end;

procedure TfmMainBook.actSaveExecute(Sender: TObject);
begin
  FBk.Save();
  FModified := False;
end;

procedure TfmMainBook.actSaveUpdate(Sender: TObject);
begin
  (Sender as TAction).Enabled := FModified;
end;

procedure TfmMainBook.actSprAccountsExecute(Sender: TObject);
begin
  fmSprAccounts := TfmSprAccounts.Create(Application);
  fmSprAccounts.Init(FBk);
  fmSprAccounts.ShowModal;
  if fmSprAccounts.IsModified() then
  begin
    FModified := True;
    UpdateData();
  end;
  fmSprAccounts.Free;
end;

procedure TfmMainBook.actSprCategoriesExecute(Sender: TObject);
begin
  fmSprCategories := TfmSprCategories.Create(Application);
  fmSprCategories.Init(FBk);
  fmSprCategories.ShowModal;
  if fmSprCategories.IsModified() then
  begin
    FModified := True;
    UpdateData();
  end;
  fmSprCategories.Free;
end;

procedure TfmMainBook.actSprCurrenciesExecute(Sender: TObject);
var
  ct: TbkCurrencyTypes;
begin
  fmSprCurrencies := TfmSprCurrencies.Create(Application);
  fmSprCurrencies.Init(FBk.CurrencyValues);
  if fmSprCurrencies.ShowModal = mrOK then
  begin
    for ct := low(TbkCurrencyTypes) to high(TbkCurrencyTypes) do
      FBk.CurrencyValues[ct] := fmSprCurrencies.Cur[ct];
    FModified := True;
    UpdateData();
  end;
  fmSprCurrencies.Free;
end;

procedure TfmMainBook.actsMainUpdate(AAction: TBasicAction; var Handled: Boolean);
begin
  if pc.ActivePage <> tsMain then
  begin
    (AAction as TAction).Enabled := False;
    Handled := True;
  end;
end;

procedure TfmMainBook.actTransDeleteExecute(Sender: TObject);
var
  ix: integer;
  tr: TbkTrans;
begin
  if MessageDlg('Подтверждение', 'Удалить выбранную транзакцию?', mtConfirmation, [mbYes, mbNo], 0) = mrYes then
  begin
    // find desired transaction
    ix := FTransIndexes[sgTrans.Row];
    tr := TbkTrans(FBk.Trans[ix]);
    tr.Free;
    FBk.Trans.Delete(ix);

    FModified := True;
    UpdateData();
  end;
end;

procedure TfmMainBook.actTransEditExecute(Sender: TObject);
var
  ix: integer;
  tr: TbkTrans;
  dateChanged, transChanged: boolean;
begin
  ix := FTransIndexes[sgTrans.Row];
  tr := TbkTrans(FBk.Trans[ix]);
  dateChanged := False;
  transChanged := False;
  case tr.Typ of
    ttSimple:
      begin
        fmTransSimple := TfmTransSimple.Create(Application);
        fmTransSimple.Init(FCal.Date, FBk, tr);
        if fmTransSimple.ShowModal = mrOK then
        begin
          dateChanged := tr.Date <> fmTransSimple.edDate.Date;
          transChanged := fmTransSimple.Modified();

          tr.Date := fmTransSimple.edDate.Date;
          tr.Account := fmTransSimple.Account();
          tr.Value := StrToInt(fmTransSimple.edValue.Text);
          tr.Name := fmTransSimple.edName.Text;
          tr.Category := fmTransSimple.Category();
        end;
        fmTransSimple.Free;
      end;
    ttStart:
      begin
        fmTransStart := TfmTransStart.Create(Application);
        fmTransStart.Init(Fcal.Date, FBk, tr);
        if fmTransStart.ShowModal = mrOK then
        begin
          dateChanged := tr.Date <> fmTransStart.edDate.Date;
          transChanged := fmTransStart.Modified();

          tr.Date := fmTransStart.edDate.Date;
          tr.Account := fmTransStart.Account();
          tr.Value := StrToInt(fmTransStart.edValue.Text);
        end;
        fmTransStart.Free;
      end;
    ttTransfer:
      begin
        fmTransTrans := TfmTransTrans.Create(Application);
        fmTransTrans.Init(FCal.Date, FBk, tr);
        if fmTransTrans.ShowModal = mrOK then
        begin
          dateChanged := tr.Date <> fmTransTrans.edDate.Date;
          transChanged := fmTransTrans.Modified();

          tr.Date := fmTransTrans.edDate.Date;
          tr.Account := fmTransTrans.AccountFrom();
          tr.Value := fmTransTrans.ValueFrom();
          tr.Account_to := fmTransTrans.AccountTo();
          tr.Value_to := fmTransTrans.ValueTo();
        end;
        fmTransTrans.Free;
      end;
  end;

  FModified := FModified or transChanged;
  if dateChanged then
    FBk.MoveTrans(ix, tr);
  if transChanged then
    UpdateData();
end;

procedure TfmMainBook.actTransEditUpdate(Sender: TObject);
begin
  (Sender as TAction).Enabled := sgTrans.Focused and (sgTrans.Row > 0);
end;

procedure TfmMainBook.actTransSimpleExecute(Sender: TObject);
var
  tr: TbkTrans;
begin
  fmTransSimple := TfmTransSimple.Create(Application);
  fmTransSimple.Init(FCal.Date, FBk, nil);
  if fmTransSimple.ShowModal = mrOK then
  begin
    tr := TbkTrans.Create();
    tr.Typ := ttSimple;
    tr.Date := fmTransSimple.edDate.Date;
    tr.Account := fmTransSimple.Account();
    tr.Value := StrToInt(fmTransSimple.edValue.Text);
    tr.Name := fmTransSimple.edName.Text;
    tr.Category := fmTransSimple.Category();

    FBk.InsertTrans(tr);
    FModified := True;
    UpdateData();
  end;
  fmTransSimple.Free;
end;

procedure TfmMainBook.actTransStartExecute(Sender: TObject);
var
  tr: TbkTrans;
begin
  fmTransStart := TfmTransStart.Create(Application);
  fmTransStart.Init(Fcal.Date, FBk, nil);
  if fmTransStart.ShowModal = mrOK then
  begin
    tr := TbkTrans.Create();
    tr.Typ := ttStart;
    tr.Date := fmTransStart.edDate.Date;
    tr.Account := fmTransStart.Account();
    tr.Value := StrToInt(fmTransStart.edValue.Text);

    FBk.InsertTrans(tr);
    FModified := True;
    UpdateData();
  end;
  fmTransStart.Free;
end;

procedure TfmMainBook.actTransTransExecute(Sender: TObject);
var
  tr: TbkTrans;
begin
  fmTransTrans := TfmTransTrans.Create(Application);
  fmTransTrans.Init(FCal.Date, FBk, nil);
  if fmTransTrans.ShowModal = mrOK then
  begin
    tr := TbkTrans.Create();
    tr.Typ := ttTransfer;

    tr.Date := fmTransTrans.edDate.Date;
    tr.Account := fmTransTrans.AccountFrom();
    tr.Value := fmTransTrans.ValueFrom();
    tr.Account_to := fmTransTrans.AccountTo();
    tr.Value_to := fmTransTrans.ValueTo();

    FBk.InsertTrans(tr);
    FModified := True;
    UpdateData();
  end;
  fmTransTrans.Free;
end;

{$EndRegion}

{$Region 'Остатки на счетах'}
procedure TfmMainBook.sgRemainSelection(Sender: TObject; aCol, aRow: Integer);
begin
  BuildRemainGraph();
end;

procedure TfmMainBook.btRemainPrevClick(Sender: TObject);
begin
  FRemainYear := FRemainYear - 1;
  UpdateRemainPage();
end;

procedure TfmMainBook.cbBudgetLineTypeChange(Sender: TObject);
begin

end;

procedure TfmMainBook.btRemainNextClick(Sender: TObject);
begin
  FRemainYear := FRemainYear + 1;
  UpdateRemainPage();
end;

procedure TfmMainBook.sgRemainDrawCell(Sender: TObject; aCol, aRow: Integer;
  aRect: TRect; aState: TGridDrawState);
begin
  if aRow > 0 then
  begin
    if (aRow = 1) or (Pos('[', sgRemain.Cells[0, aRow]) = 1) then
    begin
      // group
      if not ((gdSelected in aState) or (gdFocused in aState)) then
      begin
        if aRow = 1 then
        begin
          sgRemain.Canvas.Brush.Color := clGrayText;
          sgRemain.Canvas.Font.Color := clBlack;
        end
        else
          sgRemain.Canvas.Brush.Color := clForm;
      end;
      sgRemain.Canvas.Brush.Style := bsSolid;
      sgRemain.Canvas.Pen.Color := sgRemain.Canvas.Brush.Color;
      sgRemain.Canvas.Rectangle(aRect);
      sgRemain.Canvas.Font.Style := [fsBold];
      sgRemain.DefaultDrawCell(aCol, aRow, aRect, aState);
    end
    else
    begin
      // simple
      sgRemain.Canvas.Brush.Style := bsSolid;
      sgRemain.Canvas.Pen.Color := sgRemain.Canvas.Brush.Color;
      sgRemain.Canvas.Rectangle(aRect);
      aRect.Left := aRect.Left + 24;
      sgRemain.DefaultDrawCell(aCol, aRow, aRect, aState);
    end;
  end;
end;

procedure TfmMainBook.UpdateRemainPage();
  function _buildBalance(AGroup: TbkAccountGroup; AValue: integer; ACurrency: TbkCurrencyTypes): string;
  var
    i, j: integer;
    gr: TbkAccountGroup;
    isExists: boolean;
  begin
    Result := '';
    isExists := False;
    if AGroup = nil then
    begin
      for i := 0 to FBk.Accounts.Count - 1 do
      begin
        gr := TbkAccountGroup(FBk.Accounts[i]);
        for j := 0 to gr.Accounts.Count - 1 do
          if TbkAccount(gr.Accounts[j]).Currency = ACurrency then
          begin
            isExists := True;
            break;
          end;
        if isExists then
          break;
      end;
    end
    else
      for i := 0 to AGroup.Accounts.Count - 1 do
        if TbkAccount(AGroup.Accounts[i]).Currency = ACurrency then
        begin
          isExists := True;
          break;
        end;
    if isExists then
      Result := FormatValue(AValue);
  end;

var
  i, j, cnt, irow: integer;
  groupEmpty: boolean;
  grAcc: TbkAccountGroup;
  acc: TbkAccount;
  d1, d2, dstart, dfinish: TDate;
  ct: TbkCurrencyTypes;
begin
  lbRemainYear.Caption := IntToStr(FRemainYear);

  dstart := EncodeDate(FRemainYear, 1, 1);
  dfinish := EncodeDate(FRemainYear, 12, 31);

  cnt := FBk.Accounts.Count;
  for i := 0 to FBk.Accounts.Count - 1 do
    cnt += TbkAccountGroup(FBk.Accounts[i]).Accounts.Count;
  SetLength(FRemainData, cnt+1);

  // get only active with selected currency
  ct := TbkCurrencyTypes(rgRemainCurency.ItemIndex);
  irow := 0;
  FRemainData[irow].data := nil;
  FRemainData[irow].group := true;
  for i := 0 to FBk.Accounts.Count - 1 do
  begin
    irow += 1;
    groupEmpty := True;

    grAcc := TbkAccountGroup(FBk.Accounts[i]);
    FRemainData[irow].group := true;
    FRemainData[irow].data := grAcc;

    for j := 0 to grAcc.Accounts.Count - 1 do
    begin
      acc := TbkAccount(grAcc.Accounts[j]);
      if acc.InPeriod(dstart, dfinish) and (acc.Currency = ct) then
      begin
        groupEmpty := False;
        irow += 1;
        FRemainData[irow].group := false;
        FRemainData[irow].data := acc;
      end;
    end;
    if groupEmpty then
      irow -= 1;
  end;
  SetLength(FRemainData, irow+1);

  // fill data
  for i := 0 to 11 do
  begin
    // for each month
    d1 := EncodeDate(FRemainYear, i+1, 1);
    d2 := IncDay(IncMonth(d1), -1);

    FMonthOperations[i] := FBk.ExistsMonthOperations(d1, d2);

    FBk.UpdateAccountValues(d2);
    FRemainData[0].values[i] := 0;
    for j := 1 to High(FRemainData) do
      if FRemainData[j].group then
      begin
        grAcc := TbkAccountGroup(FRemainData[j].data);
        FRemainData[j].values[i] := grAcc.Balance(ct);
        FRemainData[0].values[i] := FRemainData[0].values[i] + FRemainData[j].values[i];
      end
      else
      begin
        acc := TbkAccount(FRemainData[j].data);
        FRemainData[j].values[i] := acc.Balance;
      end;
  end;

  // fill grid
  sgRemain.RowCount := 1 + Length(FRemainData);
  for i := 0 to High(FRemainData) do
    if FRemainData[i].data = nil then
    begin
      sgRemain.Cells[0, i+1] := 'Всего';
      for j := 0 to 11 do
        if FMonthOperations[j] then
          sgRemain.Cells[1+j, i+1] := _buildBalance(nil, FRemainData[i].values[j], ct)
        else
          sgRemain.Cells[1+j, i+1] := '';
    end
    else if FRemainData[i].group then
    begin
      grAcc := TbkAccountGroup(FRemainData[i].data);
      sgRemain.Cells[0, i+1] := '['+grAcc.Name+']';
      for j := 0 to 11 do
        if FMonthOperations[j] then
          sgRemain.Cells[1+j, i+1] := _buildBalance(grAcc, FRemainData[i].values[j], ct)
        else
          sgRemain.Cells[1+j, i+1] := '';
    end
    else
    begin
      acc := TbkAccount(FRemainData[i].data);
      sgRemain.Cells[0, i+1] := acc.Name;
      for j := 0 to 11 do
        if FMonthOperations[j] then
          sgRemain.Cells[1+j, i+1] := FormatValue(FRemainData[i].values[j])
        else
          sgRemain.Cells[1+j, i+1] := '';
    end;

  BuildRemainGraph();
end;

procedure TfmMainBook.BuildRemainGraph();
var
  irow, i, sm: integer;
begin
  irow := sgRemain.Row-1;
  chRemain.Title.Text.Text := sgRemain.Cells[0, sgRemain.Row];
  chRemain.AxisList[0].Title.Caption := 'Сумма, ' + cCurrencyNames[TbkCurrencyTypes(rgRemainCurency.ItemIndex)];
  sgRemainDetails.Columns[1].Title.Caption := 'Сумма, ' + cCurrencyNames[TbkCurrencyTypes(rgRemainCurency.ItemIndex)];
  serRemain.Clear;
  for i := 0 to 11 do
  begin
    if FMonthOperations[i] then
    begin
      sm := FRemainData[irow].values[i];
      if sm > 0 then
        serRemain.AddXY(i, sm);
      sgRemainDetails.Cells[1, i+1] := FormatValue(sm);
    end
    else
    begin
      //serRemain.AddXY(i, 0);
      sgRemainDetails.Cells[1, i+1] := '';
    end;
  end;
end;

procedure TfmMainBook.cbRemainCurrencyChange(Sender: TObject);
begin
  if pc.ActivePage = tsRemain then
    UpdateRemainPage();
end;

{$EndRegion}

{$Region 'Расходы и приходы'}
procedure TfmMainBook.btMoveNextClick(Sender: TObject);
begin
  FMoveYear := FMoveYear + 1;
  UpdateMovePage();
end;

procedure TfmMainBook.btMovePrevClick(Sender: TObject);
begin
  FMoveYear := FMoveYear - 1;
  UpdateMovePage();
end;

procedure TfmMainBook.sgMoveSelection(Sender: TObject; aCol, aRow: Integer);
begin
  BuildMoveGraph();
  BuildMoveTransDetails();
  UpdateMovePage();
end;

procedure TfmMainBook.sgMoveTransDblClick(Sender: TObject);
var
  dt: TDate;
  ix, i: integer;
begin
  if (sgMoveTrans.Row > 0) and (sgMoveTrans.Row < sgMoveTrans.RowCount) then
  begin
    ix := FTransDetailIx[sgMoveTrans.Row];
    dt := StrToDate(sgMoveTrans.Cells[0, sgMoveTrans.Row]);
    pc.ActivePage := tsMain;
    FCal.Date := dt;

    for i := 1 to sgTrans.RowCount - 1 do
      if ix = FTransIndexes[i] then
      begin
        sgTrans.Row := i;
        break;
      end;
  end;
end;

procedure TfmMainBook.sgMoveTransDrawCell(Sender: TObject; aCol, aRow: Integer;
  aRect: TRect; aState: TGridDrawState);
begin
  if aRow > 0 then
  begin
    if (gdSelected in aState) or (gdFocused in aState) then
      Exit;

    if Pos('-', Trim(sgMoveTrans.Cells[aCol, aRow])) = 1 then
      sgMoveTrans.Canvas.Font.Color := clRed;

    sgMoveTrans.Canvas.Pen.Color := sgMoveTrans.Canvas.Brush.Color;
    sgMoveTrans.Canvas.Brush.Style := bsSolid;
    sgMoveTrans.Canvas.Rectangle(aRect);
    sgMoveTrans.DefaultDrawCell(aCol, aRow, aRect, aState);
  end;
end;

procedure TfmMainBook.sgMoveDrawCell(Sender: TObject; aCol, aRow: Integer;
  aRect: TRect; aState: TGridDrawState);
var
  group, colSum, colAvg: boolean;
begin
  if aRow > 0 then
  begin
    group := (aRow in [1, 2]) or (Pos('[', sgMove.Cells[0, aRow]) = 1);
    colSum := aCol = 13;
    colAvg := aCol = 14;

    if not ((gdSelected in aState) or (gdFocused in aState)) then
    begin
      if aRow in [1, 2] then
      begin
        sgMove.Canvas.Brush.Color := clGrayText;
        sgMove.Canvas.Font.Color := clBlack;
      end
      else if colSum then
        sgMove.Canvas.Brush.Color := clForm
      else if colAvg then
      begin
        sgMove.Canvas.Brush.Color := clGrayText;
        sgMove.Canvas.Font.Color := clBlack;
      end
      else if group then
        sgMove.Canvas.Brush.Color := clForm;

      if (aRow = 1) and (aCol > 0) then
        sgMove.Canvas.Font.Color := clBlue;
      if (aRow = 2) and (aCol > 0) then
        sgMove.Canvas.Font.Color := clMaroon;
    end;

    if (gdFocused in aState)// ((aRow = sgMove.Row) and (aCol = sgMove.Col)) //or
//       ((aRow <> sgMove.Row) and (aCol = sgMove.Col))
    then
    begin
      sgMove.Canvas.Brush.Color := clDefault;
      sgMove.Canvas.Font.Color := clDefault;
    end;

    sgMove.Canvas.Brush.Style := bsSolid;
    sgMove.Canvas.Pen.Color := sgMove.Canvas.Brush.Color;
    sgMove.Canvas.Rectangle(aRect);

    if group then
      sgMove.Canvas.Font.Style := [fsBold];

    if (aCol = 0) and (not group) then
      aRect.Left := aRect.Left + 24;

    sgMove.DefaultDrawCell(aCol, aRow, aRect, aState);
  end;
end;

procedure TfmMainBook.sgMoveDetailsDrawCell(Sender: TObject; aCol,
  aRow: Integer; aRect: TRect; aState: TGridDrawState);
begin
  if aRow = 13 then
  begin
    sgMoveDetails.Canvas.Font.Style := [fsBold];
    sgMoveDetails.Canvas.Brush.Style := bsSolid;
    sgMoveDetails.Canvas.Brush.Color := clForm;
    sgMoveDetails.Canvas.Pen.Color := sgMove.Canvas.Brush.Color;
    sgMoveDetails.Canvas.Rectangle(aRect);
    sgMoveDetails.DefaultDrawCell(aCol, aRow, aRect, aState);
  end;
end;

procedure TfmMainBook.BuildMoveGraph();
var
  irow, i, sm, smm: integer;
begin
  irow := sgMove.Row-1;
  chMove.Title.Text.Text := sgMove.Cells[0, sgMove.Row];
  chMove.AxisList[0].Title.Caption := 'Сумма, ' + cCurrencyNames[TbkCurrencyTypes(rgMoveCurrency.ItemIndex)];
  sgMoveDetails.Columns[1].Title.Caption := 'Сумма, ' + cCurrencyNames[TbkCurrencyTypes(rgMoveCurrency.ItemIndex)];
  serMove.Clear;
  smm := 0;
  for i := 0 to 11 do
  begin
    if FMonthOperations[i] then
    begin
      sm := FMoveData[irow].values[i];
      if sm > 0 then
        serMove.AddXY(i, sm);
      sgMoveDetails.Cells[1, i+1] := FormatValue(sm);
      smm := smm + sm;
    end
    else
    begin
      //serMove.AddXY(i, 0);
      sgMoveDetails.Cells[1, i+1] := '';
    end;
  end;
  sgMoveDetails.Cells[0, 13] := 'Всего:';
  sgMoveDetails.Cells[1, 13] := FormatValue(smm);
end;

procedure TfmMainBook.sgMoveChartDrawCell(Sender: TObject; aCol, aRow: Integer;
  aRect: TRect; aState: TGridDrawState);
var
  sg: TStringGrid;
begin
  sg := nil;
  if Sender is TStringGrid then
    sg := TStringGrid(Sender);
  if sg = nil then
    Exit;

  if aRow = sg.RowCount-1 then
  begin
    sg.Canvas.Font.Style := [fsBold];
    sg.Canvas.Brush.Style := bsSolid;
    sg.Canvas.Brush.Color := clForm;
    sg.Canvas.Pen.Color := sgMove.Canvas.Brush.Color;
    sg.Canvas.Rectangle(aRect);
    sg.DefaultDrawCell(aCol, aRow, aRect, aState);
  end;

end;

function Cmp(Item1, Item2: Pointer): Integer;
begin
  Result := PPiePair(Item2)^.value - PPiePair(Item1)^.value;
end;

procedure TfmMainBook.UpdateMovePage();
var
  i, j, cnt, irow, sum, avg, pval: integer;
  groupEmpty: boolean;
  grCat: TbkCategoryGroup;
  cat: TbkCategory;
  d1, d2, dstart, dfinish: TDate;
  ct: TbkCurrencyTypes;
  pieSrc: TFPList;
  p: PPiePair;
begin
  lbMoveYear.Caption := IntToStr(FMoveYear);

  dstart := EncodeDate(FMoveYear, 1, 1);
  dfinish := EncodeDate(FMoveYear, 12, 31);

  cnt := FBk.Categories.Count;
  for i := 0 to FBk.Categories.Count - 1 do
    cnt += TbkCategoryGroup(FBk.Categories[i]).Categories.Count;
  SetLength(FMoveData, cnt+2);

  // get only active
  ct := TbkCurrencyTypes(rgMoveCurrency.ItemIndex);
  irow := 0;
  FMoveData[irow].data := nil;
  FMoveData[irow].group := true;
  irow := 1;
  FMoveData[irow].data := nil;
  FMoveData[irow].group := true;
  for i := 0 to FBk.Categories.Count - 1 do
  begin
    irow += 1;
    groupEmpty := True;

    grCat := TbkCategoryGroup(FBk.Categories[i]);
    FMoveData[irow].group := true;
    FMoveData[irow].data := grCat;

    for j := 0 to grCat.Categories.Count - 1 do
    begin
      cat := TbkCategory(grCat.Categories[j]);
      if cat.InPeriod(dstart, dfinish) then
      begin
        groupEmpty := False;
        irow += 1;
        FMoveData[irow].group := false;
        FMoveData[irow].data := cat;
      end;
    end;
    if groupEmpty then
      irow -= 1;
  end;
  SetLength(FMoveData, irow+1);

  // fill data
  for i := 0 to 11 do
  begin
    // for each month
    d1 := EncodeDate(FMoveYear, i+1, 1);
    d2 := IncDay(IncMonth(d1), -1);

    FMonthOperations[i] := FBk.ExistsMonthOperations(d1, d2);

    FBk.UpdateCategoryPayments(d1, d2);
    FMoveData[0].values[i] := 0;
    FMoveData[1].values[i] := 0;
    for j := 2 to High(FMoveData) do
      if FMoveData[j].group then
      begin
        grCat := TbkCategoryGroup(FMoveData[j].data);
        FMoveData[j].values[i] := grCat.Payment(ct);
        if Pos('Доход', grCat.Name) = 1 then
          FMoveData[0].values[i] := FMoveData[0].values[i] + FMoveData[j].values[i]
        else
          FMoveData[1].values[i] := FMoveData[1].values[i] + FMoveData[j].values[i];
      end
      else
        FMoveData[j].values[i] := TbkCategory(FMoveData[j].data).Payment(ct);
  end;

  // fill grid
  cnt := 0;
  for i := 0 to High(FMonthOperations) do
    if FMonthOperations[i] then
      cnt += 1;

  serPie.Clear;
  pieSrc := TFPList.Create();
  try
    ct := TbkCurrencyTypes(rgMoveCurrency.ItemIndex);
    sgMove.RowCount := 1 + Length(FMoveData);
    for i := 0 to High(FMoveData) do
    begin
      if i = 0 then
        sgMove.Cells[0, i+1] := 'Всего доходов'
      else if i = 1 then
        sgMove.Cells[0, i+1] := 'Всего расходов'
      else if FMoveData[i].group then
        sgMove.Cells[0, i+1] := '['+TbkCategoryGroup(FMoveData[i].data).Name + ']'
      else
        sgMove.Cells[0, i+1] := TbkCategory(FMoveData[i].data).Name;
      sum := 0;
      for j := 0 to 11 do
        if FMonthOperations[j] then
        begin
          sgMove.Cells[1+j, i+1] := FormatValue(FMoveData[i].values[j]);
          sum += FMoveData[i].values[j];
        end
        else
          sgMove.Cells[1+j, i+1] := '';
      avg := 0;
      if cnt > 0 then
        avg := Round(sum/cnt);
      sgMove.Cells[13, i+1] := FormatValue(sum);
      sgMove.Cells[14, i+1] := FormatValue(avg);
      if (not FMoveData[i].group) and (sum > 0) then
        if Pos('Доход', TbkCategory(FMoveData[i].data).Group.Name) = 0 then
        begin
          if (sgMove.Col >= 1) and (sgMove.Col <= 12) then
          begin
            if FMonthOperations[sgMove.Col-1] then
            begin
              Getmem(p, sizeof(TPiePair));
              p^.index := i+1;
              p^.value := FMoveData[i].values[sgMove.Col-1];
              pieSrc.Add(p);
            end;
          end
          else if sgMove.Col in [0, 13] then
          begin
            Getmem(p, sizeof(TPiePair));
            p^.index := i+1;
            p^.value := sum;
            pieSrc.Add(p);
          end
          else if sgMove.Col = 14 then
          begin
            Getmem(p, sizeof(TPiePair));
            p^.index := i+1;
            p^.value := avg;
            pieSrc.Add(p);
          end;
        end;
    end;

    pieSrc.Sort(@Cmp);
    for i := 0 to pieSrc.Count - 1 do
    begin
      pval := PPiePair(pieSrc[i])^.value;
      if pval > 0 then
        serPie.AddPie(pval, sgMove.Cells[0, PPiePair(pieSrc[i])^.index], pieColors[i]);
    end;
  finally
    for i := 0 to pieSrc.Count - 1 do
      Freemem(pieSrc[i], SizeOf(TPiePair));
    pieSrc.Free;
  end;

  cnt := 0;
  sum := 0;
  for i := 0 to serPie.Count - 1 do
    if serPie.YValue[i] > 0 then
    begin
      cnt := cnt + 1;
      sum := sum + Round(serPie.YValue[i]);
    end;
  sgMoveChart.RowCount := cnt+2;
  cnt := 0;
  for i := 0 to serPie.Count - 1 do
    if serPie.YValue[i] > 0 then
    begin
      sgMoveChart.Cells[0, cnt+1] := serPie.ListSource.Item[i]^.Text;
      sgMoveChart.Cells[1, cnt+1] := FormatValue(serPie.YValue[i]);
      sgMoveChart.Cells[2, cnt+1] := FormatValue(100*serPie.YValue[i]/sum);
      cnt := cnt + 1;
    end;
  sgMoveChart.Cells[0, sgMoveChart.RowCount-1] := 'Сумма';
  sgMoveChart.Cells[1, sgMoveChart.RowCount-1] := FormatValue(sum);
  sgMoveChart.Cells[2, sgMoveChart.RowCount-1] := '100';
  BuildMoveGraph();
  BuildMoveTransDetails();
end;

procedure TfmMainBook.BuildMoveTransDetails();
  function checkTrans(ATrans: TbkTrans; ACat: TbkCategory; AGroup: TbkCategoryGroup; Aindex: integer): boolean;
  begin
    Result := False;
    if AIndex = 1 then
      Result := ATrans.Value > 0
    else if Aindex = 2 then
      Result := ATrans.Value < 0
    else if AGroup <> nil then
      Result := ATrans.Category.Group = AGroup
    else if ACat <> nil then
      Result := ATrans.Category = ACat;
  end;
var
  i, irow: integer;
  tr: TbkTrans;
  d1, d2 : TDate;
  cur: TbkCurrencyTypes;
  cat: TbkCategory;
  grCat: TbkCategoryGroup;
begin
  if (sgMove.Col > 12) or (sgMove.Col = 0) then
  begin
    // full year
    d1 := EncodeDate(FMoveYear, 1, 1);
    d2 := EncodeDate(FMoveYear, 12, 31);
  end
  else
  begin
    // selected month
    d1 := EncodeDate(FMoveYear, sgMove.Col, 1);
    d2 := IncDay(IncMonth(d1), -1);
  end;

  cat := nil;
  grCat := nil;
  irow := sgMove.Row - 1;
  if irow > 1 then
  begin
    if FMoveData[irow].group then
      grCat := TbkCategoryGroup(FMoveData[irow].data)
    else
      cat := TbkCategory(FMoveData[irow].data);
  end;

  cur := TbkCurrencyTypes(rgMoveCurrency.ItemIndex);

  if Length(FTransDetailIx) < FBk.Trans.Count+1 then
    SetLength(FTransDetailIx, FBk.Trans.Count+1);
  sgMoveTrans.RowCount := FBk.Trans.Count + 1;
  irow := 0;
  for i := 0 to FBk.Trans.Count - 1 do
  begin
    tr := TbkTrans(FBk.Trans[i]);
    if (d1 <= tr.Date) and (tr.Date <= d2) then
      if tr.Typ  = ttSimple then
        if tr.Account.Currency = cur then
          if checkTrans(tr, cat, grCat, sgMove.Row) then
          begin
            irow += 1;
            sgMoveTrans.Cells[0, irow] := DateToStr(tr.Date);
            sgMoveTrans.Cells[1, irow] := tr.Account.Name;
            sgMoveTrans.Cells[2, irow] := FormatValue(tr.Value);
            sgMoveTrans.Cells[3, irow] := tr.Name;
            sgMoveTrans.Cells[4, irow] := tr.Category.Name;
            FTransDetailIx[irow] := i;
          end;
  end;
  sgMoveTrans.RowCount := irow + 1;
end;

procedure TfmMainBook.cbMoveCurrencyChange(Sender: TObject);
begin
  if pc.ActivePage = tsMove then
    UpdateMovePage();
end;
{$EndRegion}

{$Region 'Years data'}
procedure TfmMainBook.sgYearsDrawCell(Sender: TObject; aCol, aRow: Integer;
  aRect: TRect; aState: TGridDrawState);
begin
  if aRow > 0 then
  begin
    if aRow = 1 then
      sgYears.Canvas.Font.Style := [fsBold];

    if (not (gdSelected in aState)) and (not (gdFocused in aState)) then
    begin
      if aRow = 1 then
        sgYears.Canvas.Brush.Color := clForm;

      if aCol in [1, 3] then
        sgYears.Canvas.Font.Color := clBtnText;
      if aCol in [2, 4] then
        sgYears.Canvas.Font.Color := clRed;
      if aCol in [5, 6] then
      begin
        if Pos('-', Trim(sgYears.Cells[aCol, aRow])) = 1 then
          sgYears.Canvas.Font.Color := clRed
        else
          sgYears.Canvas.Font.Color := clBtnText;
      end;

      sgYears.Canvas.Brush.Style := bsSolid;
      sgYears.Canvas.Pen.Color := sgYears.Canvas.Brush.Color;
      sgYears.Canvas.Rectangle(aRect);
    end;
    sgYears.DefaultDrawCell(aCol, aRow, aRect, aState);
  end;
end;

procedure TfmMainBook.UpdateYearsPage();
var
  i, y1, y2: integer;
  num, sm, payIn, payOut: integer;
  incomes: array of integer;
  outcomes: array of integer;
  ct: TbkCurrencyTypes;
begin
  num := 1;
  y1 := 0;
  y2 := 0;
  SetLength(incomes, num);
  SetLength(outcomes, num);
  incomes[0] := 0;
  outcomes[0] := 0;
  ct := TbkCurrencyTypes(rgYearsCurrency.ItemIndex);
  if FBk.Trans.Count > 0 then
  begin
    y1 := YearOf(TbkTrans(FBk.Trans.First).Date);
    y2 := YearOf(TbkTrans(FBk.Trans.Last).Date);
    num := y2-y1 + 2;
    SetLength(incomes, num);
    SetLength(outcomes, num);

    for i := 1 to num-1 do
    begin
      FBk.YearPayData(y1+i-1, ct, payIn, payOut);

      incomes[i] := payIn;
      outcomes[i] := Abs(payOut);

      incomes[0] := incomes[0] + payIn;
      outcomes[0] := outcomes[0] + Abs(payOut);
    end;
  end;

  sgYears.RowCount := num + 1;
  sm := 0;
  for i := 0 to num-1 do
  begin
    if i = 0 then
      sgYears.Cells[0, i+1] := 'Итого:'
    else
      sgYears.Cells[0, i+1] := IntToStr(y1+i-1);

    sgYears.Cells[1, i+1] := FormatValue(incomes[i]);
    sgYears.Cells[2, i+1] := FormatValue(outcomes[i]);

    sgYears.Cells[3, i+1] := FormatValue(incomes[i]/12);
    sgYears.Cells[4, i+1] := FormatValue(outcomes[i]/12);

    sgYears.Cells[5, i+1] := FormatValue(incomes[i]-outcomes[i]);
    sgYears.Cells[6, i+1] := FormatValue((incomes[i]-outcomes[i])/12);

    if i = 0 then
      sgYears.Cells[7, i+1] := ''
    else
    begin
      sm := sm + incomes[i];
      sgYears.Cells[7, i+1] := FormatValue(sm/i);
    end;
  end;
end;

procedure TfmMainBook.cbYearsCurrencyChange(Sender: TObject);
begin
  if pc.ActivePage = tsYears then
    UpdateYearsPage();
end;

{$EndRegion}

{$Region 'Budget'}
procedure TfmMainBook.updateBudget();
var
  i, oldRow: integer;
  bl: TbkBudgetLine;
begin
  oldRow := sgBudget.Row;
  sgBudget.RowCount := FBk.Budget.Count + 1;
  if (oldRow > 0) and (oldRow < sgBudget.RowCount) then
    sgBudget.Row := oldRow;

  for i := 0 to FBk.Budget.Count - 1 do
  begin
    bl := TbkBudgetLine(FBk.Budget[i]);
    sgBudget.Cells[0, i+1] := bl.Name;
    sgBudget.Cells[1, i+1] := IntToStr(bl.Value);
  end;
  sgBudget.Refresh;
end;

procedure TfmMainBook.doBudgetAddEdit(AEdit: boolean);
var
  bl: TbkBudgetLine;
begin
  bl := nil;
  if AEdit then
    bl := TbkBudgetLine(FBk.Budget[sgBudget.Row-1]);

  fmBudget := TfmBudget.Create(Application);
  fmBudget.Init(bl);
  if fmBudget.ShowModal = mrOK then
  begin
    if not AEdit then
    begin
      bl := TbkBudgetLine.Create();
      FBk.Budget.Add(bl);
    end;
    bl.Name := fmBudget.BL.Name;
    bl.Value := fmBudget.BL.Value;
    bl.Typ := fmBudget.BL.Typ;
    bl.Ready := fmBudget.BL.Ready;
    bl.ReadyValue := fmBudget.BL.ReadyValue;

    FModified := True;
    UpdateBudget();
    if not AEdit then
      sgBudget.Row := sgBudget.RowCount-1;
  end;
  fmBudget.Free;
end;

procedure TfmMainBook.sgBudgetDrawCell(Sender: TObject; aCol, aRow: Integer;
  aRect: TRect; aState: TGridDrawState);
var
  bl: TbkBudgetLine;
  cl: TColor;
  w, h: integer;
  sText: string;
begin
  if aRow > 0 then
  begin
    // color
    bl := TbkBudgetLine(FBk.Budget[aRow-1]);
    cl := clDefault;
    if bl.Typ = bltSubGroup then
    begin
      cl := clDefault;
      //cl := clGrayText;
      //sgBudget.Canvas.Font.Color := clBlack;
    end
    else if bl.Typ = bltGroup then
      cl := clForm;

    // fill background
    if (gdSelected in aState) or (gdFocused in aState) then
    begin
      sgBudget.Canvas.Brush.Style := bsSolid;
      sgBudget.Canvas.Brush.Color := clHighlight;
      sgBudget.Canvas.FillRect(aRect);
      sgBudget.Canvas.Brush.Color := cl;
      sgBudget.Canvas.FillRect(aRect.Left+3, aRect.Top+3, aRect.Right-4, aRect.Bottom-4);
    end
    else
    begin
      sgBudget.Canvas.Brush.Color := cl;
      sgBudget.Canvas.Brush.Style := bsSolid;
      sgBudget.Canvas.FillRect(aRect);
    end;

    // simple shifted
    if (aCol = 0) and (bl.Typ = bltSimple) then
      aRect.Left := aRect.Left + 24;

    // group - bold
    if bl.Typ = bltGroup then
      sgBudget.Canvas.Font.Style := [fsBold];

    h := sgBudget.Canvas.TextHeight('M');
    if aCol = 0 then
    begin
      sText := sgBudget.Cells[aCol, aRow];
      sgBudget.Canvas.TextOut(aRect.Left+8, aRect.Top + ((aRect.Height-h) div 2), sText);
    end
    else if aCol = 1 then
    begin
      sText := FormatValue(StrToInt(sgBudget.Cells[aCol, aRow]));
      w := sgBudget.Canvas.TextWidth(sText);
      sgBudget.Canvas.TextOut(aRect.Right-w-8, aRect.Top + ((aRect.Height-h) div 2), sText);
    end
    else if aCol = 2 then
    begin
      // готовность
      if bl.Typ = bltSimple then
      begin
        if bl.Ready then
        begin
          sgBudget.Canvas.Font.Style := [fsBold];
          sText := 'Да';
          w := sgBudget.Canvas.TextWidth(sText);
          h := sgBudget.Canvas.TextHeight(sText);
          sgBudget.Canvas.TextOut(aRect.Left + ((aRect.Width-w) div 2), aRect.Top + ((aRect.Height-h) div 2), sText);
        end
        else
        begin
          sText := FormatValue(bl.ReadyValue);
          w := sgBudget.Canvas.TextWidth(sText);
          sgBudget.Canvas.TextOut(aRect.Right-w-8, aRect.Top + ((aRect.Height-h) div 2), sText);
        end;
      end;
    end;
  end;
end;

procedure TfmMainBook.sgBudgetKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  // insert
  if (Key = VK_INSERT) then
  begin
    if actBudgetAdd.Enabled then
      actBudgetAddExecute(actBudgetAdd);
    Key := 0;
  end;

  // delete
  if (Key = VK_DELETE) then
  begin
    if actBudgetDel.Enabled then
      actBudgetDelExecute(actBudgetDel);
    Key := 0;
  end;

  // move up
  if (Key = VK_UP) and (ssCtrl in Shift) then
  begin
    if actBudgetUp.Enabled then
      actBudgetUpExecute(actBudgetUp);
    Key := 0;
  end;

  // move down
  if (Key = VK_DOWN) and (ssCtrl in Shift) then
  begin
    if actBudgetDown.Enabled then
      actBudgetDownExecute(actBudgetDown);
    Key := 0;
  end;

  // edit
  if (Key = VK_RETURN) then
  begin
    if actBudgetDel.Enabled then
      doBudgetAddEdit(True);
    Key := 0;
  end;
end;

procedure TfmMainBook.actBudgetAddExecute(Sender: TObject);
begin
  doBudgetAddEdit(False);
end;

procedure TfmMainBook.actBudgetDelExecute(Sender: TObject);
var
  ix: integer;
begin
  ix := sgBudget.Selection.Top-1;
  FBk.Budget.Delete(ix);
  FModified := True;
  UpdateBudget();
end;

procedure TfmMainBook.actBudgetDelUpdate(Sender: TObject);
begin
  (Sender as TAction).Enabled := FBk.Budget.Count > 0;
end;

procedure TfmMainBook.actBudgetDownExecute(Sender: TObject);
var
  ix: integer;
begin
  ix := sgBudget.Selection.Top - 1;
  FBk.Budget.Move(ix, ix+1);
  FModified := True;
  UpdateBudget();
  sgBudget.Row := sgBudget.Row+1;
end;

procedure TfmMainBook.actBudgetDownUpdate(Sender: TObject);
begin
  (Sender as TAction).Enabled := (sgBudget.Row < sgBudget.RowCount-1);
end;

procedure TfmMainBook.actBudgetEditExecute(Sender: TObject);
begin
  doBudgetAddEdit(True);
end;

procedure TfmMainBook.actBudgetUpExecute(Sender: TObject);
var
  ix: integer;
begin
  ix := sgBudget.Selection.Top - 1;
  FBk.Budget.Move(ix, ix-1);
  FModified := True;
  UpdateBudget();
  sgBudget.Row := sgBudget.Row-1;
end;

procedure TfmMainBook.actBudgetUpUpdate(Sender: TObject);
begin
  (Sender as TAction).Enabled := (sgBudget.Row > 1);
end;

procedure TfmMainBook.sgBudgetDblClick(Sender: TObject);
begin
  actBudgetEdit.Execute;
end;

procedure TfmMainBook.actBudgetClearReadyExecute(Sender: TObject);
var
  i: integer;
begin
  for i := 0 to FBk.Budget.Count - 1 do
  begin
    TbkBudgetLine(FBk.Budget[i]).Ready := False;
    TbkBudgetLine(FBk.Budget[i]).ReadyValue := 0;
  end;
  FModified := True;
  UpdateBudget();
end;

procedure TfmMainBook.actBudgetClearReadyUpdate(Sender: TObject);
begin
  (Sender as TAction).Enabled := sgBudget.RowCount > 1;
end;
{$EndRegion}
end.

