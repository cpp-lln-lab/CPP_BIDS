% (C) Copyright 2020 CPP_BIDS developers

function test_suite = test_createDataDictionary %#ok<*STOUT>
    try % assignment of 'localfunctions' is necessary in Matlab >= 2016
        test_functions = localfunctions(); %#ok<*NASGU>
    catch % no problem; early Matlab versions can use initTestSuite fine
    end
    initTestSuite;
end

function test_createDataDictionaryBasic()

    outputDir = fullfile(fileparts(mfilename('fullpath')), 'output');

    %% set up

    cfg.verbose = false;

    cfg.subject.subjectNb = 1;
    cfg.subject.runNb = 1;

    cfg.task.name = 'testtask';

    cfg.dir.output = outputDir;

    cfg.testingDevice = 'mri';

    cfg = createFilename(cfg);

    logFile.extraColumns = {'Speed', 'LHL24'};

    logFile = saveEventsFile('init', cfg, logFile);

    logFile.extraColumns.Speed.length = 1;
    logFile.extraColumns.LHL24.length = 3;

    logFile = saveEventsFile('open', cfg, logFile);

    %% check that the file has the right path and name

    % data to test against
    funcDir = fullfile(outputDir, 'source', 'sub-001', 'ses-001', 'func');

    jsonFilename = ['sub-001_ses-001_task-testtask_run-001_date-' cfg.fileName.date '_events.json'];

    % test
    assertTrue(exist(fullfile(funcDir, jsonFilename), 'file') == 2);

    %% check content
    actualStruct = bids.util.jsondecode(fullfile(funcDir, jsonFilename));

    % data to test against
    expectedStruct = bids.util.jsondecode(fullfile(fileparts(mfilename('fullpath')), ...
                                                   'testData', ...
                                                   'eventsDataDictionary.json'));

    % test
    assertTrue(isequal(expectedStruct, actualStruct));

end

function test_createDataDictionaryStim()

    outputDir = fullfile(fileparts(mfilename('fullpath')), 'output');

    delete(fullfile(outputDir, 'source', 'sub-001', 'ses-001', 'func', '*.json'));
    delete(fullfile(outputDir, 'source', 'sub-001', 'ses-001', 'func', '*.tsv'));

    %% set up

    cfg.verbose = false;

    cfg.subject.subjectNb = 1;
    cfg.subject.runNb = 1;

    cfg.task.name = 'testtask';

    cfg.dir.output = outputDir;

    cfg.testingDevice = 'mri';

    cfg = createFilename(cfg);

    stimLogFile.extraColumns = {'Speed', 'LHL24', 'is_Fixation'};

    stimLogFile = saveEventsFile('init_stim', cfg, stimLogFile);

    stimLogFile.extraColumns.Speed.length = 1;
    stimLogFile.extraColumns.LHL24.length = 3;
    stimLogFile.extraColumns.is_Fixation.length = 1;

    stimLogFile.SamplingFrequency = 100;
    stimLogFile.StartTime = 0;

    stimLogFile = saveEventsFile('open', cfg, stimLogFile);

    %% check that the file has the right path and name

    % data to test against
    funcDir = fullfile(outputDir, 'source', 'sub-001', 'ses-001', 'func');

    jsonFilename = ['sub-001_ses-001_task-testtask_run-001_date-' cfg.fileName.date '_stim.json'];

    % test
    assertTrue(exist(fullfile(funcDir, jsonFilename), 'file') == 2);

    %% check content
    actualStruct = bids.util.jsondecode(fullfile(funcDir, jsonFilename));

    % data to test against
    expectedStruct = bids.util.jsondecode(fullfile(fileparts(mfilename('fullpath')), ...
                                                   'testData', ...
                                                   'stimDataDictionary.json'));

    % test
    assertTrue(isequal(expectedStruct, actualStruct));

end
