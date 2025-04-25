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

unit CQuery.FunctionsMSSQL;

{$ifdef fpc}
  {$mode delphi}{$H+}
{$endif}

interface

uses
  SysUtils,
  CQuery.FunctionsAbstract;

type
  TCQueryFunctionsMSSQL = class(TCQueryFunctionAbstract)
  public
    constructor Create;
    function SubString(const AVAlue: String; const AStart, ALength: Integer): String; override;
    function Date(const AVAlue: String; const AFormat: String): String; overload; override;
    function Date(const AVAlue: String): String; overload; override;
    function Day(const AValue: String): String; override;
    function Month(const AValue: String): String; override;
    function Year(const AValue: String): String; override;
    function Concat(const AValue: array of String): String; override;
  end;

implementation

uses
  CQuery.Register,
  CQuery.Interfaces;

{ TCQueryFunctionsMSSQL }

function TCQueryFunctionsMSSQL.Concat(const AValue: array of String): String;
var
  LFor: Integer;
  LIni: Integer;
  LFin: Integer;
const
  cCONCAT = 'CONCAT(%s)';
begin
  Result := '';
  LIni := Low(AValue);
  LFin := High(AValue);

  for LFor := LIni to LFin do
  begin
    Result := Result + AValue[LFor];
    if LFor < LFin then
      Result := Result + ', ';
  end;
  Result := Format(cCONCAT, [Result]);
end;

constructor TCQueryFunctionsMSSQL.Create;
begin
  inherited;
end;

function TCQueryFunctionsMSSQL.SubString(const AVAlue: String; const AStart,
  ALength: Integer): String;
begin
  Result := 'SUBString(' + AValue + ', ' + IntToStr(AStart) + ', ' + IntToStr(ALength) + ')';
end;

function TCQueryFunctionsMSSQL.Year(const AValue: String): String;
begin
  Result := 'YEAR(' + AValue + ')';
end;

function TCQueryFunctionsMSSQL.Date(const AVAlue, AFormat: String): String;
begin
  Result := FormatDateTime(AFormat, StrToDateTime(AValue));
end;

function TCQueryFunctionsMSSQL.Date(const AVAlue: String): String;
begin
  Result := AValue;
end;

function TCQueryFunctionsMSSQL.Day(const AValue: String): String;
begin
  Result := 'DAY(' + AValue + ')';
end;

function TCQueryFunctionsMSSQL.Month(const AValue: String): String;
begin
  Result := 'MONTH(' + AValue + ')';
end;

end.

