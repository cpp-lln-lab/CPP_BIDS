function test_saveEventsFileOpen()

    %% Initialize file
    clear;

    outputDir = fullfile(fileparts(mfilename('fullpath')), '..', 'output');

    %%% set up

    cfg.subject.subjectNb = 1;
    cfg.subject.runNb = 1;
    cfg.task.name = 'testtask';
    cfg.dir.output = outputDir;

    cfg.testingDevice = 'mri';

    %%% do stuff

    cfg = createFilename(cfg);

    % create the events file and header
    logFile = saveEventsFile('open', cfg);

    % close the file
    saveEventsFile('close', cfg, logFile);

    %%% test section

    % test data
    funcDir = fullfile(outputDir, 'source', 'sub-001', 'ses-001', 'func');
    eventFilename = ['sub-001_ses-001_task-testtask_run-001_events_date-' ...
        cfg.fileName.date '.tsv'];

    % check that the file has the right path and name
    assert(exist(fullfile(funcDir, eventFilename), 'file') == 2);
    
    FID = fopen(fullfile(funcDir, eventFilename), 'r');
    C = textscan(FID, repmat('%s', 1, 3), 'Delimiter', '\t', 'EndOfLine', '\n');

    % check the extra columns of the header
    assert(isequal(C{1}{1}, 'onset'));
    assert(isequal(C{2}{1}, 'duration'));
    assert(isequal(C{3}{1}, 'trial_type'));

    %% check header writing with extra columns
    fprintf('\n\n--------------------------------------------------------------------');

    clear;

    outputDir = fullfile(fileparts(mfilename('fullpath')), '..', 'output');

    %%% set up

    cfg.subject.subjectNb = 1;
    cfg.subject.runNb = 1;
    cfg.task.name = 'testtask';
    cfg.dir.output = outputDir;

    cfg.testingDevice = 'mri';

    % define the extra columns: they will be added to the tsv files in the order the user input them
    logFile.extraColumns = {'Speed', 'is_Fixation'};

    %%% do stuff

    cfg = createFilename(cfg);

    % create the events file and header
    logFile = saveEventsFile('open', cfg, logFile);

    % close the file
    saveEventsFile('close', cfg, logFile);

    %%% test section

    % open the file
    funcDir = fullfile(cfg.dir.outputSubject, cfg.fileName.modality);
    eventFilename = cfg.fileName.events;
    
    nbExtraCol = 2;
    FID = fopen(fullfile(funcDir, eventFilename), 'r');
    C = textscan(FID, repmat('%s', 1, nbExtraCol + 3), 'Delimiter', '\t', 'EndOfLine', '\n');

    % check the extra columns of the header
    assert(isequal(C{1}{1}, 'onset'));
    assert(isequal(C{2}{1}, 'duration'));
    assert(isequal(C{3}{1}, 'trial_type'));
    assert(isequal(C{4}{1}, 'Speed'));
    assert(isequal(C{5}{1}, 'is_Fixation'));
    
    

end
