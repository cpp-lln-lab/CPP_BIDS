function [cfg, expParameters] = createFilename(cfg, expParameters)
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
    expParameters.pattern = pattern;

    dateFormat = 'yyyymmdd_HHMM';
    expParameters.date = datestr(now, dateFormat);

    [cfg, expParameters] = checkCFG(cfg, expParameters);

    if ~isfield(expParameters, 'task')
        error('createFilename: missing a task name. i.e expParameters.task');
    end

    expParameters = getModality(cfg, expParameters);

    expParameters = createDirectories(cfg, expParameters);

    expParameters = setSuffixes(expParameters);

    expParameters = setFilenames(cfg, expParameters);

    talkToMe(cfg, expParameters);

end

function expParameters = getModality(cfg, expParameters)
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

    expParameters.modality = modality;
end

function [subjectGrp, subjectNb, sessionNb, modality] = extractInput(expParameters)

    subjectGrp = expParameters.subjectGrp;
    subjectNb = expParameters.subjectNb;
    sessionNb = expParameters.sessionNb;
    modality = expParameters.modality;

    if isempty(sessionNb)
        sessionNb = 1;
    end

end

function expParameters = createDirectories(cfg, expParameters)

    [subjectGrp, subjectNb, sessionNb, modality] = extractInput(expParameters);

    pattern = expParameters.pattern;

    % output dir
    expParameters.subjectOutputDir = fullfile ( ...
        expParameters.outputDir, ...
        'source', ...
        ['sub-' subjectGrp, sprintf(pattern, subjectNb)], ...
        ['ses-', sprintf(pattern, sessionNb)]);

    [~, ~, ~] = mkdir(expParameters.outputDir);
    [~, ~, ~] = mkdir(expParameters.subjectOutputDir);
    [~, ~, ~] = mkdir(fullfile(expParameters.subjectOutputDir, modality));

    if cfg.eyeTracker
        [~, ~, ~] = mkdir(fullfile(expParameters.subjectOutputDir, 'eyetracker'));
    end

end

function expParameters = setSuffixes(expParameters)

    expParameters.runSuffix = ['_run-' sprintf(expParameters.pattern, expParameters.runNb)];

    % set values for the suffixes for the different fields in the BIDS name
    fields2Check = { ...
        'ce', ...
        'dir', ...  % For BIDS file naming: phase encoding direction of acquisition for fMRI
        'rec', ...  % For BIDS file naming: reconstruction of fMRI images
        'echo', ... % For BIDS file naming: echo fMRI images
        'acq'       % For BIDS file naming: acquisition of fMRI images
        };

    for iField = 1:numel(fields2Check)
        if isempty (getfield(expParameters.MRI, fields2Check{iField})) %#ok<*GFLD>
            expParameters.MRI = setfield(expParameters.MRI, [fields2Check{iField} 'Suffix'], ...
                ''); %#ok<*SFLD>
        else
            expParameters.MRI = setfield(expParameters.MRI, [fields2Check{iField} 'Suffix'], ...
                ['_' fields2Check{iField} '-' getfield(expParameters.MRI, fields2Check{iField})]);
        end
    end

end

function expParameters = setFilenames(cfg, expParameters)

    [subjectGrp, subjectNb, sessionNb, modality] = extractInput(expParameters);

    runSuffix = expParameters.runSuffix;
    pattern = expParameters.pattern;
    acqSuffix = expParameters.MRI.acqSuffix ;
    ceSuffix = expParameters.MRI.ceSuffix ;
    dirSuffix = expParameters.MRI.dirSuffix ;
    recSuffix = expParameters.MRI.recSuffix ;
    echoSuffix = expParameters.MRI.echoSuffix;

    expParameters.datasetDescription.filename = fullfile ( ...
        expParameters.outputDir, ...
        'dataset_description.json');

    % create base filename
    fileNameBase = ...
        ['sub-', subjectGrp, sprintf(pattern, subjectNb), ...
        '_ses-', sprintf(pattern, sessionNb), ...
        '_task-', expParameters.task];
    expParameters.fileName.base = fileNameBase;

    switch modality

        case 'func'

            expParameters.fileName.events = ...
                [fileNameBase, ...
                acqSuffix, ceSuffix, ...
                dirSuffix, recSuffix, ...
                runSuffix, echoSuffix, ...
                '_events_date-' expParameters.date '.tsv'];

        otherwise

            expParameters.fileName.events = ...
                [fileNameBase, runSuffix, '_events_date-' expParameters.date '.tsv'];

    end

    expParameters.fileName.stim = strrep(expParameters.fileName.events, 'events', 'stim');

    if cfg.eyeTracker
        expParameters.fileName.eyetracker = ...
            [fileNameBase, acqSuffix, ...
            runSuffix, '_eyetrack_date-' expParameters.date '.edf'];

    end

end

function talkToMe(cfg, expParameters)

    fprintf(1, '\nData will be saved in this directory:\n\t%s\n', ...
        fullfile(expParameters.subjectOutputDir, expParameters.modality));

    fprintf(1, '\nData will be saved in this file:\n\t%s\n', ...
        expParameters.fileName.events);

    if cfg.eyeTracker

        fprintf(1, '\nEyetracking data will be saved in this directory:\n\t%s\n', ...
            fullfile(expParameters.subjectOutputDir, 'eyetracker'));

        fprintf(1, '\nEyetracking data will be saved in this file:\n\t%s\n', ...
            expParameters.fileName.eyetracker);

    end

end
