function test_makeRawDataset()

    outputDir = fullfile(fileparts(mfilename('fullpath')), 'output');

    if isdir(outputDir)
        rmdir(outputDir, 's');
    end

    %% set up
    cfg.dir.output = outputDir;

    cfg.bids.datasetDescription.Name = 'dummy';
    cfg.bids.datasetDescription.BIDSVersion = '1.0.0';
    cfg.bids.datasetDescription.Authors = {'Jane Doe', 'John Doe'};

    cfg.testingDevice = 'mri';

    %% MRI task data
    cfg.mri.repetitionTime = 1.56;

    cfg.subject.subjectNb = 1;
    cfg.subject.runNb = 1;

    cfg.task.name = 'testtask';

    logFile.extraColumns.Speed.length = 1;
    logFile.extraColumns.LHL24.length = 3;
    logFile.extraColumns.is_Fixation.length = 1;

    cfg = createFilename(cfg);

    createBoldJson(cfg);

    createDatasetDescription(cfg);

    % create the events file and header
    logFile = saveEventsFile('open', cfg, logFile);

    % ROW 2: normal events : all info is there
    logFile(1, 1).onset = 2;
    logFile(end, 1).trial_type = 'MotionUp';
    logFile(end, 1).duration = 3;
    logFile(end, 1).Speed = 2;
    logFile(end, 1).is_Fixation = true;
    logFile(end, 1).LHL24 = 1:3;

    % ROW 3: missing info (speed, LHL24)
    logFile(1, 1).onset = 3;
    logFile(end, 1).trial_type = 'static';
    logFile(end, 1).duration = 4;
    logFile(end, 1).is_Fixation = false;

    % ROW 4: missing info (duration is missing and speed is empty)
    logFile(2, 1).onset = 4;
    logFile(end, 1).trial_type = 'BLUES';
    logFile(end, 1).Speed = [];
    logFile(end, 1).is_Fixation = true;
    logFile(end, 1).LHL24 = rand(1, 3);

    % ROW 5: missing info (array is not the right size)
    logFile(5, 1).onset = 5;
    logFile(end, 1).trial_type = 'jazz';
    logFile(end, 1).duration = 3;
    logFile(end, 1).LHL24 = rand(1, 2);

    saveEventsFile('save', cfg, logFile);

    % close the file
    saveEventsFile('close', cfg, logFile);

    % add dummy stim data
    stimLogFile = saveEventsFile('open_stim', cfg, logFile);
    for i = 1:100
        stimLogFile(i, 1).onset = cfg.mri.repetitionTime * i;
        stimLogFile(i, 1).trial_type = 'test';
        stimLogFile(i, 1).duration = 1;
        stimLogFile(i, 1).Speed = rand(1);
        stimLogFile(i, 1).is_Fixation = rand > 0.5;
        stimLogFile(i, 1).LHL24 = randn(1, 3);
    end
    saveEventsFile('save', cfg, stimLogFile);
    saveEventsFile('close', cfg, stimLogFile);

    % add dummy functional data
    funcDir = fullfile(cfg.dir.output, 'source', 'sub-001', 'ses-001', 'func');
    boldFilename = 'sub-001_ses-001_task-testtask_run-001_bold.nii.gz';

    copyfile( ...
        fullfile('..', 'dummyData', 'dummyData.nii.gz'), ...
        fullfile(funcDir, boldFilename));

    %% MRI bold rest data and fancy suffixes
    clear cfg;

    cfg.dir.output = outputDir;

    cfg.testingDevice = 'mri';

    cfg.subject.subjectNb = 2;
    cfg.subject.sessionNb = 3;
    cfg.subject.runNb = 4;

    % deal with MRI suffixes
    cfg.mri.reconstruction = 'fast recon';
    cfg.mri.contrastEnhancement = 'test';
    cfg.mri.phaseEncodingDirection = 'y pos';
    cfg.mri.echo = '1';
    cfg.mri.acquisition = ' new tYpe';
    cfg.mri.repetitionTime = 1.56;

    cfg.task.name = 'rest';

    cfg = createFilename(cfg);

    createBoldJson(cfg);

    %% add dummy functional data
    funcDir = fullfile(cfg.dir.output, 'source', 'sub-002', 'ses-003', 'func');
    boldFilename = ['sub-002_ses-003_task-rest',  ...
        '_acq-newTYpe_ce-test_dir-yPos_rec-fastRecon', ...
        '_run-004_echo-1_bold.nii.gz'];

    copyfile( ...
        fullfile('..', 'dummyData', 'dummyData.nii.gz'), ...
        fullfile(funcDir, boldFilename));

    %% actually do the conversion of the source data thus created
    clear;

    outputDir = fullfile(fileparts(mfilename('fullpath')), 'output');
    cfg.dir.output = outputDir;
    convertSourceToRaw(cfg);

end
