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

function cfg = setUp()

    cfg.verbose = false;

    cfg.subject.subjectNb = 1;
    cfg.subject.runNb = 1;

    cfg.task.name = 'testtask';

    cfg.dir.output = fullfile(fileparts(mfilename('fullpath')), '..', 'output');

end
