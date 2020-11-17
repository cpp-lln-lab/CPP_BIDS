% (C) Copyright 2020 CPP_BIDS developers

function test_suite = test_saveEventsFileOpenMultiColumn %#ok<*STOUT>
    try % assignment of 'localfunctions' is necessary in Matlab >= 2016
        test_functions = localfunctions(); %#ok<*NASGU>
    catch % no problem; early Matlab versions can use initTestSuite fine
    end
    initTestSuite;
end

function test_saveEventsFileOpenMultiColumnCheckHeader()

    outputDir = fullfile(fileparts(mfilename('fullpath')), '..', 'output');

    %% set up

    cfg.verbose = false;

    cfg.subject.subjectNb = 1;
    cfg.subject.runNb = 1;

    cfg.task.name = 'testtask';

    cfg.dir.output = outputDir;

    cfg.testingDevice = 'mri';

    cfg = createFilename(cfg);

    % define the extra columns names
    logFile.extraColumns = {'Speed', 'LHL24', 'is_Fixation'};

    % initalize logfile
    logFile = saveEventsFile('init', cfg, logFile);

    % extra columns: here we specify how many columns we want for each variable
    logFile.extraColumns.Speed.length = 1; % will set 1 columns with name Speed
    logFile.extraColumns.LHL24.length = 12; % will set 12 columns with names LHL24-01, LHL24-02, ...

    % create the events file and header
    logFile = saveEventsFile('open', cfg, logFile);

    % close the file
    saveEventsFile('close', cfg, logFile);

    funcDir = fullfile(cfg.dir.outputSubject, cfg.fileName.modality);

    eventFilename = cfg.fileName.events;

    nbExtraCol = ...
        logFile(1).extraColumns.Speed.length + ...
        logFile(1).extraColumns.LHL24.length + ...
        logFile(1).extraColumns.is_Fixation.length;

    %% test
    FID = fopen(fullfile(funcDir, eventFilename), 'r');
    C = textscan(FID, repmat('%s', 1, nbExtraCol + 3), 'Delimiter', '\t', 'EndOfLine', '\n');

    % check the extra columns of the header
    assertEqual(C{4}{1}, 'Speed');
    assertEqual(C{5}{1}, 'LHL24_01');
    assertEqual(C{16}{1}, 'LHL24_12');
    assertEqual(C{17}{1}, 'is_Fixation');

end
