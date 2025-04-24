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

unit CQuery.Register;

{$ifdef fpc}
  {$mode delphi}{$H+}
{$endif}

{$include ../cquery4d.inc}

interface

uses
  SysUtils,
  Generics.Collections,
  CQuery.Interfaces;

type
  TCQueryRegister = class
  strict private
    FCQLSerialize: TDictionary<string, ICQuerySerialize>;
    FCQLSelect: TDictionary<string, ICQuerySelect>;
    FCQLWhere: TDictionary<string, ICQueryWhere>;
    FCQLFunctions: TDictionary<string, ICQueryFunctions>;
  private
    procedure _RegisterDrivers;
    {$IFDEF FIREBIRD}procedure _RegisterFirebird;{$ENDIF}
    {$IFDEF MSSQL}procedure _RegisterMSSQL;{$ENDIF}
    {$IFDEF MYSQL}procedure _RegisterMySQL;{$ENDIF}
    {$IFDEF SQLITE}procedure _RegisterSQLite;{$ENDIF}
    {$IFDEF INTERBASE}procedure _RegisterInterbase;{$ENDIF}
    {$IFDEF DB2}procedure _RegisterDB2;{$ENDIF}
    {$IFDEF ORACLE}procedure _RegisterOracle;{$ENDIF}
    {$IFDEF INFORMIX}procedure _RegisterInformix;{$ENDIF}
    {$IFDEF POSTGRESQL}procedure _RegisterPostgreSQL;{$ENDIF}
    {$IFDEF ADS}procedure _RegisterADS;{$ENDIF}
    {$IFDEF ASA}procedure _RegisterASA;{$ENDIF}
    {$IFDEF ABSOLUTEDB}procedure _RegisterAbsoluteDB;{$ENDIF}
    {$IFDEF MONGODB}procedure _RegisterMongoDB;{$ENDIF}
    {$IFDEF ELEVATEDB}procedure _RegisterElevateDB;{$ENDIF}
    {$IFDEF NEXUSDB}procedure _RegisterNexusDB;{$ENDIF}
  public
    constructor Create;
    destructor Destroy; override;
    procedure RegisterSelect(const ADriverName: TCQueryDriver; const ACQLSelect: ICQuerySelect);
    function Select(const ADriverName: TCQueryDriver): ICQuerySelect;
    procedure RegisterWhere(const ADriverName: TCQueryDriver; const ACQLWhere: ICQueryWhere);
    function Where(const ADriverName: TCQueryDriver): ICQueryWhere;
    procedure RegisterFunctions(const ADriverName: TCQueryDriver; const ACQLFunctions: ICQueryFunctions);
    function Functions(const ADriverName: TCQueryDriver): ICQueryFunctions;
    procedure RegisterSerialize(const ADriverName: TCQueryDriver; const ACQLSelect: ICQuerySerialize);
    function Serialize(const ADriverName: TCQueryDriver): ICQuerySerialize;
  end;

implementation

uses
  {$IFDEF FIREBIRD}CQuery.SerializeFirebird, CQuery.SelectFirebird, CQuery.FunctionsFirebird;{$ENDIF}
  {$IFDEF MSSQL}CQuery.SerializeMSSQL, CQuery.SelectMSSQL, CQuery.FunctionsMSSQL;{$ENDIF}
  {$IFDEF MYSQL}CQuery.SerializeMySQL, CQuery.SelectMySQL, CQuery.FunctionsMySQL;{$ENDIF}
  {$IFDEF SQLITE}CQuery.SerializeSQLite, CQuery.SelectSQLite, CQuery.FunctionsSQLite;{$ENDIF}
  {$IFDEF INTERBASE}CQuery.SerializeInterbase, CQuery.SelectInterbase, CQuery.FunctionsInterbase;{$ENDIF}
  {$IFDEF DB2}CQuery.SerializeDB2, CQuery.SelectDB2, CQuery.FunctionsDB2;{$ENDIF}
  {$IFDEF ORACLE}CQuery.SerializeOracle, CQuery.SelectOracle, CQuery.FunctionsOracle;{$ENDIF}
  {$IFDEF INFORMIX}CQuery.SerializeInformix, CQuery.SelectInformix, CQuery.FunctionsInformix;{$ENDIF}
  {$IFDEF POSTGRESQL}CQuery.SerializePostgreSQL, CQuery.SelectPostgreSQL, CQuery.FunctionsPostgreSQL;{$ENDIF}
  {$IFDEF ADS}CQuery.SerializeADS, CQuery.SelectADS, CQuery.FunctionsADS;{$ENDIF}
  {$IFDEF ASA}CQuery.SerializeASA, CQuery.SelectASA, CQuery.FunctionsASA;{$ENDIF}
  {$IFDEF ABSOLUTEDB}CQuery.SerializeAbsoluteDB, CQuery.SelectAbsoluteDB, CQuery.FunctionsAbsoluteDB;{$ENDIF}
  {$IFDEF MONGODB}CQuery.SerializeMongoDB, CQuery.SelectMongoDB, CQuery.FunctionsMongoDB;{$ENDIF}
  {$IFDEF ELEVATEDB}CQuery.SerializeElevateDB, CQuery.SelectElevateDB, CQuery.FunctionsElevateDB;{$ENDIF}
  {$IFDEF NEXUSDB}CQuery.SerializeNexusDB, CQuery.SelectNexusDB, CQuery.FunctionsNexusDB;{$ENDIF}

const
  TStrDBEngineName: array[dbnMSSQL..dbnNexusDB] of string = (
    'MSSQL', 'MySQL', 'Firebird', 'SQLite', 'Interbase', 'DB2',
    'Oracle', 'Informix', 'PostgreSQL', 'ADS', 'ASA', 'AbsoluteDB',
    'MongoDB', 'ElevateDB', 'NexusDB'
  );

constructor TCQueryRegister.Create;
begin
  FCQLSelect := TDictionary<string, ICQuerySelect>.Create;
  FCQLWhere := TDictionary<string, ICQueryWhere>.Create;
  FCQLSerialize := TDictionary<string, ICQuerySerialize>.Create;
  FCQLFunctions := TDictionary<string, ICQueryFunctions>.Create;

  _RegisterDrivers;
end;

destructor TCQueryRegister.Destroy;
var
  LKey: string;
begin
  for LKey in FCQLSerialize.Keys do
    FCQLSerialize[LKey] := nil;
  FCQLSerialize.Free;

  for LKey in FCQLSelect.Keys do
    FCQLSelect[LKey] := nil;
  FCQLSelect.Free;

  for LKey in FCQLWhere.Keys do
    FCQLWhere[LKey] := nil;
  FCQLWhere.Free;

  for LKey in FCQLFunctions.Keys do
    FCQLFunctions[LKey] := nil;
  FCQLFunctions.Free;
  inherited;
end;

procedure TCQueryRegister._RegisterDrivers;
begin
  {$IFDEF FIREBIRD}_RegisterFirebird;{$ENDIF}
  {$IFDEF MSSQL}_RegisterMSSQL;{$ENDIF}
  {$IFDEF MYSQL}_RegisterMySQL;{$ENDIF}
  {$IFDEF SQLITE}_RegisterSQLite;{$ENDIF}
  {$IFDEF INTERBASE}_RegisterInterbase;{$ENDIF}
  {$IFDEF DB2}_RegisterDB2;{$ENDIF}
  {$IFDEF ORACLE}_RegisterOracle;{$ENDIF}
  {$IFDEF INFORMIX}_RegisterInformix;{$ENDIF}
  {$IFDEF POSTGRESQL}_RegisterPostgreSQL;{$ENDIF}
  {$IFDEF ADS}_RegisterADS;{$ENDIF}
  {$IFDEF ASA}_RegisterASA;{$ENDIF}
  {$IFDEF ABSOLUTEDB}_RegisterAbsoluteDB;{$ENDIF}
  {$IFDEF MONGODB}_RegisterMongoDB;{$ENDIF}
  {$IFDEF ELEVATEDB}_RegisterElevateDB;{$ENDIF}
  {$IFDEF NEXUSDB}_RegisterNexusDB;{$ENDIF}
end;

{$IFDEF FIREBIRD}
procedure TCQueryRegister._RegisterFirebird;
begin
  Self.RegisterSerialize(dbnFirebird, TCQuerySerializerFirebird.Create);
  Self.RegisterSelect(dbnFirebird, TCQuerySelectFirebird.Create);
  Self.RegisterFunctions(dbnFirebird, TCQueryFunctionsFirebird.Create);
end;
{$ENDIF}

{$IFDEF MSSQL}
procedure TCQueryRegister._RegisterMSSQL;
begin
  Self.RegisterSerialize(dbnMSSQL, TCQuerySerializerMSSQL.Create);
  Self.RegisterSelect(dbnMSSQL, TCQuerySelectMSSQL.Create);
  Self.RegisterFunctions(dbnMSSQL, TCQueryFunctionsMSSQL.Create);
end;
{$ENDIF}

{$IFDEF MYSQL}
procedure TCQueryRegister._RegisterMySQL;
begin
  Self.RegisterSerialize(dbnMySQL, TCQuerySerializerMySQL.Create);
  Self.RegisterSelect(dbnMySQL, TCQuerySelectMySQL.Create);
  Self.RegisterFunctions(dbnMySQL, TCQueryFunctionsMySQL.Create);
end;
{$ENDIF}

{$IFDEF SQLITE}
procedure TCQueryRegister._RegisterSQLite;
begin
  Self.RegisterSerialize(dbnSQLite, TCQuerySerializerSQLite.Create);
  Self.RegisterSelect(dbnSQLite, TCQuerySelectSQLite.Create);
  Self.RegisterFunctions(dbnSQLite, TCQueryFunctionsSQLite.Create);
end;
{$ENDIF}

{$IFDEF INTERBASE}
procedure TCQueryRegister._RegisterInterbase;
begin
  Self.RegisterSerialize(dbnInterbase, TCQuerySerializerInterbase.Create);
  Self.RegisterSelect(dbnInterbase, TCQuerySelectInterbase.Create);
  Self.RegisterFunctions(dbnInterbase, TCQueryFunctionsInterbase.Create);
end;
{$ENDIF}

{$IFDEF DB2}
procedure TCQueryRegister._RegisterDB2;
begin
  Self.RegisterSerialize(dbnDB2, TCQuerySerializeDB2.Create);
  Self.RegisterSelect(dbnDB2, TCQuerySelectDB2.Create);
  Self.RegisterFunctions(dbnDB2, TCQueryFunctionsDB2.Create);
end;
{$ENDIF}

{$IFDEF ORACLE}
procedure TCQueryRegister._RegisterOracle;
begin
  Self.RegisterSerialize(dbnOracle, TCQuerySerializeOracle.Create);
  Self.RegisterSelect(dbnOracle, TCQuerySelectOracle.Create);
  Self.RegisterFunctions(dbnOracle, TCQueryFunctionsOracle.Create);
end;
{$ENDIF}

{$IFDEF INFORMIX}
procedure TCQueryRegister._RegisterInformix;
begin
  Self.RegisterSerialize(dbnInformix, TCQuerySerializeInformix.Create);
  Self.RegisterSelect(dbnInformix, TCQuerySelectInformix.Create);
  Self.RegisterFunctions(dbnInformix, TCQueryFunctionsInformix.Create);
end;
{$ENDIF}

{$IFDEF POSTGRESQL}
procedure TCQueryRegister._RegisterPostgreSQL;
begin
  Self.RegisterSerialize(dbnPostgreSQL, TCQuerySerializerPostgreSQL.Create);
  Self.RegisterSelect(dbnPostgreSQL, TCQuerySelectPostgreSQL.Create);
  Self.RegisterFunctions(dbnPostgreSQL, TCQueryFunctionsPostgreSQL.Create);
end;
{$ENDIF}

{$IFDEF ADS}
procedure TCQueryRegister._RegisterADS;
begin
  Self.RegisterSerialize(dbnADS, TCQuerySerializeADS.Create);
  Self.RegisterSelect(dbnADS, TCQuerySelectADS.Create);
  Self.RegisterFunctions(dbnADS, TCQueryFunctionsADS.Create);
end;
{$ENDIF}

{$IFDEF ASA}
procedure TCQueryRegister._RegisterASA;
begin
  Self.RegisterSerialize(dbnASA, TCQuerySerializeASA.Create);
  Self.RegisterSelect(dbnASA, TCQuerySelectASA.Create);
  Self.RegisterFunctions(dbnASA, TCQueryFunctionsASA.Create);
end;
{$ENDIF}

{$IFDEF ABSOLUTEDB}
procedure TCQueryRegister._RegisterAbsoluteDB;
begin
  Self.RegisterSerialize(dbnAbsoluteDB, TCQuerySerializeAbsoluteDB.Create);
  Self.RegisterSelect(dbnAbsoluteDB, TCQuerySelectAbsoluteDB.Create);
  Self.RegisterFunctions(dbnAbsoluteDB, TCQueryFunctionsAbsoluteDB.Create);
end;
{$ENDIF}

{$IFDEF MONGODB}
procedure TCQueryRegister._RegisterMongoDB;
begin
  Self.RegisterSerialize(dbnMongoDB, TCQuerySerializerMongoDB.Create);
  Self.RegisterSelect(dbnMongoDB, TCQuerySelectMongoDB.Create);
  Self.RegisterFunctions(dbnMongoDB, TCQueryFunctionsMongoDB.Create);
end;
{$ENDIF}

{$IFDEF ELEVATEDB}
procedure TCQueryRegister._RegisterElevateDB;
begin
  Self.RegisterSerialize(dbnElevateDB, TCQuerySerializeElevateDB.Create);
  Self.RegisterSelect(dbnElevateDB, TCQuerySelectElevateDB.Create);
  Self.RegisterFunctions(dbnElevateDB, TCQueryFunctionsElevateDB.Create);
end;
{$ENDIF}

{$IFDEF NEXUSDB}
procedure TCQueryRegister._RegisterNexusDB;
begin
  Self.RegisterSerialize(dbnNexusDB, TCQuerySerializeNexusDB.Create);
  Self.RegisterSelect(dbnNexusDB, TCQuerySelectNexusDB.Create);
  Self.RegisterFunctions(dbnNexusDB, TCQueryFunctionsNexusDB.Create);
end;
{$ENDIF}

function TCQueryRegister.Functions(const ADriverName: TCQueryDriver): ICQueryFunctions;
begin
  Result := nil;
  if FCQLFunctions.ContainsKey(TStrDBEngineName[ADriverName]) then
    Result := FCQLFunctions[TStrDBEngineName[ADriverName]];
end;

function TCQueryRegister.Select(const ADriverName: TCQueryDriver): ICQuerySelect;
begin
  Result := nil;
  if not FCQLSelect.ContainsKey(TStrDBEngineName[ADriverName]) then
    raise Exception.Create('O select do banco ' + TStrDBEngineName[ADriverName] + ' não está registrado, adicione a unit "CQuery.Select.???.pas" onde ??? nome do banco, na cláusula USES do seu projeto!');

  Result := FCQLSelect[TStrDBEngineName[ADriverName]];
end;

procedure TCQueryRegister.RegisterFunctions(const ADriverName: TCQueryDriver; const ACQLFunctions: ICQueryFunctions);
begin
  FCQLFunctions.AddOrSetValue(TStrDBEngineName[ADriverName], ACQLFunctions);
end;

procedure TCQueryRegister.RegisterSelect(const ADriverName: TCQueryDriver; const ACQLSelect: ICQuerySelect);
begin
  FCQLSelect.AddOrSetValue(TStrDBEngineName[ADriverName], ACQLSelect);
end;

function TCQueryRegister.Serialize(const ADriverName: TCQueryDriver): ICQuerySerialize;
begin
  if not FCQLSerialize.ContainsKey(TStrDBEngineName[ADriverName]) then
    raise Exception.Create('O serialize do banco ' + TStrDBEngineName[ADriverName] + ' não está registrado, adicione a unit "CQuery.Serialize.???.pas" onde ??? nome do banco, na cláusula USES do seu projeto!');

  Result := FCQLSerialize[TStrDBEngineName[ADriverName]];
end;

function TCQueryRegister.Where(const ADriverName: TCQueryDriver): ICQueryWhere;
begin
  Result := nil;
  if FCQLWhere.ContainsKey(TStrDBEngineName[ADriverName]) then
    Result := FCQLWhere[TStrDBEngineName[ADriverName]];
end;

procedure TCQueryRegister.RegisterSerialize(const ADriverName: TCQueryDriver; const ACQLSelect: ICQuerySerialize);
begin
  FCQLSerialize.AddOrSetValue(TStrDBEngineName[ADriverName], ACQLSelect);
end;

procedure TCQueryRegister.RegisterWhere(const ADriverName: TCQueryDriver; const ACQLWhere: ICQueryWhere);
begin
  FCQLWhere.AddOrSetValue(TStrDBEngineName[ADriverName], ACQLWhere);
end;

end.

