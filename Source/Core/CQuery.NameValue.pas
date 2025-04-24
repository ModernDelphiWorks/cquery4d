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

unit CQuery.NameValue;

{$ifdef fpc}
  {$mode delphi}{$H+}
{$endif}

interface

uses
  SysUtils,
  Generics.Collections,
  CQuery.Interfaces;

type
  TCQueryNameValue  = class(TInterfacedObject, ICQueryNameValue)
  strict private
    FName : String;
    FValue: String;
    function _GetName: String;
    function _GetValue: String;
    procedure _SetName(const Value: String);
    procedure _SetValue(const Value: String);
  public
    procedure Clear;
    function IsEmpty: Boolean;
    property Name: String read _GetName write _SetName;
    property Value: String read _GetValue write _SetValue;
  end;

  TCQueryNameValuePairs = class(TInterfacedObject, ICQueryNameValuePairs)
  strict private
    FList: TList<ICQueryNameValue>;
    function _GetItem(AIdx: Integer): ICQueryNameValue;
  public
    constructor Create;
    destructor Destroy; override;
    function Add: ICQueryNameValue; overload;
    procedure Add(const ANameValue: ICQueryNameValue); overload;
    procedure Clear;
    function Count: Integer;
    function IsEmpty: Boolean;
    property Item[AIdx: Integer]: ICQueryNameValue read _GetItem; default;
  end;

implementation

uses
  CQuery.Utils;

{ TCQueryNameValue }

procedure TCQueryNameValue.Clear;
begin
  FName := '';
  FValue := '';
end;

function TCQueryNameValue._GetName: String;
begin
  Result := FName;
end;

function TCQueryNameValue._GetValue: String;
begin
  Result := FValue;
end;

function TCQueryNameValue.IsEmpty: Boolean;
begin
  Result := (FName <> '');
end;

procedure TCQueryNameValue._SetName(const Value: String);
begin
  FName := Value;
end;

procedure TCQueryNameValue._SetValue(const Value: String);
begin
  FValue := Value;
end;

{ TCQueryNameValuePairs }

function TCQueryNameValuePairs.Add: ICQueryNameValue;
begin
  Result := TCQueryNameValue.Create;
  Add(Result);
end;

procedure TCQueryNameValuePairs.Add(const ANameValue: ICQueryNameValue);
begin
  FList.Add(ANameValue);
end;

procedure TCQueryNameValuePairs.Clear;
begin
  FList.Clear;
end;

function TCQueryNameValuePairs.Count: Integer;
begin
  Result := FList.Count;
end;

constructor TCQueryNameValuePairs.Create;
begin
  FList := TList<ICQueryNameValue>.Create;
end;

destructor TCQueryNameValuePairs.Destroy;
begin
  FList.Free;
  inherited;
end;

function TCQueryNameValuePairs._GetItem(AIdx: Integer): ICQueryNameValue;
begin
  Result := FList[AIdx];
end;

function TCQueryNameValuePairs.IsEmpty: Boolean;
begin
  Result := (Count = 0);
end;

end.

