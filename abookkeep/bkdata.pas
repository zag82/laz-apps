unit bkdata;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils;

type
  TbkCurrencyTypes = (curRUR, curUSD, curEUR);
  TbkCurrencyValues = array[TbkCurrencyTypes] of integer;
  TbkCurrencyNames = array[TbkCurrencyTypes] of string;
const
  cCurrencyNames: TbkCurrencyNames = ('Руб', 'USD', 'EUR');
  cMoneyFormat = '### ### ### ##0';

type
  { TbkAccountGroup }

  TbkAccountGroup = class
  private
    FName: string;
    FAccounts: TList;
    FBalance: TbkCurrencyValues;
    procedure ClearBalance();
  public
    function Balance(ACurrency: TbkCurrencyTypes): integer;

    constructor Create();
    destructor Destroy;override;

    property Name: string read FName write FName;
    property Accounts: TList read FAccounts;
  end;

  TbkAccount = class
  private
    FName: string;
    FDescr: string;
    FCurrency: TbkCurrencyTypes;
    FGroup: TbkAccountGroup;
    FD1: TDate;
    FD2: TDate;
    FBalance: integer;
    procedure UpdateBalance(ABalance: integer);
  public
    function InPeriod(ADateFrom, ADateTo: TDate): boolean;
    function FullName(): string;
    function Hash(): integer;

    property Name: string read FName write FName;
    property Descr: string read FDescr write FDescr;
    property Currency: TbkCurrencyTypes read FCurrency write FCurrency;
    property Group: TbkAccountGroup read FGroup write FGroup;
    property D1: TDate read FD1 write FD1;
    property D2: TDate read FD2 write FD2;

    property Balance: integer read FBalance;
  end;

  { TbkCategoryGroup }

  TbkCategoryGroup = class
  private
    FName: string;
    FCategories: TList;
    FPayments: TbkCurrencyValues; // payments for period
    procedure ClearPayments();
  public
    function Payment(ACurrency: TbkCurrencyTypes): integer;

    constructor Create();
    destructor Destroy; override;

    property Name: string read FName write FName;
    property Categories: TList read FCategories;
  end;

  TbkCategory = class
  private
    FName: string;
    FDescr: string;
    FGroup: TbkCategoryGroup;
    FD1: TDate;
    FD2: TDate;
    FPayments: TbkCurrencyValues; // Payments for period
    procedure UpdatePayments(APayment: integer; ACurrency: TbkCurrencyTypes);
  public
    function PaymentEmpty(): boolean;
    function PaymentStr(): string;
    function Payment(ACurrency: TbkCurrencyTypes): integer;
    function InPeriod(ADateFrom, ADateTo: TDate): boolean;
    function Hash(): integer;

    property Name: string read FName write FName;
    property Descr: string read FDescr write FDescr;
    property Group: TbkCategoryGroup read FGroup write FGroup;
    property D1: TDate read FD1 write FD1;
    property D2: TDate read FD2 write FD2;
  end;

  TbkTransType = (ttSimple, ttStart, ttTransfer);

  { TbkTrans }

  TbkTrans = class
  private
    FDate: TDate;
    FValue: integer;
    FTyp: TbkTransType;
    FName: string;
    FAccount: TbkAccount;
    FCategory: TbkCategory;
    FAccount_to: TbkAccount;
    FValue_to: integer;
  public
    function InAccount(AAcc: TbkAccount): boolean;
    function AccValue(AAcc: TbkAccount): integer;

    property Date: TDate read FDate write FDate;
    property Value: integer read FValue write FValue;
    property Typ: TbkTransType read FTyp write FTyp;
    property Name: string read FName write FName;
    property Account: TbkAccount read FAccount write FAccount;
    property Category: TbkCategory read FCategory write FCategory;
    property Account_to: TbkAccount read FAccount_to write FAccount_to;
    property Value_to: integer read FValue_to write FValue_to;
  end;


  TbkBudgetLineType = (bltSimple, bltGroup, bltSubGroup);

  TbkBudgetLine = class
  private
    FName: string;
    FValue: integer;
    FTyp: TbkBudgetLineType;
    FReady: boolean;
    FReadyValue: integer;
  public
    property Name: string read FName write FName;
    property Value: integer read FValue write FValue;
    property Typ: TbkBudgetLineType read FTyp write FTyp;
    property Ready: boolean read FReady write FReady;
    property ReadyValue: integer read FReadyValue write FReadyValue;
  end;

  { TbkData }

  TbkData = class
  private
    FAccounts: TList;  // TbkAccountGroups
    FCategories: TList; // TbkCategoriesGroups
    FTrans: TList;  // TbkTrans
    FBudget: TList; // TList of TbkBudgetLine
    FFileName: string;

    procedure TrFind(ADate: TDate; out index1, index2: integer);
    procedure Load();
  public
    CurrencyValues: TbkCurrencyValues;

    constructor Create(const AFileName: string);
    destructor Destroy; override;

    procedure Save();

    procedure UpdateAccountValues(ADate: TDate);
    procedure UpdateCategoryPayments(ADateFrom, ADateTo: TDate);
    procedure InsertTrans(ATrans: TbkTrans);
    procedure MoveTrans(AIndex1: integer; ATrans: TbkTrans);

    function ExistsMonthOperations(ADate1, ADate2: TDate): boolean;
    procedure YearPayData(AYear: integer; ACurrency: TbkCurrencyTypes; out APayIn, APayOut: integer);

    property Accounts: TList read FAccounts;
    property Categories: TList read FCategories;
    property Trans: TList read FTrans;
    property Budget: TList read FBudget;
  end;

function FormatValue(const AValue: double): string;

implementation

uses
  streamdata;

const
  C_VERSION = 1;

function FormatValue(const AValue: double): string;
begin
  Result := Trim(FormatFloat(cMoneyFormat, abs(AValue)));
  if AValue < 0 then
    Result := '-'+Result;
end;

{ TbkCategory }

procedure TbkCategory.UpdatePayments(APayment: integer; ACurrency: TbkCurrencyTypes);
begin
  // apply balance
  FGroup.FPayments[ACurrency] := FGroup.FPayments[ACurrency] + APayment;
  FPayments[ACurrency] := APayment;
end;

function TbkCategory.PaymentEmpty(): boolean;
var
  ct: TbkCurrencyTypes;
begin
  Result := True;
  for ct := low(TbkCurrencyTypes) to high(TbkCurrencyTypes) do
    if FPayments[ct] > 0 then
    begin
      Result := False;
      break;
    end;
end;

function TbkCategory.PaymentStr(): string;
var
  ct: TbkCurrencyTypes;
begin
  Result := '';
  for ct := low(TbkCurrencyTypes) to high(TbkCurrencyTypes) do
    if FPayments[ct] > 0 then
    begin
      if Result <> '' then
        Result := Result + ', ';
      Result := Result + FormatValue(FPayments[ct]) + ' ' + cCurrencyNames[ct];
    end;
end;

function TbkCategory.Payment(ACurrency: TbkCurrencyTypes): integer;
begin
  Result := FPayments[ACurrency];
end;

function TbkCategory.InPeriod(ADateFrom, ADateTo: TDate): boolean;
var
  d_1, d_2: TDate;
begin
  Result := False;
  if FD1 = 0 then
    d_1 := EncodeDate(1000, 1, 1)
  else
    d_1 := FD1;
  if FD2 = 0 then
    d_2 := EncodeDate(3000, 1, 1)
  else
    d_2 := FD2;
  if (FD1 <= ADateTo) and (ADateFrom <= d_2) and (ADateTo >= ADateFrom) and (d_2 >= d_1) then
    Result := True;
end;

function TbkCategory.Hash(): integer;
begin
  Result := ElfHash(FName + '_' + FDescr + '_' + DateToStr(FD1) + '-' + DateToStr(FD2));
end;

{ TbkTrans }

function TbkTrans.InAccount(AAcc: TbkAccount): boolean;
begin
  Result := (FAccount = AAcc) or (FAccount_to = AAcc);
end;

function TbkTrans.AccValue(AAcc: TbkAccount): integer;
begin
  Result := 0;
  if AAcc = FAccount_to then
    Result := FValue_to
  else if AAcc = FAccount then
  begin
    Case FTyp of
      ttStart: Result := FValue;
      ttTransfer: Result := FValue;
      ttSimple: Result := FValue;
    end;
  end;
end;

{ TbkAccount }

procedure TbkAccount.UpdateBalance(ABalance: integer);
begin
  // apply balance
  FGroup.FBalance[FCurrency] := FGroup.FBalance[FCurrency] + ABalance;
  FBalance := ABalance;
end;

function TbkAccount.InPeriod(ADateFrom, ADateTo: TDate): boolean;
var
  d_1, d_2: TDate;
begin
  Result := False;
  if FD1 = 0 then
    d_1 := EncodeDate(1000, 1, 1)
  else
    d_1 := FD1;
  if FD2 = 0 then
    d_2 := EncodeDate(3000, 1, 1)
  else
    d_2 := FD2;
  if (d_1 <= ADateTo) and (ADateFrom <= d_2) and (ADateTo >= ADateFrom) and (d_2 >= d_1) then
    Result := True;
end;

function TbkAccount.FullName(): string;
begin
  Result := FName + ' (' + cCurrencyNames[FCurrency] + ')';
end;

function TbkAccount.Hash(): integer;
begin
  Result := ElfHash(FName + '_ ' + FDescr + '_' + cCurrencyNames[FCurrency] + '_' + DateToStr(FD1) + '-' + DateToStr(FD2));
end;


{ TbkCategoryGroup }

procedure TbkCategoryGroup.ClearPayments();
var
  ct: TbkCurrencyTypes;
begin
  for ct := low(TbkCurrencyTypes) to high(TbkCurrencyTypes) do
    FPayments[ct] := 0;
end;

function TbkCategoryGroup.Payment(ACurrency: TbkCurrencyTypes): integer;
begin
  Result := FPayments[ACurrency];
end;

constructor TbkCategoryGroup.Create();
begin
  FCategories := TList.Create;
end;

destructor TbkCategoryGroup.Destroy;
var
  i: integer;
begin
  for i := 0 to FCategories.Count - 1 do
    TbkCategory(FCategories[i]).Free;
  FCategories.Free;
  inherited Destroy;
end;

{ TbkAccountGroup }

procedure TbkAccountGroup.ClearBalance();
var
  ct: TbkCurrencyTypes;
begin
  for ct := low(TbkCurrencyTypes) to high(TbkCurrencyTypes) do
    FBalance[ct] := 0;
end;

function TbkAccountGroup.Balance(ACurrency: TbkCurrencyTypes): integer;
begin
  Result := FBalance[ACurrency];
end;

constructor TbkAccountGroup.Create();
begin
  FAccounts := TList.Create;
end;

destructor TbkAccountGroup.Destroy;
var
  i: integer;
begin
  for i := 0 to FAccounts.Count - 1 do
    TbkAccount(FAccounts[i]).Free;
  FAccounts.Free;
  inherited Destroy;
end;

{ TbkData }

constructor TbkData.Create(const AFileName: string);
begin
  FFileName := AFileName;

  FAccounts := TList.Create;
  FCategories := TList.Create;
  FTrans := TList.Create;
  FBudget := TList.Create;

  Load();
end;

destructor TbkData.Destroy;
var
  i: integer;
begin
  for i := 0 to FBudget.Count - 1 do
    TbkBudgetLine(FBudget[i]).Free;
  FBudget.Free;

  for i := 0 to FTrans.Count - 1 do
    TbkTrans(FTrans[i]).Free;
  FTrans.Free;

  for i := 0 to FAccounts.Count - 1 do
    TbkAccountGroup(FAccounts[i]).Free;
  FAccounts.Free;

  for i := 0 to FCategories.Count - 1 do
    TbkCategoryGroup(FCategories[i]).Free;
  FCategories.Free;

  inherited Destroy;
end;

procedure TbkData.TrFind(ADate: TDate; out index1, index2: integer);
var
  right, left, ix, i: integer;
begin

  left := 0;
  right := FTrans.Count-1;

  if right < left then
  begin
    index1 := -1;
    index2 := -1;
    Exit;
  end;
  if TbkTrans(FTrans[right]).Date < ADate then
  begin
    index1 := right+1;
    index2 := right+1;
    Exit;
  end;
  if TbkTrans(FTrans[left]).Date > ADate then
  begin
    index1 := left-1;
    index2 := left-1;
    Exit;
  end;

  while right - left > 1 do
  begin
    ix := (left + right) div 2;
    if TbkTrans(FTrans[ix]).Date < ADate then
      left := ix
    else if TbkTrans(FTrans[ix]).Date > ADate then
      right := ix
    else
    begin
      left := ix;
      right := ix;
      break;
    end;
  end;

  if (TbkTrans(FTrans[left]).Date = ADate) or (TbkTrans(FTrans[right]).Date = ADate) then
  begin
    if TbkTrans(FTrans[left]).Date <> ADate then
      left := right;
    index1 := left;
    for i := left-1 downto 0 do
      if TbkTrans(FTrans[i]).Date = ADate then
        index1 := i
      else
        break;

    index2 := left;
    for i := left+1 to FTrans.Count-1 do
      if TbkTrans(FTrans[i]).Date = ADate then
        index2 := i
      else
        break;
  end
  else
  begin
    index1 := left+1;
    index2 := left;
  end;
end;

procedure TbkData.Load();
var
  allAccounts, allCategories: TList;

  function FindAccount(AHash: integer): TbkAccount;
  var
    i: integer;
  begin
    Result := nil;
    for i := 0 to allAccounts.Count - 1 do
      if TbkAccount(allAccounts[i]).Hash() = AHash then
      begin
        Result := TbkAccount(allAccounts[i]);
        break;
      end;
  end;

  function FindCategory(AHash: integer): TbkCategory;
  var
    i: integer;
  begin
    Result := nil;
    for i := 0 to allCategories.Count - 1 do
      if TbkCategory(allCategories[i]).Hash() = AHash then
      begin
        Result := TbkCategory(allCategories[i]);
        break;
      end;
  end;
var
  ms: TMemoryStream;
  i, j, cnt, cnt2, h: integer;
  grAcc: TbkAccountGroup;
  grCat: TbkCategoryGroup;
  acc: TbkAccount;
  cat: TbkCategory;
  tr: TbkTrans;
  bl: TbkBudgetLine;
  ver: integer;
  stemp: string;
begin
  if not FileExists(FFileName) then
    Exit;
  try
    ms := TMemoryStream.Create;
    allAccounts := TList.Create;
    allCategories := TList.Create;
    try
      ms.LoadFromFile(FFileName);
      ms.Position := 0;

      // header
      ver := ReadInteger(ms);
      if ver <> C_VERSION then
        Exit;
      ReadInteger(ms);
      ReadInteger(ms);
      ReadInteger(ms);

      // currencies
      stemp := ReadString(ms);
      if stemp <> 'currencies' then
        Exit;
      cnt := ReadInteger(ms);
      if cnt > ord(High(TbkCurrencyTypes)) then
        Exit;
      for i := 0 to cnt do
        CurrencyValues[TbkCurrencyTypes(i)] := ReadInteger(ms);

      // accounts
      stemp := ReadString(ms);
      if stemp <> 'accounts' then
        Exit;
      cnt := ReadInteger(ms);
      for i := 0 to cnt - 1 do
      begin
        grAcc := TbkAccountGroup.Create();
        grAcc.FName := ReadString(ms);
        cnt2 := ReadInteger(ms);
        for j := 0 to cnt2 - 1 do
        begin
          acc := TbkAccount.Create();
          acc.FName := ReadString(ms);
          acc.FDescr := ReadString(ms);
          acc.FCurrency := TbkCurrencyTypes(ReadInteger(ms));
          acc.FD1 := ReadDouble(ms);
          acc.FD2 := ReadDouble(ms);
          acc.Group := grAcc;

          grAcc.FAccounts.Add(acc);
          allAccounts.Add(acc);
        end;
        FAccounts.Add(grAcc);
      end;

      // categories
      stemp := ReadString(ms);
      if stemp <> 'categories' then
        Exit;
      cnt := ReadInteger(ms);
      for i := 0 to cnt - 1 do
      begin
        grCat := TbkCategoryGroup.Create;
        grCat.FName := ReadString(ms);
        cnt2 := ReadInteger(ms);
        for j := 0 to cnt2 - 1 do
        begin
          cat := TbkCategory.Create;
          cat.FName := ReadString(ms);
          cat.FDescr := ReadString(ms);
          cat.FD1 := ReadDouble(ms);
          cat.FD2 := ReadDouble(ms);
          cat.Group := grCat;

          grCat.FCategories.Add(cat);
          allCategories.Add(cat);
        end;
        FCategories.Add(grCat);
      end;

      // transactions
      stemp := ReadString(ms);
      if stemp <> 'transactions' then
        Exit;
      cnt := ReadInteger(ms);
      for i := 0 to cnt - 1 do
      begin
        tr := TbkTrans.Create;
        tr.FDate := ReadDouble(ms);
        tr.FTyp := TbkTransType(ReadInteger(ms));
        Case tr.FTyp of
          ttSimple:
            begin
              tr.FValue := ReadInteger(ms);
              tr.FName := ReadString(ms);
              h := ReadInteger(ms);
              tr.FAccount := FindAccount(h);
              h := ReadInteger(ms);
              tr.FCategory := FindCategory(h);
            end;
          ttStart:
            begin
              tr.FValue := ReadInteger(ms);
              h := ReadInteger(ms);
              tr.FAccount := FindAccount(h);
            end;
          ttTransfer:
            begin
              tr.FValue := ReadInteger(ms);
              h := ReadInteger(ms);
              tr.FAccount := FindAccount(h);

              tr.FValue_to := ReadInteger(ms);
              h := ReadInteger(ms);
              tr.FAccount_to := FindAccount(h);
            end;
        end;

        FTrans.Add(tr);
      end;

      // budget
      if ms.Position = ms.Size then
        Exit;
      stemp := ReadString(ms);
      if stemp <> 'budget' then
        Exit;
      cnt := ReadInteger(ms);
      for i := 0 to cnt - 1 do
      begin
        bl := TbkBudgetLine.Create;
        bl.FName := ReadString(ms);
        bl.FValue := ReadInteger(ms);
        bl.FTyp := TbkBudgetLineType(ReadInteger(ms));
        bl.FReady := ReadBoolean(ms);
        bl.FReadyValue := ReadInteger(ms);

        FBudget.Add(bl);
      end;

    finally
      ms.Free;
      allCategories.Free;
      allAccounts.Free;
    end;
  except
  end;
end;

procedure TbkData.Save();
var
  ms: TMemoryStream;
  i, j: integer;
  ct: TbkCurrencyTypes;
  grAcc: TbkAccountGroup;
  grCat: TbkCategoryGroup;
  tr: TbkTrans;
  bl: TbkBudgetLine;
begin
  ms := TMemoryStream.Create;
  try
    // header
    WriteInteger(ms, C_VERSION);
    WriteInteger(ms, 0);
    WriteInteger(ms, 0);
    WriteInteger(ms, 0);

    // currencies
    WriteString(ms, 'currencies');
    WriteInteger(ms, Ord(High(TbkCurrencyTypes)));
    for ct := Low(TbkCurrencyTypes) to High(TbkCurrencyTypes) do
      WriteInteger(ms, CurrencyValues[ct]);

    // accounts
    WriteString(ms, 'accounts');
    WriteInteger(ms, FAccounts.Count);
    for i := 0 to FAccounts.Count - 1 do
    begin
      grAcc := TbkAccountGroup(FAccounts[i]);
      WriteString(ms, grAcc.FName);
      WriteInteger(ms, grAcc.FAccounts.Count);
      for j := 0 to grAcc.FAccounts.Count - 1 do
      begin
        WriteString(ms, TbkAccount(grAcc.FAccounts[j]).FName);
        WriteString(ms, TbkAccount(grAcc.FAccounts[j]).FDescr);
        WriteInteger(ms, Ord(TbkAccount(grAcc.FAccounts[j]).FCurrency));
        WriteDouble(ms, TbkAccount(grAcc.FAccounts[j]).FD1);
        WriteDouble(ms, TbkAccount(grAcc.FAccounts[j]).FD2);
      end;
    end;

    // categories
    WriteString(ms, 'categories');
    WriteInteger(ms, FCategories.Count);
    for i := 0 to FCategories.Count - 1 do
    begin
      grCat := TbkCategoryGroup(FCategories[i]);
      WriteString(ms, grCat.FName);
      WriteInteger(ms, grCat.FCategories.Count);
      for j := 0 to grCat.FCategories.Count - 1 do
      begin
        WriteString(ms, TbkCategory(grCat.FCategories[j]).FName);
        WriteString(ms, TbkCategory(grCat.FCategories[j]).FDescr);
        WriteDouble(ms, TbkCategory(grCat.FCategories[j]).FD1);
        WriteDouble(ms, TbkCategory(grCat.FCategories[j]).FD2);
      end;
    end;

    // transactions
    WriteString(ms, 'transactions');
    WriteInteger(ms, FTrans.Count);
    for i := 0 to FTrans.Count - 1 do
    begin
      tr := TbkTrans(FTrans[i]);
      WriteDouble(ms, tr.FDate);
      WriteInteger(ms, ord(tr.FTyp));
      Case tr.FTyp of
        ttSimple:
          begin
            WriteInteger(ms, tr.FValue);
            WriteString(ms, tr.FName);
            WriteInteger(ms, tr.FAccount.Hash());
            WriteInteger(ms, tr.FCategory.Hash());
          end;
        ttStart:
          begin
            WriteInteger(ms, tr.FValue);
            WriteInteger(ms, tr.FAccount.Hash());
          end;
        ttTransfer:
          begin
            WriteInteger(ms, tr.FValue);
            WriteInteger(ms, tr.FAccount.Hash());
            WriteInteger(ms ,tr.FValue_to);
            WriteInteger(ms, tr.FAccount_to.Hash());
          end;
      end;
    end;

    // budget
    WriteString(ms, 'budget');
    WriteInteger(ms, FBudget.Count);
    for i := 0 to FBudget.Count - 1 do
    begin
      bl := TbkBudgetLine(FBudget[i]);

      WriteString(ms, bl.FName);
      WriteInteger(ms, bl.FValue);
      WriteInteger(ms, Ord(bl.FTyp));
      WriteBoolean(ms, bl.FReady);
      WriteInteger(ms, bl.FReadyValue);
    end;

    // save to file
    ms.Position := 0;
    ms.SaveToFile(FFileName);
  finally
    ms.Free;
  end;
end;

procedure TbkData.UpdateAccountValues(ADate: TDate);
var
  i, j, k, ix1, ix2: integer;
  accGroup: TbkAccountGroup;
  acc: TbkAccount;
  sm: integer;
  tr: TbkTrans;
begin
  TrFind(ADate, ix1, ix2);
  if ix2 > FTrans.Count-1 then
    ix2 := FTrans.Count-1;
  for i := 0 to FAccounts.Count - 1 do
  begin
    accGroup := TbkAccountGroup(FAccounts[i]);
    accGroup.ClearBalance();
    for j := 0 to accGroup.FAccounts.Count - 1 do
    begin
      acc := TbkAccount(accGroup.FAccounts[j]);
      if not acc.InPeriod(ADate, ADate) then
      begin
        acc.UpdateBalance(0);
        Continue;
      end;
      // sum
      sm := 0;
      for k := ix2 downto 0 do
      begin
        tr := TbkTrans(FTrans[k]);
        if tr.InAccount(acc) then
        begin
          sm := sm + tr.AccValue(acc);
          if tr.FTyp = ttStart then
            break;
        end;
      end;
      acc.UpdateBalance(sm);
    end;
  end;
end;

procedure TbkData.UpdateCategoryPayments(ADateFrom, ADateTo: TDate);
var
  i, j, k, ix1, ix2, ixtemp: integer;
  catGroup: TbkCategoryGroup;
  cat: TbkCategory;
  ct: TbkCurrencyTypes;
  sm: integer;
  tr: TbkTrans;
begin
  TrFind(ADateFrom, ix1, ixtemp);
  TrFind(ADateTo, ixtemp, ix2);
  if ix1 = -1 then
    ix1 := 0;
  if ix2 > FTrans.Count-1 then
    ix2 := FTrans.Count-1;
  for i := 0 to FCategories.Count - 1 do
  begin
    catGroup := TbkCategoryGroup(FCategories[i]);
    catGroup.ClearPayments();
    for j := 0 to catGroup.FCategories.Count - 1 do
    begin
      cat := TbkCategory(catGroup.FCategories[j]);
      if not cat.InPeriod(ADateFrom, ADateTo) then
      begin
        for ct := low(TbkCurrencyTypes) to high(TbkCurrencyTypes) do
          cat.UpdatePayments(0, ct);
        Continue;
      end;

      for ct := low(TbkCurrencyTypes) to high(TbkCurrencyTypes) do
      begin
        // sum
        sm := 0;
        for k := ix1 to ix2 do
        begin
          tr := TbkTrans(FTrans[k]);
          if (tr.FTyp = ttSimple) and (tr.FCategory = cat) and (tr.FAccount.FCurrency = ct) then
            sm := sm + tr.FValue;
        end;
        cat.UpdatePayments(Abs(sm), ct);
      end;
    end;
  end;
end;

procedure TbkData.InsertTrans(ATrans: TbkTrans);
var
  ix1, ix2: integer;
begin
  TrFind(ATrans.Date, ix1, ix2);
  if ix2+1 > FTrans.Count then
    FTrans.Add(ATrans)
  else
    FTrans.Insert(ix2+1, ATrans);
end;

procedure TbkData.MoveTrans(AIndex1: integer; ATrans: TbkTrans);
var
  ix1, ix2: integer;
begin
  TrFind(ATrans.Date, ix1, ix2);
  if ix2+1 > FTrans.Count-1 then
    FTrans.Move(AIndex1, FTrans.Count-1)
  else
    FTrans.Move(AIndex1, ix2+1);
end;

function TbkData.ExistsMonthOperations(ADate1, ADate2: TDate): boolean;
begin
  Result := False;
  if FTrans.Count > 0 then
    Result := (ADate1 <= ADate2) and (ADate1 <= TbkTrans(FTrans.Last).Date) and (TbkTrans(FTrans.First).Date <= ADate2);
end;

procedure TbkData.YearPayData(AYear: integer; ACurrency: TbkCurrencyTypes; out APayIn, APayOut: integer);
var
  i, ix1, ix2, ixtemp: integer;
  tr: TbkTrans;
begin
  APayIn := 0;
  APayOut := 0;

  TrFind(EncodeDate(AYear, 1, 1), ix1, ixtemp);
  TrFind(EncodeDate(AYear, 12, 31), ixtemp, ix2);

  if ix1 = -1 then
    ix1 := 0;
  if ix2 > FTrans.Count-1 then
    ix2 := FTrans.Count-1;

  for i := ix1 to ix2 do
  begin
    tr := TbkTrans(FTrans[i]);
    if (tr.FTyp = ttSimple) and (tr.Account.Currency = ACurrency) then
    begin
      if tr.Value > 0 then
        APayIn := APayIn + tr.Value
      else
        APayOut := APayOut + tr.Value;
    end;
  end;
end;

end.

