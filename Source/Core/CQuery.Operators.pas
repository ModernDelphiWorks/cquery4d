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
  @abstract(CQuery4D - Fluent SQL Framework for Delphi)
  @description(A modern and extensible query framework supporting multiple databases)
  @created(03 Apr 2025)
  @author(Isaque Pinheiro)
  @contact(isaquepsp@gmail.com)
  @discord(https://discord.gg/T2zJC8zX)
}

unit CQuery.Operators;


{$ifdef fpc}
  {$mode delphi}{$H+}
{$endif}

interface

uses
  SysUtils,
  StrUtils,
  Variants,
  CQuery.Interfaces,
  CQuery.Utils;

type
  TCQueryOperator = class(TInterfacedObject, ICQueryOperator)
  strict private
    FDatabase: TCQueryDriver;
    function _GetColumnName: String;
    function _GetCompare: TCQueryOperatorCompare;
    function _GetValue: Variant;
    function _GetDataType: TCQueryDataFieldType;
    function _ArrayValueToString: String;
    procedure _SetColumnName(const Value: String);
    procedure _SetCompare(const Value: TCQueryOperatorCompare);
    procedure _SetValue(const Value: Variant);
    procedure _SetdataType(const Value: TCQueryDataFieldType);
  protected
    FColumnName: String;
    FCompare: TCQueryOperatorCompare;
    FValue: Variant;
    FDataType: TCQueryDataFieldType;
    function GetOperator: String;
    function GetCompareValue: String; virtual;
  public
    constructor Create(const ADatabase: TCQueryDriver); overload;
    destructor Destroy; override;
    property ColumnName:String read _GetColumnName write _SetColumnName;
    property Compare: TCQueryOperatorCompare read _GetCompare write _SetCompare;
    property Value: Variant read _GetValue write _SetValue;
    property DataType: TCQueryDataFieldType read _GetDataType write _SetdataType;
    function AsString: String;
  end;

  TCQueryOperators = class(TInterfacedObject, ICQueryOperators)
  private
    FDatabase: TCQueryDriver;
    function _CreateOperator(const AColumnName: String;
      const AValue: Variant;
      const ACompare: TCQueryOperatorCompare;
      const ADataType: TCQueryDataFieldType): ICQueryOperator;
  public
    constructor Create(const ADatabase: TCQueryDriver);
    destructor Destroy; override;
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

implementation

{ TCQueryOperator }

function TCQueryOperator.AsString: String;
begin
  Result := TUtils.Concat([FColumnName, GetOperator, GetCompareValue] );
end;

constructor TCQueryOperator.Create(const ADatabase: TCQueryDriver);
begin
  FDatabase := ADatabase;
end;

destructor TCQueryOperator.Destroy;
begin

  inherited;
end;

function TCQueryOperator._GetColumnName: String;
begin
  Result := FColumnName;
end;

function TCQueryOperator._GetCompare: TCQueryOperatorCompare;
begin
  Result := FCompare;
end;

function TCQueryOperator.GetCompareValue: String;
begin
  if VarIsNull(FValue) then
    Exit;
  case FDataType of
    dftString:
      begin
        Result := VarToStrDef(FValue, EmptyStr);
        case FCompare of
          fcLike,
          fcNotLike:      Result := QuotedStr(TUtils.Concat([Result], EmptyStr));
          fcLikeFull,
          fcNotLikeFull:  Result := QuotedStr(TUtils.Concat(['%', Result, '%'], EmptyStr));
          fcLikeLeft,
          fcNotLikeLeft:  Result := QuotedStr(TUtils.Concat(['%', Result], EmptyStr));
          fcLikeRight,
          fcNotLikeRight: Result := QuotedStr(TUtils.Concat([Result, '%'], EmptyStr));
        end;
//        Result := QuotedStr(Result);
      end;
    dftInteger:  Result := VarToStrDef(FValue, EmptyStr);
    dftFloat:    Result := ReplaceStr(FloatToStr(FValue), ',', '.');
    dftDate:     Result := QuotedStr(TUtils.DateToSQLFormat(FDatabase, VarToDateTime(FValue)));
    dftDateTime: Result := QuotedStr(TUtils.DateTimeToSQLFormat(FDatabase, VarToDateTime(FValue)));
    dftGuid:     Result := TUtils.GuidStrToSQLFormat(FDatabase, StringToGUID(FValue));
    dftArray:    Result := _ArrayValueToString;
    dftBoolean:  result := BoolToStr(FValue);
    dftText:     Result := '(' + FValue + ')';
  end;
end;

function TCQueryOperator._GetDataType: TCQueryDataFieldType;
begin
  Result := FDataType;
end;

function TCQueryOperator.GetOperator: String;
begin
  case FCompare of
    fcEqual        : Result := '=';
    fcNotEqual     : Result := '<>';
    fcGreater      : Result := '>';
    fcGreaterEqual : Result := '>=';
    fcLess         : Result := '<';
    fcLessEqual    : Result := '<=';
    fcIn           : Result := 'in';
    fcNotIn        : Result := 'not in';
    fcIsNull       : Result := 'is null';
    fcIsNotNull    : Result := 'is not null';
    fcBetween      : Result := 'between';
    fcNotBetween   : Result := 'not between';
    fcExists       : Result := 'exists';
    fcNotExists    : Result := 'not exists';
    fcLike,
    fcLikeFull,
    fcLikeLeft,
    fcLikeRight    : Result := 'like';
    fcNotLike,
    fcNotLikeFull,
    fcNotLikeLeft,
    fcNotLikeRight : Result := 'not like';
  end;
end;

function TCQueryOperator._GetValue: Variant;
begin
  Result := FValue;
end;

procedure TCQueryOperator._SetColumnName(const Value: String);
begin
  FColumnName := Value;
end;

procedure TCQueryOperator._SetCompare(const Value: TCQueryOperatorCompare);
begin
  FCompare := Value;
end;

procedure TCQueryOperator._SetdataType(const Value: TCQueryDataFieldType);
begin
  FDataType := Value;
end;

procedure TCQueryOperator._SetValue(const Value: Variant);
begin
  FValue := Value;
end;

function TCQueryOperator._ArrayValueToString: String;
var
  LFor: Integer;
  LValue: Variant;
  LValues: array of Variant;
begin
  Result := '(';
  LValues:= FValue;
  for LFor := 0 to Length(LValues) -1 do
  begin
    LValue := LValues[LFor];
    Result := Result + IfThen(LFor = 0, EmptyStr, ', ');
    Result := Result + IfThen(VarTypeAsText(VarType(LValue)) = 'OleStr',
                              QuotedStr(VarToStr(LValue)),
                              ReplaceStr(VarToStr(LValue), ',', '.'));
  end;
  Result := Result + ')';
end;

{ TCQueryOperators }

function TCQueryOperators._CreateOperator(const AColumnName: String;
  const AValue: Variant;
  const ACompare: TCQueryOperatorCompare;
  const ADataType: TCQueryDataFieldType): ICQueryOperator;
begin
  Result := TCQueryOperator.Create(FDatabase);
  Result.ColumnName := AColumnName;
  Result.Compare := ACompare;
  Result.Value := AValue;
  Result.DataType := ADataType;
end;

function TCQueryOperators.IsEqual(const AValue: Integer): String;
begin
  Result := _CreateOperator('', AValue, fcEqual, dftInteger).AsString;
end;

function TCQueryOperators.IsEqual(const AValue: Extended): String;
begin
  Result := _CreateOperator('', AValue, fcEqual, dftFloat).AsString;
end;

constructor TCQueryOperators.Create(const ADatabase: TCQueryDriver);
begin
  FDatabase := ADatabase;
end;

function TCQueryOperators.IsEqual(const AValue: String): String;
begin
  Result := _CreateOperator('', AValue, fcEqual, dftString).AsString;
end;

function TCQueryOperators.IsExists(const AValue: String): String;
begin
  Result := _CreateOperator('', AValue, fcExists, dftText).AsString;
end;

function TCQueryOperators.IsGreaterEqThan(const AValue: Extended): String;
begin
  Result := _CreateOperator('', AValue, fcGreaterEqual, dftFloat).AsString;
end;

function TCQueryOperators.IsGreaterEqThan(const AValue: Integer): String;
begin
  Result := _CreateOperator('', AValue, fcGreaterEqual, dftInteger).AsString;
end;

function TCQueryOperators.IsGreaterThan(const AValue: Integer): String;
begin
  Result := _CreateOperator('', AValue, fcGreater, dftInteger).AsString;
end;

function TCQueryOperators.IsIn(const AValue: String): String;
begin
  Result := _CreateOperator('', AValue, fcIn, dftText).AsString;
end;

function TCQueryOperators.IsIn(const AValue: TArray<String>): String;
begin
  Result := _CreateOperator('', AValue, fcIn, dftArray).AsString;
end;

function TCQueryOperators.IsIn(const AValue: TArray<Double>): String;
begin
  Result := _CreateOperator('', AValue, fcIn, dftArray).AsString;
end;

function TCQueryOperators.IsGreaterThan(const AValue: Extended): String;
begin
  Result := _CreateOperator('', AValue, fcGreater, dftFloat).AsString;
end;

function TCQueryOperators.IsLessEqThan(const AValue: Extended): String;
begin
  Result := _CreateOperator('', AValue, fcLessEqual, dftFloat).AsString;
end;

function TCQueryOperators.IsLessEqThan(const AValue: Integer): String;
begin
  Result := _CreateOperator('', AValue, fcLessEqual, dftInteger).AsString;
end;

function TCQueryOperators.IsLessThan(const AValue: Extended): String;
begin
  Result := _CreateOperator('', AValue, fcLess, dftFloat).AsString;
end;

function TCQueryOperators.IsLessThan(const AValue: Integer): String;
begin
  Result := _CreateOperator('', AValue, fcLess, dftInteger).AsString;
end;

function TCQueryOperators.IsLike(const AValue: String): String;
begin
  Result := _CreateOperator('', AValue, fcLike, dftString).AsString;
end;

function TCQueryOperators.IsLikeFull(const AValue: String): String;
begin
  Result := _CreateOperator('', AValue, fcLikeFull, dftString).AsString;
end;

function TCQueryOperators.IsLikeLeft(const AValue: String): String;
begin
  Result := _CreateOperator('', AValue, fcLikeLeft, dftString).AsString;
end;

function TCQueryOperators.IsLikeRight(const AValue: String): String;
begin
  Result := _CreateOperator('', AValue, fcLikeRight, dftString).AsString;
end;

function TCQueryOperators.IsNotEqual(const AValue: Extended): String;
begin
  Result := _CreateOperator('', AValue, fcNotEqual, dftFloat).AsString;
end;

function TCQueryOperators.IsNotEqual(const AValue: String): String;
begin
  Result := _CreateOperator('', AValue, fcNotEqual, dftString).AsString;
end;

function TCQueryOperators.IsNotEqual(const AValue: TDate): String;
begin
  Result := _CreateOperator('', AValue, fcNotEqual, dftDate).AsString;
end;

function TCQueryOperators.IsNotEqual(const AValue: TDateTime): String;
begin
  Result := _CreateOperator('', AValue, fcNotEqual, dftDateTime).AsString;
end;

function TCQueryOperators.IsNotExists(const AValue: String): String;
begin
  Result := _CreateOperator('', AValue, fcNotExists, dftText).AsString;
end;

function TCQueryOperators.IsNotEqual(const AValue: Integer): String;
begin
  Result := _CreateOperator('', AValue, fcNotEqual, dftInteger).AsString;
end;

function TCQueryOperators.IsNotLike(const AValue: String): String;
begin
  Result := _CreateOperator('', AValue, fcNotLike, dftString).AsString;
end;

function TCQueryOperators.IsNotLikeFull(const AValue: String): String;
begin
  Result := _CreateOperator('', AValue, fcNotLikeFull, dftString).AsString;
end;

function TCQueryOperators.IsNotLikeLeft(const AValue: String): String;
begin
  Result := _CreateOperator('', AValue, fcNotLikeLeft, dftString).AsString;
end;

function TCQueryOperators.IsNotLikeRight(const AValue: String): String;
begin
  Result := _CreateOperator('', AValue, fcNotLikeRight, dftString).AsString;
end;

function TCQueryOperators.IsNotNull: String;
begin
  Result := _CreateOperator('', Null, fcIsNotNull, dftUnknown).AsString;
end;

function TCQueryOperators.IsNull: String;
begin
  Result := _CreateOperator('', Null, fcIsNull, dftUnknown).AsString;
end;

function TCQueryOperators.IsNotIn(const AValue: TArray<String>): String;
begin
  Result := _CreateOperator('', AValue, fcNotIn, dftArray).AsString;
end;

function TCQueryOperators.IsNotIn(const AValue: TArray<Double>): String;
begin
  Result := _CreateOperator('', AValue, fcNotIn, dftArray).AsString;
end;

function TCQueryOperators.IsNotIn(const AValue: String): String;
begin
  Result := _CreateOperator('', AValue, fcNotIn, dftText).AsString;
end;

function TCQueryOperators.IsEqual(const AValue: TDateTime): String;
begin
  Result := _CreateOperator('', AValue, fcEqual, dftDateTime).AsString;
end;

function TCQueryOperators.IsEqual(const AValue: TDate): String;
begin
  Result := _CreateOperator('', AValue, fcEqual, dftDate).AsString;
end;

function TCQueryOperators.IsGreaterEqThan(const AValue: TDateTime): String;
begin
  Result := _CreateOperator('', AValue, fcGreaterEqual, dftDateTime).AsString;
end;

function TCQueryOperators.IsGreaterEqThan(const AValue: TDate): String;
begin
  Result := _CreateOperator('', AValue, fcGreaterEqual, dftDate).AsString;
end;

function TCQueryOperators.IsGreaterThan(const AValue: TDate): String;
begin
  Result := _CreateOperator('', AValue, fcGreater, dftDate).AsString;
end;

function TCQueryOperators.IsGreaterThan(const AValue: TDateTime): String;
begin
  Result := _CreateOperator('', AValue, fcGreater, dftDateTime).AsString;
end;

function TCQueryOperators.IsLessEqThan(const AValue: TDateTime): String;
begin
  Result := _CreateOperator('', AValue, fcLessEqual, dftDateTime).AsString;
end;

function TCQueryOperators.IsLessEqThan(const AValue: TDate): String;
begin
  Result := _CreateOperator('', AValue, fcLessEqual, dftDate).AsString;
end;

function TCQueryOperators.IsLessThan(const AValue: TDateTime): String;
begin
  Result := _CreateOperator('', AValue, fcLess, dftDateTime).AsString;
end;

function TCQueryOperators.IsLessThan(const AValue: TDate): String;
begin
  Result := _CreateOperator('', AValue, fcLess, dftDate).AsString;
end;

destructor TCQueryOperators.Destroy;
begin
  inherited;
end;

function TCQueryOperators.IsEqual(const AValue: TGUID): String;
begin
  Result := _CreateOperator('', AValue.ToString, fcEqual, dftGuid).AsString;
end;

function TCQueryOperators.IsNotEqual(const AValue: TGUID): String;
begin
  Result := _CreateOperator('', AValue.ToString, fcNotEqual, dftGuid).AsString;
end;

end.

