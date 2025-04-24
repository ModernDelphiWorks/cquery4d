{
               CQuery4D - Fluent SQL Framework for Delphi

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

unit CQuery.Having;

{$ifdef fpc}
  {$mode delphi}{$H+}
{$endif}

interface

uses
  CQuery.Section,
  CQuery.Interfaces;

type
  TCQueryHaving = class(TCQuerySection, ICQueryHaving)
  strict private
    FExpression: ICQueryExpression;
    function _GetExpression: ICQueryExpression;
    procedure _SetExpression(const Value: ICQueryExpression);
  public
    constructor Create;
    procedure Clear; override;
    function IsEmpty: Boolean; override;
    function Serialize: String;
    property Expression: ICQueryExpression read _GetExpression write _SetExpression;
  end;


implementation

uses
  CQuery.Expression,
  CQuery.Utils;

{ TCQueryHaving }

constructor TCQueryHaving.Create;
begin
  inherited Create('Having');
  FExpression := TCQueryExpression.Create;
end;

procedure TCQueryHaving.Clear;
begin
  FExpression.Clear;
end;

function TCQueryHaving._GetExpression: ICQueryExpression;
begin
  Result := FExpression;
end;

function TCQueryHaving.IsEmpty: Boolean;
begin
  Result := FExpression.IsEmpty;
end;

function TCQueryHaving.Serialize: String;
begin
  if IsEmpty then
    Result := ''
  else
    Result := TUtils.Concat(['HAVING', FExpression.Serialize]);
end;

procedure TCQueryHaving._SetExpression(const Value: ICQueryExpression);
begin
  FExpression := Value;
end;

end.

