unit UTestFluent.CQLFirebird;

interface

uses
  DUnitX.TestFramework,
  Generics.Collections,
  System.Rtti,
  System.Fluent,
  System.Fluent.Queryable;

type
  [TestFixture]
  TTestFluentCQLFirebird = class
  private
    FEnum: IFluentQueryable<String>;
  public
    [Setup]
    procedure Setup;
    [TearDown]
    procedure TearDown;
    [Test]
    procedure TestSelectAllFromClientes;
    [Test]
    procedure TestSelectWhereNome;
    [Test]
    procedure TestSelectWithAlias;
    [Test]
    procedure TestSelectWithJoin;
    [Test]
    procedure TestMinValue;
    [Test]
    procedure TestMaxValue;
    [Test]
    procedure TestFromBeforeSelect;
    [Test]
    procedure TestSelectBeforeWhere;
    [Test]
    procedure TestWhereJoinSelect;
    [Test]
    procedure TestGroupBy;
  end;

implementation

procedure TTestFluentCQLFirebird.Setup;
begin
  FEnum := IFluentQueryable<String>.CreateForDatabase(TDBName.dbnFirebird);
end;

procedure TTestFluentCQLFirebird.TearDown;
begin
end;

procedure TTestFluentCQLFirebird.TestSelectAllFromClientes;
begin
  FEnum.Select.From('CLIENTES');
  Assert.AreEqual('SELECT * FROM CLIENTES', FEnum.AsString, 'SQL gerado incorreto');
end;

procedure TTestFluentCQLFirebird.TestSelectWhereNome;
begin
  FEnum.From('CLIENTES').Select.Where('NOME > ''B''');
  Assert.AreEqual('SELECT * FROM CLIENTES WHERE NOME > ''B''', FEnum.AsString, 'SQL gerado incorreto');
end;

procedure TTestFluentCQLFirebird.TestSelectWithAlias;
begin
  FEnum.Select.From('CLIENTES').Alias('C').Where('C.NOME = ''Ana''');
  Assert.AreEqual('SELECT * FROM CLIENTES AS C WHERE C.NOME = ''Ana''', FEnum.AsString, 'SQL gerado incorreto');
end;

procedure TTestFluentCQLFirebird.TestSelectWithJoin;
begin
  FEnum.Select.From('CLIENTES').Alias('C')
       .InnerJoin('PEDIDOS', 'P')
       .OnCond('C.ID = P.ID_CLIENTE');
  Assert.AreEqual('SELECT * FROM CLIENTES AS C INNER JOIN PEDIDOS AS P ON C.ID = P.ID_CLIENTE',
                  FEnum.AsString, 'SQL gerado incorreto');
end;

procedure TTestFluentCQLFirebird.TestMinValue;
var
  EnumInt: IFluentQueryable<Integer>;
begin
  EnumInt := IFluentQueryable<Integer>.CreateForDatabase(TDBName.dbnFirebird);
  EnumInt.Select('ID').From('PEDIDOS');
  EnumInt.Min;
  Assert.AreEqual('SELECT MIN(ID) FROM PEDIDOS', EnumInt.AsString, 'SQL gerado incorreto');
end;

procedure TTestFluentCQLFirebird.TestMaxValue;
var
  EnumInt: IFluentQueryable<Integer>;
begin
  EnumInt := IFluentQueryable<Integer>.CreateForDatabase(TDBName.dbnFirebird);
  EnumInt.Select('ID').From('PEDIDOS');
  EnumInt.Max;
  Assert.AreEqual('SELECT MAX(ID) FROM PEDIDOS', EnumInt.AsString, 'SQL gerado incorreto');
end;

procedure TTestFluentCQLFirebird.TestFromBeforeSelect;
begin
  FEnum.From('CLIENTES').Select;
  Assert.AreEqual('SELECT * FROM CLIENTES', FEnum.AsString, 'SQL gerado incorreto');
end;

procedure TTestFluentCQLFirebird.TestSelectBeforeWhere;
begin
  FEnum.Select.Where('NOME = ''Ana''').From('CLIENTES');
  Assert.AreEqual('SELECT * FROM CLIENTES WHERE NOME = ''Ana''', FEnum.AsString, 'SQL gerado incorreto');
end;

procedure TTestFluentCQLFirebird.TestWhereJoinSelect;
begin
  FEnum.Where('NOME > ''B''').InnerJoin('PEDIDOS', 'P').OnCond('CLIENTES.ID = P.ID_CLIENTE').Select.From('CLIENTES');
  Assert.AreEqual('SELECT * FROM CLIENTES INNER JOIN PEDIDOS AS P ON CLIENTES.ID = P.ID_CLIENTE WHERE NOME > ''B''',
                  FEnum.AsString, 'SQL gerado incorreto');
end;

procedure TTestFluentCQLFirebird.TestGroupBy;
begin
  FEnum.Select('COUNT(*)').From('PEDIDOS').GroupBy('CLIENTE_ID');
  Assert.AreEqual('SELECT COUNT(*) FROM PEDIDOS GROUP BY CLIENTE_ID', FEnum.AsString, 'SQL gerado incorreto');
end;

initialization
  TDUnitX.RegisterTestFixture(TTestFluentCQLFirebird);
end.
