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

unit CQuery.Joins;

{$ifdef fpc}
  {$mode delphi}{$H+}
{$endif}

interface

uses
  SysUtils,
  Generics.Collections,
  CQuery.Expression,
  CQuery.Utils,
  CQuery.Section,
  CQuery.Name,
  CQuery.Interfaces;

type
  TCQueryJoin = class(TCQuerySection, ICQueryJoin)
  strict private
    FCondition: ICQueryExpression;
    FJoinedTable: ICQueryName;
    FJoinType: TJoinType;
    function _GetCondition: ICQueryExpression;
    function _GetJoinedTable: ICQueryName;
    function _GetJoinType: TJoinType;
    procedure _SetCondition(const Value: ICQueryExpression);
    procedure _SetJoinedTable(const Value: ICQueryName);
    procedure _SetJoinType(const Value: TJoinType);
  public
    constructor Create;
    destructor Destroy; override;
    procedure Clear; override;
    function IsEmpty: Boolean; override;
    property Condition: ICQueryExpression read _GetCondition write _SetCondition;
    property JoinedTable: ICQueryName read _GetJoinedTable write _SetJoinedTable;
    property JoinType: TJoinType read _GetJoinType write _SetJoinType;
  end;

  TCQueryJoins = class(TInterfacedObject, ICQueryJoins)
  strict private
    FJoins: TList<ICQueryJoin>;
    function SerializeJoinType(const AJoin: ICQueryJoin): String;
    function _GetJoins(AIdx: Integer): ICQueryJoin;
    procedure _SetJoins(AIdx: Integer; const Value: ICQueryJoin);
  public
    constructor Create;
    destructor Destroy; override;
    function Add: ICQueryJoin; overload;
    procedure Add(const AJoin: ICQueryJoin); overload;
    procedure Clear;
    function Count: Integer;
    function IsEmpty: Boolean;
    function Serialize: String;
    property Joins[AIdx: Integer]: ICQueryJoin read _GetJoins write _SetJoins; default;
  end;

implementation

{ TCQueryJoin }

procedure TCQueryJoin.Clear;
begin
  FCondition.Clear;
  FJoinedTable.Clear;
end;

constructor TCQueryJoin.Create;
begin
  inherited Create('Join');
  FJoinedTable := TCQueryName.Create;
  FCondition := TCQueryExpression.Create;
end;

destructor TCQueryJoin.Destroy;
begin
  FCondition := nil;
  FJoinedTable := nil;
  inherited;
end;

function TCQueryJoin._GetCondition: ICQueryExpression;
begin
  Result := FCondition;
end;

function TCQueryJoin._GetJoinedTable: ICQueryName;
begin
  Result := FJoinedTable;
end;

function TCQueryJoin._GetJoinType: TJoinType;
begin
  Result := FJoinType;
end;

function TCQueryJoin.IsEmpty: Boolean;
begin
  Result := (FCondition.IsEmpty and FJoinedTable.IsEmpty);
end;

procedure TCQueryJoin._SetCondition(const Value: ICQueryExpression);
begin
  FCondition := Value;
end;

procedure TCQueryJoin._SetJoinedTable(const Value: ICQueryName);
begin
  FJoinedTable := Value;
end;

procedure TCQueryJoin._SetJoinType(const Value: TJoinType);
begin
  FJoinType := Value;
end;

{ TCQueryJoins }

procedure TCQueryJoins.Add(const AJoin: ICQueryJoin);
begin
  FJoins.Add(AJoin);
end;

function TCQueryJoins.Add: ICQueryJoin;
begin
  Result := TCQueryJoin.Create;
  Add(Result);
end;

procedure TCQueryJoins.Clear;
begin
  FJoins.Clear;
end;

function TCQueryJoins.Count: Integer;
begin
  Result := FJoins.Count;
end;

constructor TCQueryJoins.Create;
begin
  inherited Create;
  FJoins := TList<ICQueryJoin>.Create;
end;

destructor TCQueryJoins.Destroy;
begin
  FJoins.Free;
  inherited;
end;

function TCQueryJoins._GetJoins(AIdx: Integer): ICQueryJoin;
begin
  Result := FJoins[AIdx];
end;

function TCQueryJoins.IsEmpty: Boolean;
begin
  Result := (FJoins.Count = 0);
end;

function TCQueryJoins.Serialize: String;
var
  LFor: Integer;
  LJoin: ICQueryJoin;
begin
  Result := '';
  for LFor := 0 to Count -1 do
  begin
    LJoin := FJoins[LFor];
    Result := TUtils.Concat([Result,
                             SerializeJoinType(LJoin),
                             'JOIN',
                             LJoin.JoinedTable.Serialize,
                             'ON',
                             LJoin.Condition.Serialize]);
  end;
end;

function TCQueryJoins.SerializeJoinType(const AJoin: ICQueryJoin): String;
begin
  case AJoin.JoinType of
    jtINNER: Result := 'INNER';
    jtLEFT:  Result := 'LEFT';
    jtRIGHT: Result := 'RIGHT';
    jtFULL:  Result := 'FULL';
  else
    raise Exception.Create('Error Message');
  end;
end;

procedure TCQueryJoins._SetJoins(AIdx: Integer; const Value: ICQueryJoin);
begin
  FJoins[AIdx] := Value;
end;

end.


