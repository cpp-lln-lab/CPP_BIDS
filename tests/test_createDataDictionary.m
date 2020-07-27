function test_createDataDictionary()

    clear;

    outputDir = fullfile(fileparts(mfilename('fullpath')), '..', 'output');

    %%% set up part

    cfg.subjectNb = 1;
    cfg.runNb = 1;
    cfg.task = 'testtask';
    cfg.outputDir = outputDir;

    cfg.testingDevice = 'mri';

    cfg = createFilename(cfg);

    logFile.extraColumns.Speed.length = 1;
    logFile.extraColumns.LHL24.length = 3;
    logFile = saveEventsFile('init', cfg, logFile);

    createDataDictionary(cfg, logFile);

    %%% test part

    % test data
    funcDir = fullfile(outputDir, 'source', 'sub-001', 'ses-001', 'func');
    jsonFilename = ['sub-001_ses-001_task-testtask_run-001_events_date-' ...
        cfg.date '.json'];

    % check that the file has the right path and name
    assert(exist(fullfile(funcDir, jsonFilename), 'file') == 2);

    % check content
    expectedStruct = bids.util.jsondecode(fullfile(pwd, 'testData', 'eventsDataDictionary.json'));
    actualStruct = bids.util.jsondecode(fullfile(funcDir, jsonFilename));

    assert(isequal(expectedStruct, actualStruct));

end
