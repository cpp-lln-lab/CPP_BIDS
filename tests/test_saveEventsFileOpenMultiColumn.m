function test_saveEventsFileOpenMultiColumn()

    %% check header writing with several columns for one variable
    clear;

    outputDir = fullfile(fileparts(mfilename('fullpath')), '..', 'output');

    %%% set up

    cfg.subjectNb = 1;
    cfg.runNb = 1;
    cfg.task = 'testtask';
    cfg.outputDir = outputDir;

    cfg.testingDevice = 'mri';

    cfg = createFilename(cfg); 

    % define the extra columns: here we specify how many columns we want for
    % each variable
    logFile.extraColumns.Speed.length = 1; % will set 1 columns with name Speed
    logFile.extraColumns.LHL24.length = 12; % will set 12 columns with names LHL24-01, LHL24-02, ...
    logFile.extraColumns.is_Fixation = []; % will set 1 columns with name is_Fixation

    %%% do stuff

    % create the events file and header
    logFile = saveEventsFile('open', cfg, logFile);

    % close the file
    saveEventsFile('close', cfg, logFile);

    %%% test section

    % check the extra columns of the header and some of the content
    nbExtraCol = ...
        logFile(1).extraColumns.Speed.length + ...
        logFile(1).extraColumns.LHL24.length + ...
        logFile(1).extraColumns.is_Fixation.length;
    FID = fopen(fullfile( ...
        cfg.subjectOutputDir, ...
        cfg.modality, ...
        cfg.fileName.events), ...
        'r');
    C = textscan(FID, repmat('%s', 1, nbExtraCol + 3), 'Delimiter', '\t', 'EndOfLine', '\n');

    % check the extra columns of the header
    assert(isequal(C{4}{1}, 'Speed'));
    assert(isequal(C{5}{1}, 'LHL24_01'));
    assert(isequal(C{16}{1}, 'LHL24_12'));
    assert(isequal(C{17}{1}, 'is_Fixation'));

end
