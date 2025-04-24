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

unit CQuery.FunctionsAbstract;

{$ifdef fpc}
  {$mode delphi}{$H+}
{$endif}

interface

uses
  SysUtils,
  CQuery.Interfaces,
  System.Fluent.Core;

type
  TCQueryFunctionAbstract = class(TInterfacedObject, ICQueryFunctions)
  public
    function Count(const AValue: String): String; virtual;
    function Upper(const AValue: String): String; virtual;
    function Lower(const AValue: String): String; virtual;
    function Min(const AValue: String): String; virtual;
    function Max(const AValue: String): String; virtual;
    function Sum(const AValue: String): String; virtual;
    function Average(const AValue: String): String; virtual;
    function Coalesce(const AValues: array of String): String; virtual;
    function SubString(const AVAlue: String; const AStart, ALength: Integer): String; virtual;
    function Cast(const AExpression: String; const ADataType: String): String; virtual;
    function Convert(const ADataType: String; const AExpression: String;
      const AStyle: String): String; virtual;
    function Year(const AValue: String): String; virtual;
    function Concat(const AValue: array of String): String; virtual;
    function Length(const AValue: String): String; virtual;
    function Trim(const AValue: String): String; virtual;
    function LTrim(const AValue: String): String; virtual;
    function RTrim(const AValue: String): String; virtual;
    // Date
    function Date(const AVAlue: String; const AFormat: String): String; overload; virtual;
    function Date(const AVAlue: String): String; overload; virtual;
    function Day(const AValue: String): String; virtual;
    function Month(const AValue: String): String; virtual;
    function CurrentDate: String; virtual;
    function CurrentTimestamp: String; virtual;
    function Round(const AValue: String; const ADecimals: Integer): String; virtual;
    function Floor(const AValue: String): String; virtual;
    function Ceil(const AValue: String): String; virtual;
    function Modulus(const AValue, ADivisor: String): String; virtual;
    function Abs(const AValue: String): String; virtual;
  end;

implementation

{ TCQueryFunctionAbstract }

function TCQueryFunctionAbstract.Abs(const AValue: String): String;
begin
  raise EAbstractError.CreateFmt(ABSTRACT_METHOD_ERROR, ['Abs', Self.ClassName]);
end;

function TCQueryFunctionAbstract.Average(const AValue: String): String;
begin
  raise EAbstractError.CreateFmt(ABSTRACT_METHOD_ERROR, ['Average', Self.ClassName]);
end;

function TCQueryFunctionAbstract.Cast(const AExpression, ADataType: String): String;
begin
  raise EAbstractError.CreateFmt(ABSTRACT_METHOD_ERROR, ['Cast', Self.ClassName]);
end;

function TCQueryFunctionAbstract.Ceil(const AValue: String): String;
begin
  raise EAbstractError.CreateFmt(ABSTRACT_METHOD_ERROR, ['Ceil', Self.ClassName]);
end;

function TCQueryFunctionAbstract.Coalesce(const AValues: array of String): String;
begin
  raise EAbstractError.CreateFmt(ABSTRACT_METHOD_ERROR, ['Coalesce', Self.ClassName]);
end;

function TCQueryFunctionAbstract.Concat(const AValue: array of String): String;
begin
  raise EAbstractError.CreateFmt(ABSTRACT_METHOD_ERROR, ['Concat', Self.ClassName]);
end;

function TCQueryFunctionAbstract.Convert(const ADataType, AExpression, AStyle: String): String;
begin
  raise EAbstractError.CreateFmt(ABSTRACT_METHOD_ERROR, ['Convert', Self.ClassName]);
end;

function TCQueryFunctionAbstract.Count(const AValue: String): String;
begin
  raise EAbstractError.CreateFmt(ABSTRACT_METHOD_ERROR, ['Count', Self.ClassName]);
end;

function TCQueryFunctionAbstract.CurrentDate: String;
begin
  raise EAbstractError.CreateFmt(ABSTRACT_METHOD_ERROR, ['CurrentDate', Self.ClassName]);
end;

function TCQueryFunctionAbstract.CurrentTimestamp: String;
begin
  raise EAbstractError.CreateFmt(ABSTRACT_METHOD_ERROR, ['CurrentTimestamp', Self.ClassName]);
end;

function TCQueryFunctionAbstract.Date(const AVAlue, AFormat: String): String;
begin
  raise EAbstractError.CreateFmt(ABSTRACT_METHOD_ERROR, ['Date, Format', Self.ClassName]);
end;

function TCQueryFunctionAbstract.Date(const AVAlue: String): String;
begin
  raise EAbstractError.CreateFmt(ABSTRACT_METHOD_ERROR, ['Date', Self.ClassName]);
end;

function TCQueryFunctionAbstract.Day(const AValue: String): String;
begin
  raise EAbstractError.CreateFmt(ABSTRACT_METHOD_ERROR, ['Day', Self.ClassName]);
end;

function TCQueryFunctionAbstract.Floor(const AValue: String): String;
begin
  raise EAbstractError.CreateFmt(ABSTRACT_METHOD_ERROR, ['Floor', Self.ClassName]);
end;

function TCQueryFunctionAbstract.Length(const AValue: String): String;
begin
  raise EAbstractError.CreateFmt(ABSTRACT_METHOD_ERROR, ['Length', Self.ClassName]);
end;

function TCQueryFunctionAbstract.Lower(const AValue: String): String;
begin
  raise EAbstractError.CreateFmt(ABSTRACT_METHOD_ERROR, ['Lower', Self.ClassName]);
end;

function TCQueryFunctionAbstract.LTrim(const AValue: String): String;
begin
  raise EAbstractError.CreateFmt(ABSTRACT_METHOD_ERROR, ['LTrim', Self.ClassName]);
end;

function TCQueryFunctionAbstract.Max(const AValue: String): String;
begin
  raise EAbstractError.CreateFmt(ABSTRACT_METHOD_ERROR, ['Max', Self.ClassName]);
end;

function TCQueryFunctionAbstract.Min(const AValue: String): String;
begin
  raise EAbstractError.CreateFmt(ABSTRACT_METHOD_ERROR, ['Min', Self.ClassName]);
end;

function TCQueryFunctionAbstract.Modulus(const AValue, ADivisor: String): String;
begin
  raise EAbstractError.CreateFmt(ABSTRACT_METHOD_ERROR, ['Modulus', Self.ClassName]);
end;

function TCQueryFunctionAbstract.Month(const AValue: String): String;
begin
  raise EAbstractError.CreateFmt(ABSTRACT_METHOD_ERROR, ['Month', Self.ClassName]);
end;

function TCQueryFunctionAbstract.Round(const AValue: String; const ADecimals: Integer): String;
begin
  raise EAbstractError.CreateFmt(ABSTRACT_METHOD_ERROR, ['Round', Self.ClassName]);
end;

function TCQueryFunctionAbstract.RTrim(const AValue: String): String;
begin
  raise EAbstractError.CreateFmt(ABSTRACT_METHOD_ERROR, ['RTrim', Self.ClassName]);
end;

function TCQueryFunctionAbstract.SubString(const AVAlue: String; const AStart,
  ALength: Integer): String;
begin
  raise EAbstractError.CreateFmt(ABSTRACT_METHOD_ERROR, ['SubString', Self.ClassName]);
end;

function TCQueryFunctionAbstract.Sum(const AValue: String): String;
begin
  raise EAbstractError.CreateFmt(ABSTRACT_METHOD_ERROR, ['Sum', Self.ClassName]);
end;

function TCQueryFunctionAbstract.Trim(const AValue: String): String;
begin
  raise EAbstractError.CreateFmt(ABSTRACT_METHOD_ERROR, ['Trim', Self.ClassName]);
end;

function TCQueryFunctionAbstract.Upper(const AValue: String): String;
begin
  raise EAbstractError.CreateFmt(ABSTRACT_METHOD_ERROR, ['Upper', Self.ClassName]);
end;

function TCQueryFunctionAbstract.Year(const AValue: String): String;
begin
  raise EAbstractError.CreateFmt(ABSTRACT_METHOD_ERROR, ['Year', Self.ClassName]);
end;

end.

