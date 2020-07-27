function testmanual_makeRawDataset()

    fprintf('\n\n--------------------------------------------------------------------\n\n');

    clear;

    outputDir = fullfile(fileparts(mfilename('fullpath')), '..', 'output');

    if isdir(outputDir)
        rmdir(outputDir, 's');
    end

    %% set up

    %%% set up

    cfg.subjectNb = 1;
    cfg.runNb = 1;
    cfg.task = 'testtask';
    cfg.outputDir = outputDir;

    cfg.bids.datasetDescription.Name = 'dummy';
    cfg.bids.datasetDescription.BIDSVersion = '1.0.0';
    cfg.bids.datasetDescription.Authors = {'Jane Doe', 'John Doe'};

    cfg.bids.MRI.RepetitionTime = 1.56;

    cfg.testingDevice = 'mri';

    logFile.extraColumns.Speed.length = 1;
    logFile.extraColumns.LHL24.length = 3;
    logFile.extraColumns.is_Fixation.length = 1;

    %%% do stuff

    cfg = createFilename(cfg); 

    % create the events file and header
    logFile = saveEventsFile('open', cfg, logFile);

    createBoldJson(cfg);
    createDatasetDescription(cfg);

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

    % add dummy functional data
    funcDir = fullfile(cfg.outputDir, 'source', 'sub-001', 'ses-001', 'func');
    boldFilename = 'sub-001_ses-001_task-testtask_run-001_bold.nii.gz';
    copyfile( ...
        fullfile('..', 'dummyData', 'dummyData.nii.gz'), ...
        fullfile(funcDir, boldFilename));

    %%

    convertSourceToRaw(cfg);
end
