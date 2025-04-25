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

unit CQuery.SerializeDB2;

{$ifdef fpc}
  {$mode delphi}{$H+}
{$endif}

interface

uses
  SysUtils,
  CQuery.Register,
  CQuery.Interfaces,
  CQuery.Serialize;

type
  TCQuerySerializeDB2 = class(TCQuerySerialize)
  public
    function AsString(const AAST: ICQueryAST): String; override;
  end;

implementation

{ TCQuerySerialize }

function TCQuerySerializeDB2.AsString(const AAST: ICQueryAST): String;
var
  LSerializePagination: String;
begin
  Result := inherited AsString(AAST);
  LSerializePagination := AAST.Select.Qualifiers.SerializePagination;
  if LSerializePagination = '' then
    Exit;
  Result := Format(LSerializePagination, [Result]);
end;

end.

