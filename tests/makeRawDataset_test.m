function test_makeRawDataset()

    fprintf('\n\n--------------------------------------------------------------------\n\n');

    clear;

    outputDir = fullfile(fileparts(mfilename('fullpath')), '..', 'output');

    if isdir(outputDir)
        rmdir(outputDir, 's');
    end

    %% set up

    %%% set up

    expParameters.subjectNb = 1;
    expParameters.runNb = 1;
    expParameters.task = 'testtask';
    expParameters.outputDir = outputDir;

    expParameters.bids.datasetDescription.Name = 'dummy';
    expParameters.bids.datasetDescription.BIDSVersion = '1.0.0';
    expParameters.bids.datasetDescription.Authors = {'Jane Doe', 'John Doe'};

    expParameters.bids.MRI.RepetitionTime = 1.56;

    cfg.testingDevice = 'mri';

    logFile.extraColumns.Speed.length = 1;
    logFile.extraColumns.LHL24.length = 3;
    logFile.extraColumns.is_Fixation.length = 1;

    %%% do stuff

    [cfg, expParameters] = createFilename(cfg, expParameters); %#ok<*ASGLU>

    % create the events file and header
    logFile = saveEventsFile('open', expParameters, logFile);

    createDataDictionary(expParameters, logFile);
    createBoldJson(expParameters);
    createDatasetDescription(expParameters);

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

    saveEventsFile('save', expParameters, logFile);

    % close the file
    saveEventsFile('close', expParameters, logFile);

    % add dummy functional data
    funcDir = fullfile(expParameters.outputDir, 'source', 'sub-001', 'ses-001', 'func');
    boldFilename = 'sub-001_ses-001_task-testtask_run-001_bold.nii.gz';
    copyfile( ...
        fullfile('..', 'dummyData', 'dummyData.nii.gz'), ...
        fullfile(funcDir, boldFilename));

    %%

    convertSourceToRaw(expParameters);
end
