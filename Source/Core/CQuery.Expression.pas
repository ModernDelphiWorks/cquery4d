{
               CQuery4D - Fluent SQL Framework for Delphi

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

unit CQuery.Expression;

{$ifdef fpc}
  {$mode delphi}{$H+}
{$endif}

interface

uses
  SysUtils,
  CQuery.Interfaces;

type
  TCQueryExpression = class(TInterfacedObject, ICQueryExpression)
  strict private
    FOperation: TExpressionOperation;
    FLeft: ICQueryExpression;
    FRight: ICQueryExpression;
    FTerm: String;
    function _SerializeWhere(AAddParens: Boolean): String;
    function _SerializeAND: String;
    function _SerializeOR: String;
    function _SerializeOperator: String;
    function _SerializeFunction: String;
  protected
    function GetLeft: ICQueryExpression;
    function GetOperation: TExpressionOperation;
    function GetRight: ICQueryExpression;
    function GetTerm: String;
    procedure SetLeft(const AValue: ICQueryExpression);
    procedure SetOperation(const AValue: TExpressionOperation);
    procedure SetRight(const AValue: ICQueryExpression);
    procedure SetTerm(const AValue: String);
  public
    destructor Destroy; override;
    procedure Assign(const ANode: ICQueryExpression);
    procedure Clear;
    function IsEmpty: Boolean;
    function Serialize(AAddParens: Boolean = False): String;
    property Term: String read GetTerm write SetTerm;
    property Operation: TExpressionOperation read GetOperation write SetOperation;
    property Left: ICQueryExpression read GetLeft write SetLeft;
    property Right: ICQueryExpression read GetRight write SetRight;
  end;

  TCQueryCriteriaExpression = class(TInterfacedObject, ICQueryCriteriaExpression)
  strict private
    FExpression: ICQueryExpression;
    FLastAnd: ICQueryExpression;
  protected
    function FindRightmostAnd(const AExpression: ICQueryExpression): ICQueryExpression;
  public
    constructor Create(const AExpression: String = ''); overload;
    constructor Create(const AExpression: ICQueryExpression); overload;
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

implementation

uses
  CQuery.Utils;

{ TCQueryExpression }

procedure TCQueryExpression.Assign(const ANode: ICQueryExpression);
begin
  FLeft := ANode.Left;
  FRight := ANode.Right;
  FTerm := ANode.Term;
  FOperation := ANode.Operation;
end;

procedure TCQueryExpression.Clear;
begin
  FOperation := opNone;
  FTerm := '';
  FLeft := nil;
  FRight := nil;
end;

destructor TCQueryExpression.Destroy;
begin
  FLeft := nil;
  FRight := nil;
  inherited;
end;

function TCQueryExpression.GetLeft: ICQueryExpression;
begin
  Result := FLeft;
end;

function TCQueryExpression.GetOperation: TExpressionOperation;
begin
  Result := FOperation;
end;

function TCQueryExpression.GetRight: ICQueryExpression;
begin
  Result := FRight;
end;

function TCQueryExpression.GetTerm: String;
begin
  Result := FTerm;
end;

function TCQueryExpression.IsEmpty: Boolean;
begin
  // Caso não exista a chamada do WHERE é considerado Empty.
  Result := (FOperation = opNone) and (FTerm = '');
end;

function TCQueryExpression.Serialize(AAddParens: Boolean): String;
begin
  if IsEmpty then
    Result := ''
  else
    case FOperation of
      opNone:
        Result := _SerializeWhere(AAddParens);
      opAND:
        Result := _SerializeAND;
      opOR:
        Result := _SerializeOR;
      opOperation:
        Result := _SerializeOperator;
      opFunction:
        Result := _SerializeFunction;
      else
        raise Exception.Create('TCQueryExpression.Serialize: Unknown operation');
    end;
end;

function TCQueryExpression._SerializeAND: String;
begin
  Result := TUtils.Concat([FLeft.Serialize(True),
                           'AND',
                           FRight.Serialize(True)]);
end;

function TCQueryExpression._SerializeFunction: String;
begin
  Result := TUtils.Concat([FLeft.Serialize(False),
                           FRight.Serialize(False)]);
end;

function TCQueryExpression._SerializeOperator: String;
begin
  Result := '(' + TUtils.Concat([FLeft.Serialize(False),
                                 FRight.Serialize(False)]) + ')';
end;

function TCQueryExpression._SerializeOR: String;
begin
  Result := '(' + TUtils.Concat([FLeft.Serialize(True),
                                 'OR',
                                 FRight.Serialize(True)]) + ')';
end;

function TCQueryExpression._SerializeWhere(AAddParens: Boolean): String;
begin
  if AAddParens then
    Result := TUtils.concat(['(', FTerm, ')'], '')
  else
    Result := FTerm;
end;

procedure TCQueryExpression.SetLeft(const AValue: ICQueryExpression);
begin
  FLeft := AValue;
end;

procedure TCQueryExpression.SetOperation(const AValue: TExpressionOperation);
begin
  FOperation := AValue;
end;

procedure TCQueryExpression.SetRight(const AValue: ICQueryExpression);
begin
  FRight := AValue;
end;

procedure TCQueryExpression.SetTerm(const AValue: String);
begin
  FTerm := AValue;
end;

{ TCQueryCriteriaExpression }

function TCQueryCriteriaExpression.AndOpe(const AExpression: ICQueryExpression): ICQueryCriteriaExpression;
var
  LNode: ICQueryExpression;
  LRoot: ICQueryExpression;
begin
  LRoot := FExpression;
  if LRoot.IsEmpty then
  begin
    LRoot.Assign(AExpression);
    FLastAnd := LRoot;
  end
  else
  begin
    LNode := TCQueryExpression.Create;
    LNode.Assign(LRoot);
    LRoot.Left := LNode;
    LRoot.Operation := opAND;
    LRoot.Right := AExpression;
    FLastAnd := LRoot.Right;
  end;
  Result := Self;
end;

function TCQueryCriteriaExpression.AndOpe(const AExpression: String): ICQueryCriteriaExpression;
var
  LNode: ICQueryExpression;
begin
  LNode := TCQueryExpression.Create;
  LNode.Term := AExpression;
  Result := AndOpe(LNode);
end;

function TCQueryCriteriaExpression.AndOpe(const AExpression: array of const): ICQueryCriteriaExpression;
begin
  Result := AndOpe(TUtils.SqlParamsToStr(AExpression));
end;

function TCQueryCriteriaExpression.AsString: String;
begin
  Result := FExpression.Serialize;
end;

constructor TCQueryCriteriaExpression.Create(const AExpression: ICQueryExpression);
begin
  FExpression := AExpression;
  FLastAnd := FindRightmostAnd(AExpression);
end;

function TCQueryCriteriaExpression.Expression: ICQueryExpression;
begin
  Result := FExpression;
end;

constructor TCQueryCriteriaExpression.Create(const AExpression: String);
begin
  FExpression := TCQueryExpression.Create;
  if AExpression <> '' then
    AndOpe(AExpression);
end;

function TCQueryCriteriaExpression.FindRightmostAnd(const AExpression: ICQueryExpression): ICQueryExpression;
begin
  if AExpression.Operation = opNone then
    Result := FExpression
  else
  if AExpression.Operation = opOR then
    Result := FExpression
  else
    Result := FindRightmostAnd(AExpression.Right);
end;

function TCQueryCriteriaExpression.Fun(const AExpression: array of const): ICQueryCriteriaExpression;
begin
  Result := Fun(TUtils.SqlParamsToStr(AExpression));
end;

function TCQueryCriteriaExpression.Fun(const AExpression: String): ICQueryCriteriaExpression;
var
  LNode: ICQueryExpression;
begin
  LNode := TCQueryExpression.Create;
  LNode.Term := AExpression;
  Result := Fun(LNode);
end;

function TCQueryCriteriaExpression.Fun(const AExpression: ICQueryExpression): ICQueryCriteriaExpression;
var
  LNode: ICQueryExpression;
begin
  LNode := TCQueryExpression.Create;
  LNode.Assign(FLastAnd);
  FLastAnd.Left := LNode;
  FLastAnd.Operation := opFunction;
  FLastAnd.Right := AExpression;
  Result := Self;
end;

function TCQueryCriteriaExpression.OrOpe(const AExpression: array of const): ICQueryCriteriaExpression;
begin
  Result := OrOpe(TUtils.SqlParamsToStr(AExpression));
end;

function TCQueryCriteriaExpression.OrOpe(const AExpression: String): ICQueryCriteriaExpression;
var
  LNode: ICQueryExpression;
begin
  LNode := TCQueryExpression.Create;
  LNode.Term := AExpression;
  Result := OrOpe(LNode);
end;

function TCQueryCriteriaExpression.Ope(const AExpression: array of const): ICQueryCriteriaExpression;
begin
  Result := Ope(TUtils.SqlParamsToStr(AExpression));
end;

function TCQueryCriteriaExpression.Ope(const AExpression: String): ICQueryCriteriaExpression;
var
  LNode: ICQueryExpression;
begin
  LNode := TCQueryExpression.Create;
  LNode.Term := AExpression;
  Result := Ope(LNode);
end;

function TCQueryCriteriaExpression.Ope(const AExpression: ICQueryExpression): ICQueryCriteriaExpression;
var
  LNode: ICQueryExpression;
begin
  LNode := TCQueryExpression.Create;
  LNode.Assign(FLastAnd);
  FLastAnd.Left := LNode;
  FLastAnd.Operation := opOperation;
  FLastAnd.Right := AExpression;
  Result := Self;
end;

function TCQueryCriteriaExpression.OrOpe(const AExpression: ICQueryExpression): ICQueryCriteriaExpression;
var
  LNode: ICQueryExpression;
  LRoot: ICQueryExpression;
begin
  LRoot := FLastAnd;
  LNode := TCQueryExpression.Create;
  LNode.Assign(LRoot);
  LRoot.Left := LNode;
  LRoot.Operation := opOR;
  LRoot.Right := AExpression;
  FLastAnd := LRoot.Right;
  Result := Self;
end;

end.


