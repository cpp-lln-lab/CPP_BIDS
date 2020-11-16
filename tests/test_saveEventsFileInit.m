function test_suite = test_saveEventsFileInit %#ok<*STOUT>
    try % assignment of 'localfunctions' is necessary in Matlab >= 2016
        test_functions = localfunctions(); %#ok<*NASGU>
    catch % no problem; early Matlab versions can use initTestSuite fine
    end
    initTestSuite;
end

function test_saveEventsFileInitBasic()

    %% set up

    cfg.verbose = false;

    % make sure the dependencies are there
    checkCFG(cfg);

    [logFile] = saveEventsFile('init');

    %% data to test against
    expectedStrcut(1).filename = '';
    expectedStrcut(1).extraColumns = [];

    %% test
    assertEqual(expectedStrcut, logFile);

end

function test_saveEventsFileInitExtraColumns()

    %% set up

    cfg.verbose = false;

    cfg = checkCFG(cfg);

    logFile.extraColumns = {'Speed'};

    [logFile] = saveEventsFile('init', cfg, logFile);

    %% data to test against
    expectedStrcut(1).extraColumns.Speed.length = 1;
    expectedStrcut(1).extraColumns.Speed.bids.LongName = '';
    expectedStrcut(1).extraColumns.Speed.bids.Description = '';
    expectedStrcut(1).extraColumns.Speed.bids.Levels = '';
    expectedStrcut(1).extraColumns.Speed.bids.TermURL = '';
    expectedStrcut(1).extraColumns.Speed.bids.Units = '';

    %% test
    assertEqual(expectedStrcut, logFile);

end

function test_saveEventsFileInitExtraColumnsArray()

    %% set up

    cfg.verbose = false;

    cfg = checkCFG(cfg);

    logFile.extraColumns.Speed.length = 1;
    logFile.extraColumns.LHL24.length = 3;

    [logFile] = saveEventsFile('init', cfg, logFile);

    %% data to test against
    expectedStrcut(1).extraColumns.Speed.length = 1;
    expectedStrcut(1).extraColumns.Speed.bids.LongName = '';
    expectedStrcut(1).extraColumns.Speed.bids.Description = '';
    expectedStrcut(1).extraColumns.Speed.bids.Levels = '';
    expectedStrcut(1).extraColumns.Speed.bids.TermURL = '';
    expectedStrcut(1).extraColumns.Speed.bids.Units = '';
    expectedStrcut(1).extraColumns.LHL24.length = 3;
    expectedStrcut(1).extraColumns.LHL24.bids.LongName = '';
    expectedStrcut(1).extraColumns.LHL24.bids.Description = '';
    expectedStrcut(1).extraColumns.LHL24.bids.Levels = '';
    expectedStrcut(1).extraColumns.LHL24.bids.TermURL = '';
    expectedStrcut(1).extraColumns.LHL24.bids.Units = '';

    %% test
    assertEqual(expectedStrcut, logFile);

end
