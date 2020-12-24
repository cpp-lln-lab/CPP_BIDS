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

    eventFilename = ['sub-001_ses-001_task-testtask_run-001_bold_date-' ...
                     cfg.fileName.date '.json'];

    %% test
    assertTrue(exist(fullfile(funcDir, eventFilename), 'file') == 2);

end

function test_createJsonBeh()

    %% set up
    cfg = setUp();

    cfg.testingDevice = 'pc';

    cfg = createFilename(cfg);

    logFile = saveEventsFile('init', cfg); %#ok<*NASGU>

    createJson(cfg);

    %% data to test against
    funcDir = fullfile(cfg.dir.output, 'source', 'sub-001', 'ses-001', 'beh');

    eventFilename = ['sub-001_ses-001_task-testtask_run-001_beh_date-' ...
                     cfg.fileName.date '.json'];

    %% test
    assertTrue(exist(fullfile(funcDir, eventFilename), 'file') == 2);

end

function test_createJsonEeg()

    %% set up
    cfg = setUp();

    cfg.testingDevice = 'eeg';

    cfg = createFilename(cfg);

    logFile = saveEventsFile('init', cfg); %#ok<*NASGU>

    createJson(cfg);

    %% data to test against
    funcDir = fullfile(cfg.dir.output, 'source', 'sub-001', 'ses-001', 'eeg');

    eventFilename = ['sub-001_ses-001_task-testtask_run-001_eeg_date-' ...
                     cfg.fileName.date '.json'];

    %% test
    assertTrue(exist(fullfile(funcDir, eventFilename), 'file') == 2);

end

function test_createJsonMeg()

    %% set up
    cfg = setUp();

    cfg.testingDevice = 'meg';

    cfg = createFilename(cfg);

    logFile = saveEventsFile('init', cfg); %#ok<*NASGU>

    createJson(cfg);

    %% data to test against
    funcDir = fullfile(cfg.dir.output, 'source', 'sub-001', 'ses-001', 'meg');

    eventFilename = ['sub-001_ses-001_task-testtask_run-001_meg_date-' ...
                     cfg.fileName.date '.json'];

    %% test
    assertTrue(exist(fullfile(funcDir, eventFilename), 'file') == 2);

end

function test_createJsonIeeg()

    %% set up
    cfg = setUp();

    cfg.testingDevice = 'ieeg';

    cfg = createFilename(cfg);

    logFile = saveEventsFile('init', cfg); %#ok<*NASGU>

    createJson(cfg);

    %% data to test against
    funcDir = fullfile(cfg.dir.output, 'source', 'sub-001', 'ses-001', 'ieeg');

    eventFilename = ['sub-001_ses-001_task-testtask_run-001_ieeg_date-' ...
                     cfg.fileName.date '.json'];

    %% test
    assertTrue(exist(fullfile(funcDir, eventFilename), 'file') == 2);

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

    % TODO fix error in CI
    %     failure: /github/workspace/lib/JSONio/jsonread.mex: failed to load: liboctinterp.so.4:
    %     cannot open shared object file: No such file or directory
    %     jsondecode:27 (/github/workspace/lib/bids-matlab/+bids/+util/jsondecode.m)
    %     test_createJson>test_createJsonExtra:158 (/github/workspace/tests/test_createJson.m)
    %
    %     failure: fileread: cannot open file
    %     fileread:37 (/octave/share/octave/5.2.0/m/io/fileread.m)
    %     jsondecode:27 (/github/workspace/lib/bids-matlab/+bids/+util/jsondecode.m)
    %     test_createJson>test_createJsonExtra:180 (/github/workspace/tests/test_createJson.m)

    actualStruct = bids.util.jsondecode(fullfile( ...
                                                 cfg.dir.outputSubject, ...
                                                 cfg.fileName.modality, ...
                                                 fileName));

    return

    expectedStruct = bids.util.jsondecode(fullfile(pwd, 'testData', 'extra_bold.json'));

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
