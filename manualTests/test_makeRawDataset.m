% (C) Copyright 2020 CPP_BIDS developers

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
    cfg.task.instructions = 'do this';

    cfg.verbosity = 0;

    cfg = createFilename(cfg);

    logFile.extraColumns.Speed.length = 1;
    logFile.extraColumns.LHL24.length = 3;
    logFile.extraColumns.is_Fixation.length = 1;

    logFile = saveEventsFile('init', cfg, logFile);

    extraInfo = struct('extraInfo', struct('nestedExtraInfo', 'something extra'));
    createJson(cfg, extraInfo);

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
    stimLogFile.extraColumns.Speed.length = 1;
    stimLogFile.extraColumns.LHL24.length = 1;
    stimLogFile.extraColumns.is_Fixation.length = 1;

    stimLogFile.SamplingFrequency = cfg.mri.repetitionTime;
    stimLogFile.StartTime = 0;

    stimLogFile = saveEventsFile('init_stim', cfg, stimLogFile);
    stimLogFile = saveEventsFile('open', cfg, stimLogFile);
    for i = 1:100
        stimLogFile(i, 1).onset = cfg.mri.repetitionTime * i;
        stimLogFile(i, 1).trial_type = 'test';
        stimLogFile(i, 1).duration = 1;
        stimLogFile(i, 1).Speed = rand(1);
        stimLogFile(i, 1).is_Fixation = rand > 0.5;
        stimLogFile(i, 1).LHL24 = randn();
    end
    saveEventsFile('save', cfg, stimLogFile);
    saveEventsFile('close', cfg, stimLogFile);

    %% MRI bold rest data and fancy suffixes
    clear cfg;

    cfg.dir.output = outputDir;

    cfg.testingDevice = 'mri';

    cfg.subject.subjectNb = 1;
    cfg.subject.runNb = 1;

    % deal with MRI suffixes
    cfg.suffix.reconstruction = 'fast recon';
    cfg.suffix.contrastEnhancement = 'test';
    cfg.suffix.phaseEncodingDirection = 'y pos';
    cfg.suffix.echo = '1';
    cfg.suffix.acquisition = ' new tYpe';

    cfg.mri.repetitionTime = 1.56;

    cfg.task.name = 'rest';

    cfg = createFilename(cfg);

    extraInfo = struct('extraInfo', struct('nestedExtraInfo', 'something extra'));
    createJson(cfg, extraInfo);

    %% EEG data and fancy suffixes
    clear cfg;

    cfg.dir.output = outputDir;

    cfg.testingDevice = 'eeg';

    cfg.subject.subjectNb = 1;
    cfg.subject.runNb = 1;

    cfg.task.name = 'target practice';
    cfg.task.instructions = 'do this';

    cfg.bids.eeg.EEGReference = 'Cz';
    cfg.bids.eeg.SamplingFrequency = 2400;
    cfg.bids.eeg.PowerLineFrequency = 50;
    cfg.bids.eeg.SoftwareFilters = 'n/a';

    cfg = createFilename(cfg);

    extraInfo = struct('extraInfo', struct('nestedExtraInfo', 'something extra'));
    createJson(cfg, extraInfo);

    %% iEEG data and fancy suffixes
    clear cfg;

    cfg.dir.output = outputDir;

    cfg.testingDevice = 'ieeg';

    cfg.subject.subjectNb = 1;
    cfg.subject.runNb = 1;

    cfg.task.name = 'implanted target practice';
    cfg.task.instructions = 'do this';

    cfg.bids.ieeg.iEEGReference = 'Cz';
    cfg.bids.ieeg.SamplingFrequency = 2400;
    cfg.bids.ieeg.PowerLineFrequency = 50;
    cfg.bids.ieeg.SoftwareFilters = 'n/a';

    cfg = createFilename(cfg);

    extraInfo = struct('extraInfo', struct('nestedExtraInfo', 'something extra'));
    createJson(cfg, extraInfo);

    %% MEG data and fancy suffixes
    clear cfg;

    cfg.dir.output = outputDir;

    cfg.testingDevice = 'meg';

    cfg.subject.subjectNb = 1;
    cfg.subject.runNb = 1;

    cfg.task.name = 'magnetic target practice';
    cfg.task.instructions = 'do this';

    cfg.bids.meg.SamplingFrequency = 2400;
    cfg.bids.meg.PowerLineFrequency = 60;
    cfg.bids.meg.DewarPosition = 'upright';
    cfg.bids.meg.SoftwareFilters = 'n/a';
    cfg.bids.meg.DigitizedLandmarks = false;
    cfg.bids.meg.DigitizedHeadPoints = false;

    cfg = createFilename(cfg);

    extraInfo = struct('extraInfo', struct('nestedExtraInfo', 'something extra'));
    createJson(cfg, extraInfo);

    %% beh data and fancy suffixes
    clear cfg;

    cfg.dir.output = outputDir;

    cfg.testingDevice = 'pc';

    cfg.subject.subjectNb = 1;
    cfg.subject.runNb = 1;

    cfg.task.name = 'easy target practice';
    cfg.task.instructions = 'do this';

    cfg = createFilename(cfg);

    extraInfo = struct('extraInfo', struct('nestedExtraInfo', 'something extra'));
    createJson(cfg, extraInfo);

    %% add dummy data
    subjectDir = fullfile(cfg.dir.output, 'source', 'sub-001', 'ses-001');
    funcDir = fullfile(subjectDir, 'func');

    boldFilename = 'sub-001_ses-001_task-testtask_run-001_bold.nii.gz';

    copyfile( ...
             fullfile('dummyData', 'dummyData.nii.gz'), ...
             fullfile(funcDir, boldFilename));

    boldFilename = ['sub-001_ses-001_task-rest',  ...
                    '_acq-newTYpe_ce-test_dir-yPos_rec-fastRecon', ...
                    '_run-001_echo-1_bold.nii.gz'];

    copyfile( ...
             fullfile('dummyData', 'dummyData.nii.gz'), ...
             fullfile(funcDir, boldFilename));

    eegDir = fullfile(subjectDir, 'eeg');
    megDir = fullfile(subjectDir, 'meg');
    ieegDir = fullfile(subjectDir, 'ieeg');
    behDir = fullfile(subjectDir, 'beh');

    eegFilename = 'sub-001_ses-001_task-targetPractice_run-001_eeg.edf';
    megFilename = 'sub-001_ses-001_task-magneticTargetPractice_run-001_meg.fif';
    ieegFilename = 'sub-001_ses-001_task-implantedTargetPractice_run-001_ieeg.edf';
    behFilename = 'sub-001_ses-001_task-easyTargetPractice_run-001_beh.tsv';

    copyfile( ...
             fullfile('dummyData', 'dummyData.nii.gz'), ...
             fullfile(eegDir, eegFilename));

    copyfile( ...
             fullfile('dummyData', 'dummyData.nii.gz'), ...
             fullfile(megDir, megFilename));

    copyfile( ...
             fullfile('dummyData', 'dummyData.nii.gz'), ...
             fullfile(ieegDir, ieegFilename));

    copyfile( ...
             fullfile('dummyData', 'dummyData.nii.gz'), ...
             fullfile(behDir, behFilename));

    %% actually do the conversion of the source data thus created
    clear;

    outputDir = fullfile(fileparts(mfilename('fullpath')), 'output');
    cfg.dir.output = outputDir;
    convertSourceToRaw(cfg);

end
