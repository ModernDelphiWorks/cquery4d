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

unit CQL.Joins;

{$ifdef fpc}
  {$mode delphi}{$H+}
{$endif}

interface

uses
  SysUtils,
  Generics.Collections,
  CQL.Expression,
  CQL.Utils,
  CQL.Section,
  CQL.Name,
  CQL.Interfaces;

type
  TCQLJoin = class(TCQLSection, ICQLJoin)
  strict private
    FCondition: ICQLExpression;
    FJoinedTable: ICQLName;
    FJoinType: TJoinType;
    function _GetCondition: ICQLExpression;
    function _GetJoinedTable: ICQLName;
    function _GetJoinType: TJoinType;
    procedure _SetCondition(const Value: ICQLExpression);
    procedure _SetJoinedTable(const Value: ICQLName);
    procedure _SetJoinType(const Value: TJoinType);
  public
    constructor Create;
    destructor Destroy; override;
    procedure Clear; override;
    function IsEmpty: Boolean; override;
    property Condition: ICQLExpression read _GetCondition write _SetCondition;
    property JoinedTable: ICQLName read _GetJoinedTable write _SetJoinedTable;
    property JoinType: TJoinType read _GetJoinType write _SetJoinType;
  end;

  TCQLJoins = class(TInterfacedObject, ICQLJoins)
  strict private
    FJoins: TList<ICQLJoin>;
    function SerializeJoinType(const AJoin: ICQLJoin): String;
    function _GetJoins(AIdx: Integer): ICQLJoin;
    procedure _SetJoins(AIdx: Integer; const Value: ICQLJoin);
  public
    constructor Create;
    destructor Destroy; override;
    function Add: ICQLJoin; overload;
    procedure Add(const AJoin: ICQLJoin); overload;
    procedure Clear;
    function Count: Integer;
    function IsEmpty: Boolean;
    function Serialize: String;
    property Joins[AIdx: Integer]: ICQLJoin read _GetJoins write _SetJoins; default;
  end;

implementation

{ TCQLJoin }

procedure TCQLJoin.Clear;
begin
  FCondition.Clear;
  FJoinedTable.Clear;
end;

constructor TCQLJoin.Create;
begin
  inherited Create('Join');
  FJoinedTable := TCQLName.Create;
  FCondition := TCQLExpression.Create;
end;

destructor TCQLJoin.Destroy;
begin
  FCondition := nil;
  FJoinedTable := nil;
  inherited;
end;

function TCQLJoin._GetCondition: ICQLExpression;
begin
  Result := FCondition;
end;

function TCQLJoin._GetJoinedTable: ICQLName;
begin
  Result := FJoinedTable;
end;

function TCQLJoin._GetJoinType: TJoinType;
begin
  Result := FJoinType;
end;

function TCQLJoin.IsEmpty: Boolean;
begin
  Result := (FCondition.IsEmpty and FJoinedTable.IsEmpty);
end;

procedure TCQLJoin._SetCondition(const Value: ICQLExpression);
begin
  FCondition := Value;
end;

procedure TCQLJoin._SetJoinedTable(const Value: ICQLName);
begin
  FJoinedTable := Value;
end;

procedure TCQLJoin._SetJoinType(const Value: TJoinType);
begin
  FJoinType := Value;
end;

{ TCQLJoins }

procedure TCQLJoins.Add(const AJoin: ICQLJoin);
begin
  FJoins.Add(AJoin);
end;

function TCQLJoins.Add: ICQLJoin;
begin
  Result := TCQLJoin.Create;
  Add(Result);
end;

procedure TCQLJoins.Clear;
begin
  FJoins.Clear;
end;

function TCQLJoins.Count: Integer;
begin
  Result := FJoins.Count;
end;

constructor TCQLJoins.Create;
begin
  inherited Create;
  FJoins := TList<ICQLJoin>.Create;
end;

destructor TCQLJoins.Destroy;
begin
  FJoins.Free;
  inherited;
end;

function TCQLJoins._GetJoins(AIdx: Integer): ICQLJoin;
begin
  Result := FJoins[AIdx];
end;

function TCQLJoins.IsEmpty: Boolean;
begin
  Result := (FJoins.Count = 0);
end;

function TCQLJoins.Serialize: String;
var
  LFor: Integer;
  LJoin: ICQLJoin;
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

function TCQLJoins.SerializeJoinType(const AJoin: ICQLJoin): String;
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

procedure TCQLJoins._SetJoins(AIdx: Integer; const Value: ICQLJoin);
begin
  FJoins[AIdx] := Value;
end;

end.

