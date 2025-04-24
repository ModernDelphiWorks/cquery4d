{
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

{$ifdef fpc}
  {$mode delphi}{$H+}
{$endif}

unit CQuery.Functions;

interface

uses
  SysUtils,
  CQuery.Interfaces,
  CQuery.Register,
  CQuery.FunctionsAbstract;

type
  TCQueryFunctions = class(TCQueryFunctionAbstract, ICQueryFunctions)
  strict private
    FDatabase: TCQueryDriver;
    FRegister: TCQueryRegister;
  public
    class function QFunc(const AValue: String): String;
    constructor Create(const ADatabase: TCQueryDriver;
      const ARegister: TCQueryRegister);
    destructor Destroy; override;
    // Aggregation functions
    function Count(const AValue: String): String; override;
    function Sum(const AValue: String): String; override;
    function Min(const AValue: String): String; override;
    function Max(const AValue: String): String; override;
    function Average(const AValue: String): String; override;
    // String functions
    function Upper(const AValue: String): String; override;
    function Lower(const AValue: String): String; override;
    function Length(const AValue: String): String; override;
    function Trim(const AValue: String): String; override;
    function LTrim(const AValue: String): String; override;
    function RTrim(const AValue: String): String; override;
    function SubString(const AValue: String; const AFrom, AFor: Integer): String; override;
    function Concat(const AValue: array of String): String; override;
    // Null handling
    function Coalesce(const AValues: array of String): String; override;
    // Type conversion
    function Cast(const AExpression: String; const ADataType: String): String; override;
    // Date functions
    function Date(const AValue: String; const AFormat: String): String; overload; override;
    function Date(const AValue: String): String; overload; override;
    function Day(const AValue: String): String; override;
    function Month(const AValue: String): String; override;
    function Year(const AValue: String): String; override;
    function CurrentDate: String; override;
    function CurrentTimestamp: String; override;
    // Numeric functions
    function Round(const AValue: String; const ADecimals: Integer): String; override;
    function Floor(const AValue: String): String; override;
    function Ceil(const AValue: String): String; override;
    function Modulus(const AValue, ADivisor: String): String;
    function Abs(const AValue: String): String;
  end;

implementation

{ TCQueryFunctions }

constructor TCQueryFunctions.Create(const ADatabase: TCQueryDriver;
  const ARegister: TCQueryRegister);
begin
  FDatabase := ADatabase;
  FRegister := ARegister;
end;

destructor TCQueryFunctions.Destroy;
begin
  FRegister := nil;
  inherited;
end;

class function TCQueryFunctions.QFunc(const AValue: String): String;
begin
  Result := '''' + AValue + '''';
end;

function TCQueryFunctions.Count(const AValue: String): String;
begin
  Result := 'COUNT(' + AValue + ')';
end;

function TCQueryFunctions.Sum(const AValue: String): String;
begin
  Result := 'SUM(' + AValue + ')';
end;

function TCQueryFunctions.Min(const AValue: String): String;
begin
  Result := 'MIN(' + AValue + ')';
end;

function TCQueryFunctions.Max(const AValue: String): String;
begin
  Result := 'MAX(' + AValue + ')';
end;

function TCQueryFunctions.Abs(const AValue: String): String;
begin
  Result := 'ABS(' + AValue + ')';
end;

function TCQueryFunctions.Average(const AValue: String): String;
begin
  Result := 'AVG(' + AValue + ')';
end;

function TCQueryFunctions.Upper(const AValue: String): String;
begin
  Result := 'UPPER(' + AValue + ')';
end;

function TCQueryFunctions.Lower(const AValue: String): String;
begin
  Result := 'LOWER(' + AValue + ')';
end;

function TCQueryFunctions.Length(const AValue: String): String;
begin
  Result := 'LENGTH(' + AValue + ')';
end;

function TCQueryFunctions.Trim(const AValue: String): String;
begin
  Result := FRegister.Functions(FDatabase).Trim(AValue);
end;

function TCQueryFunctions.LTrim(const AValue: String): String;
begin
  Result := FRegister.Functions(FDatabase).LTrim(AValue);
end;

function TCQueryFunctions.RTrim(const AValue: String): String;
begin
  Result := FRegister.Functions(FDatabase).RTrim(AValue);
end;

function TCQueryFunctions.SubString(const AValue: String; const AFrom, AFor: Integer): String;
begin
  Result := FRegister.Functions(FDatabase).SubString(AValue, AFrom, AFor);
end;

function TCQueryFunctions.Concat(const AValue: array of String): String;
begin
  Result := FRegister.Functions(FDatabase).Concat(AValue);
end;

function TCQueryFunctions.Coalesce(const AValues: array of String): String;
begin
  Result := FRegister.Functions(FDatabase).Coalesce(AValues);
end;

function TCQueryFunctions.Cast(const AExpression: String; const ADataType: String): String;
begin
  Result := 'CAST(' + AExpression + ' AS ' + ADataType + ')';
end;

function TCQueryFunctions.Date(const AValue: String): String;
begin
  Result := FRegister.Functions(FDatabase).Date(AValue);
end;

function TCQueryFunctions.Date(const AValue, AFormat: String): String;
begin
  Result := FRegister.Functions(FDatabase).Date(AValue, AFormat);
end;

function TCQueryFunctions.Day(const AValue: String): String;
begin
  Result := FRegister.Functions(FDatabase).Day(AValue);
end;

function TCQueryFunctions.Modulus(const AValue, ADivisor: String): String;
begin
  Result := FRegister.Functions(FDatabase).Modulus(AValue, ADivisor);
end;

function TCQueryFunctions.Month(const AValue: String): String;
begin
  Result := FRegister.Functions(FDatabase).Month(AValue);
end;

function TCQueryFunctions.Year(const AValue: String): String;
begin
  Result := FRegister.Functions(FDatabase).Year(AValue);
end;

function TCQueryFunctions.CurrentDate: String;
begin
  Result := FRegister.Functions(FDatabase).CurrentDate;
end;

function TCQueryFunctions.CurrentTimestamp: String;
begin
  Result := FRegister.Functions(FDatabase).CurrentTimestamp;
end;

function TCQueryFunctions.Round(const AValue: String; const ADecimals: Integer): String;
begin
  Result := 'ROUND(' + AValue + ', ' + IntToStr(ADecimals) + ')';
end;

function TCQueryFunctions.Floor(const AValue: String): String;
begin
  Result := 'FLOOR(' + AValue + ')';
end;

function TCQueryFunctions.Ceil(const AValue: String): String;
begin
  Result := 'CEIL(' + AValue + ')';
end;

end.

