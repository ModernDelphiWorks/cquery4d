unit UTestFluent.CQLFirebird;

interface

uses
  DUnitX.TestFramework,
  Fluent.Core,
  Fluent.CQLProvider,
  CQL.SerializeFirebird,
  CQL.SelectFirebird,
  CQL.Interfaces,
  Generics.Collections,
  System.Rtti;

type
  [TestFixture]
  TTestFluentCQLFirebird = class
  private
    FProvider: IFluentProvider<String>;
    FEnum: IFluentEnumerable<String>;
    function GetSQL: string;
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
  end;

implementation

function TTestFluentCQLFirebird.GetSQL: string;
begin
  Result := (FProvider as TFluentProvider<String>).AsString;
end;

procedure TTestFluentCQLFirebird.Setup;
begin
  FProvider := TFluentProvider<String>.Create(dbnFirebird);
  FEnum := IFluentEnumerable<String>.Create(nil, FProvider);
end;

procedure TTestFluentCQLFirebird.TearDown;
begin
  FEnum := Default(IFluentEnumerable<String>);
  FProvider := nil;
end;

procedure TTestFluentCQLFirebird.TestSelectAllFromClientes;
begin
  FEnum.Select.From('CLIENTES');
  Assert.AreEqual('SELECT * FROM CLIENTES', GetSQL, 'SQL gerado incorreto');
end;

procedure TTestFluentCQLFirebird.TestSelectWhereNome;
begin
  FEnum.Select.From('CLIENTES').Where('NOME > ''B''');
  Assert.AreEqual('SELECT * FROM CLIENTES WHERE NOME > ''B''', GetSQL, 'SQL gerado incorreto');
end;

procedure TTestFluentCQLFirebird.TestSelectWithAlias;
begin
  FEnum.Select.From('CLIENTES').Alias('C').Where('C.NOME = ''Ana''');
  Assert.AreEqual('SELECT * FROM CLIENTES AS C WHERE C.NOME = ''Ana''', GetSQL, 'SQL gerado incorreto');
end;

procedure TTestFluentCQLFirebird.TestSelectWithJoin;
begin
  FEnum.Select.From('CLIENTES').Alias('C')
       .InnerJoin('PEDIDOS', 'P')
       .OnCond('C.ID = P.ID_CLIENTE');
  Assert.AreEqual('SELECT * FROM CLIENTES AS C INNER JOIN PEDIDOS AS P ON C.ID = P.ID_CLIENTE',
                  GetSQL, 'SQL gerado incorreto');
end;

procedure TTestFluentCQLFirebird.TestMinValue;
var
  EnumInt: IFluentEnumerable<Integer>;
  ProviderInt: IFluentProvider<Integer>;
begin
  ProviderInt := TFluentProvider<Integer>.Create(dbnFirebird);
  EnumInt := IFluentEnumerable<Integer>.Create(nil, ProviderInt);
  EnumInt.Select('ID').From('PEDIDOS');
  Assert.AreEqual('SELECT MIN(ID) FROM PEDIDOS', ProviderInt.Min.AsString, 'SQL gerado incorreto');
end;

initialization
  TDUnitX.RegisterTestFixture(TTestFluentCQLFirebird);

end.
