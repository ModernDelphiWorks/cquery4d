program TestCQuery_Firebird;

{$IFNDEF TESTINSIGHT}
{$APPTYPE CONSOLE}
{$ENDIF}{$STRONGLINKTYPES ON}
uses
  System.SysUtils,
  {$IFDEF TESTINSIGHT}
  TestInsight.DUnitX,
  {$ENDIF }
  DUnitX.Loggers.Console,
  DUnitX.Loggers.Xml.NUnit,
  DUnitX.TestFramework,
  test.select.firebird in 'test.select.firebird.pas',
  CQL.Ast in '..\..\Source\Core\CQL.Ast.pas',
  CQL.Cases in '..\..\Source\Core\CQL.Cases.pas',
  CQL.Delete in '..\..\Source\Core\CQL.Delete.pas',
  CQL.Expression in '..\..\Source\Core\CQL.Expression.pas',
  CQL.FunctionsAbstract in '..\..\Source\Core\CQL.FunctionsAbstract.pas',
  CQL.GroupBy in '..\..\Source\Core\CQL.GroupBy.pas',
  CQL.Having in '..\..\Source\Core\CQL.Having.pas',
  CQL.Insert in '..\..\Source\Core\CQL.Insert.pas',
  CQL.Interfaces in '..\..\Source\Core\CQL.Interfaces.pas',
  CQL.Joins in '..\..\Source\Core\CQL.Joins.pas',
  CQL.OrderBy in '..\..\Source\Core\CQL.OrderBy.pas',
  CQL in '..\..\Source\Core\CQL.pas',
  CQL.Qualifier in '..\..\Source\Core\CQL.Qualifier.pas',
  CQL.Select in '..\..\Source\Core\CQL.Select.pas',
  CQL.Serialize in '..\..\Source\Core\CQL.Serialize.pas',
  CQL.Update in '..\..\Source\Core\CQL.Update.pas',
  CQL.Where in '..\..\Source\Core\CQL.Where.pas',
  CQL.Utils in '..\..\Source\Core\CQL.Utils.pas',
  CQL.Register in '..\..\Source\Core\CQL.Register.pas',
  test.insert.firebird in 'test.insert.firebird.pas',
  test.update.firebird in 'test.update.firebird.pas',
  test.delete.firebird in 'test.delete.firebird.pas',
  CQL.Operators in '..\..\Source\Core\CQL.Operators.pas',
  test.operators.firebird in 'test.operators.firebird.pas',
  test.operators.like.firebird in 'test.operators.like.firebird.pas',
  test.operators.less.firebird in 'test.operators.less.firebird.pas',
  test.operators.greater.firebird in 'test.operators.greater.firebird.pas',
  test.operators.equal.firebird in 'test.operators.equal.firebird.pas',
  test.operators.isin.firebird in 'test.operators.isin.firebird.pas',
  test.operators.exists.firebird in 'test.operators.exists.firebird.pas',
  CQL.QualifierFirebird in '..\..\Source\Drivers\CQL.QualifierFirebird.pas',
  CQL.QualifierMongoDB in '..\..\Source\Drivers\CQL.QualifierMongoDB.pas',
  CQL.QualifierMSSQL in '..\..\Source\Drivers\CQL.QualifierMSSQL.pas',
  CQL.QualifierMySQL in '..\..\Source\Drivers\CQL.QualifierMySQL.pas',
  CQL.QualifierOracle in '..\..\Source\Drivers\CQL.QualifierOracle.pas',
  CQL.QualifierSQLite in '..\..\Source\Drivers\CQL.QualifierSQLite.pas',
  CQL.SelectMongoDB in '..\..\Source\Drivers\CQL.SelectMongoDB.pas',
  CQL.SelectMSSQL in '..\..\Source\Drivers\CQL.SelectMSSQL.pas',
  CQL.SelectMySQL in '..\..\Source\Drivers\CQL.SelectMySQL.pas',
  CQL.SelectOracle in '..\..\Source\Drivers\CQL.SelectOracle.pas',
  CQL.Select.SQLite in '..\..\Source\Drivers\CQL.Select.SQLite.pas',
  CQL.SerializeMongoDB in '..\..\Source\Drivers\CQL.SerializeMongoDB.pas',
  CQL.SerializeMSSQL in '..\..\Source\Drivers\CQL.SerializeMSSQL.pas',
  CQL.SerializeMySQL in '..\..\Source\Drivers\CQL.SerializeMySQL.pas',
  CQL.SerializeOracle in '..\..\Source\Drivers\CQL.SerializeOracle.pas',
  CQL.SerializeSQLite in '..\..\Source\Drivers\CQL.SerializeSQLite.pas',
  CQL.SerializeFirebird in '..\..\Source\Drivers\CQL.SerializeFirebird.pas',
  CQL.SelectFirebird in '..\..\Source\Drivers\CQL.SelectFirebird.pas',
  CQL.FunctionsFirebird in '..\..\Source\Drivers\CQL.FunctionsFirebird.pas',
  CQL.Functions in '..\..\Source\Core\CQL.Functions.pas',
  CQL.FunctionsInterbase in '..\..\Source\Drivers\CQL.FunctionsInterbase.pas',
  CQL.FunctionsMySQL in '..\..\Source\Drivers\CQL.FunctionsMySQL.pas',
  CQL.FunctionsMSSQL in '..\..\Source\Drivers\CQL.FunctionsMSSQL.pas',
  CQL.FunctionsSQLite in '..\..\Source\Drivers\CQL.FunctionsSQLite.pas',
  CQL.FunctionsOracle in '..\..\Source\Drivers\CQL.FunctionsOracle.pas',
  CQL.FunctionsDB2 in '..\..\Source\Drivers\CQL.FunctionsDB2.pas',
  CQL.FunctionsPostgreSQL in '..\..\Source\Drivers\CQL.FunctionsPostgreSQL.pas',
  test.functions.firebird in 'test.functions.firebird.pas',
  CQL.SelectInterbase in '..\..\Source\Drivers\CQL.SelectInterbase.pas',
  CQL.QualifierInterbase in '..\..\Source\Drivers\CQL.QualifierInterbase.pas',
  CQL.SerializeInterbase in '..\..\Source\Drivers\CQL.SerializeInterbase.pas',
  CQL.SelectDB2 in '..\..\Source\Drivers\CQL.SelectDB2.pas',
  CQL.QualifierDB2 in '..\..\Source\Drivers\CQL.QualifierDB2.pas',
  CQL.SerializeDB2 in '..\..\Source\Drivers\CQL.SerializeDB2.pas',
  CQL.Section in '..\..\Source\Core\CQL.Section.pas',
  CQL.Name in '..\..\Source\Core\CQL.Name.pas',
  CQL.NameValue in '..\..\Source\Core\CQL.NameValue.pas',
  CQL.Core in '..\..\Source\Core\CQL.Core.pas',
  CQL.RegisterDB in '..\..\Source\Core\CQL.RegisterDB.pas';

{$IFNDEF TESTINSIGHT}
var
  runner : ITestRunner;
  results : IRunResults;
  logger : ITestLogger;
  nunitLogger : ITestLogger;
{$ENDIF}
begin
  ReportMemoryLeaksOnShutdown := DebugHook <> 0;
{$IFDEF TESTINSIGHT}
  TestInsight.DUnitX.RunRegisteredTests;
{$ELSE}
  try
    //Check command line options, will exit if invalid
    TDUnitX.CheckCommandLine;
    //Create the test runner
    runner := TDUnitX.CreateRunner;
    //Tell the runner to use RTTI to find Fixtures
    runner.UseRTTI := True;
    //tell the runner how we will log things
    //Log to the console window
    logger := TDUnitXConsoleLogger.Create(true);
    runner.AddLogger(logger);
    //Generate an NUnit compatible XML File
    nunitLogger := TDUnitXXMLNUnitFileLogger.Create(TDUnitX.Options.XMLOutputFile);
    runner.AddLogger(nunitLogger);
    runner.FailsOnNoAsserts := False; //When true, Assertions must be made during tests;

    //Run tests
    results := runner.Execute;
    if not results.AllPassed then
      System.ExitCode := EXIT_ERRORS;

    {$IFNDEF CI}
    //We don't want this happening when running under CI.
    TDUnitX.Options.ExitBehavior := TDUnitXExitBehavior.Pause;
    if TDUnitX.Options.ExitBehavior = TDUnitXExitBehavior.Pause then
    begin
      System.Write('Done.. press <Enter> key to quit.');
      System.Readln;
    end;
    {$ENDIF}
  except
    on E: Exception do
      System.Writeln(E.ClassName, ': ', E.Message);
  end;
{$ENDIF}

end.
