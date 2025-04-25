{
                          Apache License
                      Version 2.0, January 2004
                   http://www.apache.org/licenses/

       Licensed under the Apache License, Version 2.0 (the "License");
       you may not use this file except in compliance with the License.
       You may obtain a copy of the License at

             http://www.apache.org/licenses/LICENSE-2.0

       Unless required by applicable law or agreed to in writing, software
       distributed under the License is distributed on an "AS IS" BASIS,
       WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
       See the License for the specific language governing permissions and
       limitations under the License.
}

{
  @abstract(CQuery4D: Fluent SQL Framework for Delphi)
  @description(A modern and extensible query framework supporting multiple databases)
  @created(03 Apr 2025)
  @author(Isaque Pinheiro)
  @contact(isaquepsp@gmail.com)
  @discord(https://discord.gg/T2zJC8zX)
}

unit CQuery;

{$ifdef fpc}
  {$mode delphi}{$H+}
{$endif}

interface

uses
  SysUtils,
  CQuery.Operators,
  CQuery.Functions,
  CQuery.Interfaces,
  CQuery.Cases,
  CQuery.Select,
  CQuery.Utils,
  CQuery.Serialize,
  CQuery.Qualifier,
  CQuery.Ast,
  CQuery.Expression,
  CQuery.Register;

type
  TCQueryDriver = CQuery.Interfaces.TCQueryDriver;
  CQLFun = CQuery.Functions.TCQueryFunctions;

  TCQuery = class(TInterfacedObject, ICQuery)
  strict private
    class var FDatabaseDafault: TCQueryDriver;
    type
      TSection = (secSelect = 0,
                  secDelete = 1,
                  secInsert = 2,
                  secUpdate = 3,
                  secJoin = 4,
                  secWhere= 5,
                  secGroupBy = 6,
                  secHaving = 7,
                  secOrderBy = 8);
      TSections = set of TSection;
  strict private
    FActiveSection: TSection;
    FActiveOperator: TOperator;
    FActiveExpr: ICQueryCriteriaExpression;
    FActiveValues: ICQueryNameValuePairs;
    FDatabase: TCQueryDriver;
    FOperator: ICQueryOperators;
    FFunction: ICQueryFunctions;
    FAST: ICQueryAST;
    FRegister: TCQueryRegister;
    procedure _AssertSection(ASections: TSections);
    procedure _AssertOperator(AOperators: TOperators);
    procedure _AssertHaveName;
    procedure _SetSection(ASection: TSection);
    procedure _DefineSectionSelect;
    procedure _DefineSectionDelete;
    procedure _DefineSectionInsert;
    procedure _DefineSectionUpdate;
    procedure _DefineSectionWhere;
    procedure _DefineSectionGroupBy;
    procedure _DefineSectionHaving;
    procedure _DefineSectionOrderBy;
    function _CreateJoin(AjoinType: TJoinType; const ATableName: String): ICQuery;
    function _InternalSet(const AColumnName, AColumnValue: String): ICQuery;
  public
    constructor Create(const ADatabase: TCQueryDriver);
    destructor Destroy; override;
    class procedure SetDatabaseDafault(const ADatabase: TCQueryDriver);
    function AndOpe(const AExpression: array of const): ICQuery; overload;
    function AndOpe(const AExpression: String): ICQuery; overload;
    function AndOpe(const AExpression: ICQueryCriteriaExpression): ICQuery; overload;
    function Alias(const AAlias: String): ICQuery;
    function CaseExpr(const AExpression: String = ''): ICQueryCriteriaCase; overload;
    function CaseExpr(const AExpression: array of const): ICQueryCriteriaCase; overload;
    function CaseExpr(const AExpression: ICQueryCriteriaExpression): ICQueryCriteriaCase; overload;
    function Clear: ICQuery;
    function ClearAll: ICQuery;
    function All: ICQuery;
    function Column(const AColumnName: String = ''): ICQuery; overload;
    function Column(const ATableName: String; const AColumnName: String): ICQuery; overload;
    function Column(const AColumnsName: array of const): ICQuery; overload;
    function Column(const ACaseExpression: ICQueryCriteriaCase): ICQuery; overload;
    function Delete: ICQuery;
    function Desc: ICQuery;
    function Distinct: ICQuery;
    function IsEmpty: Boolean;
    function Expression(const ATerm: String = ''): ICQueryCriteriaExpression; overload;
    function Expression(const ATerm: array of const): ICQueryCriteriaExpression; overload;
    function From(const AExpression: ICQueryCriteriaExpression): ICQuery; overload;
    function From(const AQuery: ICQuery): ICQuery; overload;
    function From(const ATableName: String): ICQuery; overload;
    function From(const ATableName: String; const AAlias: String): ICQuery; overload;
    function GroupBy(const AColumnName: String = ''): ICQuery;
    function Having(const AExpression: String = ''): ICQuery; overload;
    function Having(const AExpression: array of const): ICQuery; overload;
    function Having(const AExpression: ICQueryCriteriaExpression): ICQuery; overload;
    function Insert: ICQuery;
    function Into(const ATableName: String): ICQuery;
    function FullJoin(const ATableName: String): ICQuery; overload;
    function InnerJoin(const ATableName: String): ICQuery; overload;
    function LeftJoin(const ATableName: String): ICQuery; overload;
    function RightJoin(const ATableName: String): ICQuery; overload;
    function FullJoin(const ATableName: String; const AAlias: String): ICQuery; overload;
    function InnerJoin(const ATableName: String; const AAlias: String): ICQuery; overload;
    function LeftJoin(const ATableName: String; const AAlias: String): ICQuery; overload;
    function RightJoin(const ATableName: String; const AAlias: String): ICQuery; overload;
    function OnCond(const AExpression: String): ICQuery; overload;
    function OnCond(const AExpression: array of const): ICQuery; overload;
    function OrOpe(const AExpression: array of const): ICQuery; overload;
    function OrOpe(const AExpression: String): ICQuery; overload;
    function OrOpe(const AExpression: ICQueryCriteriaExpression): ICQuery; overload;
    function OrderBy(const AColumnName: String = ''): ICQuery; overload;
    function OrderBy(const ACaseExpression: ICQueryCriteriaCase): ICQuery; overload;
    function Select(const AColumnName: String = ''): ICQuery; overload;
    function Select(const ACaseExpression: ICQueryCriteriaCase): ICQuery; overload;
    function SetValue(const AColumnName, AColumnValue: String): ICQuery; overload;
    function SetValue(const AColumnName: String; AColumnValue: Integer): ICQuery; overload;
    function SetValue(const AColumnName: String; AColumnValue: Extended; ADecimalPlaces: Integer): ICQuery; overload;
    function SetValue(const AColumnName: String; AColumnValue: Double; ADecimalPlaces: Integer): ICQuery; overload;
    function SetValue(const AColumnName: String; AColumnValue: Currency; ADecimalPlaces: Integer): ICQuery; overload;
    function SetValue(const AColumnName: String; const AColumnValue: array of const): ICQuery; overload;
    function SetValue(const AColumnName: String; const AColumnValue: TDate): ICQuery; overload;
    function SetValue(const AColumnName: String; const AColumnValue: TDateTime): ICQuery; overload;
    function SetValue(const AColumnName: String; const AColumnValue: TGUID): ICQuery; overload;
    function Values(const AColumnName, AColumnValue: String): ICQuery; overload;
    function Values(const AColumnName: String; const AColumnValue: array of const): ICQuery; overload;
    function First(const AValue: Integer): ICQuery;
    function Skip(const AValue: Integer): ICQuery;
    function Update(const ATableName: String): ICQuery;
    function Where(const AExpression: String = ''): ICQuery; overload;
    function Where(const AExpression: array of const): ICQuery; overload;
    function Where(const AExpression: ICQueryCriteriaExpression): ICQuery; overload;
    // Operators methods
    function Equal(const AValue: String = ''): ICQuery; overload;
    function Equal(const AValue: Extended): ICQuery overload;
    function Equal(const AValue: Integer): ICQuery; overload;
    function Equal(const AValue: TDate): ICQuery; overload;
    function Equal(const AValue: TDateTime): ICQuery; overload;
    function Equal(const AValue: TGUID): ICQuery; overload;
    function NotEqual(const AValue: String = ''): ICQuery; overload;
    function NotEqual(const AValue: Extended): ICQuery; overload;
    function NotEqual(const AValue: Integer): ICQuery; overload;
    function NotEqual(const AValue: TDate): ICQuery; overload;
    function NotEqual(const AValue: TDateTime): ICQuery; overload;
    function NotEqual(const AValue: TGUID): ICQuery; overload;
    function GreaterThan(const AValue: Extended): ICQuery; overload;
    function GreaterThan(const AValue: Integer) : ICQuery; overload;
    function GreaterThan(const AValue: TDate): ICQuery; overload;
    function GreaterThan(const AValue: TDateTime) : ICQuery; overload;
    function GreaterEqThan(const AValue: Extended): ICQuery; overload;
    function GreaterEqThan(const AValue: Integer) : ICQuery; overload;
    function GreaterEqThan(const AValue: TDate): ICQuery; overload;
    function GreaterEqThan(const AValue: TDateTime) : ICQuery; overload;
    function LessThan(const AValue: Extended): ICQuery; overload;
    function LessThan(const AValue: Integer) : ICQuery; overload;
    function LessThan(const AValue: TDate): ICQuery; overload;
    function LessThan(const AValue: TDateTime) : ICQuery; overload;
    function LessEqThan(const AValue: Extended): ICQuery; overload;
    function LessEqThan(const AValue: Integer) : ICQuery; overload;
    function LessEqThan(const AValue: TDate): ICQuery; overload;
    function LessEqThan(const AValue: TDateTime) : ICQuery; overload;
    function IsNull: ICQuery;
    function IsNotNull: ICQuery;
    function Like(const AValue: String): ICQuery;
    function LikeFull(const AValue: String): ICQuery;
    function LikeLeft(const AValue: String): ICQuery;
    function LikeRight(const AValue: String): ICQuery;
    function NotLike(const AValue: String): ICQuery;
    function NotLikeFull(const AValue: String): ICQuery;
    function NotLikeLeft(const AValue: String): ICQuery;
    function NotLikeRight(const AValue: String): ICQuery;
    function InValues(const AValue: TArray<Double>): ICQuery; overload;
    function InValues(const AValue: TArray<String>): ICQuery; overload;
    function InValues(const AValue: String): ICQuery; overload;
    function NotIn(const AValue: TArray<Double>): ICQuery; overload;
    function NotIn(const AValue: TArray<String>): ICQuery; overload;
    function NotIn(const AValue: String): ICQuery; overload;
    function Exists(const AValue: String): ICQuery; overload;
    function NotExists(const AValue: String): ICQuery; overload;
    // Functions methods
    function Count: ICQuery;
    function Lower: ICQuery;
    function Min: ICQuery;
    function Max: ICQuery;
    function Upper: ICQuery;
    function SubString(const AStart: Integer; const ALength: Integer): ICQuery;
    function Date(const AValue: String): ICQuery;
    function Day(const AValue: String): ICQuery;
    function Month(const AValue: String): ICQuery;
    function Year(const AValue: String): ICQuery;
    function Concat(const AValue: array of String): ICQuery;
    // Result full command sql
    function AsFun: ICQueryFunctions;
    function AsString: String;
  end;

function TCQ(const ADatabase: TCQueryDriver): ICQuery;

implementation

function TCQ(const ADatabase: TCQueryDriver): ICQuery;
begin
  Result := TCQuery.Create(ADatabase);
end;

{ TCQuery }

function TCQuery.Alias(const AAlias: String): ICQuery;
begin
  _AssertSection([secSelect, secDelete, secJoin]);
  _AssertHaveName;
  FAST.ASTName.Alias := AAlias;
  Result := Self;
end;

function TCQuery.AsFun: ICQueryFunctions;
begin
  Result := FFunction;
end;

function TCQuery.CaseExpr(const AExpression: String): ICQueryCriteriaCase;
var
  LExpression: String;
begin
  LExpression := AExpression;
  if LExpression = '' then
    LExpression := FAST.ASTName.Name;
  Result := TCQueryCriteriaCase.Create(Self, LExpression);
  if Assigned(FAST) then
    FAST.ASTName.CaseExpr := Result.CaseExpr;
end;

function TCQuery.CaseExpr(const AExpression: array of const): ICQueryCriteriaCase;
begin
  Result := CaseExpr(TUtils.SqlParamsToStr(AExpression));
end;

function TCQuery.CaseExpr(const AExpression: ICQueryCriteriaExpression): ICQueryCriteriaCase;
begin
  Result := TCQueryCriteriaCase.Create(Self, '');
  Result.AndOpe(AExpression);
end;

function TCQuery.AndOpe(const AExpression: ICQueryCriteriaExpression): ICQuery;
begin
  FActiveOperator := opeAND;
  FActiveExpr.AndOpe(AExpression.Expression);
  Result := Self;
end;

function TCQuery.AndOpe(const AExpression: String): ICQuery;
begin
  FActiveOperator := opeAND;
  FActiveExpr.AndOpe(AExpression);
  Result := Self;
end;

function TCQuery.AndOpe(const AExpression: array of const): ICQuery;
begin
  Result := AndOpe(TUtils.SqlParamsToStr(AExpression));
end;

function TCQuery.OrOpe(const AExpression: array of const): ICQuery;
begin
  Result := OrOpe(TUtils.SqlParamsToStr(AExpression));
end;

function TCQuery.OrOpe(const AExpression: String): ICQuery;
begin
  FActiveOperator := opeOR;
  FActiveExpr.OrOpe(AExpression);
  Result := Self;
end;

function TCQuery.OrOpe(const AExpression: ICQueryCriteriaExpression): ICQuery;
begin
  FActiveOperator := opeOR;
  FActiveExpr.OrOpe(AExpression.Expression);
  Result := Self;
end;

function TCQuery.SetValue(const AColumnName: String; const AColumnValue: array of const): ICQuery;
begin
  Result := _InternalSet(AColumnName, TUtils.SqlParamsToStr(AColumnValue));
end;

function TCQuery.SetValue(const AColumnName, AColumnValue: String): ICQuery;
begin
  Result := _InternalSet(AColumnName, QuotedStr(AColumnValue));
end;

function TCQuery.OnCond(const AExpression: String): ICQuery;
begin
  Result := AndOpe(AExpression);
end;

function TCQuery.OnCond(const AExpression: array of const): ICQuery;
begin
  Result := OnCond(TUtils.SqlParamsToStr(AExpression));
end;

function TCQuery.InValues(const AValue: String): ICQuery;
begin
  _AssertOperator([opeWhere, opeAND, opeOR]);
  FActiveExpr.Ope(FOperator.IsIn(AValue));
  Result := Self;
end;

function TCQuery.SetValue(const AColumnName: String; AColumnValue: Integer): ICQuery;
begin
  Result := _InternalSet(AColumnName, IntToStr(AColumnValue));
end;

function TCQuery.SetValue(const AColumnName: String; AColumnValue: Extended; ADecimalPlaces: Integer): ICQuery;
var
  LFormat: TFormatSettings;
begin
  LFormat.DecimalSeparator := '.';
  Result := _InternalSet(AColumnName, Format('%.' + IntToStr(ADecimalPlaces) + 'f', [AColumnValue], LFormat));
end;

function TCQuery.SetValue(const AColumnName: String; AColumnValue: Double; ADecimalPlaces: Integer): ICQuery;
var
  LFormat: TFormatSettings;
begin
  LFormat.DecimalSeparator := '.';
  Result := _InternalSet(AColumnName, Format('%.' + IntToStr(ADecimalPlaces) + 'f', [AColumnValue], LFormat));
end;

function TCQuery.SetValue(const AColumnName: String; AColumnValue: Currency; ADecimalPlaces: Integer): ICQuery;
var
  LFormat: TFormatSettings;
begin
  LFormat.DecimalSeparator := '.';
  Result := _InternalSet(AColumnName, Format('%.' + IntToStr(ADecimalPlaces) + 'f', [AColumnValue], LFormat));
end;

function TCQuery.SetValue(const AColumnName: String;
  const AColumnValue: TDate): ICQuery;
begin
  Result := _InternalSet(AColumnName, QuotedStr(TUtils.DateToSQLFormat(FDatabase, AColumnValue)));
end;

function TCQuery.SetValue(const AColumnName: String;
  const AColumnValue: TDateTime): ICQuery;
begin
  Result := _InternalSet(AColumnName, QuotedStr(TUtils.DateTimeToSQLFormat(FDatabase, AColumnValue)));
end;

function TCQuery.SetValue(const AColumnName: String;
  const AColumnValue: TGUID): ICQuery;
begin
  Result := _InternalSet(AColumnName, TUtils.GuidStrToSQLFormat(FDatabase, AColumnValue));
end;

class procedure TCQuery.SetDatabaseDafault(const ADatabase: TCQueryDriver);
begin
  FDatabaseDafault := ADatabase;
end;

function TCQuery.All: ICQuery;
begin
  if not (FDatabase in [dbnMongoDB]) then
    Result := Column('*')
  else
    Result := Self;
end;

procedure TCQuery._AssertHaveName;
begin
  if not Assigned(FAST.ASTName) then
    raise Exception.Create('TCriteria: Current name is not set');
end;

procedure TCQuery._AssertOperator(AOperators: TOperators);
begin
  if not (FActiveOperator in AOperators) then
    raise Exception.Create('TCQuery: Not supported in this operator');
end;

procedure TCQuery._AssertSection(ASections: TSections);
begin
  if not (FActiveSection in ASections) then
    raise Exception.Create('TCQuery: Not supported in this section');
end;

function TCQuery.AsString: String;
begin
  FActiveOperator := opeNone;
  Result := FRegister.Serialize(FDatabase).AsString(FAST);
end;

function TCQuery.Column(const AColumnName: String): ICQuery;
begin
  if Assigned(FAST) then
  begin
    FAST.ASTName := FAST.ASTColumns.Add;
    FAST.ASTName.Name := AColumnName;
  end
  else
    raise Exception.CreateFmt('Current section [%s] does not support COLUMN.', [FAST.ASTSection.Name]);
  Result := Self;
end;

function TCQuery.Column(const ATableName: String; const AColumnName: String): ICQuery;
begin
  Result := Column(ATableName + '.' + AColumnName);
end;

function TCQuery.Clear: ICQuery;
begin
  FAST.ASTSection.Clear;
  Result := Self;
end;

function TCQuery.ClearAll: ICQuery;
begin
  FAST.Clear;
  Result := Self;
end;

function TCQuery.Column(const ACaseExpression: ICQueryCriteriaCase): ICQuery;
begin
  if Assigned(FAST.ASTColumns) then
  begin
    FAST.ASTName := FAST.ASTColumns.Add;
    FAST.ASTName.CaseExpr := ACaseExpression.CaseExpr;
  end
  else
    raise Exception.CreateFmt('Current section [%s] does not support COLUMN.', [FAST.ASTSection.Name]);
  Result := Self;
end;

function TCQuery.Concat(const AValue: array of String): ICQuery;
begin
  _AssertSection([secSelect, secJoin, secWhere]);
  _AssertHaveName;
  case FActiveSection of
    secSelect: FAST.ASTName.Name := FFunction.Concat(AValue);
    secWhere: FActiveExpr.Fun(FFunction.Concat(AValue));
  end;
  Result := Self;
end;

function TCQuery.Count: ICQuery;
begin
  _AssertSection([secSelect, secDelete, secJoin]);
  _AssertHaveName;
  FAST.ASTName.Name := FFunction.Count(FAST.ASTName.Name);
  Result := Self;
end;

function TCQuery.Column(const AColumnsName: array of const): ICQuery;
begin
  Result := Column(TUtils.SqlParamsToStr(AColumnsName));
end;

constructor TCQuery.Create(const ADatabase: TCQueryDriver);
begin
  FDatabase := ADatabase;
  FRegister := TCQueryRegister.Create;
  FOperator := TCQueryOperators.Create(FDatabase);
  FFunction := TCQueryFunctions.Create(FDatabase, FRegister);
  FAST := TCQueryAST.Create(FDatabase, FRegister);
  FAST.Clear;
  FActiveOperator := opeNone;
end;

function TCQuery._CreateJoin(AjoinType: TJoinType; const ATableName: String): ICQuery;
var
  LJoin: ICQueryJoin;
begin
  FActiveSection := secJoin;
  LJoin := FAST.Joins.Add;
  LJoin.JoinType := AjoinType;
  FAST.ASTName := LJoin.JoinedTable;
  FAST.ASTName.Name := ATableName;
  FAST.ASTSection := LJoin;
  FAST.ASTColumns := nil;
  FActiveExpr := TCQueryCriteriaExpression.Create(LJoin.Condition);
  Result := Self;
end;

function TCQuery.Date(const AValue: String): ICQuery;
begin
  _AssertSection([secSelect, secJoin, secWhere]);
  _AssertHaveName;
  case FActiveSection of
    secSelect: FAST.ASTName.Name := FFunction.Date(AValue);
    secWhere: FActiveExpr.Fun(FFunction.Date(AValue));
  end;
  Result := Self;
end;

function TCQuery.Day(const AValue: String): ICQuery;
begin
  _AssertSection([secSelect, secJoin, secWhere]);
  _AssertHaveName;
  case FActiveSection of
    secSelect: FAST.ASTName.Name := FFunction.Day(AValue);
    secWhere: FActiveExpr.Fun(FFunction.Day(AValue));
  end;
  Result := Self;
end;

procedure TCQuery._DefineSectionDelete;
begin
  ClearAll();
  FAST.ASTSection := FAST.Delete;
  FAST.ASTColumns := nil;
  FAST.ASTTableNames := FAST.Delete.TableNames;
  FActiveExpr := nil;
  FActiveValues := nil;
end;

procedure TCQuery._DefineSectionGroupBy;
begin
  FAST.ASTSection := FAST.GroupBy;
  FAST.ASTColumns := FAST.GroupBy.Columns;
  FAST.ASTTableNames := nil;
  FActiveExpr := nil;
  FActiveValues := nil;
end;

procedure TCQuery._DefineSectionHaving;
begin
  FAST.ASTSection := FAST.Having;
  FAST.ASTColumns   := nil;
  FActiveExpr := TCQueryCriteriaExpression.Create(FAST.Having.Expression);
  FAST.ASTTableNames := nil;
  FActiveValues := nil;
end;

procedure TCQuery._DefineSectionInsert;
begin
  ClearAll();
  FAST.ASTSection := FAST.Insert;
  FAST.ASTColumns := FAST.Insert.Columns;
  FAST.ASTTableNames := nil;
  FActiveExpr := nil;
  FActiveValues := FAST.Insert.Values;
end;

procedure TCQuery._DefineSectionOrderBy;
begin
  FAST.ASTSection := FAST.OrderBy;
  FAST.ASTColumns := FAST.OrderBy.Columns;
  FAST.ASTTableNames := nil;
  FActiveExpr := nil;
  FActiveValues := nil;
end;

procedure TCQuery._DefineSectionSelect;
begin
  ClearAll();
  FAST.ASTSection := FAST.Select;
  FAST.ASTColumns := FAST.Select.Columns;
  FAST.ASTTableNames := FAST.Select.TableNames;
  FActiveExpr := nil;
  FActiveValues := nil;
end;

procedure TCQuery._DefineSectionUpdate;
begin
  ClearAll();
  FAST.ASTSection := FAST.Update;
  FAST.ASTColumns := nil;
  FAST.ASTTableNames := nil;
  FActiveExpr := nil;
  FActiveValues := FAST.Update.Values;
end;

procedure TCQuery._DefineSectionWhere;
begin
  FAST.ASTSection := FAST.Where;
  FAST.ASTColumns := nil;
  FAST.ASTTableNames := nil;
  FActiveExpr := TCQueryCriteriaExpression.Create(FAST.Where.Expression);
  FActiveValues := nil;
end;

function TCQuery.Delete: ICQuery;
begin
  _SetSection(secDelete);
  Result := Self;
end;

function TCQuery.Desc: ICQuery;
begin
  _AssertSection([secOrderBy]);
  Assert(FAST.ASTColumns.Count > 0, 'TCriteria.Desc: No columns set up yet');
  (FAST.OrderBy.Columns[FAST.OrderBy.Columns.Count -1] as ICQueryOrderByColumn).Direction := dirDescending;
  Result := Self;
end;

destructor TCQuery.Destroy;
begin
  FActiveExpr := nil;
  FActiveValues := nil;
  FOperator := nil;
  FFunction := nil;
  FAST := nil;
  inherited;
end;

function TCQuery.Distinct: ICQuery;
var
  LQualifier: ICQuerySelectQualifier;
begin
  _AssertSection([secSelect]);
  LQualifier := FAST.Select.Qualifiers.Add;
  LQualifier.Qualifier := sqDistinct;
  // Esse método tem que Add o Qualifier já todo parametrizado.
  FAST.Select.Qualifiers.Add(LQualifier);
  Result := Self;
end;

function TCQuery.Equal(const AValue: Integer): ICQuery;
begin
  _AssertOperator([opeWhere, opeAND, opeOR]);
  FActiveExpr.Ope(FOperator.IsEqual(AValue));
  Result := Self;
end;

function TCQuery.Equal(const AValue: Extended): ICQuery;
begin
  _AssertOperator([opeWhere, opeAND, opeOR]);
  FActiveExpr.Ope(FOperator.IsEqual(AValue));
  Result := Self;
end;

function TCQuery.Equal(const AValue: String): ICQuery;
begin
  _AssertOperator([opeWhere, opeAND, opeOR]);
  if AValue = '' then
    FActiveExpr.Fun(FOperator.IsEqual(AValue))
  else
    FActiveExpr.Ope(FOperator.IsEqual(AValue));
  Result := Self;
end;

function TCQuery.Exists(const AValue: String): ICQuery;
begin
  _AssertOperator([opeWhere, opeAND, opeOR]);
  FActiveExpr.Ope(FOperator.IsExists(AValue));
  Result := Self;
end;

function TCQuery.Expression(const ATerm: array of const): ICQueryCriteriaExpression;
begin
  Result := Expression(TUtils.SqlParamsToStr(ATerm));
end;

function TCQuery.Expression(const ATerm: String): ICQueryCriteriaExpression;
begin
  Result := TCQueryCriteriaExpression.Create(ATerm);
end;

function TCQuery.From(const AExpression: ICQueryCriteriaExpression): ICQuery;
begin
  Result := From('(' + AExpression.AsString + ')');
end;

function TCQuery.From(const AQuery: ICQuery): ICQuery;
begin
  Result := From('(' + AQuery.AsString + ')');
end;

function TCQuery.From(const ATableName: String): ICQuery;
begin
  _AssertSection([secSelect, secDelete]);
  FAST.ASTName := FAST.ASTTableNames.Add;
  FAST.ASTName.Name := ATableName;
  Result := Self;
end;

function TCQuery.FullJoin(const ATableName: String): ICQuery;
begin
  Result := _CreateJoin(jtFULL, ATableName);
end;

function TCQuery.GreaterEqThan(const AValue: Integer): ICQuery;
begin
  _AssertOperator([opeWhere, opeAND, opeOR]);
  FActiveExpr.Ope(FOperator.IsGreaterEqThan(AValue));
  Result := Self;
end;

function TCQuery.GreaterEqThan(const AValue: Extended): ICQuery;
begin
  _AssertOperator([opeWhere, opeAND, opeOR]);
  FActiveExpr.Ope(FOperator.IsGreaterEqThan(AValue));
  Result := Self;
end;

function TCQuery.GreaterThan(const AValue: Integer): ICQuery;
begin
  _AssertOperator([opeWhere, opeAND, opeOR]);
  FActiveExpr.Ope(FOperator.IsGreaterThan(AValue));
  Result := Self;
end;

function TCQuery.GreaterThan(const AValue: Extended): ICQuery;
begin
  _AssertOperator([opeWhere, opeAND, opeOR]);
  FActiveExpr.Ope(FOperator.IsGreaterThan(AValue));
  Result := Self;
end;

function TCQuery.GroupBy(const AColumnName: String): ICQuery;
begin
  _SetSection(secGroupBy);
  if AColumnName = '' then
    Result := Self
  else
    Result := Column(AColumnName);
end;

function TCQuery.Having(const AExpression: String): ICQuery;
begin
  _SetSection(secHaving);
  if AExpression = '' then
    Result := Self
  else
    Result := AndOpe(AExpression);
end;

function TCQuery.Having(const AExpression: array of const): ICQuery;
begin
  Result := Having(TUtils.SqlParamsToStr(AExpression));
end;

function TCQuery.Having(const AExpression: ICQueryCriteriaExpression): ICQuery;
begin
  _SetSection(secHaving);
  Result := AndOpe(AExpression);
end;

function TCQuery.InnerJoin(const ATableName: String): ICQuery;
begin
  Result := _CreateJoin(jtINNER, ATableName);
end;

function TCQuery.InnerJoin(const ATableName, AAlias: String): ICQuery;
begin
  InnerJoin(ATableName).Alias(AAlias);
  Result := Self;
end;

function TCQuery.Insert: ICQuery;
begin
  _SetSection(secInsert);
  Result := Self;
end;

function TCQuery._InternalSet(const AColumnName, AColumnValue: String): ICQuery;
var
  LPair: ICQueryNameValue;
begin
  _AssertSection([secInsert, secUpdate]);
  LPair := FActiveValues.Add;
  LPair.Name := AColumnName;
  LPair.Value := AColumnValue;
  Result := Self;
end;

function TCQuery.Into(const ATableName: String): ICQuery;
begin
  _AssertSection([secInsert]);
  FAST.Insert.TableName := ATableName;
  Result := Self;
end;

function TCQuery.IsEmpty: Boolean;
begin
  Result := FAST.ASTSection.IsEmpty;
end;

function TCQuery.InValues(const AValue: TArray<String>): ICQuery;
begin
  _AssertOperator([opeWhere, opeAND, opeOR]);
  FActiveExpr.Ope(FOperator.IsIn(AValue));
  Result := Self;
end;

function TCQuery.InValues(const AValue: TArray<Double>): ICQuery;
begin
  _AssertOperator([opeWhere, opeAND, opeOR]);
  FActiveExpr.Ope(FOperator.IsIn(AValue));
  Result := Self;
end;

function TCQuery.IsNotNull: ICQuery;
begin
  _AssertOperator([opeWhere, opeAND, opeOR]);
  FActiveExpr.Ope(FOperator.IsNotNull);
  Result := Self;
end;

function TCQuery.IsNull: ICQuery;
begin
  _AssertOperator([opeWhere, opeAND, opeOR]);
  FActiveExpr.Ope(FOperator.IsNull);
  Result := Self;
end;

function TCQuery.LeftJoin(const ATableName: String): ICQuery;
begin
  Result := _CreateJoin(jtLEFT, ATableName);
end;

function TCQuery.LeftJoin(const ATableName, AAlias: String): ICQuery;
begin
  LeftJoin(ATableName).Alias(AAlias);
  Result := Self;
end;

function TCQuery.LessEqThan(const AValue: Integer): ICQuery;
begin
  _AssertOperator([opeWhere, opeAND, opeOR]);
  FActiveExpr.Ope(FOperator.IsLessEqThan(AValue));
  Result := Self;
end;

function TCQuery.LessEqThan(const AValue: Extended): ICQuery;
begin
  _AssertOperator([opeWhere, opeAND, opeOR]);
  FActiveExpr.Ope(FOperator.IsLessEqThan(AValue));
  Result := Self;
end;

function TCQuery.LessThan(const AValue: Integer): ICQuery;
begin
  _AssertOperator([opeWhere, opeAND, opeOR]);
  FActiveExpr.Ope(FOperator.IsLessThan(AValue));
  Result := Self;
end;

function TCQuery.LessThan(const AValue: Extended): ICQuery;
begin
  _AssertOperator([opeWhere, opeAND, opeOR]);
  FActiveExpr.Ope(FOperator.IsLessThan(AValue));
  Result := Self;
end;

function TCQuery.Like(const AValue: String): ICQuery;
begin
  _AssertOperator([opeWhere, opeAND, opeOR]);
  FActiveExpr.Ope(FOperator.IsLike(AValue));
  Result := Self;
end;

function TCQuery.LikeFull(const AValue: String): ICQuery;
begin
  _AssertOperator([opeWhere, opeAND, opeOR]);
  FActiveExpr.Ope(FOperator.IsLikeFull(AValue));
  Result := Self;
end;

function TCQuery.LikeLeft(const AValue: String): ICQuery;
begin
  _AssertOperator([opeWhere, opeAND, opeOR]);
  FActiveExpr.Ope(FOperator.IsLikeLeft(AValue));
  Result := Self;
end;

function TCQuery.LikeRight(const AValue: String): ICQuery;
begin
  _AssertOperator([opeWhere, opeAND, opeOR]);
  FActiveExpr.Ope(FOperator.IsLikeRight(AValue));
  Result := Self;
end;

function TCQuery.Lower: ICQuery;
begin
  _AssertSection([secSelect, secDelete, secJoin]);
  _AssertHaveName;
  FAST.ASTName.Name := FFunction.Lower(FAST.ASTName.Name);
  Result := Self;
end;

function TCQuery.Max: ICQuery;
begin
  _AssertSection([secSelect, secDelete, secJoin]);
  _AssertHaveName;
  FAST.ASTName.Name := FFunction.Max(FAST.ASTName.Name);
  Result := Self;
end;

function TCQuery.Min: ICQuery;
begin
  _AssertSection([secSelect, secDelete, secJoin]);
  _AssertHaveName;
  FAST.ASTName.Name := FFunction.Min(FAST.ASTName.Name);
  Result := Self;
end;

function TCQuery.Month(const AValue: String): ICQuery;
begin
  _AssertSection([secSelect, secJoin, secWhere]);
  _AssertHaveName;
  case FActiveSection of
    secSelect: FAST.ASTName.Name := FFunction.Month(AValue);
    secWhere: FActiveExpr.Fun(FFunction.Month(AValue));
  end;
  Result := Self;
end;

function TCQuery.NotEqual(const AValue: String): ICQuery;
begin
  _AssertOperator([opeWhere, opeAND, opeOR]);
  FActiveExpr.Ope(FOperator.IsNotEqual(AValue));
  Result := Self;
end;

function TCQuery.NotEqual(const AValue: Extended): ICQuery;
begin
  _AssertOperator([opeWhere, opeAND, opeOR]);
  FActiveExpr.Ope(FOperator.IsNotEqual(AValue));
  Result := Self;
end;

function TCQuery.NotEqual(const AValue: Integer): ICQuery;
begin
  _AssertOperator([opeWhere, opeAND, opeOR]);
  FActiveExpr.Ope(FOperator.IsNotEqual(AValue));
  Result := Self;
end;

function TCQuery.NotExists(const AValue: String): ICQuery;
begin
  _AssertOperator([opeWhere, opeAND, opeOR]);
  FActiveExpr.Ope(FOperator.IsNotExists(AValue));
  Result := Self;
end;

function TCQuery.NotIn(const AValue: TArray<String>): ICQuery;
begin
  _AssertOperator([opeWhere, opeAND, opeOR]);
  FActiveExpr.Ope(FOperator.IsNotIn(AValue));
  Result := Self;
end;

function TCQuery.NotIn(const AValue: TArray<Double>): ICQuery;
begin
  _AssertOperator([opeWhere, opeAND, opeOR]);
  FActiveExpr.Ope(FOperator.IsNotIn(AValue));
  Result := Self;
end;

function TCQuery.NotLike(const AValue: String): ICQuery;
begin
  _AssertOperator([opeWhere, opeAND, opeOR]);
  FActiveExpr.Ope(FOperator.IsNotLike(AValue));
  Result := Self;
end;

function TCQuery.NotLikeFull(const AValue: String): ICQuery;
begin
  _AssertOperator([opeWhere, opeAND, opeOR]);
  FActiveExpr.Ope(FOperator.IsNotLikeFull(AValue));
  Result := Self;
end;

function TCQuery.NotLikeLeft(const AValue: String): ICQuery;
begin
  _AssertOperator([opeWhere, opeAND, opeOR]);
  FActiveExpr.Ope(FOperator.IsNotLikeLeft(AValue));
  Result := Self;
end;

function TCQuery.NotLikeRight(const AValue: String): ICQuery;
begin
  _AssertOperator([opeWhere, opeAND, opeOR]);
  FActiveExpr.Ope(FOperator.IsNotLikeRight(AValue));
  Result := Self;
end;

function TCQuery.OrderBy(const ACaseExpression: ICQueryCriteriaCase): ICQuery;
begin
  _SetSection(secOrderBy);
  Result := Column(ACaseExpression);
end;

function TCQuery.RightJoin(const ATableName, AAlias: String): ICQuery;
begin
  RightJoin(ATableName).Alias(AAlias);
  Result := Self;
end;

function TCQuery.RightJoin(const ATableName: String): ICQuery;
begin
  Result := _CreateJoin(jtRIGHT, ATableName);
end;

function TCQuery.OrderBy(const AColumnName: String): ICQuery;
begin
  _SetSection(secOrderBy);
  if AColumnName = '' then
    Result := Self
  else
    Result := Column(AColumnName);
end;

function TCQuery.Select(const AColumnName: String): ICQuery;
begin
  _SetSection(secSelect);
  if AColumnName = '' then
    Result := Self
  else
    Result := Column(AColumnName);
end;

function TCQuery.Select(const ACaseExpression: ICQueryCriteriaCase): ICQuery;
begin
  _SetSection(secSelect);
  Result := Column(ACaseExpression);
end;

procedure TCQuery._SetSection(ASection: TSection);
begin
  case ASection of
    secSelect:  _DefineSectionSelect;
    secDelete:  _DefineSectionDelete;
    secInsert:  _DefineSectionInsert;
    secUpdate:  _DefineSectionUpdate;
    secWhere:   _DefineSectionWhere;
    secGroupBy: _DefineSectionGroupBy;
    secHaving:  _DefineSectionHaving;
    secOrderBy: _DefineSectionOrderBy;
  else
      raise Exception.Create('TCriteria.SetSection: Unknown section');
  end;
  FActiveSection := ASection;
end;

function TCQuery.First(const AValue: Integer): ICQuery;
var
  LQualifier: ICQuerySelectQualifier;
begin
  _AssertSection([secSelect, secWhere, secOrderBy]);
  LQualifier := FAST.Select.Qualifiers.Add;
  LQualifier.Qualifier := sqFirst;
  LQualifier.Value := AValue;
  // Esse método tem que Add o Qualifier já todo parametrizado.
  FAST.Select.Qualifiers.Add(LQualifier);
  Result := Self;
end;

function TCQuery.Skip(const AValue: Integer): ICQuery;
var
  LQualifier: ICQuerySelectQualifier;
begin
  _AssertSection([secSelect, secWhere, secOrderBy]);
  LQualifier := FAST.Select.Qualifiers.Add;
  LQualifier.Qualifier := sqSkip;
  LQualifier.Value := AValue;
  // Esse método tem que Add o Qualifier já todo parametrizado.
  FAST.Select.Qualifiers.Add(LQualifier);
  Result := Self;
end;

function TCQuery.SubString(const AStart, ALength: Integer): ICQuery;
begin
  _AssertSection([secSelect, secDelete, secJoin]);
  _AssertHaveName;
  FAST.ASTName.Name := FFunction.SubString(FAST.ASTName.Name, AStart, ALength);
  Result := Self;
end;

function TCQuery.Update(const ATableName: String): ICQuery;
begin
  _SetSection(secUpdate);
  FAST.Update.TableName := ATableName;
  Result := Self;
end;

function TCQuery.Upper: ICQuery;
begin
  _AssertSection([secSelect, secDelete, secJoin]);
  _AssertHaveName;
  FAST.ASTName.Name := FFunction.Upper(FAST.ASTName.Name);
  Result := Self;
end;

function TCQuery.Values(const AColumnName: String; const AColumnValue: array of const): ICQuery;
begin
  Result := _InternalSet(AColumnName, TUtils.SqlParamsToStr(AColumnValue));
end;

function TCQuery.Values(const AColumnName, AColumnValue: String): ICQuery;
begin
  Result := _InternalSet(AColumnName, QuotedStr(AColumnValue));
end;

function TCQuery.Where(const AExpression: String): ICQuery;
begin
  _SetSection(secWhere);
  FActiveOperator := opeWhere;
  if AExpression = '' then
    Result := Self
  else
    Result := AndOpe(AExpression);
end;

function TCQuery.Where(const AExpression: array of const): ICQuery;
begin
  Result := Where(TUtils.SqlParamsToStr(AExpression));
end;

function TCQuery.Where(const AExpression: ICQueryCriteriaExpression): ICQuery;
begin
  _SetSection(secWhere);
  FActiveOperator := opeWhere;
  Result := AndOpe(AExpression);
end;

function TCQuery.Year(const AValue: String): ICQuery;
begin
  _AssertSection([secSelect, secJoin, secWhere]);
  _AssertHaveName;
  case FActiveSection of
    secSelect: FAST.ASTName.Name := FFunction.Year(AValue);
    secWhere: FActiveExpr.Fun(FFunction.Year(AValue));
  end;
  Result := Self;
end;

function TCQuery.From(const ATableName, AAlias: String): ICQuery;
begin
  From(ATableName).Alias(AAlias);
  Result := Self;
end;

function TCQuery.FullJoin(const ATableName, AAlias: String): ICQuery;
begin
  FullJoin(ATableName).Alias(AAlias);
  Result := Self;
end;

function TCQuery.NotIn(const AValue: String): ICQuery;
begin
  _AssertOperator([opeWhere, opeAND, opeOR]);
  FActiveExpr.Ope(FOperator.IsNotIn(AValue));
  Result := Self;
end;

function TCQuery.Equal(const AValue: TDateTime): ICQuery;
begin
  _AssertOperator([opeWhere, opeAND, opeOR]);
  FActiveExpr.Ope(FOperator.IsEqual(AValue));
  Result := Self;
end;

function TCQuery.Equal(const AValue: TDate): ICQuery;
begin
  _AssertOperator([opeWhere, opeAND, opeOR]);
  FActiveExpr.Ope(FOperator.IsEqual(AValue));
  Result := Self;
end;

function TCQuery.GreaterEqThan(const AValue: TDateTime): ICQuery;
begin
  _AssertOperator([opeWhere, opeAND, opeOR]);
  FActiveExpr.Ope(FOperator.IsGreaterEqThan(AValue));
  Result := Self;
end;

function TCQuery.GreaterEqThan(const AValue: TDate): ICQuery;
begin
  _AssertOperator([opeWhere, opeAND, opeOR]);
  FActiveExpr.Ope(FOperator.IsGreaterEqThan(AValue));
  Result := Self;
end;

function TCQuery.GreaterThan(const AValue: TDate): ICQuery;
begin
  _AssertOperator([opeWhere, opeAND, opeOR]);
  FActiveExpr.Ope(FOperator.IsGreaterThan(AValue));
  Result := Self;
end;

function TCQuery.GreaterThan(const AValue: TDateTime): ICQuery;
begin
  _AssertOperator([opeWhere, opeAND, opeOR]);
  FActiveExpr.Ope(FOperator.IsGreaterThan(AValue));
  Result := Self;
end;

function TCQuery.LessEqThan(const AValue: TDateTime): ICQuery;
begin
  _AssertOperator([opeWhere, opeAND, opeOR]);
  FActiveExpr.Ope(FOperator.IsLessEqThan(AValue));
  Result := Self;
end;

function TCQuery.LessEqThan(const AValue: TDate): ICQuery;
begin
  _AssertOperator([opeWhere, opeAND, opeOR]);
  FActiveExpr.Ope(FOperator.IsLessEqThan(AValue));
  Result := Self;
end;

function TCQuery.LessThan(const AValue: TDateTime): ICQuery;
begin
  _AssertOperator([opeWhere, opeAND, opeOR]);
  FActiveExpr.Ope(FOperator.IsLessThan(AValue));
  Result := Self;
end;

function TCQuery.LessThan(const AValue: TDate): ICQuery;
begin
  _AssertOperator([opeWhere, opeAND, opeOR]);
  FActiveExpr.Ope(FOperator.IsLessThan(AValue));
  Result := Self;
end;

function TCQuery.NotEqual(const AValue: TDate): ICQuery;
begin
  _AssertOperator([opeWhere, opeAND, opeOR]);
  FActiveExpr.Ope(FOperator.IsNotEqual(AValue));
  Result := Self;
end;

function TCQuery.NotEqual(const AValue: TDateTime): ICQuery;
begin
  _AssertOperator([opeWhere, opeAND, opeOR]);
  FActiveExpr.Ope(FOperator.IsNotEqual(AValue));
  Result := Self;
end;

function TCQuery.Equal(const AValue: TGUID): ICQuery;
begin
  _AssertOperator([opeWhere, opeAND, opeOR]);
  FActiveExpr.Ope(FOperator.IsEqual(AValue));
  Result := Self;
end;

function TCQuery.NotEqual(const AValue: TGUID): ICQuery;
begin
  _AssertOperator([opeWhere, opeAND, opeOR]);
  FActiveExpr.Ope(FOperator.IsNotEqual(AValue));
  Result := Self;
end;

end.



