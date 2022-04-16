% (C) Copyright 2020 CPP_BIDS developers

function test_makeRawDataset()

    if isdir(outputDir())
        rmdir(outputDir(), 's');
    end

    templateFolder = fullfile(fileparts(mfilename('fullpath')), '..', '..', 'templates');

    for iSub = 1:2
        %% set up
        cfg = baseCfg(iSub);

        cfg.bids.datasetDescription.Name = 'dummy';
        cfg.bids.datasetDescription.BIDSVersion = '1.0.0';
        cfg.bids.datasetDescription.Authors = {'Jane Doe', 'John Doe'};

        cfg.testingDevice = 'mri';

        %% MRI task data
        cfg.mri.repetitionTime = 1.56;

        cfg.task.name = 'testtask';

        cfg = createFilename(cfg);

        extraInfo = struct('extraInfo', struct('nestedExtraInfo', 'something extra'));
        createJson(cfg, extraInfo);

        createTsvWithContent(cfg);

        createDatasetDescription(cfg);

        %% MRI bold rest data and fancy suffixes
        clear cfg;

        cfg = baseCfg(iSub);

        cfg.testingDevice = 'mri';

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

        cfg = baseCfg(iSub);

        cfg.testingDevice = 'eeg';

        cfg.task.name = 'target practice';

        cfg.bids.eeg.EEGReference = 'Cz';
        cfg.bids.eeg.SamplingFrequency = 2400;
        cfg.bids.eeg.PowerLineFrequency = 50;
        cfg.bids.eeg.SoftwareFilters = 'n/a';

        cfg = createFilename(cfg);

        extraInfo = struct('extraInfo', struct('nestedExtraInfo', 'something extra'));
        createJson(cfg, extraInfo);

        createTsvWithContent(cfg);

        %% iEEG data and fancy suffixes
        clear cfg;

        cfg = baseCfg(iSub);

        cfg.testingDevice = 'ieeg';

        cfg.task.name = 'implanted target practice';

        cfg.bids.ieeg.iEEGReference = 'Cz';
        cfg.bids.ieeg.SamplingFrequency = 2400;
        cfg.bids.ieeg.PowerLineFrequency = 50;
        cfg.bids.ieeg.SoftwareFilters = 'n/a';

        cfg = createFilename(cfg);

        extraInfo = struct('extraInfo', struct('nestedExtraInfo', 'something extra'));
        createJson(cfg, extraInfo);

        createTsvWithContent(cfg);

        %% MEG data and fancy suffixes
        clear cfg;

        cfg = baseCfg(iSub);

        cfg.testingDevice = 'meg';

        cfg.task.name = 'magnetic target practice';

        cfg.bids.meg.SamplingFrequency = 2400;
        cfg.bids.meg.PowerLineFrequency = 60;
        cfg.bids.meg.DewarPosition = 'upright';
        cfg.bids.meg.SoftwareFilters = 'n/a';
        cfg.bids.meg.DigitizedLandmarks = false;
        cfg.bids.meg.DigitizedHeadPoints = false;

        cfg = createFilename(cfg);

        extraInfo = struct('extraInfo', struct('nestedExtraInfo', 'something extra'));
        createJson(cfg, extraInfo);

        createTsvWithContent(cfg);

        %% beh data and fancy suffixes
        clear cfg;

        cfg = baseCfg(iSub);

        cfg.testingDevice = 'pc';

        cfg.task.name = 'easy target practice';

        cfg = createFilename(cfg);

        extraInfo = struct('extraInfo', struct('nestedExtraInfo', 'something extra'));
        createJson(cfg, extraInfo);

        createTsvWithContent(cfg);

    end

    %% add dummy data
    subjectsLabel = {'001', '002'};

    for iSub = 1:numel(subjectsLabel)

        subjectDir = fullfile(cfg.dir.output, 'source', ['sub-' subjectsLabel{iSub}], 'ses-001');
        funcDir = fullfile(subjectDir, 'func');

        basename = ['sub-' subjectsLabel{iSub} '_ses-001'];

        boldFilename = [basename '_task-testtask_run-001_date-' cfg.fileName.date '_bold.nii.gz'];

        copyfile(fullfile(templateFolder, 'dummyData.nii.gz'), ...
                 fullfile(funcDir, boldFilename));

        boldFilename = [basename '_task-rest',  ...
                        '_run-001_echo-1_date-' cfg.fileName.date '_bold.nii.gz'];

        copyfile( ...
                 fullfile(templateFolder, 'dummyData.nii.gz'), ...
                 fullfile(funcDir, boldFilename));

        eegDir = fullfile(subjectDir, 'eeg');
        megDir = fullfile(subjectDir, 'meg');
        ieegDir = fullfile(subjectDir, 'ieeg');
        behDir = fullfile(subjectDir, 'beh');

        eegFilename = [basename '_task-targetPractice_run-001_date-', ...
                       cfg.fileName.date '_eeg.edf'];
        megFilename = [basename '_task-magneticTargetPractice_run-001_date-', ...
                       cfg.fileName.date '_meg.fif'];
        ieegFilename = [basename '_task-implantedTargetPractice_run-001_date-', ...
                        cfg.fileName.date '_ieeg.edf'];
        behFilename = [basename '_task-easyTargetPractice_run-001_date-', ...
                       cfg.fileName.date '_beh.tsv'];

        copyfile(fullfile(templateFolder, 'dummyData.nii.gz'), ...
                 fullfile(eegDir, eegFilename));

        copyfile(fullfile(templateFolder, 'dummyData.nii.gz'), ...
                 fullfile(megDir, megFilename));

        copyfile(fullfile(templateFolder, 'dummyData.nii.gz'), ...
                 fullfile(ieegDir, ieegFilename));

        copyfile(fullfile(templateFolder, 'dummyData.nii.gz'), ...
                 fullfile(behDir, behFilename));

    end

    %% actually do the conversion of the source data thus created
    clear;

    cfg.dir.output = outputDir();
    convertSourceToRaw(cfg);

end

function createTsvWithContent(cfg)

    logFile.extraColumns.Speed.length = 1;
    logFile.extraColumns.LHL24.length = 3;
    logFile.extraColumns.is_Fixation.length = 1;

    logFile = saveEventsFile('init', cfg, logFile);

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

    createJson(cfg);

    % add dummy stim data
    SamplingFrequency = 100;

    stimLogFile.extraColumns.Speed.length = 1;
    stimLogFile.extraColumns.LHL24.length = 1;
    stimLogFile.extraColumns.is_Fixation.length = 1;

    stimLogFile.SamplingFrequency = SamplingFrequency;
    stimLogFile.StartTime = 0;

    stimLogFile = saveEventsFile('init_stim', cfg, stimLogFile);
    stimLogFile = saveEventsFile('open', cfg, stimLogFile);
    for i = 1:100
        stimLogFile(i, 1).onset = SamplingFrequency * i;
        stimLogFile(i, 1).trial_type = 'test';
        stimLogFile(i, 1).duration = 1;
        stimLogFile(i, 1).Speed = rand(1);
        stimLogFile(i, 1).is_Fixation = rand > 0.5;
        stimLogFile(i, 1).LHL24 = randn();
    end
    saveEventsFile('save', cfg, stimLogFile);
    saveEventsFile('close', cfg, stimLogFile);

    createJson(cfg);

end

function value = outputDir()
    value = fullfile(fileparts(mfilename('fullpath')), 'output');
end

function value = baseCfg(subjectNb)
    value.dir.output = outputDir;
    value.StimulusPresentation = stimulusPresentation();
    value.subject.subjectNb = subjectNb;
    value.subject.runNb = 1;
    value.task.instructions = 'do this';
    value.verbosity = 0;
end

function value = stimulusPresentation()

    value.OperatingSystem = computer();
    value.SoftwareRRID = 'SCR_002881';
    value.Code = 'https://github.com/cpp-lln-lab/TODO.git';
    value.SoftwareVersion = sprintf('%i.%i.%i', 3, 0, 18);

    runsOn = 'Matlab - ';
    runsOn = [runsOn version()];
    value.SoftwareName = ['Psychtoolbox on ' runsOn];

end
