function test_saveEventsFileOpen()

    %% Initialize file
    fprintf('\n\n--------------------------------------------------------------------\n\n');

    clear;

    outputDir = fullfile(fileparts(mfilename('fullpath')), '..', 'output');

    %%% set up

    expParameters.subjectNb = 1;
    expParameters.runNb = 1;
    expParameters.task = 'testtask';
    expParameters.outputDir = outputDir;

    cfg.testingDevice = 'mri';

    %%% do stuff

    [cfg, expParameters] = createFilename(cfg, expParameters);

    % create the events file and header
    logFile = saveEventsFile('open', expParameters);

    % close the file
    saveEventsFile('close', expParameters, logFile);

    %%% test section

    % test data
    funcDir = fullfile(outputDir, 'source', 'sub-001', 'ses-001', 'func');
    eventFilename = ['sub-001_ses-001_task-testtask_run-001_events_date-' ...
        expParameters.date '.tsv'];

    % open the file
    FID = fopen(fullfile(funcDir, eventFilename), 'r');
    C = textscan(FID, repmat('%s', 1, 3), 'Delimiter', '\t', 'EndOfLine', '\n');

    % check that the file has the right path and name
    assert(exist(fullfile(funcDir, eventFilename), 'file') == 2);

    % check the extra columns of the header
    assert(isequal(C{1}{1}, 'onset'));
    assert(isequal(C{2}{1}, 'trial_type'));
    assert(isequal(C{3}{1}, 'duration'));

    %% check header writing with extra columns
    fprintf('\n\n--------------------------------------------------------------------\n\n');

    clear;

    outputDir = fullfile(fileparts(mfilename('fullpath')), '..', 'output');

    %%% set up

    expParameters.subjectNb = 1;
    expParameters.runNb = 1;
    expParameters.task = 'testtask';
    expParameters.outputDir = outputDir;

    cfg.testingDevice = 'mri';

    % define the extra columns: they will be added to the tsv files in the order the user input them
    logFile.extraColumns = {'Speed', 'is_Fixation'};

    %%% do stuff

    [cfg, expParameters] = createFilename(cfg, expParameters);

    % create the events file and header
    logFile = saveEventsFile('open', expParameters, logFile);

    % close the file
    saveEventsFile('close', expParameters, logFile);

    %%% test section

    % open the file
    nbExtraCol = 2;
    FID = fopen(fullfile( ...
        expParameters.subjectOutputDir, ...
        expParameters.modality, ...
        expParameters.fileName.events), ...
        'r');
    C = textscan(FID, repmat('%s', 1, nbExtraCol + 3), 'Delimiter', '\t', 'EndOfLine', '\n');

    % check the extra columns of the header
    assert(isequal(C{1}{1}, 'onset'));
    assert(isequal(C{2}{1}, 'trial_type'));
    assert(isequal(C{3}{1}, 'duration'));
    assert(isequal(C{4}{1}, 'Speed'));
    assert(isequal(C{5}{1}, 'is_Fixation'));

end
