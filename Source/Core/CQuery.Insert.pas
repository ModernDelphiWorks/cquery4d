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

unit CQuery.Insert;

{$ifdef fpc}
  {$mode delphi}{$H+}
{$endif}

interface

uses
  CQuery.Section,
  CQuery.Name,
  CQuery.Namevalue,
  CQuery.Interfaces;

type
  TCQueryInsert = class(TCQuerySection, ICQueryInsert)
  strict private
    FColumns: ICQueryNames;
    FTableName: String;
    FValues: ICQueryNameValuePairs;
    function _SerializeNameValuePairsForInsert(const APairs: ICQueryNameValuePairs): String;
    function _GetTableName: String;
    procedure _SetTableName(const Value: String);
  public
    constructor Create;
    procedure Clear; override;
    function Columns: ICQueryNames;
    function IsEmpty: Boolean; override;
    function Values: ICQueryNameValuePairs;
    function Serialize: String;
    property TableName: String read _GetTableName write _SetTableName;
  end;

implementation

uses
  CQuery.Utils;

{ TCQueryInsert }

procedure TCQueryInsert.Clear;
begin
  FTableName := '';
  FColumns.Clear;
  FValues.Clear;
end;

function TCQueryInsert.Columns: ICQueryNames;
begin
  Result := FColumns;
end;

constructor TCQueryInsert.Create;
begin
  inherited Create('Insert');
  FColumns := TCQueryNames.Create;
  FValues := TCQueryNameValuePairs.Create;
end;

function TCQueryInsert._GetTableName: String;
begin
  Result := FTableName;
end;

function TCQueryInsert.IsEmpty: Boolean;
begin
  Result := (TableName = '');
end;

function TCQueryInsert.Serialize: String;
begin
  if IsEmpty then
    Result := ''
  else
  begin
    Result := TUtils.Concat(['INSERT INTO', FTableName]);
    if FColumns.Count > 0 then
      Result := TUtils.Concat([Result, '(', Columns.Serialize, ')'])
    else
      Result := TUtils.Concat([Result, _SerializeNameValuePairsForInsert(FValues)]);
  end;
end;

function TCQueryInsert._SerializeNameValuePairsForInsert(const APairs: ICQueryNameValuePairs): String;
var
  LFor: integer;
  LColumns: String;
  LValues: String;
begin
  Result := '';
  if APairs.Count = 0 then
    Exit;

  LColumns := '';
  LValues := '';
  for LFor := 0 to APairs.Count - 1 do
  begin
    LColumns := TUtils.Concat([LColumns, APairs[LFor].Name] , ', ');
    LValues  := TUtils.Concat([LValues , APairs[LFor].Value], ', ');
  end;
  Result := TUtils.Concat(['(', LColumns, ') VALUES (', LValues, ')'],'');
end;

procedure TCQueryInsert._SetTableName(const Value: String);
begin
  FTableName := Value;
end;

function TCQueryInsert.Values: ICQueryNameValuePairs;
begin
  Result := FValues;
end;

end.


