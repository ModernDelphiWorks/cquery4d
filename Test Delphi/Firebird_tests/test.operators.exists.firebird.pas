unit test.operators.exists.firebird;

interface
uses
  DUnitX.TestFramework;

type

  [TestFixture]
  TTestCQLExists = class(TObject)
  public
    [Setup]
    procedure Setup;
    [TearDown]
    procedure TearDown;

    [Test]
    procedure TestExistsSubQuery;
    [Test]
    procedure TestNotExistsSubQuery;
  end;

implementation

uses
  SysUtils,
  CQL.Interfaces,
  CQL;

procedure TTestCQLExists.Setup;
begin
end;

procedure TTestCQLExists.TearDown;
begin
end;

procedure TTestCQLExists.TestExistsSubQuery;
var
  LAsString : String;
begin
  LAsString := 'SELECT * FROM CLIENTES WHERE (EXISTS (SELECT IDCLIENTE FROM PEDIDOS WHERE (PEDIDOS.IDCLIENTE = CLIENTES.IDCLIENTE)))';
  Assert.AreEqual(LAsString, CQuery(dbnFirebird)
                                 .Select
                                 .All
                                 .From('CLIENTES')
                                 .Where.Exists( CQuery(dbnFirebird)
                                                        .Select
                                                        .Column('IDCLIENTE')
                                                        .From('PEDIDOS')
                                                        .Where('PEDIDOS.IDCLIENTE').Equal('CLIENTES.IDCLIENTE')
                                                        .AsString)
                                 .AsString);
end;

procedure TTestCQLExists.TestNotExistsSubQuery;
var
  LAsString : String;
begin
  LAsString := 'SELECT * FROM CLIENTES WHERE (NOT EXISTS (SELECT IDCLIENTE FROM PEDIDOS WHERE (PEDIDOS.IDCLIENTE = CLIENTES.IDCLIENTE)))';
  Assert.AreEqual(LAsString, CQuery(dbnFirebird)
                                 .Select
                                 .All
                                 .From('CLIENTES')
                                 .Where.NotExists( CQuery(dbnFirebird)
                                                        .Select
                                                        .Column('IDCLIENTE')
                                                        .From('PEDIDOS')
                                                        .Where('PEDIDOS.IDCLIENTE').Equal('CLIENTES.IDCLIENTE')
                                                        .AsString)
                                 .AsString);
end;

initialization
  TDUnitX.RegisterTestFixture(TTestCQLExists);

end.
