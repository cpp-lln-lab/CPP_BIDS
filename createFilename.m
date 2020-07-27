function cfg = createFilename(cfg)
    % create the BIDS compliant directories and filenames for the behavioral output
    % for this subject / session / run using the information from cfg and expParameters.
    % Will also create the right filename for the eyetracking data file.
    %
    % For the moment the date of acquisition is appended to the filename
    %
    % can work for behavioral experiment if cfg.device is set to 'PC'
    % can work for fMRI experiment if cfg.device is set to 'scanner'
    % can work for simple eyetracking data if cfg.eyeTracker is set to 1
    %
    %
    % See test_createFilename in the test folder for more details on how to use it.

    zeroPadding = 3;
    pattern = ['%0' num2str(zeroPadding) '.0f'];
    cfg.pattern = pattern;

    dateFormat = 'yyyymmddHHMM';
    cfg.date = datestr(now, dateFormat);

    cfg = checkCFG(cfg);

    if ~isfield(cfg, 'task')
        error('createFilename: missing a task name. i.e cfg.task');
    end

    cfg = getModality(cfg);

    cfg = createDirectories(cfg);

    cfg = setSuffixes(cfg);

    cfg = setFilenames(cfg);

    talkToMe(cfg);
    
    cfg = orderfields(cfg);
    cfg = orderfields(cfg);

end

function cfg = getModality(cfg)

    switch lower(cfg.testingDevice)
        case 'pc'
            modality = 'beh';
        case 'mri'
            modality = 'func';
        case 'eeg'
            modality = 'eeg';
        case 'ieeg'
            modality = 'ieeg';
        case 'meg'
            modality = 'meg';
        otherwise
            modality = 'beh';
    end

    cfg.modality = modality;

end

function [subjectGrp, subjectNb, sessionNb, modality, taskName] = extractInput(cfg)

    subjectGrp = cfg.subjectGrp;
    subjectNb = cfg.subjectNb;
    sessionNb = cfg.sessionNb;
    modality = cfg.modality;
    taskName = cfg.task;

    if isempty(sessionNb)
        sessionNb = 1;
    end

end

function cfg = createDirectories(cfg)

    [subjectGrp, subjectNb, sessionNb, modality] = extractInput(cfg);

    pattern = cfg.pattern;

    % output dir
    cfg.subjectOutputDir = fullfile ( ...
        cfg.outputDir, ...
        'source', ...
        ['sub-' subjectGrp, sprintf(pattern, subjectNb)], ...
        ['ses-', sprintf(pattern, sessionNb)]);

    [~, ~, ~] = mkdir(cfg.outputDir);
    [~, ~, ~] = mkdir(cfg.subjectOutputDir);
    [~, ~, ~] = mkdir(fullfile(cfg.subjectOutputDir, modality));

    if cfg.eyeTracker
        [~, ~, ~] = mkdir(fullfile(cfg.subjectOutputDir, 'eyetracker'));
    end

end

function cfg = setSuffixes(cfg)

    cfg.runSuffix = ['_run-' sprintf(cfg.pattern, cfg.runNb)];

    % set values for the suffixes for the different fields in the BIDS name
    fields2Check = { ...
        'ce', ...
        'dir', ...  % For BIDS file naming: phase encoding direction of acquisition for fMRI
        'rec', ...  % For BIDS file naming: reconstruction of fMRI images
        'echo', ... % For BIDS file naming: echo fMRI images
        'acq'       % For BIDS file naming: acquisition of fMRI images
        };

    for iField = 1:numel(fields2Check)
        if isempty (cfg.MRI.(fields2Check{iField})) %#ok<*GFLD>
            cfg.MRI.([fields2Check{iField} 'Suffix']) = ''; %#ok<*SFLD>
        else
            cfg.MRI.([fields2Check{iField} 'Suffix']) = ...
                ['_' fields2Check{iField} '-' getfield(cfg.MRI, fields2Check{iField})];
        end
    end

end

function cfg = setFilenames(cfg)

    [subjectGrp, subjectNb, sessionNb, modality, taskName] = extractInput(cfg);

    runSuffix = cfg.runSuffix;
    pattern = cfg.pattern;
    acqSuffix = cfg.MRI.acqSuffix ;
    ceSuffix = cfg.MRI.ceSuffix ;
    dirSuffix = cfg.MRI.dirSuffix ;
    recSuffix = cfg.MRI.recSuffix ;
    echoSuffix = cfg.MRI.echoSuffix;

    cfg.datasetDescription.filename = fullfile ( ...
        cfg.outputDir, ...
        'dataset_description.json');

    % create base filename
    fileNameBase = ...
        ['sub-', subjectGrp, sprintf(pattern, subjectNb), ...
        '_ses-', sprintf(pattern, sessionNb), ...
        '_task-', taskName];
    cfg.fileName.base = fileNameBase;

    switch modality

        case 'func'

            cfg.fileName.events = ...
                [fileNameBase, ...
                acqSuffix, ceSuffix, ...
                dirSuffix, recSuffix, ...
                runSuffix, echoSuffix, ...
                '_events_date-' cfg.date '.tsv'];

        otherwise

            cfg.fileName.events = ...
                [fileNameBase, runSuffix, '_events_date-' cfg.date '.tsv'];

    end

    cfg.fileName.stim = strrep(cfg.fileName.events, 'events', 'stim');

    if cfg.eyeTracker
        cfg.fileName.eyetracker = ...
            [fileNameBase, acqSuffix, ...
            runSuffix, '_eyetrack_date-' cfg.date '.edf'];

    end

end

function talkToMe(cfg)

    fprintf(1, '\nData will be saved in this directory:\n\t%s\n', ...
        fullfile(cfg.subjectOutputDir, cfg.modality));

    fprintf(1, '\nData will be saved in this file:\n\t%s\n', ...
        cfg.fileName.events);

    if cfg.eyeTracker

        fprintf(1, '\nEyetracking data will be saved in this directory:\n\t%s\n', ...
            fullfile(cfg.subjectOutputDir, 'eyetracker'));

        fprintf(1, '\nEyetracking data will be saved in this file:\n\t%s\n', ...
            cfg.fileName.eyetracker);

    end

end
