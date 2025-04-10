unit CQL.Register;

{$ifdef fpc}
  {$mode delphi}{$H+}
{$endif}

{$include ../cquery4d.inc}

interface

uses
  SysUtils,
  Generics.Collections,
  CQL.Interfaces;

type
  TCQLRegister = class
  strict private
    FCQLSerialize: TDictionary<TDBName, ICQLSerialize>;
    FCQLSelect: TDictionary<TDBName, ICQLSelect>;
    FCQLWhere: TDictionary<TDBName, ICQLWhere>;
    FCQLFunctions: TDictionary<TDBName, ICQLFunctions>;
  private
    procedure _RegisterGeral;
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
    procedure RegisterSelect(const ADBName: TDBName; const ACQLSelect: ICQLSelect);
    function Select(const ADBName: TDBName): ICQLSelect;
    procedure RegisterWhere(const ADBName: TDBName; const ACQLWhere: ICQLWhere);
    function Where(const ADBName: TDBName): ICQLWhere;
    procedure RegisterFunctions(const ADBName: TDBName; const ACQLFunctions: ICQLFunctions);
    function Functions(const ADBName: TDBName): ICQLFunctions;
    procedure RegisterSerialize(const ADBName: TDBName; const ACQLSelect: ICQLSerialize);
    function Serialize(const ADBName: TDBName): ICQLSerialize;
  end;

implementation

uses
  {$IFDEF FIREBIRD}CQL.SerializeFirebird, CQL.SelectFirebird, CQL.FunctionsFirebird;{$ENDIF}
  {$IFDEF MSSQL}CQL.SerializeMSSQL, CQL.SelectMSSQL, CQL.FunctionsMSSQL;{$ENDIF}
  {$IFDEF MYSQL}CQL.SerializeMySQL, CQL.SelectMySQL, CQL.FunctionsMySQL;{$ENDIF}
  {$IFDEF SQLITE}CQL.SerializeSQLite, CQL.SelectSQLite, CQL.FunctionsSQLite;{$ENDIF}
  {$IFDEF INTERBASE}CQL.SerializeInterbase, CQL.SelectInterbase, CQL.FunctionsInterbase;{$ENDIF}
  {$IFDEF DB2}CQL.SerializeDB2, CQL.SelectDB2, CQL.FunctionsDB2;{$ENDIF}
  {$IFDEF ORACLE}CQL.SerializeOracle, CQL.SelectOracle, CQL.FunctionsOracle;{$ENDIF}
  {$IFDEF INFORMIX}CQL.SerializeInformix, CQL.SelectInformix, CQL.FunctionsInformix;{$ENDIF}
  {$IFDEF POSTGRESQL}CQL.SerializePostgreSQL, CQL.SelectPostgreSQL, CQL.FunctionsPostgreSQL;{$ENDIF}
  {$IFDEF ADS}CQL.SerializeADS, CQL.SelectADS, CQL.FunctionsADS;{$ENDIF}
  {$IFDEF ASA}CQL.SerializeASA, CQL.SelectASA, CQL.FunctionsASA;{$ENDIF}
  {$IFDEF ABSOLUTEDB}CQL.SerializeAbsoluteDB, CQL.SelectAbsoluteDB, CQL.FunctionsAbsoluteDB;{$ENDIF}
  {$IFDEF MONGODB}CQL.SerializeMongoDB, CQL.SelectMongoDB, CQL.FunctionsMongoDB;{$ENDIF}
  {$IFDEF ELEVATEDB}CQL.SerializeElevateDB, CQL.SelectElevateDB, CQL.FunctionsElevateDB;{$ENDIF}
  {$IFDEF NEXUSDB}CQL.SerializeNexusDB, CQL.SelectNexusDB, CQL.FunctionsNexusDB;{$ENDIF}

const
  TStrDBName: array[dbnMSSQL..dbnNexusDB] of String = (
    'MSSQL', 'MySQL', 'Firebird', 'SQLite', 'Interbase', 'DB2',
    'Oracle', 'Informix', 'PostgreSQL', 'ADS', 'ASA',
    'AbsoluteDB', 'MongoDB', 'ElevateDB', 'NexusDB'
  );

constructor TCQLRegister.Create;
begin
  FCQLSelect := TDictionary<TDBName, ICQLSelect>.Create;
  FCQLWhere := TDictionary<TDBName, ICQLWhere>.Create;
  FCQLSerialize := TDictionary<TDBName, ICQLSerialize>.Create;
  FCQLFunctions := TDictionary<TDBName, ICQLFunctions>.Create;

  _RegisterGeral;
end;

destructor TCQLRegister.Destroy;
var
  LKey: TDBName;
begin
//  for LKey in FCQLSerialize.Keys do
//    FCQLSerialize[LKey] := nil;
//  FCQLSerialize.Clear;
  FCQLSerialize.Free;

//  for LKey in FCQLSelect.Keys do
//    FCQLSelect[LKey] := nil;
//  FCQLSelect.Clear;
  FCQLSelect.Free;

//  for LKey in FCQLWhere.Keys do
//    FCQLWhere[LKey] := nil;
//  FCQLWhere.Clear;
  FCQLWhere.Free;

//  for LKey in FCQLFunctions.Keys do
//    FCQLFunctions[LKey] := nil;
//  FCQLFunctions.Clear;
  FCQLFunctions.Free;

  inherited;
end;

procedure TCQLRegister._RegisterGeral;
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
procedure TCQLRegister._RegisterFirebird;
begin
  Self.RegisterSerialize(dbnFirebird, TCQLSerializerFirebird.Create);
  Self.RegisterSelect(dbnFirebird, TCQLSelectFirebird.Create);
  Self.RegisterFunctions(dbnFirebird, TCQLFunctionsFirebird.Create);
end;
{$ENDIF}

{$IFDEF MSSQL}
procedure TCQLRegister._RegisterMSSQL;
begin
  Self.RegisterSerialize(dbnMSSQL, TCQLSerializerMSSQL.Create);
  Self.RegisterSelect(dbnMSSQL, TCQLSelectMSSQL.Create);
  Self.RegisterFunctions(dbnMSSQL, TCQLFunctionsMSSQL.Create);
end;
{$ENDIF}

{$IFDEF MYSQL}
procedure TCQLRegister._RegisterMySQL;
begin
  Self.RegisterSerialize(dbnMySQL, TCQLSerializerMySQL.Create);
  Self.RegisterSelect(dbnMySQL, TCQLSelectMySQL.Create);
  Self.RegisterFunctions(dbnMySQL, TCQLFunctionsMySQL.Create);
end;
{$ENDIF}

{$IFDEF SQLITE}
procedure TCQLRegister._RegisterSQLite;
begin
  Self.RegisterSerialize(dbnSQLite, TCQLSerializerSQLite.Create);
  Self.RegisterSelect(dbnSQLite, TCQLSelectSQLite.Create);
  Self.RegisterFunctions(dbnSQLite, TCQLFunctionsSQLite.Create);
end;
{$ENDIF}

{$IFDEF INTERBASE}
procedure TCQLRegister._RegisterInterbase;
begin
  Self.RegisterSerialize(dbnInterbase, TCQLSerializerInterbase.Create);
  Self.RegisterSelect(dbnInterbase, TCQLSelectInterbase.Create);
  Self.RegisterFunctions(dbnInterbase, TCQLFunctionsInterbase.Create);
end;
{$ENDIF}

{$IFDEF DB2}
procedure TCQLRegister._RegisterDB2;
begin
  Self.RegisterSerialize(dbnDB2, TCQLSerializeDB2.Create);
  Self.RegisterSelect(dbnDB2, TCQLSelectDB2.Create);
  Self.RegisterFunctions(dbnDB2, TCQLFunctionsDB2.Create);
end;
{$ENDIF}

{$IFDEF ORACLE}
procedure TCQLRegister._RegisterOracle;
begin
  Self.RegisterSerialize(dbnOracle, TCQLSerializeOracle.Create);
  Self.RegisterSelect(dbnOracle, TCQLSelectOracle.Create);
  Self.RegisterFunctions(dbnOracle, TCQLFunctionsOracle.Create);
end;
{$ENDIF}

{$IFDEF INFORMIX}
procedure TCQLRegister._RegisterInformix;
begin
  Self.RegisterSerialize(dbnInformix, TCQLSerializeInformix.Create);
  Self.RegisterSelect(dbnInformix, TCQLSelectInformix.Create);
  Self.RegisterFunctions(dbnInformix, TCQLFunctionsInformix.Create);
end;
{$ENDIF}

{$IFDEF POSTGRESQL}
procedure TCQLRegister._RegisterPostgreSQL;
begin
  Self.RegisterSerialize(dbnPostgreSQL, TCQLSerializerPostgreSQL.Create);
  Self.RegisterSelect(dbnPostgreSQL, TCQLSelectPostgreSQL.Create);
  Self.RegisterFunctions(dbnPostgreSQL, TCQLFunctionsPostgreSQL.Create);
end;
{$ENDIF}

{$IFDEF ADS}
procedure TCQLRegister._RegisterADS;
begin
  Self.RegisterSerialize(dbnADS, TCQLSerializeADS.Create);
  Self.RegisterSelect(dbnADS, TCQLSelectADS.Create);
  Self.RegisterFunctions(dbnADS, TCQLFunctionsADS.Create);
end;
{$ENDIF}

{$IFDEF ASA}
procedure TCQLRegister._RegisterASA;
begin
  Self.RegisterSerialize(dbnASA, TCQLSerializeASA.Create);
  Self.RegisterSelect(dbnASA, TCQLSelectASA.Create);
  Self.RegisterFunctions(dbnASA, TCQLFunctionsASA.Create);
end;
{$ENDIF}

{$IFDEF ABSOLUTEDB}
procedure TCQLRegister._RegisterAbsoluteDB;
begin
  Self.RegisterSerialize(dbnAbsoluteDB, TCQLSerializeAbsoluteDB.Create);
  Self.RegisterSelect(dbnAbsoluteDB, TCQLSelectAbsoluteDB.Create);
  Self.RegisterFunctions(dbnAbsoluteDB, TCQLFunctionsAbsoluteDB.Create);
end;
{$ENDIF}

{$IFDEF MONGODB}
procedure TCQLRegister._RegisterMongoDB;
begin
  Self.RegisterSerialize(dbnMongoDB, TCQLSerializerMongoDB.Create);
  Self.RegisterSelect(dbnMongoDB, TCQLSelectMongoDB.Create);
  Self.RegisterFunctions(dbnMongoDB, TCQLFunctionsMongoDB.Create);
end;
{$ENDIF}

{$IFDEF ELEVATEDB}
procedure TCQLRegister._RegisterElevateDB;
begin
  Self.RegisterSerialize(dbnElevateDB, TCQLSerializeElevateDB.Create);
  Self.RegisterSelect(dbnElevateDB, TCQLSelectElevateDB.Create);
  Self.RegisterFunctions(dbnElevateDB, TCQLFunctionsElevateDB.Create);
end;
{$ENDIF}

{$IFDEF NEXUSDB}
procedure TCQLRegister._RegisterNexusDB;
begin
  Self.RegisterSerialize(dbnNexusDB, TCQLSerializeNexusDB.Create);
  Self.RegisterSelect(dbnNexusDB, TCQLSelectNexusDB.Create);
  Self.RegisterFunctions(dbnNexusDB, TCQLFunctionsNexusDB.Create);
end;
{$ENDIF}

function TCQLRegister.Functions(const ADBName: TDBName): ICQLFunctions;
begin
  Result := nil;
  if FCQLFunctions.ContainsKey(ADBName) then
    Result := FCQLFunctions[ADBName];
end;

function TCQLRegister.Select(const ADBName: TDBName): ICQLSelect;
begin
  Result := nil;
  if not FCQLSelect.ContainsKey(ADBName) then
    raise Exception.Create('O select do banco ' + TStrDBName[ADBName] + ' não está registrado, adicione a unit "CQL.Select.???.pas" onde ??? nome do banco, na cláusula USES do seu projeto!');

  Result := FCQLSelect[ADBName];
end;

procedure TCQLRegister.RegisterFunctions(const ADBName: TDBName; const ACQLFunctions: ICQLFunctions);
begin
  FCQLFunctions.AddOrSetValue(ADBName, ACQLFunctions);
end;

procedure TCQLRegister.RegisterSelect(const ADBName: TDBName; const ACQLSelect: ICQLSelect);
begin
  FCQLSelect.AddOrSetValue(ADBName, ACQLSelect);
end;

function TCQLRegister.Serialize(const ADBName: TDBName): ICQLSerialize;
begin
  if not FCQLSerialize.ContainsKey(ADBName) then
    raise Exception.Create('O serialize do banco ' + TStrDBName[ADBName] + ' não está registrado, adicione a unit "CQL.Serialize.???.pas" onde ??? nome do banco, na cláusula USES do seu projeto!');

  Result := FCQLSerialize[ADBName];
end;

function TCQLRegister.Where(const ADBName: TDBName): ICQLWhere;
begin
  Result := nil;
  if FCQLWhere.ContainsKey(ADBName) then
    Result := FCQLWhere[ADBName];
end;

procedure TCQLRegister.RegisterSerialize(const ADBName: TDBName; const ACQLSelect: ICQLSerialize);
begin
  FCQLSerialize.AddOrSetValue(ADBName, ACQLSelect);
end;

procedure TCQLRegister.RegisterWhere(const ADBName: TDBName; const ACQLWhere: ICQLWhere);
begin
  FCQLWhere.AddOrSetValue(ADBName, ACQLWhere);
end;

end.
