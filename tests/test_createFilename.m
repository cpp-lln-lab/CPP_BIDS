function test_suite = test_createFilename %#ok<*STOUT>
    try % assignment of 'localfunctions' is necessary in Matlab >= 2016
        test_functions = localfunctions(); %#ok<*NASGU>
    catch % no problem; early Matlab versions can use initTestSuite fine
    end
    initTestSuite;
end

function test_createFilenameBasic()

    outputDir = fullfile(fileparts(mfilename('fullpath')), '..', 'output');

    %% set up

    cfg.verbose = false;
    cfg.subject.subjectNb = 1;
    cfg.subject.runNb = 1;
    cfg.task.name = 'test task';
    cfg.dir.output = outputDir;

    cfg = createFilename(cfg);

    %% data to test against
    behDir = fullfile(outputDir, 'source', 'sub-001', 'ses-001', 'beh');

    eyetrackerDir = fullfile(outputDir, 'source', 'sub-001', 'ses-001', 'eyetracker');

    eventFilename = ['sub-001_ses-001_task-testTask_run-001_events_date-'...
        cfg.fileName.date '.tsv'];

    stimFilename =  ['sub-001_ses-001_task-testTask_run-001_stim_date-'...
        cfg.fileName.date '.tsv'];

    %% test

    % make sure the beh dir is created
    assertTrue(exist(behDir, 'dir') == 7);

    % make sure the eyetracker dir is not created
    assertTrue(exist(eyetrackerDir, 'dir') == 0);

    % make sure the events filename is created
    assertEqual(cfg.fileName.events, eventFilename);

    % make sure the stim filename is created
    assertEqual(cfg.fileName.stim, stimFilename);

end

function test_createFilenameMriEyetracker()

    outputDir = fullfile(fileparts(mfilename('fullpath')), '..', 'output');

    %% set up

    cfg.verbose = false;
    cfg.subject.subjectGrp = 'ctrl';
    cfg.subject.subjectNb = 2;
    cfg.subject.sessionNb = 2;
    cfg.subject.runNb = 2;
    cfg.task.name = 'test task';
    cfg.dir.output = outputDir;

    cfg.eyeTracker.do = true;
    cfg.testingDevice = 'mri';

    cfg = createFilename(cfg);

    %% data to test against

    funcDir = fullfile(outputDir, 'source', 'sub-ctrl002', 'ses-002', 'func');

    eyetrackerDir = fullfile(outputDir, 'source', 'sub-ctrl002', 'ses-002', 'eyetracker');

    baseFilename = 'sub-ctrl002_ses-002_task-testTask';

    eventFilename = ['sub-ctrl002_ses-002_task-testTask_run-002_events_date-' ...
        cfg.fileName.date '.tsv'];

    eyetrackerFilename =  ['sub-ctrl002_ses-002_task-testTask_run-002_eyetrack_date-' ...
        cfg.fileName.date '.edf'];

    %% tests
    % make sure the func dir is created
    assertTrue(exist(funcDir, 'dir') == 7);

    % make sure the eyetracker dir is created
    assertTrue(exist(eyetrackerDir, 'dir') == 7);

    % make sure the right filenames are created
    assertEqual(cfg.fileName.base, baseFilename);
    assertEqual(cfg.fileName.events, eventFilename);
    assertEqual(cfg.fileName.eyetracker, eyetrackerFilename);

end

function test_createFilenameEeg()

    outputDir = fullfile(fileparts(mfilename('fullpath')), '..', 'output');

    %% set up

    cfg.verbose = false;
    cfg.subject.subjectGrp = 'blind';
    cfg.subject.subjectNb = 3;
    cfg.subject.sessionNb = 1;
    cfg.subject.runNb = 1;
    cfg.task.name = 'test task';
    cfg.dir.output = outputDir;

    cfg.testingDevice = 'eeg';

    cfg = createFilename(cfg);

    %% data to test against
    eegDir = fullfile(outputDir, 'source', 'sub-blind003', 'ses-001', 'eeg');

    %% test
    % make sure the func dir is created
    assertTrue(exist(eegDir, 'dir') == 7);

end
