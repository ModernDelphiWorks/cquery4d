unit test.select.mssql;

interface

uses
  DUnitX.TestFramework;

type
  [TestFixture]
  TTestCQLSelectMSSQL = class
  public
    [Setup]
    procedure Setup;
    [TearDown]
    procedure TearDown;

    [Test]
    procedure TestSelectAll;
    [Test]
    procedure TestSelectAllWhere;
    [Test]
    procedure TestSelectAllWhereAndOr;
    [Test]
    procedure TestSelectAllWhereAndAnd;
    [Test]
    procedure TestSelectAllOrderBy;
    [Test]
    procedure TestSelectColumns;
    [Test]
    procedure TestSelectColumnsCase;
    [Test]
    procedure TestSelectPagingMSSQL;
//    [Test]
    procedure Test2SelectPagingMSSQL;
  end;

implementation

uses
  SysUtils,
  CQL.Interfaces,
  CQL;

procedure TTestCQLSelectMSSQL.Setup;
begin
end;

procedure TTestCQLSelectMSSQL.TearDown;
begin
end;

procedure TTestCQLSelectMSSQL.TestSelectAll;
var
  LAsString: String;
begin
  LAsString := 'SELECT * FROM CLIENTES AS CLI';
  Assert.AreEqual(LAsString, TCQL.New(dbnFirebird)
                                      .Select
                                      .All
                                      .From('CLIENTES').&As('CLI')
                                      .AsString);
end;

procedure TTestCQLSelectMSSQL.TestSelectAllOrderBy;
var
  LAsString: String;
begin
  LAsString := 'SELECT * FROM CLIENTES ORDER BY ID_CLIENTE';
  Assert.AreEqual(LAsString, TCQL.New(dbnFirebird)
                                      .Select
                                      .All
                                      .From('CLIENTES')
                                      .OrderBy('ID_CLIENTE')
                                      .AsString);
end;

procedure TTestCQLSelectMSSQL.TestSelectAllWhere;
var
  LAsString: String;
begin
  LAsString := 'SELECT * FROM CLIENTES WHERE ID_CLIENTE = 1';
  Assert.AreEqual(LAsString, TCQL.New(dbnFirebird)
                                      .Select
                                      .All
                                      .From('CLIENTES')
                                      .Where('ID_CLIENTE = 1')
                                      .AsString);
end;

procedure TTestCQLSelectMSSQL.TestSelectAllWhereAndAnd;
var
  LAsString: String;
begin
  LAsString := 'SELECT * FROM CLIENTES WHERE (ID_CLIENTE = 1) AND (ID >= 10) AND (ID <= 20)';
  Assert.AreEqual(LAsString, TCQL.New(dbnFirebird)
                                      .Select
                                      .All
                                      .From('CLIENTES')
                                      .Where('ID_CLIENTE = 1')
                                      .&And('ID').GreaterEqThan(10)
                                      .&And('ID').LessEqThan(20)
                                      .AsString);
end;

procedure TTestCQLSelectMSSQL.TestSelectAllWhereAndOr;
var
  LAsString: String;
begin
  LAsString := 'SELECT * FROM CLIENTES WHERE (ID_CLIENTE = 1) AND ((ID >= 10) OR (ID <= 20))';
  Assert.AreEqual(LAsString, TCQL.New(dbnFirebird)
                                      .Select
                                      .All
                                      .From('CLIENTES')
                                      .Where('ID_CLIENTE = 1')
                                      .&And('ID').GreaterEqThan(10)
                                      .&Or('ID').LessEqThan(20)
                                      .AsString);
end;

procedure TTestCQLSelectMSSQL.TestSelectColumns;
var
  LAsString: String;
begin
  LAsString := 'SELECT ID_CLIENTE, NOME_CLIENTE FROM CLIENTES';
  Assert.AreEqual(LAsString, TCQL.New(dbnFirebird)
                                      .Select
                                      .Column('ID_CLIENTE')
                                      .Column('NOME_CLIENTE')
                                      .From('CLIENTES')
                                      .AsString);
end;

procedure TTestCQLSelectMSSQL.TestSelectColumnsCase;
var
  LAsString: String;
begin
  LAsString := 'SELECT ID_CLIENTE, NOME_CLIENTE, (CASE TIPO_CLIENTE WHEN 0 THEN ''FISICA'' WHEN 1 THEN ''JURIDICA'' ELSE ''PRODUTOR'' END) AS TIPO_PESSOA FROM CLIENTES';
  Assert.AreEqual(LAsString, TCQL.New(dbnFirebird)
                                      .Select
                                      .Column('ID_CLIENTE')
                                      .Column('NOME_CLIENTE')
                                      .Column('TIPO_CLIENTE')
                                      .&Case
                                        .When('0').&Then(CQL.Q('FISICA'))
                                        .When('1').&Then(CQL.Q('JURIDICA'))
                                                  .&Else('''PRODUTOR''')
                                      .&End
                                      .&As('TIPO_PESSOA')
                                      .From('CLIENTES')
                                      .AsString);
end;

procedure TTestCQLSelectMSSQL.TestSelectPagingMSSQL;
var
  LAsString: String;
begin
  LAsString := 'SELECT * FROM (SELECT *, ROW_NUMBER() OVER(ORDER BY CURRENT_TIMESTAMP) AS ROWNUMBER FROM CLIENTES) AS CLIENTES WHERE (ROWNUMBER > 3 AND ROWNUMBER <= 6) ORDER BY ID_CLIENTE';
  Assert.AreEqual(LAsString, TCQL.New(dbnMSSQL)
                                      .Select
                                      .All
                                      .Limit(3)
                                      .Offset(3)
                                      .From('CLIENTES')
                                      .OrderBy('ID_CLIENTE')
                                      .AsString);
end;

procedure TTestCQLSelectMSSQL.Test2SelectPagingMSSQL;
var
  LAsString: String;
begin
  LAsString := 'SELECT * '+
               'FROM (SELECT ID_CLIENTE, '+
               'ROW_NUMBER() OVER(ORDER BY CURRENT_TIMESTAMP) AS ROWNUMBER '+
               'FROM CLIENTES AS C) AS CLIENTES '+
               'WHERE (ROWNUMBER > 0 AND ROWNUMBER <= 3) '+
               'ORDER BY ID_CLIENTE';
  Assert.AreEqual(LAsString, TCQL.New(dbnMSSQL)
                              .Select
                              .Column('ID_CLIENTE')
                              .Offset(0)
                              .Limit(3)
                              .From('CLIENTES', 'C')
                              .OrderBy('ID_CLIENTE')
                              .AsString);
end;

initialization
  TDUnitX.RegisterTestFixture(TTestCQLSelectMSSQL);

end.
