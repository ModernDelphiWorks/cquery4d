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

unit CQuery.SelectMSSQL;

{$ifdef fpc}
  {$mode delphi}{$H+}
{$endif}

interface

uses
  SysUtils,
  CQuery.Interfaces,
  CQuery.Select;

type
  TCQuerySelectMSSQL = class(TCQuerySelect)
  public
    constructor Create; override;
    function Serialize: String; override;
  end;

implementation

uses
  CQuery.Utils,
  CQuery.Register,
  CQuery.QualifierMSSQL;

{ TCQuerySelectMSSQL }

constructor TCQuerySelectMSSQL.Create;
begin
  inherited Create;
  FQualifiers := TCQuerySelectQualifiersMSSQL.Create;
end;

function TCQuerySelectMSSQL.Serialize: String;
var
  LFor: Integer;

  function DoSerialize: String;
  begin
    Result := TUtils.Concat(['SELECT',
                             FColumns.Serialize,
                             FQualifiers.SerializeDistinct,
                             'FROM',
                             FTableNames.Serialize]);
  end;

const
  cSELECT = 'SELECT * FROM (%s) AS %s';

begin
  if IsEmpty then
    Result := ''
  else
  begin
    if FQualifiers.ExecutingPagination then
    begin
      FColumns.Add.Name := 'ROW_NUMBER() OVER(ORDER BY CURRENT_TIMESTAMP) AS ROWNUMBER';
      Result := Format(cSELECT, [DoSerialize, FTableNames[0].Name]);
    end
    else
      Result := DoSerialize;
  end;
end;

end.


