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

unit CQuery.Ast;

{$ifdef fpc}
  {$mode delphi}{$H+}
{$endif}

interface

uses
  CQuery.Interfaces,
  CQuery.Register;

type
  TCQueryAST = class(TInterfacedObject, ICQueryAST)
  strict private
    FRegister: TCQueryRegister;
    FASTColumns: ICQueryNames;
    FASTSection: ICQuerySection;
    FASTName: ICQueryName;
    FASTTableNames: ICQueryNames;
    FSelect: ICQuerySelect;
    FInsert: ICQueryInsert;
    FUpdate: ICQueryUpdate;
    FDelete : ICQueryDelete;
    FGroupBy: ICQueryGroupBy;
    FHaving: ICQueryHaving;
    FJoins: ICQueryJoins;
    FOrderBy: ICQueryOrderBy;
    FWhere: ICQueryWhere;
    function _GetASTColumns: ICQueryNames;
    procedure _SetASTColumns(const Value: ICQueryNames);
    function _GetASTSection: ICQuerySection;
    procedure _SetASTSection(const Value: ICQuerySection);
    function _GetASTName: ICQueryName;
    procedure _SetASTName(const Value: ICQueryName);
    function _GetASTTableNames: ICQueryNames;
    procedure _SetASTTableNames(const Value: ICQueryNames);
  public
    constructor Create(const ADatabase: TCQueryDriver; const ARegister: TCQueryRegister);
    destructor Destroy; override;
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

implementation

uses
  CQuery.Select,
  CQuery.OrderBy,
  CQuery.Where,
  CQuery.Delete,
  CQuery.Joins,
  CQuery.GroupBy,
  CQuery.Having,
  CQuery.Insert,
  CQuery.Update;

{ TCQueryAST }

procedure TCQueryAST.Clear;
begin
  FSelect.Clear;
  FDelete.Clear;
  FInsert.Clear;
  FUpdate.Clear;
  FJoins.Clear;
  FWhere.Clear;
  FGroupBy.Clear;
  FHaving.Clear;
  FOrderBy.Clear;
end;

constructor TCQueryAST.Create(const ADatabase: TCQueryDriver; const ARegister: TCQueryRegister);
begin
  FRegister := ARegister;
  FDelete := TCQueryDelete.Create;
  FInsert := TCQueryInsert.Create;
  FUpdate := TCQueryUpdate.Create;
  FJoins := TCQueryJoins.Create;
  FSelect := FRegister.Select(ADatabase);
  FWhere := FRegister.Where(ADatabase);
  if FWhere = nil then
    FWhere := TCQueryWhere.Create;
  FGroupBy := TCQueryGroupBy.Create;
  FHaving := TCQueryHaving.Create;
  FOrderBy := TCQueryOrderBy.Create;
end;

function TCQueryAST.Delete: ICQueryDelete;
begin
  Result := FDelete;
end;

destructor TCQueryAST.Destroy;
begin
  FASTColumns := nil;
  FASTSection := nil;
  FASTName := nil;
  FASTTableNames := nil;
  FSelect := nil;
  FInsert := nil;
  FUpdate := nil;
  FDelete  := nil;
  FGroupBy := nil;
  FHaving := nil;
  FJoins := nil;
  FOrderBy := nil;
  FWhere := nil;
  FRegister := nil;
  inherited;
end;

function TCQueryAST._GetASTColumns: ICQueryNames;
begin
  Result := FASTColumns;
end;

function TCQueryAST._GetASTName: ICQueryName;
begin
  Result := FASTName;
end;

function TCQueryAST._GetASTSection: ICQuerySection;
begin
  Result := FASTSection;
end;

function TCQueryAST._GetASTTableNames: ICQueryNames;
begin
  Result := FASTTableNames;
end;

function TCQueryAST.GroupBy: ICQueryGroupBy;
begin
  Result := FGroupBy;
end;

function TCQueryAST.Having: ICQueryHaving;
begin
  Result := FHaving;
end;

function TCQueryAST.Insert: ICQueryInsert;
begin
  Result := FInsert;
end;

function TCQueryAST.IsEmpty: Boolean;
begin
  Result := FSelect.IsEmpty and
            FJoins.IsEmpty and
            FWhere.IsEmpty and
            FGroupBy.IsEmpty and
            FHaving.IsEmpty and
            FOrderBy.IsEmpty;
end;

function TCQueryAST.Joins: ICQueryJoins;
begin
  Result := FJoins;
end;

function TCQueryAST.OrderBy: ICQueryOrderBy;
begin
  Result := FOrderBy;
end;

function TCQueryAST.Select: ICQuerySelect;
begin
  Result := FSelect;
end;

procedure TCQueryAST._SetASTColumns(const Value: ICQueryNames);
begin
  FASTColumns := Value;
end;

procedure TCQueryAST._SetASTName(const Value: ICQueryName);
begin
  FASTName := Value;
end;

procedure TCQueryAST._SetASTSection(const Value: ICQuerySection);
begin
  FASTSection := Value;
end;

procedure TCQueryAST._SetASTTableNames(const Value: ICQueryNames);
begin
  FASTTableNames := Value;
end;

function TCQueryAST.Update: ICQueryUpdate;
begin
  Result := FUpdate;
end;

function TCQueryAST.Where: ICQueryWhere;
begin
  Result := FWhere;
end;

end.


