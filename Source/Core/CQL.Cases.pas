{
         CQL Brasil - Criteria Query Language for Delphi/Lazarus


                   Copyright (c) 2019, Isaque Pinheiro
                          All rights reserved.

                    GNU Lesser General Public License
                      Vers�o 3, 29 de junho de 2007

       Copyright (C) 2007 Free Software Foundation, Inc. <http://fsf.org/>
       A todos � permitido copiar e distribuir c�pias deste documento de
       licen�a, mas mud�-lo n�o � permitido.

       Esta vers�o da GNU Lesser General Public License incorpora
       os termos e condi��es da vers�o 3 da GNU General Public License
       Licen�a, complementado pelas permiss�es adicionais listadas no
       arquivo LICENSE na pasta principal.
}

{
  @abstract(CQLBr Framework)
  @created(18 Jul 2019)
  @source(Inspired by and based on "GpSQLBuilder" project - https://github.com/gabr42/GpSQLBuilder)
  @source(Author of CQLBr Framework: Isaque Pinheiro <isaquesp@gmail.com>)
  @source(Author's Website: https://www.isaquepinheiro.com.br)
}

unit CQL.Cases;

{$ifdef fpc}
  {$mode delphi}{$H+}
{$endif}

interface

uses
  SysUtils,
  Generics.Collections,
  CQL.Interfaces,
  CQL.Expression;

type
  TCQLCaseWhenThen = class(TInterfacedObject, ICQLCaseWhenThen)
  strict private
    FThenExpression: ICQLExpression;
    FWhenExpression: ICQLExpression;
  protected
    function GetThenExpression: ICQLExpression;
    function GetWhenExpression: ICQLExpression;
    procedure SetThenExpression(const AValue: ICQLExpression);
    procedure SetWhenExpression(const AValue: ICQLExpression);
  public
    constructor Create;
    destructor Destroy; override;
    property WhenExpression: ICQLExpression read GetWhenExpression write SetWhenExpression;
    property ThenExpression: ICQLExpression read GetThenExpression write SetThenExpression;
  end;

  TCQLCaseWhenList = class(TInterfacedObject, ICQLCaseWhenList)
  strict private
    FWhenThenList: TList<ICQLCaseWhenThen>;
  protected
    function GetWhenThen(AIdx: Integer): ICQLCaseWhenThen;
    procedure SetWhenThen(AIdx: Integer; const AValue: ICQLCaseWhenThen);
    constructor Create;
  public
    destructor Destroy; override;
    function Add: ICQLCaseWhenThen; overload;
    function Add(const AWhenThen: ICQLCaseWhenThen): Integer; overload;
    function Count: Integer;
    property WhenThen[AIdx: Integer]: ICQLCaseWhenThen read GetWhenThen write SetWhenThen; default;
  end;

  TCQLCase = class(TInterfacedObject, ICQLCase)
  protected
    FCaseExpression: ICQLExpression;
    FElseExpression: ICQLExpression;
    FWhenList: ICQLCaseWhenList;
    function SerializeExpression(const AExpression: ICQLExpression): String;
    function GetCaseExpression: ICQLExpression;
    function GetElseExpression: ICQLExpression;
    function GetWhenList: ICQLCaseWhenList;
    procedure SetCaseExpression(const AValue: ICQLExpression);
    procedure SetElseExpression(const AValue: ICQLExpression);
    procedure SetWhenList(const AValue: ICQLCaseWhenList);
  public
    constructor Create;
    destructor Destroy; override;
    function Serialize: String; virtual;
    property CaseExpression: ICQLExpression read GetCaseExpression write SetCaseExpression;
    property WhenList: ICQLCaseWhenList read GetWhenList write SetWhenList;
    property ElseExpression: ICQLExpression read GetElseExpression write SetElseExpression;
  end;

  TCQLCriteriaCase = class(TInterfacedObject, ICQLCriteriaCase)
  strict private
    FOwner: ICQL;
    FCase: ICQLCase;
    FLastExpression: ICQLCriteriaExpression;
    function _GetCase: ICQLCase;
  public
    constructor Create(const AOwner: ICQL; const AExpression: String);
    destructor Destroy; override;
    function AndOpe(const AExpression: array of const): ICQLCriteriaCase; overload;
    function AndOpe(const AExpression: String): ICQLCriteriaCase; overload;
    function AndOpe(const AExpression: ICQLCriteriaExpression): ICQLCriteriaCase; overload;
    function ElseIf(const AValue: String): ICQLCriteriaCase; overload;
    function ElseIf(const AValue: Int64): ICQLCriteriaCase; overload;
    function EndCase: ICQL;
    function OrOpe(const AExpression: array of const): ICQLCriteriaCase; overload;
    function OrOpe(const AExpression: String): ICQLCriteriaCase; overload;
    function OrOpe(const AExpression: ICQLCriteriaExpression): ICQLCriteriaCase; overload;
    function IfThen(const AValue: String): ICQLCriteriaCase; overload;
    function IfThen(const AValue: Int64): ICQLCriteriaCase; overload;
    function When(const ACondition: String): ICQLCriteriaCase; overload;
    function When(const ACondition: array of const): ICQLCriteriaCase; overload;
    function When(const ACondition: ICQLCriteriaExpression): ICQLCriteriaCase; overload;
    property Value: ICQLCase read _GetCase;
  end;

implementation

uses
  CQL.Utils;

{ TCQLCase }

constructor TCQLCase.Create;
begin
  FCaseExpression := TCQLExpression.Create;
  FElseExpression := TCQLExpression.Create;
  FWhenList := TCQLCaseWhenList.Create;
end;

destructor TCQLCase.Destroy;
begin
  FCaseExpression := nil;
  FElseExpression := nil;
  FWhenList := nil;
  inherited;
end;

function TCQLCase.GetCaseExpression: ICQLExpression;
begin
  Result := FCaseExpression;
end;

function TCQLCase.GetElseExpression: ICQLExpression;
begin
  Result := FElseExpression;
end;

function TCQLCase.GetWhenList: ICQLCaseWhenList;
begin
  Result := FWhenList;
end;

function TCQLCase.Serialize: String;
var
  LFor: Integer;
  LWhenThen: ICQLCaseWhenThen;
begin
  Result := 'CASE';
  if not FCaseExpression.IsEmpty then
    Result := TUtils.Concat([Result, FCaseExpression.Serialize]);
  for LFor := 0 to FWhenList.Count - 1 do
  begin
    Result := TUtils.Concat([Result, 'WHEN']);
    LWhenThen := FWhenList[LFor];
    if not LWhenThen.WhenExpression.IsEmpty then
      Result := TUtils.Concat([Result, LWhenThen.WhenExpression.Serialize]);
    Result := TUtils.Concat([Result, 'THEN', LWhenThen.ThenExpression.Serialize]);
  end;
  if not FElseExpression.IsEmpty then
    Result := TUtils.Concat([Result, 'ELSE', FElseExpression.Serialize]);
  Result := TUtils.Concat([Result, 'END']);
end;

function TCQLCase.SerializeExpression(const AExpression: ICQLExpression): String;
begin
  Result := AExpression.Serialize;
end;

procedure TCQLCase.SetCaseExpression(const AValue: ICQLExpression);
begin
  FCaseExpression := AValue;
end;

procedure TCQLCase.SetElseExpression(const AValue: ICQLExpression);
begin
  FElseExpression := AValue;
end;

procedure TCQLCase.SetWhenList(const AValue: ICQLCaseWhenList);
begin
  FWhenList := AValue;
end;

{ TCQLCaseWhenList }

constructor TCQLCaseWhenList.Create;
begin
  FWhenThenList := TList<ICQLCaseWhenThen>.Create;
end;

destructor TCQLCaseWhenList.Destroy;
begin
  FWhenThenList.Free;
  inherited;
end;

function TCQLCaseWhenList.Add: ICQLCaseWhenThen;
begin
  Result := TCQLCaseWhenThen.Create;
  Add(Result);
end;

function TCQLCaseWhenList.Add(const AWhenThen: ICQLCaseWhenThen): Integer;
begin
  Result := FWhenThenList.Add(AWhenThen);
end;

function TCQLCaseWhenList.Count: Integer;
begin
  Result := FWhenThenList.Count;
end;

function TCQLCaseWhenList.GetWhenThen(AIdx: Integer): ICQLCaseWhenThen;
begin
  Result := FWhenThenList[AIdx];
end;

procedure TCQLCaseWhenList.SetWhenThen(AIdx: Integer; const AValue: ICQLCaseWhenThen);
begin
  FWhenThenList[AIdx] := AValue;
end;

{ TCQLCaseWhenThen }

constructor TCQLCaseWhenThen.Create;
begin
  FWhenExpression := TCQLExpression.Create;
  FThenExpression := TCQLExpression.Create;
end;

destructor TCQLCaseWhenThen.Destroy;
begin
  FThenExpression := nil;
  FWhenExpression := nil;
  inherited;
end;

function TCQLCaseWhenThen.GetThenExpression: ICQLExpression;
begin
  Result := FThenExpression;
end;

function TCQLCaseWhenThen.GetWhenExpression: ICQLExpression;
begin
  Result := FWhenExpression;
end;

procedure TCQLCaseWhenThen.SetThenExpression(const AValue: ICQLExpression);
begin
  FThenExpression := AValue;
end;

procedure TCQLCaseWhenThen.SetWhenExpression(const AValue: ICQLExpression);
begin
  FWhenExpression := AValue;
end;

{ TCQLCriteriaCase }

function TCQLCriteriaCase.AndOpe(const AExpression: String): ICQLCriteriaCase;
begin
  FLastExpression.AndOpe(AExpression);
  Result := Self;
end;

function TCQLCriteriaCase.AndOpe(const AExpression: array of const): ICQLCriteriaCase;
begin
  FLastExpression.AndOpe(AExpression);
  Result := Self;
end;

constructor TCQLCriteriaCase.Create(const AOwner: ICQL; const AExpression: String);
begin
  FOwner := AOwner;
  FCase := TCQLCase.Create;
  if AExpression <> '' then
    FCase.CaseExpression.Term := AExpression;
end;

destructor TCQLCriteriaCase.Destroy;
begin
  FOwner := nil;
  FCase := nil;
  FLastExpression := nil;
  inherited;
end;

function TCQLCriteriaCase.ElseIf(const AValue: String): ICQLCriteriaCase;
begin
  FLastExpression := TCQLCriteriaExpression.Create(AValue);
  FCase.ElseExpression := FLastExpression.Expression;
  Result := Self;
end;

function TCQLCriteriaCase.ElseIf(const AValue: int64): ICQLCriteriaCase;
begin
  Result := ElseIf(IntToStr(AValue));
end;

function TCQLCriteriaCase.EndCase: ICQL;
begin
  Result := FOwner;
end;

function TCQLCriteriaCase._GetCase: ICQLCase;
begin
  Result := FCase;
end;

function TCQLCriteriaCase.OrOpe(const AExpression: String): ICQLCriteriaCase;
begin
  FLastExpression.OrOpe(AExpression);
  Result := Self;
end;

function TCQLCriteriaCase.OrOpe(const AExpression: array of const): ICQLCriteriaCase;
begin
  FLastExpression.OrOpe(AExpression);
  Result := Self;
end;

function TCQLCriteriaCase.IfThen(const AValue: int64): ICQLCriteriaCase;
begin
  Result := IfThen(IntToStr(AValue));
end;

function TCQLCriteriaCase.When(const ACondition: ICQLCriteriaExpression): ICQLCriteriaCase;
var
  LWhenThen: ICQLCaseWhenThen;
begin
  FLastExpression := ACondition;
  LWhenThen := FCase.WhenList.Add;
  LWhenThen.WhenExpression := FLastExpression.Expression;
  Result := Self;
end;

function TCQLCriteriaCase.IfThen(const AValue: String): ICQLCriteriaCase;
begin
  Assert(FCase.WhenList.Count > 0, 'TCQLCriteriaCase.IfThen: Missing When');
  FLastExpression := TCQLCriteriaExpression.Create(AValue);
  FCase.WhenList[FCase.WhenList.Count-1].ThenExpression := FLastExpression.Expression;
  Result := Self;
end;

function TCQLCriteriaCase.When(const ACondition: array of const): ICQLCriteriaCase;
begin
  Result := When(TUtils.SqlParamsToStr(ACondition));
end;

function TCQLCriteriaCase.When(const ACondition: String): ICQLCriteriaCase;
begin
  Result := When(TCQLCriteriaExpression.Create(ACondition));
end;

function TCQLCriteriaCase.OrOpe(const AExpression: ICQLCriteriaExpression): ICQLCriteriaCase;
begin
  FLastExpression.OrOpe(AExpression.Expression);
  Result := Self;
end;

function TCQLCriteriaCase.AndOpe(const AExpression: ICQLCriteriaExpression): ICQLCriteriaCase;
begin
  FLastExpression.AndOpe(AExpression.Expression);
  Result := Self;
end;

end.


