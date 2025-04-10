{
         CQL Brasil - Criteria Query Language for Delphi/Lazarus


                   Copyright (c) 2019, Isaque Pinheiro
                          All rights reserved.

                    GNU Lesser General Public License
                      Versão 3, 29 de junho de 2007

       Copyright (C) 2007 Free Software Foundation, Inc. <http://fsf.org/>
       A todos é permitido copiar e distribuir cópias deste documento de
       licença, mas mudá-lo não é permitido.

       Esta versão da GNU Lesser General Public License incorpora
       os termos e condições da versão 3 da GNU General Public License
       Licença, complementado pelas permissões adicionais listadas no
       arquivo LICENSE na pasta principal.
}

{
  @abstract(CQLBr Framework)
  @created(18 Jul 2019)
  @source(Inspired by and based on "GpSQLBuilder" project - https://github.com/gabr42/GpSQLBuilder)
  @source(Author of CQLBr Framework: Isaque Pinheiro <isaquesp@gmail.com>)
  @source(Author's Website: https://www.isaquepinheiro.com.br)
}

unit CQL.Operators;


{$ifdef fpc}
  {$mode delphi}{$H+}
{$endif}

interface

uses
  SysUtils,
  StrUtils,
  Variants,
  CQL.Interfaces,
  CQL.Utils;

type
  TCQLOperator = class(TInterfacedObject, ICQLOperator)
  strict private
    FDatabase: TDBName;
    function _GetColumnName: String;
    function _GetCompare: TCQLOperatorCompare;
    function _GetValue: Variant;
    function _GetDataType: TCQLDataFieldType;
    procedure _SetColumnName(const Value: String);
    procedure _SetCompare(const Value: TCQLOperatorCompare);
    procedure _SetValue(const Value: Variant);
    procedure _SetdataType(const Value: TCQLDataFieldType);
    function _ArrayValueToString: String;
  protected
    FColumnName: String;
    FCompare: TCQLOperatorCompare;
    FValue: Variant;
    FDataType: TCQLDataFieldType;
    function GetOperator: String;
    function GetCompareValue: String; virtual;
  public
    constructor Create(const ADatabase: TDBName); overload;
    destructor Destroy; override;
    property ColumnName:String read _GetColumnName write _SetColumnName;
    property Compare: TCQLOperatorCompare read _GetCompare write _SetCompare;
    property Value: Variant read _GetValue write _SetValue;
    property DataType: TCQLDataFieldType read _GetDataType write _SetdataType;
    function AsString: String;
  end;

  TCQLOperators = class(TInterfacedObject, ICQLOperators)
  private
    FDatabase: TDBName;
    function _CreateOperator(const AColumnName: String;
      const AValue: Variant;
      const ACompare: TCQLOperatorCompare;
      const ADataType: TCQLDataFieldType): ICQLOperator;
  public
    constructor Create(const ADatabase: TDBName);
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

{ TCQLOperator }

function TCQLOperator.AsString: String;
begin
  Result := TUtils.Concat([FColumnName, GetOperator, GetCompareValue] );
end;

constructor TCQLOperator.Create(const ADatabase: TDBName);
begin
  FDatabase := ADatabase;
end;

destructor TCQLOperator.Destroy;
begin

  inherited;
end;

function TCQLOperator._GetColumnName: String;
begin
  Result := FColumnName;
end;

function TCQLOperator._GetCompare: TCQLOperatorCompare;
begin
  Result := FCompare;
end;

function TCQLOperator.GetCompareValue: String;
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

function TCQLOperator._GetDataType: TCQLDataFieldType;
begin
  Result := FDataType;
end;

function TCQLOperator.GetOperator: String;
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

function TCQLOperator._GetValue: Variant;
begin
  Result := FValue;
end;

procedure TCQLOperator._SetColumnName(const Value: String);
begin
  FColumnName := Value;
end;

procedure TCQLOperator._SetCompare(const Value: TCQLOperatorCompare);
begin
  FCompare := Value;
end;

procedure TCQLOperator._SetdataType(const Value: TCQLDataFieldType);
begin
  FDataType := Value;
end;

procedure TCQLOperator._SetValue(const Value: Variant);
begin
  FValue := Value;
end;

function TCQLOperator._ArrayValueToString: String;
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

{ TCQLOperators }

function TCQLOperators._CreateOperator(const AColumnName: String;
  const AValue: Variant;
  const ACompare: TCQLOperatorCompare;
  const ADataType: TCQLDataFieldType): ICQLOperator;
begin
  Result := TCQLOperator.Create(FDatabase);
  Result.ColumnName := AColumnName;
  Result.Compare := ACompare;
  Result.Value := AValue;
  Result.DataType := ADataType;
end;

function TCQLOperators.IsEqual(const AValue: Integer): String;
begin
  Result := _CreateOperator('', AValue, fcEqual, dftInteger).AsString;
end;

function TCQLOperators.IsEqual(const AValue: Extended): String;
begin
  Result := _CreateOperator('', AValue, fcEqual, dftFloat).AsString;
end;

constructor TCQLOperators.Create(const ADatabase: TDBName);
begin
  FDatabase := ADatabase;
end;

function TCQLOperators.IsEqual(const AValue: String): String;
begin
  Result := _CreateOperator('', AValue, fcEqual, dftString).AsString;
end;

function TCQLOperators.IsExists(const AValue: String): String;
begin
  Result := _CreateOperator('', AValue, fcExists, dftText).AsString;
end;

function TCQLOperators.IsGreaterEqThan(const AValue: Extended): String;
begin
  Result := _CreateOperator('', AValue, fcGreaterEqual, dftFloat).AsString;
end;

function TCQLOperators.IsGreaterEqThan(const AValue: Integer): String;
begin
  Result := _CreateOperator('', AValue, fcGreaterEqual, dftInteger).AsString;
end;

function TCQLOperators.IsGreaterThan(const AValue: Integer): String;
begin
  Result := _CreateOperator('', AValue, fcGreater, dftInteger).AsString;
end;

function TCQLOperators.IsIn(const AValue: String): String;
begin
  Result := _CreateOperator('', AValue, fcIn, dftText).AsString;
end;

function TCQLOperators.IsIn(const AValue: TArray<String>): String;
begin
  Result := _CreateOperator('', AValue, fcIn, dftArray).AsString;
end;

function TCQLOperators.IsIn(const AValue: TArray<Double>): String;
begin
  Result := _CreateOperator('', AValue, fcIn, dftArray).AsString;
end;

function TCQLOperators.IsGreaterThan(const AValue: Extended): String;
begin
  Result := _CreateOperator('', AValue, fcGreater, dftFloat).AsString;
end;

function TCQLOperators.IsLessEqThan(const AValue: Extended): String;
begin
  Result := _CreateOperator('', AValue, fcLessEqual, dftFloat).AsString;
end;

function TCQLOperators.IsLessEqThan(const AValue: Integer): String;
begin
  Result := _CreateOperator('', AValue, fcLessEqual, dftInteger).AsString;
end;

function TCQLOperators.IsLessThan(const AValue: Extended): String;
begin
  Result := _CreateOperator('', AValue, fcLess, dftFloat).AsString;
end;

function TCQLOperators.IsLessThan(const AValue: Integer): String;
begin
  Result := _CreateOperator('', AValue, fcLess, dftInteger).AsString;
end;

function TCQLOperators.IsLike(const AValue: String): String;
begin
  Result := _CreateOperator('', AValue, fcLike, dftString).AsString;
end;

function TCQLOperators.IsLikeFull(const AValue: String): String;
begin
  Result := _CreateOperator('', AValue, fcLikeFull, dftString).AsString;
end;

function TCQLOperators.IsLikeLeft(const AValue: String): String;
begin
  Result := _CreateOperator('', AValue, fcLikeLeft, dftString).AsString;
end;

function TCQLOperators.IsLikeRight(const AValue: String): String;
begin
  Result := _CreateOperator('', AValue, fcLikeRight, dftString).AsString;
end;

function TCQLOperators.IsNotEqual(const AValue: Extended): String;
begin
  Result := _CreateOperator('', AValue, fcNotEqual, dftFloat).AsString;
end;

function TCQLOperators.IsNotEqual(const AValue: String): String;
begin
  Result := _CreateOperator('', AValue, fcNotEqual, dftString).AsString;
end;

function TCQLOperators.IsNotEqual(const AValue: TDate): String;
begin
  Result := _CreateOperator('', AValue, fcNotEqual, dftDate).AsString;
end;

function TCQLOperators.IsNotEqual(const AValue: TDateTime): String;
begin
  Result := _CreateOperator('', AValue, fcNotEqual, dftDateTime).AsString;
end;

function TCQLOperators.IsNotExists(const AValue: String): String;
begin
  Result := _CreateOperator('', AValue, fcNotExists, dftText).AsString;
end;

function TCQLOperators.IsNotEqual(const AValue: Integer): String;
begin
  Result := _CreateOperator('', AValue, fcNotEqual, dftInteger).AsString;
end;

function TCQLOperators.IsNotLike(const AValue: String): String;
begin
  Result := _CreateOperator('', AValue, fcNotLike, dftString).AsString;
end;

function TCQLOperators.IsNotLikeFull(const AValue: String): String;
begin
  Result := _CreateOperator('', AValue, fcNotLikeFull, dftString).AsString;
end;

function TCQLOperators.IsNotLikeLeft(const AValue: String): String;
begin
  Result := _CreateOperator('', AValue, fcNotLikeLeft, dftString).AsString;
end;

function TCQLOperators.IsNotLikeRight(const AValue: String): String;
begin
  Result := _CreateOperator('', AValue, fcNotLikeRight, dftString).AsString;
end;

function TCQLOperators.IsNotNull: String;
begin
  Result := _CreateOperator('', Null, fcIsNotNull, dftUnknown).AsString;
end;

function TCQLOperators.IsNull: String;
begin
  Result := _CreateOperator('', Null, fcIsNull, dftUnknown).AsString;
end;

function TCQLOperators.IsNotIn(const AValue: TArray<String>): String;
begin
  Result := _CreateOperator('', AValue, fcNotIn, dftArray).AsString;
end;

function TCQLOperators.IsNotIn(const AValue: TArray<Double>): String;
begin
  Result := _CreateOperator('', AValue, fcNotIn, dftArray).AsString;
end;

function TCQLOperators.IsNotIn(const AValue: String): String;
begin
  Result := _CreateOperator('', AValue, fcNotIn, dftText).AsString;
end;

function TCQLOperators.IsEqual(const AValue: TDateTime): String;
begin
  Result := _CreateOperator('', AValue, fcEqual, dftDateTime).AsString;
end;

function TCQLOperators.IsEqual(const AValue: TDate): String;
begin
  Result := _CreateOperator('', AValue, fcEqual, dftDate).AsString;
end;

function TCQLOperators.IsGreaterEqThan(const AValue: TDateTime): String;
begin
  Result := _CreateOperator('', AValue, fcGreaterEqual, dftDateTime).AsString;
end;

function TCQLOperators.IsGreaterEqThan(const AValue: TDate): String;
begin
  Result := _CreateOperator('', AValue, fcGreaterEqual, dftDate).AsString;
end;

function TCQLOperators.IsGreaterThan(const AValue: TDate): String;
begin
  Result := _CreateOperator('', AValue, fcGreater, dftDate).AsString;
end;

function TCQLOperators.IsGreaterThan(const AValue: TDateTime): String;
begin
  Result := _CreateOperator('', AValue, fcGreater, dftDateTime).AsString;
end;

function TCQLOperators.IsLessEqThan(const AValue: TDateTime): String;
begin
  Result := _CreateOperator('', AValue, fcLessEqual, dftDateTime).AsString;
end;

function TCQLOperators.IsLessEqThan(const AValue: TDate): String;
begin
  Result := _CreateOperator('', AValue, fcLessEqual, dftDate).AsString;
end;

function TCQLOperators.IsLessThan(const AValue: TDateTime): String;
begin
  Result := _CreateOperator('', AValue, fcLess, dftDateTime).AsString;
end;

function TCQLOperators.IsLessThan(const AValue: TDate): String;
begin
  Result := _CreateOperator('', AValue, fcLess, dftDate).AsString;
end;

destructor TCQLOperators.Destroy;
begin
  inherited;
end;

function TCQLOperators.IsEqual(const AValue: TGUID): String;
begin
  Result := _CreateOperator('', AValue.ToString, fcEqual, dftGuid).AsString;
end;

function TCQLOperators.IsNotEqual(const AValue: TGUID): String;
begin
  Result := _CreateOperator('', AValue.ToString, fcNotEqual, dftGuid).AsString;
end;

end.
