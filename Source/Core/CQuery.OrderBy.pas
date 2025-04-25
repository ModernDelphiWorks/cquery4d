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

unit CQuery.OrderBy;

{$ifdef fpc}
  {$mode delphi}{$H+}
{$endif}

interface

uses
  CQuery.Section,
  CQuery.Name,
  CQuery.Utils,
  CQuery.Interfaces;

type
  TCQueryOrderByColumn = class(TCQueryName, ICQueryOrderByColumn)
  strict private
    FDirection: TOrderByDirection;
  protected
    function _GetDirection: TOrderByDirection;
    procedure _SetDirection(const Value: TOrderByDirection);
  public
    property Direction: TOrderByDirection read _GetDirection write _SetDirection;
  end;

  TCQueryOrderByColumns = class(TCQueryNames)
  public
    function Add: ICQueryName; override;
  end;

  TCQueryOrderBy = class(TCQuerySection, ICQueryOrderBy)
  strict private
    FColumns: ICQueryNames;
  public
    constructor Create;
    destructor Destroy; override;
    procedure Clear; override;
    function Serialize: String;
    function IsEmpty: Boolean; override;
    function Columns: ICQueryNames;
  end;

implementation

{ TCQueryOrderByColumn }

function TCQueryOrderByColumn._GetDirection: TOrderByDirection;
begin
  Result := FDirection;
end;

procedure TCQueryOrderByColumn._SetDirection(const Value: TOrderByDirection);
begin
  FDirection := Value;
end;

{ TCQueryOrderByColumns }

function TCQueryOrderByColumns.Add: ICQueryName;
begin
  Result := TCQueryOrderByColumn.Create;
  Add(Result);
end;

{ TCQueryOrderBy }

procedure TCQueryOrderBy.Clear;
begin
  Columns.Clear;
end;

function TCQueryOrderBy.Columns: ICQueryNames;
begin
  Result := FColumns;
end;

constructor TCQueryOrderBy.Create;
begin
  inherited Create('OrderBy');
  FColumns := TCQueryOrderByColumns.Create;
end;

destructor TCQueryOrderBy.Destroy;
begin
  FColumns := nil;
  inherited;
end;

function TCQueryOrderBy.IsEmpty: Boolean;
begin
  Result := Columns.IsEmpty;
end;

function TCQueryOrderBy.Serialize: String;
begin
  if IsEmpty then
    Result := ''
  else
    Result := TUtils.Concat(['ORDER BY', FColumns.Serialize]);
end;

end.

