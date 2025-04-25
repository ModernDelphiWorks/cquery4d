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

unit CQuery.Where;

{$ifdef fpc}
  {$mode delphi}{$H+}
{$endif}

interface

uses
  CQuery.Section,
  CQuery.Expression,
  CQuery.Interfaces;

type
  TCQueryWhere = class(TCQuerySection, ICQueryWhere)
  private
    function _GetExpression: ICQueryExpression;
    procedure _SetExpression(const Value: ICQueryExpression);
  protected
    FExpression: ICQueryExpression;
  public
    constructor Create; virtual;
    destructor Destroy; override;
    procedure Clear; override;
    function Serialize: String; virtual;
    function IsEmpty: Boolean; override;
    property Expression: ICQueryExpression read _GetExpression write _SetExpression;
  end;

implementation

uses
  CQuery.Utils;

{ TCQueryWhere }

procedure TCQueryWhere.Clear;
begin
  Expression.Clear;
end;

constructor TCQueryWhere.Create;
begin
  inherited Create('Where');
  FExpression := TCQueryExpression.Create;
end;

destructor TCQueryWhere.Destroy;
begin
  inherited;
end;

function TCQueryWhere._GetExpression: ICQueryExpression;
begin
  Result := FExpression;
end;

function TCQueryWhere.IsEmpty: Boolean;
begin
  Result := FExpression.IsEmpty;
end;

function TCQueryWhere.Serialize: String;
begin
  if IsEmpty then
    Result := ''
  else
    Result := TUtils.Concat(['WHERE', FExpression.Serialize]);
end;

procedure TCQueryWhere._SetExpression(const Value: ICQueryExpression);
begin
  FExpression := Value;
end;

end.

