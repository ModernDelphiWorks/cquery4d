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

unit CQuery.QualifierMSSQL;

{$ifdef fpc}
  {$mode delphi}{$H+}
{$endif}

interface

uses
  SysUtils,
  CQuery.Interfaces,
  CQuery.Qualifier;

type
  TCQuerySelectQualifiersMSSQL = class(TCQuerySelectQualifiers)
  public
    function SerializePagination: String; override;
  end;

implementation

uses
  CQuery.Utils;

{ TCQuerySelectQualifiersMSSQL }

function TCQuerySelectQualifiersMSSQL.SerializePagination: String;
var
  LFor: Integer;
  LFirst: Integer;
  LSkip: Integer;
begin
  Result := '';
  for LFor := 0 to Count -1 do
  begin
    case FQualifiers[LFor].Qualifier of
      sqFirst: LFirst := FQualifiers[LFor].Value;
      sqSkip:  LSkip  := FQualifiers[LFor].Value;
    else
      raise Exception.Create('TCQuerySelectQualifiersMSSQL.SerializePagination: Unknown qualifier');
    end;
  end;
  Result := TUtils.Concat([Result,
                           TUtils.Concat(['ROWNUMBER >', IntToStr(LSkip)]),
                           'AND',
                           TUtils.Concat(['ROWNUMBER <=', IntToStr(LFirst + LSkip)])]);
end;

end.


