% (C) Copyright 2020 CPP_BIDS developers

function test_suite = test_saveEventsFileOpen %#ok<*STOUT>
    try % assignment of 'localfunctions' is necessary in Matlab >= 2016
        test_functions = localfunctions(); %#ok<*NASGU>
    catch % no problem; early Matlab versions can use initTestSuite fine
    end
    initTestSuite;
end

function test_saveEventsFileOpenBasic()

    outputDir = fullfile(fileparts(mfilename('fullpath')), '..', 'output');

    %% set up

    cfg.verbose = false;

    cfg.subject.subjectNb = 1;
    cfg.subject.runNb = 1;

    cfg.task.name = 'testtask';

    cfg.dir.output = outputDir;

    cfg.testingDevice = 'mri';

    cfg = createFilename(cfg);

    logFile = saveEventsFile('init', cfg);

    % create the events file and header
    logFile = saveEventsFile('open', cfg, logFile);

    % close the file
    saveEventsFile('close', cfg, logFile);

    %% data to test against
    funcDir = fullfile(outputDir, 'source', 'sub-001', 'ses-001', 'func');
    eventFilename = ['sub-001_ses-001_task-testtask_run-001_events_date-' ...
                     cfg.fileName.date '.tsv'];

    % check that the file has the right path and name
    assert(exist(fullfile(funcDir, eventFilename), 'file') == 2);
    assert(exist(fullfile(funcDir, strrep(eventFilename, '.tsv', '.json')), 'file') == 2);

    FID = fopen(fullfile(funcDir, eventFilename), 'r');
    C = textscan(FID, repmat('%s', 1, 3), 'Delimiter', '\t', 'EndOfLine', '\n');

    %% test
    % check the extra columns of the header
    assertEqual(C{1}{1}, 'onset');
    assertEqual(C{2}{1}, 'duration');
    assertEqual(C{3}{1}, 'trial_type');

end

function test_saveEventsFileOpenStimfile()

    outputDir = fullfile(fileparts(mfilename('fullpath')), '..', 'output');

    %% set up

    cfg.verbose = false;

    cfg.subject.subjectNb = 1;
    cfg.subject.runNb = 1;

    cfg.task.name = 'testtask';

    cfg.dir.output = outputDir;

    cfg.testingDevice = 'mri';

    cfg = createFilename(cfg);

    logFile = saveEventsFile('init_stim', cfg);

    % create the events file and header
    logFile = saveEventsFile('open', cfg, logFile);

    % close the file
    saveEventsFile('close', cfg, logFile);

    %% data to test against
    funcDir = fullfile(outputDir, 'source', 'sub-001', 'ses-001', 'func');
    stimFilename = ['sub-001_ses-001_task-testtask_run-001_stim_date-' ...
                    cfg.fileName.date '.tsv'];

    % check that the file has the right path and name
    assert(exist(fullfile(funcDir, stimFilename), 'file') == 2);
    assert(exist(fullfile(funcDir, strrep(stimFilename, '.tsv', '.json')), 'file') == 2);

end

function test_saveEventsFileOpenExtraColumns()

    outputDir = fullfile(fileparts(mfilename('fullpath')), '..', 'output');

    %% set up

    cfg.verbose = false;

    cfg.subject.subjectNb = 1;

    cfg.subject.runNb = 1;

    cfg.task.name = 'testtask';

    cfg.dir.output = outputDir;

    cfg.testingDevice = 'mri';

    cfg = createFilename(cfg);

    % define the extra columns
    % they will be added to the tsv files in the order the user input them
    logFile.extraColumns = {'Speed', 'is_Fixation'};

    logFile = saveEventsFile('init', cfg, logFile);

    % create the events file and header
    logFile = saveEventsFile('open', cfg, logFile);

    % close the file
    saveEventsFile('close', cfg, logFile);

    %% data to test against

    % open the file
    funcDir = fullfile(cfg.dir.outputSubject, cfg.fileName.modality);
    eventFilename = cfg.fileName.events;

    nbExtraCol = 2;
    FID = fopen(fullfile(funcDir, eventFilename), 'r');
    C = textscan(FID, repmat('%s', 1, nbExtraCol + 3), 'Delimiter', '\t', 'EndOfLine', '\n');

    %% test
    % check the extra columns of the header
    assertEqual(C{1}{1}, 'onset');
    assertEqual(C{2}{1}, 'duration');
    assertEqual(C{3}{1}, 'trial_type');
    assertEqual(C{4}{1}, 'Speed');
    assertEqual(C{5}{1}, 'is_Fixation');

end
