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

unit CQuery.Interfaces;


{$ifdef fpc}
  {$mode delphi}{$H+}
{$endif}

interface

type
  TExpressionOperation = (opNone, opAND, opOR, opOperation, opFunction);
  TOperator = (opeNone, opeWhere, opeAND, opeOR);
  TOperators = set of TOperator;
  TCQueryDriver = (dbnMSSQL, dbnMySQL, dbnFirebird, dbnSQLite, dbnInterbase, dbnDB2,
                   dbnOracle, dbnInformix, dbnPostgreSQL, dbnADS, dbnASA,
                   dbnAbsoluteDB, dbnMongoDB, dbnElevateDB, dbnNexusDB);

  ICQuery = interface;
  ICQueryAST = interface;
  ICQueryFunctions = interface;

  ICQueryExpression = interface
    ['{D1DA5991-9755-485A-A031-9C25BC42A2AA}']
    function GetLeft: ICQueryExpression;
    function GetOperation: TExpressionOperation;
    function GetRight: ICQueryExpression;
    function GetTerm: String;
    procedure SetLeft(const value: ICQueryExpression);
    procedure SetOperation(const value: TExpressionOperation);
    procedure SetRight(const value: ICQueryExpression);
    procedure SetTerm(const value: String);
    procedure Assign(const ANode: ICQueryExpression);
    procedure Clear;
    function IsEmpty: Boolean;
    function Serialize(AAddParens: Boolean = False): String;
    property Term: String read GetTerm write SetTerm;
    property Operation: TExpressionOperation read GetOperation write SetOperation;
    property Left: ICQueryExpression read GetLeft write SetLeft;
    property Right: ICQueryExpression read GetRight write SetRight;
  end;

  ICQueryCriteriaExpression = interface
    ['{E55E5EAC-BA0A-49C7-89AF-C2BAF51E5561}']
    function AndOpe(const AExpression: array of const): ICQueryCriteriaExpression; overload;
    function AndOpe(const AExpression: String): ICQueryCriteriaExpression; overload;
    function AndOpe(const AExpression: ICQueryExpression): ICQueryCriteriaExpression; overload;
    function OrOpe(const AExpression: array of const): ICQueryCriteriaExpression; overload;
    function OrOpe(const AExpression: String): ICQueryCriteriaExpression; overload;
    function OrOpe(const AExpression: ICQueryExpression): ICQueryCriteriaExpression; overload;
    function Ope(const AExpression: array of const): ICQueryCriteriaExpression; overload;
    function Ope(const AExpression: String): ICQueryCriteriaExpression; overload;
    function Ope(const AExpression: ICQueryExpression): ICQueryCriteriaExpression; overload;
    function Fun(const AExpression: array of const): ICQueryCriteriaExpression; overload;
    function Fun(const AExpression: String): ICQueryCriteriaExpression; overload;
    function Fun(const AExpression: ICQueryExpression): ICQueryCriteriaExpression; overload;
    function AsString: String;
    function Expression: ICQueryExpression;
  end;

  ICQueryCaseWhenThen = interface
    ['{C08E0BA8-87EA-4DA7-A4F2-DD718DB2E972}']
    function GetThenExpression: ICQueryExpression;
    function GetWhenExpression: ICQueryExpression;
    procedure SetThenExpression(const AValue: ICQueryExpression);
    procedure SetWhenExpression(const AValue: ICQueryExpression);
    //
    property WhenExpression: ICQueryExpression read GetWhenExpression write SetWhenExpression;
    property ThenExpression: ICQueryExpression read GetThenExpression write SetThenExpression;
  end;

  ICQueryCaseWhenList = interface
    ['{CD02CC25-7261-4C37-8D22-532320EFAEB1}']
    function GetWhenThen(AIdx: Integer): ICQueryCaseWhenThen;
    procedure SetWhenThen(AIdx: Integer; const AValue: ICQueryCaseWhenThen);
    //
    function Add: ICQueryCaseWhenThen; overload;
    function Add(const AWhenThen: ICQueryCaseWhenThen): Integer; overload;
    function Count: Integer;
    property WhenThen[AIdx: Integer]: ICQueryCaseWhenThen read GetWhenThen write SetWhenThen; default;
  end;

  ICQueryCase = interface
    ['{C3CDCEE4-990A-4709-9B24-D0A1DF2E3373}']
    function GetCaseExpression: ICQueryExpression;
    function GetElseExpression: ICQueryExpression;
    function GetWhenList: ICQueryCaseWhenList;
    procedure SetCaseExpression(const AValue: ICQueryExpression);
    procedure SetElseExpression(const AValue: ICQueryExpression);
    procedure SetWhenList(const AValue: ICQueryCaseWhenList);
    //
    function Serialize: String;
    property CaseExpression: ICQueryExpression read GetCaseExpression write SetCaseExpression;
    property WhenList: ICQueryCaseWhenList read GetWhenList write SetWhenList;
    property ElseExpression: ICQueryExpression read GetElseExpression write SetElseExpression;
  end;

  ICQueryCriteriaCase = interface
    ['{B542AEE6-5F0D-4547-A7DA-87785432BC65}']
    function _GetCase: ICQueryCase;
    //
    function AndOpe(const AExpression: array of const): ICQueryCriteriaCase; overload;
    function AndOpe(const AExpression: String): ICQueryCriteriaCase; overload;
    function AndOpe(const AExpression: ICQueryCriteriaExpression): ICQueryCriteriaCase; overload;
    function ElseIf(const AValue: String): ICQueryCriteriaCase; overload;
    function ElseIf(const AValue: int64): ICQueryCriteriaCase; overload;
    function EndCase: ICQuery;
    function OrOpe(const AExpression: array of const): ICQueryCriteriaCase; overload;
    function OrOpe(const AExpression: String): ICQueryCriteriaCase; overload;
    function OrOpe(const AExpression: ICQueryCriteriaExpression): ICQueryCriteriaCase; overload;
    function IfThen(const AValue: String): ICQueryCriteriaCase; overload;
    function IfThen(const AValue: int64): ICQueryCriteriaCase; overload;
    function When(const ACondition: String): ICQueryCriteriaCase; overload;
    function When(const ACondition: array of const): ICQueryCriteriaCase; overload;
    function When(const ACondition: ICQueryCriteriaExpression): ICQueryCriteriaCase; overload;
    property CaseExpr: ICQueryCase read _GetCase;
  end;

  ICQuery = interface
    ['{DFDEA57B-A75B-450E-A576-DC49523B01E7}']
    function AndOpe(const AExpression: array of const): ICQuery; overload;
    function AndOpe(const AExpression: String): ICQuery; overload;
    function AndOpe(const AExpression: ICQueryCriteriaExpression): ICQuery; overload;
    function Alias(const AAlias: String): ICQuery;
    function CaseExpr(const AExpression: String = ''): ICQueryCriteriaCase; overload;
    function CaseExpr(const AExpression: array of const): ICQueryCriteriaCase; overload;
    function CaseExpr(const AExpression: ICQueryCriteriaExpression): ICQueryCriteriaCase; overload;
    function OnCond(const AExpression: String): ICQuery; overload;
    function OnCond(const AExpression: array of const): ICQuery; overload;
    function OrOpe(const AExpression: array of const): ICQuery; overload;
    function OrOpe(const AExpression: String): ICQuery; overload;
    function OrOpe(const AExpression: ICQueryCriteriaExpression): ICQuery; overload;
    function SetValue(const AColumnName, AColumnValue: String): ICQuery; overload;
    function SetValue(const AColumnName: String; AColumnValue: Integer): ICQuery; overload;
    function SetValue(const AColumnName: String; AColumnValue: Extended; ADecimalPlaces: Integer): ICQuery; overload;
    function SetValue(const AColumnName: String; AColumnValue: Double; ADecimalPlaces: Integer): ICQuery; overload;
    function SetValue(const AColumnName: String; AColumnValue: Currency; ADecimalPlaces: Integer): ICQuery; overload;
    function SetValue(const AColumnName: String; const AColumnValue: array of const): ICQuery; overload;
    function SetValue(const AColumnName: String; const AColumnValue: TDate): ICQuery; overload;
    function SetValue(const AColumnName: String; const AColumnValue: TDateTime): ICQuery; overload;
    function SetValue(const AColumnName: String; const AColumnValue: TGUID): ICQuery; overload;
    function All: ICQuery;
    function Clear: ICQuery;
    function ClearAll: ICQuery;
    function Column(const AColumnName: String = ''): ICQuery; overload;
    function Column(const ATableName: String; const AColumnName: String): ICQuery; overload;
    function Column(const AColumnsName: array of const): ICQuery; overload;
    function Column(const ACaseExpression: ICQueryCriteriaCase): ICQuery; overload;
    function Delete: ICQuery;
    function Desc: ICQuery;
    function Distinct: ICQuery;
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
    function FullJoin(const ATableName: String): ICQuery; overload;
    function InnerJoin(const ATableName: String): ICQuery; overload;
    function LeftJoin(const ATableName: String): ICQuery; overload;
    function RightJoin(const ATableName: String): ICQuery; overload;
    function FullJoin(const ATableName: String; const AAlias: String): ICQuery; overload;
    function InnerJoin(const ATableName: String; const AAlias: String): ICQuery; overload;
    function LeftJoin(const ATableName: String; const AAlias: String): ICQuery; overload;
    function RightJoin(const ATableName: String; const AAlias: String): ICQuery; overload;
    function Insert: ICQuery;
    function Into(const ATableName: String): ICQuery;
    function IsEmpty: Boolean;
    function OrderBy(const AColumnName: String = ''): ICQuery; overload;
    function OrderBy(const ACaseExpression: ICQueryCriteriaCase): ICQuery; overload;
    function Select(const AColumnName: String = ''): ICQuery; overload;
    function Select(const ACaseExpression: ICQueryCriteriaCase): ICQuery; overload;
    function First(const AValue: Integer): ICQuery;
    function Skip(const AValue: Integer): ICQuery;
    function Update(const ATableName: String): ICQuery;
    function Where(const AExpression: String = ''): ICQuery; overload;
    function Where(const AExpression: array of const): ICQuery; overload;
    function Where(const AExpression: ICQueryCriteriaExpression): ICQuery; overload;
    function Values(const AColumnName, AColumnValue: String): ICQuery; overload;
    function Values(const AColumnName: String; const AColumnValue: array of const): ICQuery; overload;
    // Operators functions
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
    function GreaterThan(const AValue: TDateTime): ICQuery; overload;
    function GreaterEqThan(const AValue: Extended): ICQuery; overload;
    function GreaterEqThan(const AValue: Integer) : ICQuery; overload;
    function GreaterEqThan(const AValue: TDate): ICQuery; overload;
    function GreaterEqThan(const AValue: TDateTime): ICQuery; overload;
    function LessThan(const AValue: Extended): ICQuery; overload;
    function LessThan(const AValue: Integer) : ICQuery; overload;
    function LessThan(const AValue: TDate): ICQuery; overload;
    function LessThan(const AValue: TDateTime): ICQuery; overload;
    function LessEqThan(const AValue: Extended): ICQuery; overload;
    function LessEqThan(const AValue: Integer) : ICQuery; overload;
    function LessEqThan(const AValue: TDate) : ICQuery; overload;
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
    //
    function AsFun: ICQueryFunctions;
    function AsString: String;
  end;

  ICQueryName = interface
    ['{FA82F4B9-1202-4926-8385-C2100EB0CA97}']
    function _GetAlias: String;
    function _GetCase: ICQueryCase;
    function _GetName: String;
    procedure _SetAlias(const Value: String);
    procedure _SetCase(const Value: ICQueryCase);
    procedure _SetName(const Value: String);
    //
    procedure Clear;
    function IsEmpty: Boolean;
    function Serialize: String;
    property Name: String read _GetName write _SetName;
    property Alias: String read _GetAlias write _SetAlias;
    property CaseExpr: ICQueryCase read _GetCase write _SetCase;
  end;

  ICQueryNames = interface
    ['{6030F621-276C-4C52-9135-F029BEEEB39C}']
    function GetColumns(AIdx: Integer): ICQueryName;
    //
    function Add: ICQueryName; overload;
    procedure Add(const Value: ICQueryName); overload;
    procedure Clear;
    function Count: Integer;
    function IsEmpty: Boolean;
    function Serialize: String;
    property Columns[AIdx: Integer]: ICQueryName read GetColumns; default;
  end;

  ICQuerySection = interface
    ['{6FA93873-2285-4A08-B700-7FBAAE846F73}']
    function _GetName: String;
    //
    procedure Clear;
    function IsEmpty: Boolean;
    property Name: String read _GetName;
  end;

  TOrderByDirection = (dirAscending, dirDescending);

  ICQueryOrderByColumn = interface(ICQueryName)
    ['{AC57006D-9087-4319-8258-97E68801503A}']
    function _GetDirection: TOrderByDirection;
    procedure _SetDirection(const value: TOrderByDirection);
    //
    property Direction: TOrderByDirection read _GetDirection write _SetDirection;
  end;

  ICQueryOrderBy = interface(ICQuerySection)
    ['{8D3484F7-9856-4232-AFD5-A80FB4F7833E}']
    function Columns: ICQueryNames;
    function Serialize: String;
  end;

  TSelectQualifierType = (sqFirst, sqSkip, sqDistinct);

  ICQuerySelectQualifier = interface
    ['{44EBF85E-10BB-45C0-AC6E-336A82B3A81D}']
    function  _GetQualifier: TSelectQualifierType;
    function  _GetValue: Integer;
    procedure _SetQualifier(const Value: TSelectQualifierType);
    procedure _SetValue(const Value: Integer);
    //
    property Qualifier: TSelectQualifierType read _GetQualifier write _SetQualifier;
    property Value: Integer read _GetValue write _SetValue;
  end;

  ICQuerySelectQualifiers = interface
    ['{4AC225D9-2447-4906-8285-23D55F59B676}']
    function _GetQualifier(AIdx: Integer): ICQuerySelectQualifier;
    //
    function Add: ICQuerySelectQualifier; overload;
    procedure Add(AQualifier: ICQuerySelectQualifier); overload;
    procedure Clear;
    function ExecutingPagination: Boolean;
    function Count: Integer;
    function IsEmpty: Boolean;
    function SerializePagination: String;
    function SerializeDistinct: String;
    property Qualifier[AIdx: Integer]: ICQuerySelectQualifier read _GetQualifier; default;
  end;

  ICQuerySelect = interface(ICQuerySection)
    ['{E7EE1220-ACB9-4A02-82E5-C4F51AD2D333}']
    procedure Clear;
    function IsEmpty: Boolean;
    function Columns: ICQueryNames;
    function TableNames: ICQueryNames;
    function Qualifiers: ICQuerySelectQualifiers;
    function Serialize: String;
  end;

  ICQueryWhere = interface(ICQuerySection)
    ['{664D8830-662B-4993-BD9C-325E6C1A2ACA}']
    function _GetExpression: ICQueryExpression;
    procedure _SetExpression(const Value: ICQueryExpression);
    //
    function Serialize: String;
    property Expression: ICQueryExpression read _GetExpression write _SetExpression;
  end;

  ICQueryDelete = interface(ICQuerySection)
    ['{8823EABF-FCFB-4BDE-AF56-7053944D40DB}']
    function TableNames: ICQueryNames;
    function Serialize: String;
  end;

  TJoinType = (jtINNER, jtLEFT, jtRIGHT, jtFULL);

  ICQueryJoin = interface(ICQuerySection)
    ['{BCB6DF85-05DE-43A0-8622-5627B88FB914}']
    function _GetCondition: ICQueryExpression;
    function _GetJoinedTable: ICQueryName;
    function _GetJoinType: TJoinType;
    procedure _SetCondition(const Value: ICQueryExpression);
    procedure _SetJoinedTable(const Value: ICQueryName);
    procedure _SetJoinType(const Value: TJoinType);
    //
    property JoinedTable: ICQueryName read _GetJoinedTable write _SetJoinedTable;
    property JoinType: TJoinType read _GetJoinType write _SetJoinType;
    property Condition: ICQueryExpression read _GetCondition write _SetCondition;
  end;

  ICQueryJoins = interface
    ['{2A9F9075-01C3-433A-9E65-0264688D2E88}']
    function _GetJoins(AIdx: Integer): ICQueryJoin;
    procedure _SetJoins(AIdx: Integer; const Value: ICQueryJoin);
    //
    function Add: ICQueryJoin; overload;
    procedure Add(const AJoin: ICQueryJoin); overload;
    procedure Clear;
    function Count: Integer;
    function IsEmpty: Boolean;
    function Serialize: String;
    property Joins[AIidx: Integer]: ICQueryJoin read _GetJoins write _SetJoins; default;
  end;

  ICQueryGroupBy = interface(ICQuerySection)
    ['{820E003C-81FF-49BB-A7AC-2F00B58BE497}']
    function Columns: ICQueryNames;
    function Serialize: String;
  end;

  ICQueryHaving = interface(ICQuerySection)
    ['{FAD8D0B5-CF5A-4615-93A5-434D4B399E28}']
    function _GetExpression: ICQueryExpression;
    procedure _SetExpression(const Value: ICQueryExpression);
    //
    function Serialize: String;
    property Expression: ICQueryExpression read _GetExpression write _SetExpression;
  end;

  ICQueryNameValue = interface
    ['{FC6C53CA-7CD1-475B-935C-B356E73105CF}']
    function  _GetName: String;
    function  _GetValue: String;
    procedure _SetName(const Value: String);
    procedure _SetValue(const Value: String);
    //
    procedure Clear;
    function IsEmpty: Boolean;
    property Name: String read _GetName write _SetName;
    property Value: String read _GetValue write _SetValue;
  end;

  ICQueryNameValuePairs = interface
    ['{561CA151-60B9-45E1-A443-5BAEC88DA955}']
    function  _GetItem(AIdx: integer): ICQueryNameValue;
    //
    function Add: ICQueryNameValue; overload;
    procedure Add(const ANameValue: ICQueryNameValue); overload;
    procedure Clear;
    function Count: Integer;
    function IsEmpty: Boolean;
    property Item[AIdx: Integer]: ICQueryNameValue read _GetItem; default;
  end;

  ICQueryInsert = interface(ICQuerySection)
    ['{61136DB2-EBEB-46D1-8B9B-F5B6DBD1A423}']
    function  _GetTableName: String;
    procedure _SetTableName(const value: String);
    //
    function Columns: ICQueryNames;
    function Values: ICQueryNameValuePairs;
    function Serialize: String;
    property TableName: String read _GetTableName write _SetTableName;
  end;

  ICQueryUpdate = interface(ICQuerySection)
    ['{90F7AC38-6E5A-4F5F-9A78-482FE2DBF7B1}']
    function  _GetTableName: String;
    procedure _SetTableName(const value: String);
    //
    function Values: ICQueryNameValuePairs;
    function Serialize: String;
    property TableName: String read _GetTableName write _SetTableName;
  end;

  ICQueryAST = interface
    ['{09DC93FD-ABC4-4999-80AE-124EC1CAE9AC}']
    function _GetASTColumns: ICQueryNames;
    procedure _SetASTColumns(const Value: ICQueryNames);
    function _GetASTSection: ICQuerySection;
    procedure _SetASTSection(const Value: ICQuerySection);
    function _GetASTName: ICQueryName;
    procedure _SetASTName(const Value: ICQueryName);
    function _GetASTTableNames: ICQueryNames;
    procedure _SetASTTableNames(const Value: ICQueryNames);
    //
    procedure Clear;
    function IsEmpty: Boolean;
    function Select: ICQuerySelect;
    function Delete: ICQueryDelete;
    function Insert: ICQueryInsert;
    function Update: ICQueryUpdate;
    function Joins: ICQueryJoins;
    function Where: ICQueryWhere;
    function GroupBy: ICQueryGroupBy;
    function Having: ICQueryHaving;
    function OrderBy: ICQueryOrderBy;
    property ASTColumns: ICQueryNames read _GetASTColumns write _SetASTColumns;
    property ASTSection: ICQuerySection read _GetASTSection write _SetASTSection;
    property ASTName: ICQueryName read _GetASTName write _SetASTName;
    property ASTTableNames: ICQueryNames read _GetASTTableNames write _SetASTTableNames;
  end;

  ICQuerySerialize = interface
    ['{8F7A3C1F-2704-401F-B1DF-D334EEFFC8B7}']
    function AsString(const AAST: ICQueryAST): String;
  end;

  TCQueryOperatorCompare  = (fcEqual, fcNotEqual,
                             fcGreater, fcGreaterEqual,
                             fcLess, fcLessEqual,
                             fcIn, fcNotIn,
                             fcIsNull, fcIsNotNull,
                             fcBetween, fcNotBetween,
                             fcExists, fcNotExists,
                             fcLikeFull, fcLikeLeft, fcLikeRight,
                             fcNotLikeFull, fcNotLikeLeft, fcNotLikeRight,
                             fcLike, fcNotLike);

  TCQueryDataFieldType = (dftUnknown, dftString, dftInteger, dftFloat, dftDate,
                          dftArray, dftText, dftDateTime, dftGuid, dftBoolean);

  ICQueryOperator = interface
    ['{A07D4935-0C52-4D8A-A3CF-5837AFE01C75}']
    function _GetColumnName: String;
    function _GetCompare: TCQueryOperatorCompare;
    function _GetValue: Variant;
    function _GetDataType: TCQueryDataFieldType;
    procedure _SetColumnName(const Value: String);
    procedure _SetCompare(const Value: TCQueryOperatorCompare);
    procedure _SetValue(const Value: Variant);
    procedure _SetDataType(const Value: TCQueryDataFieldType);
    //
    property ColumnName: String read _GetColumnName write _SetColumnName;
    property Compare: TCQueryOperatorCompare read _GetCompare write _SetCompare;
    property Value: Variant read _GetValue write _SetValue;
    property DataType: TCQueryDataFieldType read _GetDataType   write _SetDataType;
    function AsString: String;
  end;

  ICQueryOperators = interface
    ['{7F855D42-FB26-4F21-BCBE-93BC407ED15B}']
    function IsEqual(const AValue: Extended) : String; overload;
    function IsEqual(const AValue: Integer): String; overload;
    function IsEqual(const AValue: String): String; overload;
    function IsEqual(const AValue: TDate): String; overload;
    function IsEqual(const AValue: TDateTime): String; overload;
    function IsEqual(const AValue: TGUID): String; overload;
    function IsNotEqual(const AValue: Extended): String; overload;
    function IsNotEqual(const AValue: Integer): String; overload;
    function IsNotEqual(const AValue: String): String; overload;
    function IsNotEqual(const AValue: TDate): String; overload;
    function IsNotEqual(const AValue: TDateTime): String; overload;
    function IsNotEqual(const AValue: TGUID): String; overload;
    function IsGreaterThan(const AValue: Extended): String; overload;
    function IsGreaterThan(const AValue: Integer): String; overload;
    function IsGreaterThan(const AValue: TDate): String; overload;
    function IsGreaterThan(const AValue: TDateTime): String; overload;
    function IsGreaterEqThan(const AValue: Extended): String; overload;
    function IsGreaterEqThan(const AValue: Integer): String; overload;
    function IsGreaterEqThan(const AValue: TDate): String; overload;
    function IsGreaterEqThan(const AValue: TDateTime): String; overload;
    function IsLessThan(const AValue: Extended): String; overload;
    function IsLessThan(const AValue: Integer): String; overload;
    function IsLessThan(const AValue: TDate): String; overload;
    function IsLessThan(const AValue: TDateTime): String; overload;
    function IsLessEqThan(const AValue: Extended): String; overload;
    function IsLessEqThan(const AValue: Integer) : String; overload;
    function IsLessEqThan(const AValue: TDate) : String; overload;
    function IsLessEqThan(const AValue: TDateTime) : String; overload;
    function IsNull: String;
    function IsNotNull: String;
    function IsLike(const AValue: String): String;
    function IsLikeFull(const AValue: String): String;
    function IsLikeLeft(const AValue: String): String;
    function IsLikeRight(const AValue: String): String;
    function IsNotLike(const AValue: String): String;
    function IsNotLikeFull(const AValue: String): String;
    function IsNotLikeLeft(const AValue: String): String;
    function IsNotLikeRight(const AValue: String): String;
    function IsIn(const AValue: TArray<Double>): String; overload;
    function IsIn(const AValue: TArray<String>): String; overload;
    function IsIn(const AValue: String): String; overload;
    function IsNotIn(const AValue: TArray<Double>): String; overload;
    function IsNotIn(const AValue: TArray<String>): String; overload;
    function IsNotIn(const AValue: String): String; overload;
    function IsExists(const AValue: String): String; overload;
    function IsNotExists(const AValue: String): String; overload;
  end;

  ICQueryFunctions = interface
    ['{5035E399-D3F0-48C6-BACB-9CA6D94B2BE7}']
    // Aggregation functions
    function Count(const AValue: String): String;
    function Sum(const AValue: String): String;
    function Min(const AValue: String): String;
    function Max(const AValue: String): String;
    function Average(const AValue: String): String;
    // String functions
    function Upper(const AValue: String): String;
    function Lower(const AValue: String): String;
    function Length(const AValue: String): String;
    function Trim(const AValue: String): String;
    function LTrim(const AValue: String): String;
    function RTrim(const AValue: String): String;
    function SubString(const AValue: String; const AFrom, AFor: Integer): String;
    function Concat(const AValue: array of String): String;
    // Null handling
    function Coalesce(const AValues: array of String): String;
    // Type conversion
    function Cast(const AExpression: String; const ADataType: String): String;
    // Date functions
    function Date(const AValue: String; const AFormat: String): String; overload;
    function Date(const AValue: String): String; overload;
    function Day(const AValue: String): String;
    function Month(const AValue: String): String;
    function Year(const AValue: String): String;
    function CurrentDate: String;
    function CurrentTimestamp: String;
    // Numeric functions
    function Round(const AValue: String; const ADecimals: Integer): String;
    function Floor(const AValue: String): String;
    function Ceil(const AValue: String): String;
    function Modulus(const AValue, ADivisor: String): String;
    function Abs(const AValue: String): String;
  end;

implementation

end.


