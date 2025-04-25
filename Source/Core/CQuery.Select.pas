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

unit CQuery.Select;

{$ifdef fpc}
  {$mode delphi}{$H+}
{$endif}

interface

uses
  CQuery.Interfaces,
  CQuery.Qualifier,
  CQuery.Section,
  CQuery.Name;

type
  TCQuerySelect = class(TCQuerySection, ICQuerySelect)
  protected
    FColumns: ICQueryNames;
    FTableNames: ICQueryNames;
    FQualifiers: ICQuerySelectQualifiers;
  public
    constructor Create; virtual;
    destructor Destroy; override;
    procedure Clear; override;
    function IsEmpty: Boolean; override;
    function Columns: ICQueryNames;
    function TableNames: ICQueryNames;
    function Qualifiers: ICQuerySelectQualifiers;
    function Serialize: String; virtual;
  end;

implementation

uses
  CQuery.Utils,
  CQuery.QualifierFirebird;

{ TSelect }

procedure TCQuerySelect.Clear;
begin
  FColumns.Clear;
  FTableNames.Clear;
  if Assigned(FQualifiers) then
    FQualifiers.Clear;
end;

function TCQuerySelect.Columns: ICQueryNames;
begin
  Result := FColumns;
end;

constructor TCQuerySelect.Create;
begin
  inherited Create('Select');
  FColumns := TCQueryNames.Create;
  FTableNames := TCQueryNames.Create;
end;

destructor TCQuerySelect.Destroy;
begin
  FColumns := nil;
  FTableNames := nil;
  FQualifiers := nil;
  inherited;
end;

function TCQuerySelect.IsEmpty: Boolean;
begin
  Result := (FColumns.IsEmpty and FTableNames.IsEmpty);
end;

function TCQuerySelect.Qualifiers: ICQuerySelectQualifiers;
begin
  Result := FQualifiers;
end;

function TCQuerySelect.Serialize: String;
begin
  if IsEmpty then
    Result := ''
  else
    Result := TUtils.Concat(['SELECT',
                             FQualifiers.SerializeDistinct,
                             FQualifiers.SerializePagination,
                             FColumns.Serialize,
                             'FROM',
                             FTableNames.Serialize]);
end;

function TCQuerySelect.TableNames: ICQueryNames;
begin
  Result := FTableNames;
end;

end.


