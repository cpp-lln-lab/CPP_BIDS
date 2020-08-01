function cfg = createFilename(cfg)
    % create the BIDS compliant directories and fileNames for the behavioral output
    % for this subject / session / run using the information from cfg and expParameters.
    % Will also create the right fileName for the eyetracking data file.
    %
    % For the moment the date of acquisition is appended to the fileName
    %
    % can work for behavioral experiment if cfg.device is set to 'PC'
    % can work for fMRI experiment if cfg.device is set to 'scanner'
    % can work for simple eyetracking data if cfg.eyeTracker.do is set to 1
    %
    %
    % See test_createFilename in the test folder for more details on how to use it.
    
    cfg = checkCFG(cfg);
    
    cfg.fileName.pattern = ['%0' num2str(cfg.fileName.zeroPadding) '.0f'];
    cfg.fileName.date = datestr(now, cfg.fileName.dateFormat);
    
    if ~isfield(cfg, 'task')
        error('createFilename: missing a task name. i.e cfg.task.name');
    end
    
    cfg = getModality(cfg);
    
    cfg = createDirectories(cfg);
    
    cfg = setSuffixes(cfg);
    
    cfg = setFilenames(cfg);
    
    talkToMe(cfg);
    
    cfg = orderfields(cfg);
    cfg.fileName = orderfields(cfg.fileName);
    cfg.dir = orderfields(cfg.dir);
    
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
    
    cfg.fileName.modality = modality;
    
end

function [subjectGrp, subjectNb, sessionNb, modality, taskName] = extractInput(cfg)
    
    subjectGrp = cfg.subject.subjectGrp;
    subjectNb = cfg.subject.subjectNb;
    sessionNb = cfg.subject.sessionNb;
    modality = cfg.fileName.modality;
    taskName = cfg.fileName.task;
    
    if isempty(sessionNb)
        sessionNb = 1;
    end
    
end

function cfg = createDirectories(cfg)
    
    [subjectGrp, subjectNb, sessionNb, modality] = extractInput(cfg);
    
    pattern = cfg.fileName.pattern;
    
    % output dir
    cfg.dir.outputSubject = fullfile ( ...
        cfg.dir.output, ...
        'source', ...
        ['sub-' subjectGrp, sprintf(pattern, subjectNb)], ...
        ['ses-', sprintf(pattern, sessionNb)]);
    
    [~, ~, ~] = mkdir(cfg.dir.output);
    [~, ~, ~] = mkdir(cfg.dir.outputSubject);
    [~, ~, ~] = mkdir(fullfile(cfg.dir.outputSubject, modality));
    
    if cfg.eyeTracker.do
        [~, ~, ~] = mkdir(fullfile(cfg.dir.outputSubject, 'eyetracker'));
    end
    
end

function cfg = setSuffixes(cfg)
    
    cfg.fileName.suffix.run = ['_run-' sprintf(cfg.fileName.pattern, cfg.subject.runNb)];
    
    % set values for the suffixes for the different fields in the BIDS name
    fields2Check = { ...
        'contrastEnhancement', ...
        'phaseEncodingDirection', ...
        'reconstruction', ...
        'echo', ...
        'acquisition'
        };
    
    for iField = 1:numel(fields2Check)
        if isempty (cfg.mri.(fields2Check{iField})) %#ok<*GFLD>
            cfg.fileName.suffix.mri.(fields2Check{iField}) = ''; %#ok<*SFLD>
        else
            cfg.fileName.suffix.mri.(fields2Check{iField}) = ...
                ['_' fields2Check{iField} '-' getfield(cfg.mri, fields2Check{iField})];
        end
    end
    
    cfg.fileName.suffix = orderfields(cfg.fileName.suffix);
    
end

function cfg = setFilenames(cfg)
    
    [subjectGrp, subjectNb, sessionNb, modality, taskName] = extractInput(cfg);
    
    pattern = cfg.fileName.pattern;
    
    runSuffix = cfg.fileName.suffix.run;
    acqSuffix = cfg.fileName.suffix.mri.acquisition ;
    ceSuffix = cfg.fileName.suffix.mri.contrastEnhancement ;
    dirSuffix = cfg.fileName.suffix.mri.phaseEncodingDirection ;
    recSuffix = cfg.fileName.suffix.mri.reconstruction ;
    echoSuffix = cfg.fileName.suffix.mri.echo;
    
    thisDate = cfg.fileName.date;
    
    cfg.fileName.datasetDescription = fullfile ( ...
        cfg.dir.output, ...
        'dataset_description.json');
    
    % create base fileName
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
                '_events_date-' thisDate '.tsv'];
            
        otherwise
            
            cfg.fileName.events = ...
                [fileNameBase, runSuffix, '_events_date-' thisDate '.tsv'];
            
    end
    
    cfg.fileName.stim = strrep(cfg.fileName.events, 'events', 'stim');
    
    if cfg.eyeTracker.do
        cfg.fileName.eyetracker = ...
            [fileNameBase, acqSuffix, ...
            runSuffix, '_eyetrack_date-' thisDate '.edf'];
    end
    
end

function talkToMe(cfg)
    
    if cfg.verbose
        
        fprintf(1, '\nData will be saved in this directory:\n\t%s\n', ...
            fullfile(cfg.dir.outputSubject, cfg.fileName.modality));
        
        fprintf(1, '\nData will be saved in this file:\n\t%s\n', ...
            cfg.fileName.events);
        
        if cfg.eyeTracker.do
            
            fprintf(1, '\nEyetracking data will be saved in this directory:\n\t%s\n', ...
                fullfile(cfg.dir.outputSubject, 'eyetracker'));
            
            fprintf(1, '\nEyetracking data will be saved in this file:\n\t%s\n', ...
                cfg.fileName.eyetracker);
            
        end
        
    end
    
end
