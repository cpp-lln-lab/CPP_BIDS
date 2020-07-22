function test_createFilename()
    % test for filename creation and their directories

    %% PC
    fprintf('\n\n--------------------------------------------------------------------\n\n');

    outputDir = fullfile(fileparts(mfilename('fullpath')), '..', 'output');

    %%% set up part

    expParameters.subjectNb = 1;
    expParameters.runNb = 1;
    expParameters.task = 'testtask';
    expParameters.outputDir = outputDir;

    cfg = struct();

    %%% run part
    [cfg, expParameters] = createFilename(cfg, expParameters);

    %%% test part

    % test data
    behDir = fullfile(outputDir, 'source', 'sub-001', 'ses-001', 'beh');
    eyetrackerDir = fullfile(outputDir, 'source', 'sub-001', 'ses-001', 'eyetracker');
    eventFilename = ['sub-001_ses-001_task-testtask_run-001_events_date-'...
        expParameters.date '.tsv'];
    stimFilename =  ['sub-001_ses-001_task-testtask_run-001_stim_date-'...
        expParameters.date '.tsv'];

    % make sure the beh dir is created
    assert(exist(behDir, 'dir') == 7);

    % make sure the eyetracker dir is not created
    assert(exist(eyetrackerDir, 'dir') == 0);

    % make sure the events filename is created
    assert(strcmp(expParameters.fileName.events, eventFilename));

    % make sure the stim filename is created
    assert(strcmp(expParameters.fileName.stim, stimFilename));

    %% fMRI and eye tracker
    fprintf('\n\n--------------------------------------------------------------------\n\n');

    clear;

    outputDir = fullfile(fileparts(mfilename('fullpath')), '..', 'output');

    %%% set up part

    expParameters.subjectGrp = 'ctrl';
    expParameters.subjectNb = 2;
    expParameters.sessionNb = 2;
    expParameters.runNb = 2;
    expParameters.task = 'testtask';
    expParameters.outputDir = outputDir;

    cfg.eyeTracker = true;
    cfg.testingDevice = 'mri';

    [cfg, expParameters] = createFilename(cfg, expParameters);

    %%% test part

    % test data
    funcDir = fullfile(outputDir, 'source', 'sub-ctrl002', 'ses-002', 'func');
    eyetrackerDir = fullfile(outputDir, 'source', 'sub-ctrl002', 'ses-002', 'eyetracker');
    baseFilename = 'sub-ctrl002_ses-002_task-testtask';
    eventFilename = ['sub-ctrl002_ses-002_task-testtask_run-002_events_date-' ...
        expParameters.date '.tsv'];
    eyetrackerFilename =  ['sub-ctrl002_ses-002_task-testtask_run-002_eyetrack_date-' ...
        expParameters.date '.edf'];

    % make sure the func dir is created
    assert(exist(funcDir, 'dir') == 7);

    % make sure the eyetracker dir is created
    assert(exist(eyetrackerDir, 'dir') == 7);

    % make sure the right filenames are created
    assert(strcmp(expParameters.fileName.base, baseFilename));
    assert(strcmp(expParameters.fileName.events, eventFilename));
    assert(strcmp(expParameters.fileName.eyetracker, eyetrackerFilename));

    %% EEG
    fprintf('\n\n--------------------------------------------------------------------\n\n');

    clear;

    outputDir = fullfile(fileparts(mfilename('fullpath')), '..', 'output');

    %%% set up part

    expParameters.subjectGrp = 'blind';
    expParameters.subjectNb = 3;
    expParameters.sessionNb = 1;
    expParameters.runNb = 1;
    expParameters.task = 'testtask';
    expParameters.outputDir = outputDir;

    cfg.testingDevice = 'eeg';

    [cfg, expParameters] = createFilename(cfg, expParameters); %#ok<ASGLU>

    %%% test part

    % test data
    eegDir = fullfile(outputDir, 'source', 'sub-blind003', 'ses-001', 'eeg');

    % make sure the func dir is created
    assert(exist(eegDir, 'dir') == 7);
