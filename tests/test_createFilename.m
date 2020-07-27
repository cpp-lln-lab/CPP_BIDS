function test_createFilename()
    % test for filename creation and their directories

    %% PC

    outputDir = fullfile(fileparts(mfilename('fullpath')), '..', 'output');

    %%% set up part

    cfg.subjectNb = 1;
    cfg.runNb = 1;
    cfg.task = 'testtask';
    cfg.outputDir = outputDir;

    %%% run part
    cfg = createFilename(cfg);

    %%% test part

    % test data
    behDir = fullfile(outputDir, 'source', 'sub-001', 'ses-001', 'beh');
    eyetrackerDir = fullfile(outputDir, 'source', 'sub-001', 'ses-001', 'eyetracker');
    eventFilename = ['sub-001_ses-001_task-testtask_run-001_events_date-'...
        cfg.date '.tsv'];
    stimFilename =  ['sub-001_ses-001_task-testtask_run-001_stim_date-'...
        cfg.date '.tsv'];

    % make sure the beh dir is created
    assert(exist(behDir, 'dir') == 7);

    % make sure the eyetracker dir is not created
    assert(exist(eyetrackerDir, 'dir') == 0);

    % make sure the events filename is created
    assert(strcmp(cfg.fileName.events, eventFilename));

    % make sure the stim filename is created
    assert(strcmp(cfg.fileName.stim, stimFilename));

    %% fMRI and eye tracker
    fprintf('\n--------------------------------------------------------------------');

    clear;

    outputDir = fullfile(fileparts(mfilename('fullpath')), '..', 'output');

    %%% set up part

    cfg.subjectGrp = 'ctrl';
    cfg.subjectNb = 2;
    cfg.sessionNb = 2;
    cfg.runNb = 2;
    cfg.task = 'testtask';
    cfg.outputDir = outputDir;

    cfg.eyeTracker = true;
    cfg.testingDevice = 'mri';

    cfg = createFilename(cfg);

    %%% test part

    % test data
    funcDir = fullfile(outputDir, 'source', 'sub-ctrl002', 'ses-002', 'func');
    eyetrackerDir = fullfile(outputDir, 'source', 'sub-ctrl002', 'ses-002', 'eyetracker');
    baseFilename = 'sub-ctrl002_ses-002_task-testtask';
    eventFilename = ['sub-ctrl002_ses-002_task-testtask_run-002_events_date-' ...
        cfg.date '.tsv'];
    eyetrackerFilename =  ['sub-ctrl002_ses-002_task-testtask_run-002_eyetrack_date-' ...
        cfg.date '.edf'];

    % make sure the func dir is created
    assert(exist(funcDir, 'dir') == 7);

    % make sure the eyetracker dir is created
    assert(exist(eyetrackerDir, 'dir') == 7);

    % make sure the right filenames are created
    assert(strcmp(cfg.fileName.base, baseFilename));
    assert(strcmp(cfg.fileName.events, eventFilename));
    assert(strcmp(cfg.fileName.eyetracker, eyetrackerFilename));

    %% EEG
    fprintf('\n--------------------------------------------------------------------');

    clear;

    outputDir = fullfile(fileparts(mfilename('fullpath')), '..', 'output');

    %%% set up part

    cfg.subjectGrp = 'blind';
    cfg.subjectNb = 3;
    cfg.sessionNb = 1;
    cfg.runNb = 1;
    cfg.task = 'testtask';
    cfg.outputDir = outputDir;

    cfg.testingDevice = 'eeg';

    cfg = createFilename(cfg); 

    %%% test part

    % test data
    eegDir = fullfile(outputDir, 'source', 'sub-blind003', 'ses-001', 'eeg');

    % make sure the func dir is created
    assert(exist(eegDir, 'dir') == 7);
