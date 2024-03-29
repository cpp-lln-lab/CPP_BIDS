% (C) Copyright 2020 CPP_BIDS developers

function test_suite = test_readAndFilterLogfile %#ok<*STOUT>
    try % assignment of 'localfunctions' is necessary in Matlab >= 2016
        test_functions = localfunctions(); %#ok<*NASGU>
    catch % no problem; early Matlab versions can use initTestSuite fine
    end
    initTestSuite;
end

function test_readAndFilterLogfile_basic()

    %% set up
    [cfg, logFile] = setUp();
    cfg.dir.output = fullfile(fileparts(mfilename('fullpath')), '..', 'output');

    % create the events file and header
    logFile = saveEventsFile('open', cfg, logFile);

    % ROW 2: normal events : all info is there
    logFile(1, 1).onset = 2;
    logFile(end, 1).trial_type = 'motion_up';
    logFile(end, 1).duration = 3;
    logFile(end, 1).Speed = 2;
    logFile(end, 1).is_Fixation = true;
    logFile(end, 1).LHL24 = 1:12;

    logFile(2, 1).onset = 2;
    logFile(end, 1).trial_type = 'motion_down';
    logFile(end, 1).duration = 3;
    logFile(end, 1).Speed = 2;
    logFile(end, 1).is_Fixation = true;
    logFile(end, 1).LHL24 = 2:13;

    logFile(3, 1).onset = 2;
    logFile(end, 1).trial_type = 'motion_up';
    logFile(end, 1).duration = 3;
    logFile(end, 1).Speed = 2;
    logFile(end, 1).is_Fixation = true;
    logFile(end, 1).LHL24 = 1:12;

    logFile(4, 1).onset = 2;
    logFile(end, 1).trial_type = 'motion_down';
    logFile(end, 1).duration = 3;
    logFile(end, 1).Speed = 2;
    logFile(end, 1).is_Fixation = true;
    logFile(end, 1).LHL24 = 2:13;

    logFile = saveEventsFile('save', cfg, logFile);

    % close the file
    saveEventsFile('close', cfg, logFile);

    % filter file
    readAndFilterLogfile('trial_type', 'trial_type==motion_down', true, cfg);

    %% test
    expectedFilename = strrep(cfg.fileName.events, '.tsv', ...
                              '_filteredOn-trial_type.tsv');
    expectedFile = fullfile(cfg.dir.outputSubject, ...
                            cfg.fileName.modality, ...
                            expectedFilename);

    assertEqual(exist(expectedFile, 'file'), 2);

    content = bids.util.tsvread(expectedFile);

    assertEqual(size(content.trial_type), [2, 1]);

    assertEqual(content.trial_type{1}, 'motion_down');
    assertEqual(content.trial_type{2}, 'motion_down');

    delete(expectedFile);

end

function test_readAndFilterLogfile_from_file()

    %% set up

    inputFile = fullfile(fileparts(mfilename('fullpath')), 'testData', ...
                         'sub-blind01_ses-01_task-vislocalizer_events.tsv');

    % filter file
    readAndFilterLogfile('trial_type', 'trial_type==VisStat', true, inputFile);

    %% test
    expectedFile = strrep(inputFile, '.tsv', ...
                          '_filteredOn-trial_type.tsv');

    assertEqual(exist(expectedFile, 'file'), 2);

    content = bids.util.tsvread(expectedFile);

    assertEqual(content.trial_type{1}, 'VisStat');

    delete(expectedFile);

end
