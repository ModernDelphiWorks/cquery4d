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

unit CQuery.GroupBy;

{$ifdef fpc}
  {$mode delphi}{$H+}
{$endif}

interface

uses
  CQuery.Section,
  CQuery.Name,
  CQuery.Interfaces;

type
  TCQueryGroupBy = class(TCQuerySection, ICQueryGroupBy)
  strict private
    FColumns: ICQueryNames;
  public
    constructor Create;
    procedure Clear; override;
    function IsEmpty: Boolean; override;
    function Columns: ICQueryNames;
    function Serialize: String;
  end;

implementation

uses
  CQuery.Utils;

{ TGpSQLGroupBy }

constructor TCQueryGroupBy.Create;
begin
  inherited Create('GroupBy');
  FColumns := TCQueryNames.Create;
end;

procedure TCQueryGroupBy.Clear;
begin
  FColumns.Clear;
end;

function TCQueryGroupBy.Columns: ICQueryNames;
begin
  Result := FColumns;
end;

function TCQueryGroupBy.IsEmpty: Boolean;
begin
  Result := FColumns.IsEmpty;
end;

function TCQueryGroupBy.Serialize: String;
begin
  if IsEmpty then
    Result := ''
  else
    Result := TUtils.Concat(['GROUP BY', FColumns.Serialize]);
end;

end.

