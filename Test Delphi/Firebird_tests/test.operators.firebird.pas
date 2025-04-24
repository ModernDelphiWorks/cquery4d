unit test.operators.firebird;

interface

uses
  DUnitX.TestFramework;

type
  [TestFixture]
  TTestCQLOperators = class
  public
    [Setup]
    procedure Setup;
    [TearDown]
    procedure TearDown;

    [Test]
    procedure TestWhereIsNull;
    [Test]
    procedure TestOrIsNull;
    [Test]
    procedure TestAndIsNull;

    [Test]
    procedure TestWhereIsNotNull;
    [Test]
    procedure TestOrIsNotNull;
    [Test]
    procedure TestAndIsNotNull;
   end;

implementation

uses
  SysUtils,
  CQL.Interfaces,
  CQL;

procedure TTestCQLOperators.Setup;
begin

end;

procedure TTestCQLOperators.TearDown;
begin

end;

procedure TTestCQLOperators.TestAndIsNotNull;
var
  LAsString : String;
begin
  LAsString := 'SELECT * FROM CLIENTES WHERE (1 = 1) AND (NOME IS NOT NULL)';
  Assert.AreEqual(LAsString, CQuery(dbnFirebird)
                                 .Select
                                 .All
                                 .From('CLIENTES')
                                 .Where('1 = 1')
                                 .AndOpe('NOME').IsNotNull
                                 .AsString);
end;

procedure TTestCQLOperators.TestAndIsNull;
var
  LAsString : String;
begin
  LAsString := 'SELECT * FROM CLIENTES WHERE (1 = 1) AND (NOME IS NULL)';
  Assert.AreEqual(LAsString, CQuery(dbnFirebird)
                                 .Select
                                 .All
                                 .From('CLIENTES')
                                 .Where('1 = 1')
                                 .AndOpe('NOME').IsNull
                                 .AsString);
end;

procedure TTestCQLOperators.TestOrIsNotNull;
var
  LAsString : String;
begin
  LAsString := 'SELECT * FROM CLIENTES WHERE ((1 = 1) OR (NOME IS NOT NULL))';
  Assert.AreEqual(LAsString, CQuery(dbnFirebird)
                                 .Select
                                 .All
                                 .From('CLIENTES')
                                 .Where('1 = 1')
                                 .OrOpe('NOME').IsNotNull
                                 .AsString);
end;

procedure TTestCQLOperators.TestOrIsNull;
var
  LAsString : String;
begin
  LAsString := 'SELECT * FROM CLIENTES WHERE ((1 = 1) OR (NOME IS NULL))';
  Assert.AreEqual(LAsString, CQuery(dbnFirebird)
                                 .Select
                                 .All
                                 .From('CLIENTES')
                                 .Where('1 = 1')
                                 .OrOpe('NOME').IsNull
                                 .AsString);
end;

procedure TTestCQLOperators.TestWhereIsNotNull;
var
  LAsString : String;
begin
  LAsString := 'SELECT * FROM CLIENTES WHERE (NOME IS NOT NULL)';
  Assert.AreEqual(LAsString, CQuery(dbnFirebird)
                                 .Select
                                 .All
                                 .From('CLIENTES')
                                 .Where('NOME').IsNotNull
                                 .AsString);
end;

procedure TTestCQLOperators.TestWhereIsNull;
var
  LAsString : String;
begin
  LAsString := 'SELECT * FROM CLIENTES WHERE (NOME IS NULL)';
  Assert.AreEqual(LAsString, CQuery(dbnFirebird)
                                 .Select
                                 .All
                                 .From('CLIENTES')
                                 .Where('NOME').IsNull
                                 .AsString);
end;

initialization
  TDUnitX.RegisterTestFixture(TTestCQLOperators);

end.
