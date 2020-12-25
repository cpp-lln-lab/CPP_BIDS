% (C) Copyright 2020 CPP_BIDS developers

function test_suite = test_saveEventsFileSave %#ok<*STOUT>
    try % assignment of 'localfunctions' is necessary in Matlab >= 2016
        test_functions = localfunctions(); %#ok<*NASGU>
    catch % no problem; early Matlab versions can use initTestSuite fine
    end
    initTestSuite;
end

function test_saveEventsFileSaveBasic()

    %% set up

    [cfg, logFile] = setUp();

    % create the events file and header
    logFile = saveEventsFile('open', cfg, logFile);

    % ROW 2: normal events : all info is there
    logFile(1, 1).onset = 2;
    logFile(end, 1).trial_type = 'motion_up';
    logFile(end, 1).duration = 3;
    logFile(end, 1).Speed = 2;
    logFile(end, 1).is_Fixation = true;
    logFile(end, 1).LHL24 = 1:12;

    logFile = saveEventsFile('save', cfg, logFile);

    % close the file
    saveEventsFile('close', cfg, logFile);

    %% test

    % check the extra columns of the header and some of the content
    content = getFileContent(cfg, logFile);

    % event 1/ ROW 2: check that values are entered correctly
    assertEqual(content{1}{2}, sprintf('%f', 2));
    assertEqual(content{3}{2}, 'motion_up');
    assertEqual(content{2}{2}, sprintf('%f', 3));
    assertEqual(content{4}{2}, sprintf('%f', 2));
    assertEqual(content{5}{2}, sprintf('%f', 1));
    assertEqual(content{16}{2}, sprintf('%f', 12));
    assertEqual(content{17}{2}, 'true');

end

function test_saveEventsFileSaveStim()

    %% set up

    cfg.verbose = 2;

    cfg.subject.subjectNb = 1;
    cfg.subject.runNb = 1;

    cfg.task.name = 'testtask';

    cfg.testingDevice = 'mri';

    cfg = createFilename(cfg);

    logFile.extraColumns = {'Speed', 'LHL24', 'is_Fixation'};

    logFile = saveEventsFile('init_stim', cfg, logFile);

    logFile.extraColumns.Speed.length = 1;
    logFile.extraColumns.LHL24.length = 3;
    logFile.extraColumns.is_Fixation.length = 1;

    % create the events file and header
    logFile = saveEventsFile('open', cfg, logFile);

    % ROW 2: normal events : all info is there
    logFile(1, 1).onset = 2;
    logFile(end, 1).trial_type = 'motion_up';
    logFile(end, 1).duration = 3;
    logFile(end, 1).Speed = 2;
    logFile(end, 1).LHL24 = 1:3;
    logFile(end, 1).is_Fixation = true;

    logFile = saveEventsFile('save', cfg, logFile);

    % close the file
    saveEventsFile('close', cfg, logFile);

    % check the extra columns of the header and some of the content
    nbExtraCol = ...
        logFile(1).extraColumns.Speed.length + ...
        logFile(1).extraColumns.LHL24.length + ...
        logFile(1).extraColumns.is_Fixation.length;

    funcDir = fullfile(cfg.dir.outputSubject, cfg.fileName.modality);

    FID = fopen(fullfile(funcDir, logFile.filename), 'r');
    content = textscan(FID, repmat('%s', 1, nbExtraCol), 'Delimiter', '\t', 'EndOfLine', '\n');

    % event 1/ ROW 2: check that values are entered correctly
    assertEqual(content{1}{1}, sprintf('%f', 2));
    assertEqual(content{4}{1}, sprintf('%f', 3));
    assertEqual(content{5}{1}, 'true');

end

function test_saveEventsFileSaveSkipEmptyEvents()

    %% set up

    [cfg, logFile] = setUp();

    cfg.verbose = 1;

    % create the events file and header
    logFile = saveEventsFile('open', cfg, logFile);

    % "empty" events except the last one
    logFile(1, 1).onset = [];
    logFile(end, 1).duration = [];

    logFile(2, 1).onset = 1;
    logFile(end, 1).duration = 'test';

    logFile(3, 1).onset = 1;
    logFile(end, 1).duration = nan;

    logFile(4, 1).onset = 'test';
    logFile(end, 1).duration = 1;

    logFile(5, 1).onset = nan;
    logFile(end, 1).duration = 1;

    logFile(6, 1).onset = 1;
    logFile(end, 1).duration = 1;

    assertWarning(@()saveEventsFile('save', cfg, logFile), 'saveEventsFile:emptyEvent');

    saveEventsFile('save', cfg, logFile);

    % close the file
    saveEventsFile('close', cfg, logFile);

    %% test

    % check the extra columns of the header and some of the content
    content = getFileContent(cfg, logFile);

    % event 4-5 / ROW 5-6: skip empty events
    assertTrue(isequal(size(content{1}, 1), 2));
    assertTrue(~isequal(content{1}{1}, sprintf('%f', 1)));

end

function test_saveEventsFileSaveMissingInfo()

    %% set up

    [cfg, logFile] = setUp();

    % create the events file and header
    logFile = saveEventsFile('open', cfg, logFile);

    % ROW 1: missing info (speed, LHL24)
    logFile(1, 1).onset = 3;
    logFile(end, 1).trial_type = 'static';
    logFile(end, 1).duration = 4;
    logFile(end, 1).is_Fixation = false;

    % ROW 2: missing info (trial_type is missing and speed is empty)
    logFile(2, 1).onset = 4;
    logFile(end, 1).duration = 2;
    logFile(end, 1).Speed = [];
    logFile(end, 1).is_Fixation = true;
    logFile(end, 1).LHL24 = 1:12;

    saveEventsFile('save', cfg, logFile);

    % close the file
    saveEventsFile('close', cfg, logFile);

    %% test

    % check the extra columns of the header and some of the content
    content = getFileContent(cfg, logFile);

    % event 2 / ROW 3: missing info replaced by n/a
    assertEqual(content{4}{2}, 'n/a');
    assertEqual(content{5}{2}, 'n/a');
    assertEqual(content{16}{2}, 'n/a');
    assertEqual(content{17}{2}, 'false');

    % event 3 / ROW 4: missing info (trial_type is missing and speed is empty)
    assertEqual(content{3}{3}, 'n/a');
    assertEqual(content{4}{3}, 'n/a');

end

function test_saveEventsFileSaveArraySize()

    %% set up

    [cfg, logFile] = setUp();

    cfg.verbose = 1;

    % create the events file and header
    logFile = saveEventsFile('open', cfg, logFile);

    % ROW 1: missing info (array is too short)
    logFile(1, 1).onset = 5;
    logFile(end, 1).trial_type = 'jazz';
    logFile(end, 1).duration = 3;
    logFile(end, 1).LHL24 = rand(1, 10);

    assertWarning(@()saveEventsFile('save', cfg, logFile), 'saveEventsFile:missingData');

    saveEventsFile('save', cfg, logFile);

    % ROW 2: too much info (array is too long)
    logFile(1, 1).onset = 5;
    logFile(end, 1).trial_type = 'blues';
    logFile(end, 1).duration = 3;
    logFile(end, 1).LHL24 = rand(1, 15);

    assertWarning(@()saveEventsFile('save', cfg, logFile), 'nanPadding:arrayTooLong');

    saveEventsFile('save', cfg, logFile);

    % close the file
    saveEventsFile('close', cfg, logFile);

    %% test
    content = getFileContent(cfg, logFile);

    % check values entered properly
    assertEqual(content{15}{2}, 'n/a');
    assertEqual(content{16}{2}, 'n/a');

end

function test_saveEventsFileSaveErrors()

    %% set up

    cfg = struct();
    logFile = struct();

    assertExceptionThrown(@()saveEventsFile('error', cfg, logFile), ...
                          'saveEventsFile:unknownActionType');

    assertExceptionThrown(@()saveEventsFile('save', cfg, logFile), ...
                          'saveEventsFile:missingFileID');

    [cfg, logFile] = setUp();

    logFile = saveEventsFile('open', cfg, logFile);

    % ROW 1: missing info (array is too short)
    logFile(1, 2).onset = 5;
    logFile(end, end).trial_type = 'jazz';
    logFile(end, end).duration = 3;
    logFile(end, end).LHL24 = rand(1, 10);

    assertExceptionThrown(@()saveEventsFile('save', cfg, logFile), ...
                          'saveEventsFile:wrongLogSize');

end

function content = getFileContent(cfg, logFile)

    % check the extra columns of the header and some of the content
    nbExtraCol = ...
        logFile(1).extraColumns.Speed.length + ...
        logFile(1).extraColumns.LHL24.length + ...
        logFile(1).extraColumns.is_Fixation.length;

    funcDir = fullfile(cfg.dir.outputSubject, cfg.fileName.modality);

    eventFilename = cfg.fileName.events;

    FID = fopen(fullfile(funcDir, eventFilename), 'r');
    content = textscan(FID, repmat('%s', 1, nbExtraCol + 3), 'Delimiter', '\t', 'EndOfLine', '\n');

end
