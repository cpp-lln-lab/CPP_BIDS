function test_saveEventsFileInit()

    %%

    %%% set up
    % make sure the dependencies are there
    checkCFG();

    %%% do stuff
    [logFile] = saveEventsFile('init');

    %%% test section
    expectedStrcut(1).filename = '';
    expectedStrcut(1).extraColumns = [];

    assert(isequal(expectedStrcut, logFile));

    %%
    fprintf('\n--------------------------------------------------------------------');

    clear;

    %%% set up
    [cfg, expParameters] = checkCFG(); %#ok<ASGLU>
    logFile.extraColumns = {'Speed'};

    %%% do stuff
    [logFile] = saveEventsFile('init', expParameters, logFile);

    %%% test section
    expectedStrcut(1).extraColumns.Speed.length = 1;
    expectedStrcut(1).extraColumns.Speed.bids.LongName = '';
    expectedStrcut(1).extraColumns.Speed.bids.Description = '';
    expectedStrcut(1).extraColumns.Speed.bids.Levels = '';
    expectedStrcut(1).extraColumns.Speed.bids.TermURL = '';

    assert(isequal(expectedStrcut, logFile));

    %%
    fprintf('\n--------------------------------------------------------------------');

    clear;

    %%% set up
    [cfg, expParameters] = checkCFG(); %#ok<ASGLU>
    logFile.extraColumns.Speed.length = 1;
    logFile.extraColumns.LHL24.length = 3;

    %%% do stuff
    [logFile] = saveEventsFile('init', expParameters, logFile);

    %%% test section
    expectedStrcut(1).extraColumns.Speed.length = 1;
    expectedStrcut(1).extraColumns.Speed.bids.LongName = '';
    expectedStrcut(1).extraColumns.Speed.bids.Description = '';
    expectedStrcut(1).extraColumns.Speed.bids.Levels = '';
    expectedStrcut(1).extraColumns.Speed.bids.TermURL = '';
    expectedStrcut(1).extraColumns.LHL24.length = 3;
    expectedStrcut(1).extraColumns.LHL24.bids.LongName = '';
    expectedStrcut(1).extraColumns.LHL24.bids.Description = '';
    expectedStrcut(1).extraColumns.LHL24.bids.Levels = '';
    expectedStrcut(1).extraColumns.LHL24.bids.TermURL = '';

    assert(isequal(expectedStrcut, logFile));

    fprintf('\n');

end
