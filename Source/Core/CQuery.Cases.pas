{
               CQuery4D: Fluent SQL Framework for Delphi

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

unit CQuery.Cases;

{$ifdef fpc}
  {$mode delphi}{$H+}
{$endif}

interface

uses
  SysUtils,
  Generics.Collections,
  CQuery.Interfaces,
  CQuery.Expression;

type
  TCQueryCaseWhenThen = class(TInterfacedObject, ICQueryCaseWhenThen)
  strict private
    FThenExpression: ICQueryExpression;
    FWhenExpression: ICQueryExpression;
  protected
    function GetThenExpression: ICQueryExpression;
    function GetWhenExpression: ICQueryExpression;
    procedure SetThenExpression(const AValue: ICQueryExpression);
    procedure SetWhenExpression(const AValue: ICQueryExpression);
  public
    constructor Create;
    destructor Destroy; override;
    property WhenExpression: ICQueryExpression read GetWhenExpression write SetWhenExpression;
    property ThenExpression: ICQueryExpression read GetThenExpression write SetThenExpression;
  end;

  TCQueryCaseWhenList = class(TInterfacedObject, ICQueryCaseWhenList)
  strict private
    FWhenThenList: TList<ICQueryCaseWhenThen>;
  protected
    function GetWhenThen(AIdx: Integer): ICQueryCaseWhenThen;
    procedure SetWhenThen(AIdx: Integer; const AValue: ICQueryCaseWhenThen);
    constructor Create;
  public
    destructor Destroy; override;
    function Add: ICQueryCaseWhenThen; overload;
    function Add(const AWhenThen: ICQueryCaseWhenThen): Integer; overload;
    function Count: Integer;
    property WhenThen[AIdx: Integer]: ICQueryCaseWhenThen read GetWhenThen write SetWhenThen; default;
  end;

  TCQueryCase = class(TInterfacedObject, ICQueryCase)
  protected
    FCaseExpression: ICQueryExpression;
    FElseExpression: ICQueryExpression;
    FWhenList: ICQueryCaseWhenList;
    function SerializeExpression(const AExpression: ICQueryExpression): String;
    function GetCaseExpression: ICQueryExpression;
    function GetElseExpression: ICQueryExpression;
    function GetWhenList: ICQueryCaseWhenList;
    procedure SetCaseExpression(const AValue: ICQueryExpression);
    procedure SetElseExpression(const AValue: ICQueryExpression);
    procedure SetWhenList(const AValue: ICQueryCaseWhenList);
  public
    constructor Create;
    destructor Destroy; override;
    function Serialize: String; virtual;
    property CaseExpression: ICQueryExpression read GetCaseExpression write SetCaseExpression;
    property WhenList: ICQueryCaseWhenList read GetWhenList write SetWhenList;
    property ElseExpression: ICQueryExpression read GetElseExpression write SetElseExpression;
  end;

  TCQueryCriteriaCase = class(TInterfacedObject, ICQueryCriteriaCase)
  strict private
    FOwner: ICQuery;
    FCase: ICQueryCase;
    FLastExpression: ICQueryCriteriaExpression;
    function _GetCase: ICQueryCase;
  public
    constructor Create(const AOwner: ICQuery; const AExpression: String);
    destructor Destroy; override;
    function AndOpe(const AExpression: array of const): ICQueryCriteriaCase; overload;
    function AndOpe(const AExpression: String): ICQueryCriteriaCase; overload;
    function AndOpe(const AExpression: ICQueryCriteriaExpression): ICQueryCriteriaCase; overload;
    function ElseIf(const AValue: String): ICQueryCriteriaCase; overload;
    function ElseIf(const AValue: Int64): ICQueryCriteriaCase; overload;
    function EndCase: ICQuery;
    function OrOpe(const AExpression: array of const): ICQueryCriteriaCase; overload;
    function OrOpe(const AExpression: String): ICQueryCriteriaCase; overload;
    function OrOpe(const AExpression: ICQueryCriteriaExpression): ICQueryCriteriaCase; overload;
    function IfThen(const AValue: String): ICQueryCriteriaCase; overload;
    function IfThen(const AValue: Int64): ICQueryCriteriaCase; overload;
    function When(const ACondition: String): ICQueryCriteriaCase; overload;
    function When(const ACondition: array of const): ICQueryCriteriaCase; overload;
    function When(const ACondition: ICQueryCriteriaExpression): ICQueryCriteriaCase; overload;
    property Value: ICQueryCase read _GetCase;
  end;

implementation

uses
  CQuery.Utils;

{ TCQueryCase }

constructor TCQueryCase.Create;
begin
  FCaseExpression := TCQueryExpression.Create;
  FElseExpression := TCQueryExpression.Create;
  FWhenList := TCQueryCaseWhenList.Create;
end;

destructor TCQueryCase.Destroy;
begin
  FCaseExpression := nil;
  FElseExpression := nil;
  FWhenList := nil;
  inherited;
end;

function TCQueryCase.GetCaseExpression: ICQueryExpression;
begin
  Result := FCaseExpression;
end;

function TCQueryCase.GetElseExpression: ICQueryExpression;
begin
  Result := FElseExpression;
end;

function TCQueryCase.GetWhenList: ICQueryCaseWhenList;
begin
  Result := FWhenList;
end;

function TCQueryCase.Serialize: String;
var
  LFor: Integer;
  LWhenThen: ICQueryCaseWhenThen;
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

function TCQueryCase.SerializeExpression(const AExpression: ICQueryExpression): String;
begin
  Result := AExpression.Serialize;
end;

procedure TCQueryCase.SetCaseExpression(const AValue: ICQueryExpression);
begin
  FCaseExpression := AValue;
end;

procedure TCQueryCase.SetElseExpression(const AValue: ICQueryExpression);
begin
  FElseExpression := AValue;
end;

procedure TCQueryCase.SetWhenList(const AValue: ICQueryCaseWhenList);
begin
  FWhenList := AValue;
end;

{ TCQueryCaseWhenList }

constructor TCQueryCaseWhenList.Create;
begin
  FWhenThenList := TList<ICQueryCaseWhenThen>.Create;
end;

destructor TCQueryCaseWhenList.Destroy;
begin
  FWhenThenList.Free;
  inherited;
end;

function TCQueryCaseWhenList.Add: ICQueryCaseWhenThen;
begin
  Result := TCQueryCaseWhenThen.Create;
  Add(Result);
end;

function TCQueryCaseWhenList.Add(const AWhenThen: ICQueryCaseWhenThen): Integer;
begin
  Result := FWhenThenList.Add(AWhenThen);
end;

function TCQueryCaseWhenList.Count: Integer;
begin
  Result := FWhenThenList.Count;
end;

function TCQueryCaseWhenList.GetWhenThen(AIdx: Integer): ICQueryCaseWhenThen;
begin
  Result := FWhenThenList[AIdx];
end;

procedure TCQueryCaseWhenList.SetWhenThen(AIdx: Integer; const AValue: ICQueryCaseWhenThen);
begin
  FWhenThenList[AIdx] := AValue;
end;

{ TCQueryCaseWhenThen }

constructor TCQueryCaseWhenThen.Create;
begin
  FWhenExpression := TCQueryExpression.Create;
  FThenExpression := TCQueryExpression.Create;
end;

destructor TCQueryCaseWhenThen.Destroy;
begin
  FThenExpression := nil;
  FWhenExpression := nil;
  inherited;
end;

function TCQueryCaseWhenThen.GetThenExpression: ICQueryExpression;
begin
  Result := FThenExpression;
end;

function TCQueryCaseWhenThen.GetWhenExpression: ICQueryExpression;
begin
  Result := FWhenExpression;
end;

procedure TCQueryCaseWhenThen.SetThenExpression(const AValue: ICQueryExpression);
begin
  FThenExpression := AValue;
end;

procedure TCQueryCaseWhenThen.SetWhenExpression(const AValue: ICQueryExpression);
begin
  FWhenExpression := AValue;
end;

{ TCQueryCriteriaCase }

function TCQueryCriteriaCase.AndOpe(const AExpression: String): ICQueryCriteriaCase;
begin
  FLastExpression.AndOpe(AExpression);
  Result := Self;
end;

function TCQueryCriteriaCase.AndOpe(const AExpression: array of const): ICQueryCriteriaCase;
begin
  FLastExpression.AndOpe(AExpression);
  Result := Self;
end;

constructor TCQueryCriteriaCase.Create(const AOwner: ICQuery; const AExpression: String);
begin
  FOwner := AOwner;
  FCase := TCQueryCase.Create;
  if AExpression <> '' then
    FCase.CaseExpression.Term := AExpression;
end;

destructor TCQueryCriteriaCase.Destroy;
begin
  FOwner := nil;
  FCase := nil;
  FLastExpression := nil;
  inherited;
end;

function TCQueryCriteriaCase.ElseIf(const AValue: String): ICQueryCriteriaCase;
begin
  FLastExpression := TCQueryCriteriaExpression.Create(AValue);
  FCase.ElseExpression := FLastExpression.Expression;
  Result := Self;
end;

function TCQueryCriteriaCase.ElseIf(const AValue: int64): ICQueryCriteriaCase;
begin
  Result := ElseIf(IntToStr(AValue));
end;

function TCQueryCriteriaCase.EndCase: ICQuery;
begin
  Result := FOwner;
end;

function TCQueryCriteriaCase._GetCase: ICQueryCase;
begin
  Result := FCase;
end;

function TCQueryCriteriaCase.OrOpe(const AExpression: String): ICQueryCriteriaCase;
begin
  FLastExpression.OrOpe(AExpression);
  Result := Self;
end;

function TCQueryCriteriaCase.OrOpe(const AExpression: array of const): ICQueryCriteriaCase;
begin
  FLastExpression.OrOpe(AExpression);
  Result := Self;
end;

function TCQueryCriteriaCase.IfThen(const AValue: int64): ICQueryCriteriaCase;
begin
  Result := IfThen(IntToStr(AValue));
end;

function TCQueryCriteriaCase.When(const ACondition: ICQueryCriteriaExpression): ICQueryCriteriaCase;
var
  LWhenThen: ICQueryCaseWhenThen;
begin
  FLastExpression := ACondition;
  LWhenThen := FCase.WhenList.Add;
  LWhenThen.WhenExpression := FLastExpression.Expression;
  Result := Self;
end;

function TCQueryCriteriaCase.IfThen(const AValue: String): ICQueryCriteriaCase;
begin
  Assert(FCase.WhenList.Count > 0, 'TCQueryCriteriaCase.IfThen: Missing When');
  FLastExpression := TCQueryCriteriaExpression.Create(AValue);
  FCase.WhenList[FCase.WhenList.Count-1].ThenExpression := FLastExpression.Expression;
  Result := Self;
end;

function TCQueryCriteriaCase.When(const ACondition: array of const): ICQueryCriteriaCase;
begin
  Result := When(TUtils.SqlParamsToStr(ACondition));
end;

function TCQueryCriteriaCase.When(const ACondition: String): ICQueryCriteriaCase;
begin
  Result := When(TCQueryCriteriaExpression.Create(ACondition));
end;

function TCQueryCriteriaCase.OrOpe(const AExpression: ICQueryCriteriaExpression): ICQueryCriteriaCase;
begin
  FLastExpression.OrOpe(AExpression.Expression);
  Result := Self;
end;

function TCQueryCriteriaCase.AndOpe(const AExpression: ICQueryCriteriaExpression): ICQueryCriteriaCase;
begin
  FLastExpression.AndOpe(AExpression.Expression);
  Result := Self;
end;

end.



