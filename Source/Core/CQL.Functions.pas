{
         CQL Brasil - Criteria Query Language for Delphi/Lazarus


                   Copyright (c) 2019, Isaque Pinheiro
                          All rights reserved.

                    GNU Lesser General Public License
                      Versão 3, 29 de junho de 2007

       Copyright (C) 2007 Free Software Foundation, Inc. <http://fsf.org/>
       A todos é permitido copiar e distribuir cópias deste documento de
       licença, mas mudá-lo não é permitido.

       Esta versão da GNU Lesser General Public License incorpora
       os termos e condições da versão 3 da GNU General Public License
       Licença, complementado pelas permissões adicionais listadas no
       arquivo LICENSE na pasta principal.
}

{
  @abstract(CQLBr Framework)
  @created(18 Jul 2019)
  @source(Inspired by and based on "GpSQLBuilder" project - https://github.com/gabr42/GpSQLBuilder)
  @source(Author of CQLBr Framework: Isaque Pinheiro <isaquesp@gmail.com>)
  @source(Author's Website: https://www.isaquepinheiro.com.br)
}

unit CQL.Functions;

{$ifdef fpc}
  {$mode delphi}{$H+}
{$endif}

interface

uses
  SysUtils,
  CQL.Interfaces,
  CQL.Register,
  CQL.FunctionsAbstract;

type
  TCQLFunctions = class(TCQLFunctionAbstract, ICQLFunctions)
  strict private
    FDatabase: TDBName;
    FRegister: TCQLRegister;
  public
    class function Q(const AValue: String): String;
    constructor Create(const ADatabase: TDBName;
      const ARegister: TCQLRegister);
    destructor Destroy; override;
    function Count(const AValue: String): String; override;
    function Upper(const AValue: String): String; override;
    function Lower(const AValue: String): String; override;
    function Min(const AValue: String): String; override;
    function Max(const AValue: String): String; override;
    function Sum(const AValue: String): String; override;
    function Coalesce(const AValues: array of String): String; override;
    function SubString(const AVAlue: String; const AStart, ALength: Integer): String; override;
    function Cast(const AExpression: String; const ADataType: String): String; override;
    function Convert(const ADataType: String; const AExpression: String;
      const AStyle: String): String; override;
    function Date(const AVAlue: String; const AFormat: String): String; overload; override;
    function Date(const AVAlue: String): String; overload; override;
    function Day(const AValue: String): String; override;
    function Month(const AValue: String): String; override;
    function Year(const AValue: String): String; override;
    function Concat(const AValue: array of String): String; override;
  end;
implementation

{ TCQLFunctions }

constructor TCQLFunctions.Create(const ADatabase: TDBName;
  const ARegister: TCQLRegister);
begin
  FDatabase := ADatabase;
  FRegister := ARegister;
end;

class function TCQLFunctions.Q(const AValue: String): String;
begin
  Result := '''' + AValue + '''';
end;

function TCQLFunctions.SubString(const AVAlue: String;
  const AStart, ALength: Integer): String;
begin
  Result := FRegister.Functions(FDatabase).SubString(AValue, AStart, ALength);
end;

function TCQLFunctions.Sum(const AValue: String): String;
begin
  Result := 'SUM(' + AValue + ')';
end;

function TCQLFunctions.Date(const AVAlue: String): String;
begin
  Result := FRegister.Functions(FDatabase).Date(AVAlue);
end;

function TCQLFunctions.Date(const AVAlue, AFormat: String): String;
begin
  Result := FRegister.Functions(FDatabase).Date(AVAlue, AFormat);
end;

function TCQLFunctions.Day(const AValue: String): String;
begin
  Result := FRegister.Functions(FDatabase).Day(AVAlue);
end;

destructor TCQLFunctions.Destroy;
begin
  FRegister := nil;
  inherited;
end;

function TCQLFunctions.Cast(const AExpression: String;
  const ADataType: String): String;
begin
  Result := 'CAST(' + AExpression + ' AS ' + ADataType + ')';
end;

function TCQLFunctions.Coalesce(const AValues: array of String): String;
begin
  Result := '';
end;

function TCQLFunctions.Concat(const AValue: array of String): String;
begin
  Result := FRegister.Functions(FDatabase).Concat(AVAlue);
end;

function TCQLFunctions.Convert(const ADataType: String;
  const AExpression: String; const AStyle: String): String;
begin
  Result := '';
end;

function TCQLFunctions.Count(const AValue: String): String;
begin
  Result := 'COUNT(' + AValue + ')';
end;

function TCQLFunctions.Lower(const AValue: String): String;
begin
  Result := 'LOWER(' + AValue + ')';
end;

function TCQLFunctions.Max(const AValue: String): String;
begin
  Result := 'MAX(' + AValue + ')';
end;

function TCQLFunctions.Min(const AValue: String): String;
begin
  Result := 'MIN(' + AValue + ')';
end;

function TCQLFunctions.Month(const AValue: String): String;
begin
  Result := FRegister.Functions(FDatabase).Month(AVAlue);
end;

function TCQLFunctions.Upper(const AValue: String): String;
begin
  Result := 'UPPER(' + AValue + ')';
end;

function TCQLFunctions.Year(const AValue: String): String;
begin
  Result := FRegister.Functions(FDatabase).Year(AVAlue);
end;

end.

