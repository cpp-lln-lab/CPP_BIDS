% (C) Copyright 2020 CPP_BIDS developers

function test_suite = test_createJson %#ok<*STOUT>
    try % assignment of 'localfunctions' is necessary in Matlab >= 2016
        test_functions = localfunctions(); %#ok<*NASGU>
    catch % no problem; early Matlab versions can use initTestSuite fine
    end
    initTestSuite;
end

function test_createJsonFunc()

    %% set up
    cfg = setUp();
    cfg.testingDevice = 'mri';
    cfg = createFilename(cfg);

    logFile = saveEventsFile('init', cfg); %#ok<*NASGU>

    createJson(cfg);

    %% data to test against
    funcDir = fullfile(cfg.dir.output, 'source', 'sub-001', 'ses-001', 'func');

    eventFilename = ['sub-001_ses-001_task-testtask_run-001_date-' cfg.fileName.date '_bold.json'];

    %% test
    assertTrue(exist(fullfile(funcDir, eventFilename), 'file') == 2);

end

function test_createJson_all()

    testing_devices = {'eeg', 'meg', 'ieeg', 'pc', 'beh'};
    suffixes = {'eeg', 'meg', 'ieeg', 'beh', 'beh'};

    for i = 1:numel(testing_devices)

        %% set up
        cfg = setUp();
        cfg.testingDevice = testing_devices{i};
        cfg = createFilename(cfg);

        logFile = saveEventsFile('init', cfg); %#ok<*NASGU>

        createJson(cfg);

        %% data to test against
        funcDir = fullfile(cfg.dir.output, 'source', 'sub-001', 'ses-001', suffixes{i});

        eventFilename = ['sub-001_ses-001_task-testtask_run-001_date-', ...
                         cfg.fileName.date, ...
                         '_' ...
                         suffixes{i}, '.json'];

        %% test
        assertTrue(exist(fullfile(funcDir, eventFilename), 'file') == 2);

    end
end

function test_createJsonExtra()

    outputDir = fullfile(fileparts(mfilename('fullpath')), 'output');

    %% set up

    cfg.verbose = false;
    cfg.subject.subjectNb = 1;
    cfg.subject.runNb = 1;
    cfg.task.name = 'testtask';
    cfg.dir.output = outputDir;
    cfg.testingDevice = 'mri';
    cfg = createFilename(cfg);

    logFile = saveEventsFile('init', cfg); %#ok<*NASGU>

    extraInfo = struct('extraInfo', struct('nestedExtraInfo', 'something extra'));

    createJson(cfg, extraInfo);

    %% check content
    fileName = strrep(cfg.fileName.events, '_events', '_bold');
    fileName = strrep(fileName, '.tsv', '.json');

    actualStruct = bids.util.jsondecode(fullfile( ...
                                                 cfg.dir.outputSubject, ...
                                                 cfg.fileName.modality, ...
                                                 fileName));

    expectedStruct = bids.util.jsondecode(fullfile(fileparts(mfilename('fullpath')), ...
                                                   'testData', ...
                                                   'extra_bold.json'));

    % test
    assertEqual(expectedStruct, actualStruct);

end

function cfg = setUp()

    cfg.verbose = false;

    cfg.subject.subjectNb = 1;
    cfg.subject.runNb = 1;

    cfg.task.name = 'testtask';

    cfg.dir.output = fullfile(fileparts(mfilename('fullpath')), '..', 'output');

end
