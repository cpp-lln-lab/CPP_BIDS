function test_createDataDictionary()

    clear;

    outputDir = fullfile(fileparts(mfilename('fullpath')), '..', 'output');

    %%% set up part

    expParameters.subjectNb = 1;
    expParameters.runNb = 1;
    expParameters.task = 'testtask';
    expParameters.outputDir = outputDir;

    cfg = struct();
    cfg.testingDevice = 'mri';

    [cfg, expParameters] = createFilename(cfg, expParameters); %#ok<ASGLU>

    logFile.extraColumns.Speed.length = 1;
    logFile.extraColumns.LHL24.length = 3;
    logFile = saveEventsFile('open', expParameters, logFile);

    createDataDictionary(expParameters, logFile);

    %%% test part

    % test data
    funcDir = fullfile(outputDir, 'source', 'sub-001', 'ses-001', 'func');
    jsonFilename = ['sub-001_ses-001_task-testtask_run-001_events_date-' ...
        expParameters.date '.json'];

    % check that the file has the right path and name
    assert(exist(fullfile(funcDir, jsonFilename), 'file') == 2);

    % check content
    expectedStruct = bids.util.jsondecode(fullfile(pwd, 'testData', 'eventsDataDictionary.json'));
    actualStruct = bids.util.jsondecode(fullfile(funcDir, jsonFilename));

    assert(isequal(expectedStruct, actualStruct));

end
