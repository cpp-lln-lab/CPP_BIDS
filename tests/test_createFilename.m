% (C) Copyright 2020 CPP_BIDS developers

function test_suite = test_createFilename %#ok<*STOUT>
    try % assignment of 'localfunctions' is necessary in Matlab >= 2016
        test_functions = localfunctions(); %#ok<*NASGU>
    catch % no problem; early Matlab versions can use initTestSuite fine
    end
    initTestSuite;
end

function test_createFilename_basic()

    %% set up

    cfg = setUp();

    cfg = createFilename(cfg);

    %% data to test against
    behDir = fullfile(cfg.dir.output, 'source', 'sub-001', 'ses-001', 'beh');

    eventFilename = ['sub-001_ses-001_task-testTask_run-001_date-' cfg.fileName.date '_events.tsv'];

    stimFilename =  ['sub-001_ses-001_task-testTask_run-001_date-' cfg.fileName.date '_stim.tsv'];

    %% test

    % make sure the beh dir is created
    assertTrue(exist(behDir, 'dir') == 7);

    % make sure the events filename is created
    assertEqual(cfg.fileName.events, eventFilename);

    % make sure the stim filename is created
    assertEqual(cfg.fileName.stim, stimFilename);

end

function test_createFilename_mri_eyetracker()

    %% set up

    cfg = setUp();

    cfg.eyeTracker.do = true;
    cfg.testingDevice = 'mri';

    cfg = createFilename(cfg);

    %% data to test against

    funcDir = fullfile(cfg.dir.output, 'source', 'sub-001', 'ses-001', 'func');

    eyetrackerDir = fullfile(cfg.dir.output, 'source', 'sub-001', 'ses-001', 'func');

    baseFilename = 'sub-001_ses-001_task-testTask';

    eventFilename = [baseFilename '_run-001_date-' ...
                     cfg.fileName.date '_events.tsv'];

    eyetrackerFilename =  [ ...
                           baseFilename '_run-001_recording-eyetracking_date-' ...
                           cfg.fileName.date '_physio.edf'];

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

function test_createFilename_mri_suffix()

    %% set up

    cfg = setUp();

    cfg.testingDevice = 'mri';

    cfg.suffix.recording = 'respi pulse';
    cfg.suffix.rec = 'fast recon';
    cfg.suffix.ce = 'test';
    cfg.suffix.dir = 'y pos';
    cfg.suffix.echo = '1';
    cfg.suffix.acq = ' new tYpe';

    cfg = createFilename(cfg);

    %% data to test against

    funcDir = fullfile(cfg.dir.output, 'source', 'sub-001', 'ses-001', 'func');

    baseFilename = 'sub-001_ses-001_task-testTask';

    eventFilename = ['sub-001_ses-001_task-testTask',  ...
                     '_acq-newTYpe_ce-test_dir-yPos_rec-fastRecon', ...
                     '_run-001_echo-1_date-' ...
                     cfg.fileName.date '_events.tsv'];

    stimFilename = ['sub-001_ses-001_task-testTask',  ...
                    '_acq-newTYpe_ce-test_dir-yPos_rec-fastRecon', ...
                    '_run-001_echo-1_recording-respiPulse_date-' ...
                    cfg.fileName.date '_stim.tsv'];

    %% tests
    % make sure the func dir is created
    assertTrue(exist(funcDir, 'dir') == 7);

    % make sure the right filenames are created
    assertEqual(cfg.fileName.base, baseFilename);
    assertEqual(cfg.fileName.events, eventFilename);
    assertEqual(cfg.fileName.stim, stimFilename);

end

function test_createFilename_beh_suffix()

    %% set up

    cfg = setUp();

    cfg.testingDevice = 'pc';

    cfg.suffix.recording = 'respi pulse';
    cfg.suffix.rec = 'fast recon';
    cfg.suffix.ce = 'test';
    cfg.suffix.dir = 'y pos';
    cfg.suffix.echo = '1';
    cfg.suffix.acq = ' new tYpe';

    cfg = createFilename(cfg);

    %% data to test against

    funcDir = fullfile(cfg.dir.output, 'source', 'sub-001', 'ses-001', 'beh');

    baseFilename = 'sub-001_ses-001_task-testTask';

    eventFilename = ['sub-001_ses-001_task-testTask',  ...
                     '_acq-newTYpe', ...
                     '_run-001_date-' ...
                     cfg.fileName.date '_events.tsv'];

    stimFilename = ['sub-001_ses-001_task-testTask',  ...
                    '_acq-newTYpe', ...
                    '_run-001_recording-respiPulse_date-' ...
                    cfg.fileName.date '_stim.tsv'];

    %% tests
    % make sure the func dir is created
    assertTrue(exist(funcDir, 'dir') == 7);

    % make sure the right filenames are created
    assertEqual(cfg.fileName.base, baseFilename);
    assertEqual(cfg.fileName.events, eventFilename);
    assertEqual(cfg.fileName.stim, stimFilename);

end

function test_createFilename_eeg_suffix()

    %% set up

    cfg = setUp();

    cfg.testingDevice = 'eeg';

    cfg.suffix.recording = 'respi pulse';
    cfg.suffix.rec = 'fast recon';
    cfg.suffix.ce = 'test';
    cfg.suffix.dir = 'y pos';
    cfg.suffix.echo = '1';
    cfg.suffix.acq = ' new tYpe';

    cfg = createFilename(cfg);

    %% data to test against

    funcDir = fullfile(cfg.dir.output, 'source', 'sub-001', 'ses-001', 'eeg');

    baseFilename = 'sub-001_ses-001_task-testTask';

    eventFilename = ['sub-001_ses-001_task-testTask',  ...
                     '_run-001_date-' ...
                     cfg.fileName.date '_events.tsv'];

    stimFilename = ['sub-001_ses-001_task-testTask',  ...
                    '_run-001_recording-respiPulse_date-' ...
                    cfg.fileName.date '_stim.tsv'];

    %% tests
    % make sure the func dir is created
    assertTrue(exist(funcDir, 'dir') == 7);

    % make sure the right filenames are created
    assertEqual(cfg.fileName.base, baseFilename);
    assertEqual(cfg.fileName.events, eventFilename);
    assertEqual(cfg.fileName.stim, stimFilename);

end

function test_createFilename_eeg()

    %% set up

    cfg = setUp();

    cfg.testingDevice = 'eeg';

    cfg = createFilename(cfg);

    %% data to test against
    eegDir = fullfile(cfg.dir.output, 'source', 'sub-001', 'ses-001', 'eeg');

    eventFilename = ['sub-001_ses-001_task-testTask_run-001_date-' cfg.fileName.date '_events.tsv'];

    %% test
    % make sure the func dir is created
    assertTrue(exist(eegDir, 'dir') == 7);

    % make sure the events filename is created
    assertEqual(cfg.fileName.events, eventFilename);

end

function test_createFilename_ieeg()

    %% set up

    cfg = setUp();

    cfg.testingDevice = 'ieeg';

    cfg = createFilename(cfg);

    %% data to test against
    ieegDir = fullfile(cfg.dir.output, 'source', 'sub-001', 'ses-001', 'ieeg');

    %% test
    % make sure the func dir is created
    assertTrue(exist(ieegDir, 'dir') == 7);

    eventFilename = ['sub-001_ses-001_task-testTask_run-001_date-' cfg.fileName.date '_events.tsv'];

end

function test_createFilename_meg()

    %% set up

    cfg = setUp();

    cfg.testingDevice = 'meg';

    cfg = createFilename(cfg);

    %% data to test against
    megDir = fullfile(cfg.dir.output, 'source', 'sub-001', 'ses-001', 'meg');

    %% test
    % make sure the func dir is created
    assertTrue(exist(megDir, 'dir') == 7);

    eventFilename = ['sub-001_ses-001_task-testTask_run-001_events_date-'...
                     cfg.fileName.date '.tsv'];

end

function cfg = setUp()
    outputDir = fullfile(fileparts(mfilename('fullpath')), '..', 'output');
    cfg = globalTestSetUp();
    cfg.dir.output = outputDir;
end
