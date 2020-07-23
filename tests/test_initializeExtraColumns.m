function test_initializeExtraColumns()

    fprintf('\n\n--------------------------------------------------------------------\n\n');

    clear;

    %%% set up
    checkCppBidsDependencies()
    logFile = struct('filename', [], 'extraColumns', cell(1));
    logFile(1).filename = '';

    %%% do stuff
    logFile = initializeExtraColumns(logFile);

    %%% test section
    expectedStrcut(1).filename = '';
    expectedStrcut(1).extraColumns = [];

    assert(isequal(expectedStrcut, logFile));

    fprintf('\n\n--------------------------------------------------------------------\n\n');

    clear;

    %%% set up
    checkCppBidsDependencies()
    logFile.extraColumns = {'Speed'};

    %%% do stuff
    logFile = initializeExtraColumns(logFile);

    %%% test section
    expectedStrcut(1).extraColumns.Speed.length = 1;
    expectedStrcut(1).extraColumns.Speed.bids.LongName = '';
    expectedStrcut(1).extraColumns.Speed.bids.Description = '';
    expectedStrcut(1).extraColumns.Speed.bids.Levels = '';
    expectedStrcut(1).extraColumns.Speed.bids.TermURL = '';

    assert(isequal(expectedStrcut, logFile));

    fprintf('\n\n--------------------------------------------------------------------\n\n');

    clear;

    %%% set up
    checkCppBidsDependencies()
    logFile.extraColumns.Speed.length = 1;
    logFile.extraColumns.LHL24.length = 3;

    %%% do stuff
    logFile = initializeExtraColumns(logFile);

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

end
