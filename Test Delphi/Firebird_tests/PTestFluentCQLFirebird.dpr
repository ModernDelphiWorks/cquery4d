program PTestFluentCQLFirebird;

{$IFNDEF TESTINSIGHT}
{$APPTYPE CONSOLE}
{$ENDIF}
{$STRONGLINKTYPES ON}
uses
  FastMM4,
  DUnitX.MemoryLeakMonitor.FastMM4,
  System.SysUtils,
  {$IFDEF TESTINSIGHT}
  TestInsight.DUnitX,
  {$ELSE}
  DUnitX.Loggers.Console,
  DUnitX.Loggers.Xml.NUnit,
  {$ENDIF }
  DUnitX.TestFramework,
  UTestFluent.CQLFirebird in 'UTestFluent.CQLFirebird.pas',
  System.Fluent.Adapters in '..\..\..\Fluent4D\Source\System.Fluent.Adapters.pas',
  System.Fluent.Cast in '..\..\..\Fluent4D\Source\System.Fluent.Cast.pas',
  System.Fluent.Chunk in '..\..\..\Fluent4D\Source\System.Fluent.Chunk.pas',
  System.Fluent.Collections in '..\..\..\Fluent4D\Source\System.Fluent.Collections.pas',
  System.Fluent.Concat in '..\..\..\Fluent4D\Source\System.Fluent.Concat.pas',
  System.Fluent.Core in '..\..\..\Fluent4D\Source\System.Fluent.Core.pas',
  System.Fluent.Distinct in '..\..\..\Fluent4D\Source\System.Fluent.Distinct.pas',
  System.Fluent.Exclude in '..\..\..\Fluent4D\Source\System.Fluent.Exclude.pas',
  System.Fluent.GroupBy in '..\..\..\Fluent4D\Source\System.Fluent.GroupBy.pas',
  System.Fluent.GroupJoin in '..\..\..\Fluent4D\Source\System.Fluent.GroupJoin.pas',
  System.Fluent.Helpers in '..\..\..\Fluent4D\Source\System.Fluent.Helpers.pas',
  System.Fluent.Intersect in '..\..\..\Fluent4D\Source\System.Fluent.Intersect.pas',
  System.Fluent.Join in '..\..\..\Fluent4D\Source\System.Fluent.Join.pas',
  System.Fluent.Json in '..\..\..\Fluent4D\Source\System.Fluent.Json.pas',
  System.Fluent.Json.Provider in '..\..\..\Fluent4D\Source\System.Fluent.Json.Provider.pas',
  System.Fluent.OfType in '..\..\..\Fluent4D\Source\System.Fluent.OfType.pas',
  System.Fluent.Order in '..\..\..\Fluent4D\Source\System.Fluent.Order.pas',
  System.Fluent.OrderBy in '..\..\..\Fluent4D\Source\System.Fluent.OrderBy.pas',
  System.Fluent in '..\..\..\Fluent4D\Source\System.Fluent.pas',
  System.Fluent.Select in '..\..\..\Fluent4D\Source\System.Fluent.Select.pas',
  System.Fluent.SelectIndexed in '..\..\..\Fluent4D\Source\System.Fluent.SelectIndexed.pas',
  System.Fluent.SelectMany in '..\..\..\Fluent4D\Source\System.Fluent.SelectMany.pas',
  System.Fluent.SelectManyCollection in '..\..\..\Fluent4D\Source\System.Fluent.SelectManyCollection.pas',
  System.Fluent.SelectManyCollectionIndexed in '..\..\..\Fluent4D\Source\System.Fluent.SelectManyCollectionIndexed.pas',
  System.Fluent.SelectManyIndexed in '..\..\..\Fluent4D\Source\System.Fluent.SelectManyIndexed.pas',
  System.Fluent.Skip in '..\..\..\Fluent4D\Source\System.Fluent.Skip.pas',
  System.Fluent.SkipWhile in '..\..\..\Fluent4D\Source\System.Fluent.SkipWhile.pas',
  System.Fluent.SkipWhileIndexed in '..\..\..\Fluent4D\Source\System.Fluent.SkipWhileIndexed.pas',
  System.Fluent.Take in '..\..\..\Fluent4D\Source\System.Fluent.Take.pas',
  System.Fluent.TakeWhile in '..\..\..\Fluent4D\Source\System.Fluent.TakeWhile.pas',
  System.Fluent.TakeWhileIndexed in '..\..\..\Fluent4D\Source\System.Fluent.TakeWhileIndexed.pas',
  System.Fluent.ThenBy in '..\..\..\Fluent4D\Source\System.Fluent.ThenBy.pas',
  System.Fluent.Union in '..\..\..\Fluent4D\Source\System.Fluent.Union.pas',
  System.Fluent.Where in '..\..\..\Fluent4D\Source\System.Fluent.Where.pas',
  System.Fluent.Xml in '..\..\..\Fluent4D\Source\System.Fluent.Xml.pas',
  System.Fluent.Xml.Provider in '..\..\..\Fluent4D\Source\System.Fluent.Xml.Provider.pas',
  System.Fluent.Zip in '..\..\..\Fluent4D\Source\System.Fluent.Zip.pas',
  System.Fluent.Query.Provider in '..\..\..\Fluent4D\Source\System.Fluent.Query.Provider.pas',
  System.Fluent.Queryable in '..\..\..\Fluent4D\Source\System.Fluent.Queryable.pas';

{ keep comment here to protect the following conditional from being removed by the IDE when adding a unit }
{$IFNDEF TESTINSIGHT}
var
  runner: ITestRunner;
  results: IRunResults;
  logger: ITestLogger;
  nunitLogger : ITestLogger;
{$ENDIF}
begin
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
    //When true, Assertions must be made during tests;
    runner.FailsOnNoAsserts := False;

    //tell the runner how we will log things
    //Log to the console window if desired
    if TDUnitX.Options.ConsoleMode <> TDunitXConsoleMode.Off then
    begin
      logger := TDUnitXConsoleLogger.Create(TDUnitX.Options.ConsoleMode = TDunitXConsoleMode.Quiet);
      runner.AddLogger(logger);
    end;
    //Generate an NUnit compatible XML File
    nunitLogger := TDUnitXXMLNUnitFileLogger.Create(TDUnitX.Options.XMLOutputFile);
    runner.AddLogger(nunitLogger);

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
