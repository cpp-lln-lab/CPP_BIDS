function test_saveEventsFile()
    % test for events.tsv file creation
    
    clear
    
    outputDir = fullfile(fileparts(mfilename('fullpath')), '..', 'output');
    
    %% set up
    
    expParameters.subjectGrp = '';
    expParameters.subjectNb = 1;
    expParameters.sessionNb = 1;
    expParameters.runNb = 1;
    expParameters.task = 'testtask';
    expParameters.outputDir = outputDir;
    
    cfg.testingDevice = 'mri';
    
    [cfg, expParameters] = createFilename(cfg, expParameters);
    
    %% create the events file
    
    logFile = saveEventsFile('open', expParameters, [], 'Speed', 'is_Fixation');

    %%% test section
    
    % test data
    funcDir = fullfile(outputDir, 'source', 'sub-001', 'ses-001', 'func');
    eventFilename = ['sub-001_ses-001_task-testtask_run-001_events_date-' ...
        expParameters.date '.tsv'];
    
    % check that the file has the right path and name
    assert(exist(fullfile(funcDir, eventFilename), 'file') == 2);

    
    %%  write things in it
    
    logFile(1).onset = 1;
    logFile(1).trial_type = 'motion_up';
    logFile(1).duration = 1;
    logFile(1).speed = [];
    logFile(1).is_fixation = 'true';
    
    saveEventsFile('save', expParameters, logFile, 'speed', 'is_fixation');
    
    logFile(1, 1).onset = 2;
    logFile(1, 1).trial_type = 'motion_up';
    logFile(1, 1).duration = 1;
    logFile(1, 1).speed = 2;
    logFile(1, 1).is_fixation = true;
    
    logFile(2, 1).onset = 3;
    logFile(2, 1).trial_type = 'static';
    logFile(2, 1).duration = 4;
    logFile(2, 1).is_fixation = 3;
    
    logFile(3, 1).onset = [];
    logFile(3, 1).trial_type = '';
    logFile(3, 1).duration = [];

    
    saveEventsFile('save', expParameters, logFile, 'speed', 'is_fixation');
    
    % close the file
    saveEventsFile('close', expParameters, logFile);
    
    
    %%% test section
    
    % check the extra columns of the header and some of the content
    
    FID = fopen(fullfile(funcDir, eventFilename), 'r');
    C = textscan(FID, '%s%s%s%s%s', 'Delimiter', '\t', 'EndOfLine', '\n');
    
    % check header
    assert(isequal(C{4}{1}, 'Speed'));
    
    % check that empty values are entered as NaN
    assert(isequal(C{4}{2}, 'NaN'));
    
    % check that missing fields are entered as NaN
    assert(isequal(C{4}{4}, 'NaN'));
    
    % check values entered properly
    assert(isequal(str2double(C{4}{3}), 2));
    
    % check values entered properly
    assert(isequal(str2double(C{5}{4}), 3));
    
    
    
    
    
    %     stimFile = saveEventsFile('open_stim', expParameters, []);
    
    %     stimFileName = fullfile( ...
    %         expParameters.outputDir, ...
    %         expParameters.modality, ...
    %         expParameters.fileName.stim);
    
%         assert(exist(stimFileName, 'file') == 2);