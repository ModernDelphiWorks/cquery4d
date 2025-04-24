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

unit CQuery.Qualifier;

{$ifdef fpc}
  {$mode delphi}{$H+}
{$endif}

interface

uses
  SysUtils,
  Generics.Collections,
  CQuery.Interfaces;

type
  TCQuerySelectQualifier = class(TInterfacedObject, ICQuerySelectQualifier)
  strict private
    FQualifier: TSelectQualifierType;
    FValue: Integer;
    function _GetQualifier: TSelectQualifierType;
    function _GetValue: Integer;
    procedure _SetQualifier(const Value: TSelectQualifierType);
    procedure _SetValue(const Value: Integer);
  public
    property Qualifier: TSelectQualifierType read _GetQualifier write _SetQualifier;
    property Value: Integer read _GetValue write _SetValue;
  end;

  TCQuerySelectQualifiers = class(TInterfacedObject, ICQuerySelectQualifiers)
  protected
    FExecutingPagination: Boolean;
    FQualifiers: TList<ICQuerySelectQualifier>;
    function _GetQualifier(AIdx: Integer): ICQuerySelectQualifier;
  public
    constructor Create;
    destructor Destroy; override;
    function Add: ICQuerySelectQualifier; overload;
    procedure Add(AQualifier: ICQuerySelectQualifier); overload;
    procedure Clear;
    function ExecutingPagination: Boolean;
    function Count: Integer;
    function IsEmpty: Boolean;
    function SerializePagination: String; virtual; abstract;
    function SerializeDistinct: String;
    property Qualifiers[AIdx: Integer]: ICQuerySelectQualifier read _GetQualifier; default;
  end;

implementation

uses
  CQuery.Utils;

{ TCQuerySelectQualifiers }

function TCQuerySelectQualifiers.Add: ICQuerySelectQualifier;
begin
  Result := TCQuerySelectQualifier.Create;
end;

procedure TCQuerySelectQualifiers.Add(AQualifier: ICQuerySelectQualifier);
begin
  FQualifiers.Add(AQualifier);
  if AQualifier.Qualifier in [sqFirst, sqSkip] then
    FExecutingPagination := True;
end;

procedure TCQuerySelectQualifiers.Clear;
begin
  FExecutingPagination := False;
  FQualifiers.Clear;
end;

function TCQuerySelectQualifiers.Count: Integer;
begin
  Result := FQualifiers.Count;
end;

constructor TCQuerySelectQualifiers.Create;
begin
  FExecutingPagination := False;
  FQualifiers := TList<ICQuerySelectQualifier>.Create;
end;

destructor TCQuerySelectQualifiers.Destroy;
begin
  FQualifiers.Free;
  inherited;
end;

function TCQuerySelectQualifiers.ExecutingPagination: Boolean;
begin
  Result := FExecutingPagination;
end;

function TCQuerySelectQualifiers._GetQualifier(AIdx: Integer): ICQuerySelectQualifier;
begin
  Result := FQualifiers[AIdx];
end;

function TCQuerySelectQualifiers.IsEmpty: Boolean;
begin
  Result := (Count = 0);
end;

function TCQuerySelectQualifiers.SerializeDistinct: String;
var
  LFor: Integer;
begin
  inherited;
  Result := '';
  for LFor := 0 to Count -1 do
  begin
    if FQualifiers[LFor].Qualifier = sqDistinct then
    begin
      Result := TUtils.Concat([Result, 'DISTINCT']);
      Exit;
    end;
  end;
end;

{ TCQuerySelectQualifier }

function TCQuerySelectQualifier._GetQualifier: TSelectQualifierType;
begin
  Result := FQualifier;
end;

function TCQuerySelectQualifier._GetValue: Integer;
begin
  Result := FValue;
end;

procedure TCQuerySelectQualifier._SetQualifier(const Value: TSelectQualifierType);
begin
  FQualifier := Value;
end;

procedure TCQuerySelectQualifier._SetValue(const Value: Integer);
begin
  FValue := Value;
end;

end.

