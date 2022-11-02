function cfg = createFilename(cfg)
    %
    % It creates the BIDS compliant directories and fileNames for the behavioral output
    % for this subject / session / run using the information from cfg.
    %
    % The folder tree will always include a session folder.
    %
    % Will also create the right fileName for the eyetracking data file.
    % For the moment the date of acquisition is appended to the fileName.
    %
    % USAGE::
    %
    %   [cfg] = createFilename(cfg)
    %
    % :param cfg: Configuration. See ``checkCFG()``.
    % :type cfg: structure
    %
    % :returns:
    %
    %           :cfg: (structure) Configuration update with the name of info about the
    %                 participants.
    %
    % The behavior of this function depends on:
    %
    %   - ``cfg.testingDevice``:
    %
    %       + set to ``pc`` (dummy try) or ``beh`` can work for behavioral experiment.
    %       + set on ``mri`` for fMRI experiment.
    %       + set on ``eeg`` or ``ieeg`` can work for electro encephalography or intracranial eeg
    %       + set on ``meg`` can work for magneto encephalography
    %
    %   - ``cfg.eyeTracker.do`` set to ``true``, can work for simple eyetracking data.
    %
    % See ``test_createFilename`` in the ``tests`` folder for more details on how to use it.
    %

    % (C) Copyright 2020 CPP_BIDS developers

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

    talkToMe(cfg, sprintf('\nData will be saved in this directory:\n\t%s\n', ...
                          pathToPrint(fullfile(cfg.dir.outputSubject, ...
                                               cfg.fileName.modality))));

    talkToMe(cfg, sprintf('\nData will be saved in this file:\n\t%s\n', ...
                          pathToPrint(cfg.fileName.events)));

    if cfg.eyeTracker.do

        talkToMe(cfg, sprintf('\nEyetracking data will be saved in this directory:\n\t%s\n', ...
                              pathToPrint(fullfile(cfg.dir.outputSubject, ...
                                                   'eyetracker'))));

        talkToMe(cfg, sprintf('\nEyetracking data will be saved in this file:\n\t%s\n', ...
                              pathToPrint(cfg.fileName.eyetracker)));

    end

    cfg = orderfields(cfg);
    cfg.fileName = orderfields(cfg.fileName);
    cfg.dir = orderfields(cfg.dir);

end

function cfg = getModality(cfg)

    switch lower(cfg.testingDevice)
        case {'pc', 'beh'}
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

end

function cfg = setSuffixes(cfg)

    cfg.filename.entities.run = sprintf(cfg.fileName.pattern, cfg.subject.runNb);

    %% MRI
    % set values for the suffixes for the different fields in the BIDS name
    fields2Check = {'acq', ...
                    'ce', ...
                    'echo', ...
                    'dir', ...
                    'rec', ...
                    'recording'};

    for iField = 1:numel(fields2Check)

        if isempty (cfg.suffix.(fields2Check{iField})) %#ok<*GFLD>

            cfg.filename.entities.(fields2Check{iField}) = ''; %#ok<*SFLD>

        else

            % upper camelCase and remove invalid characters
            thisField = getfield(cfg.suffix, fields2Check{iField});
            validFieldName = bids.internal.camel_case(thisField);

            cfg.filename.entities.(fields2Check{iField}) = validFieldName;

        end
    end

    cfg.filename.entities = orderfields(cfg.filename.entities);

end

function cfg = setFilenames(cfg)

    [subjectGrp, subjectNb, sessionNb, modality, taskName] = extractInput(cfg);

    pattern = cfg.fileName.pattern;

    cfg.fileName.datasetDescription = fullfile (cfg.dir.output, 'dataset_description.json');

    % create base fileName
    spec.entities = struct('sub', [subjectGrp, sprintf(pattern, subjectNb)]);
    spec.entities.ses = sprintf(pattern, sessionNb);
    spec.entities.task = taskName;

    bf = bids.File(spec);
    cfg.fileName.base = bf.filename;

    switch modality

        case 'func'

            spec.entities.acq = cfg.filename.entities.acq;
            spec.entities.ce = cfg.filename.entities.ce;
            spec.entities.dir = cfg.filename.entities.dir;
            spec.entities.rec = cfg.filename.entities.rec;
            spec.entities.run = cfg.filename.entities.run;
            spec.entities.echo = cfg.filename.entities.echo;

        case 'beh'

            spec.entities.acq = cfg.filename.entities.acq;
            spec.entities.run = cfg.filename.entities.run;

        otherwise

            spec.entities.run = cfg.filename.entities.run;

    end

    spec.ext = '.tsv';

    spec.suffix = 'events';
    bf = bids.File(addDate(spec, cfg.fileName.date));
    cfg.fileName.events = bf.filename;

    spec.entities.recording = cfg.filename.entities.recording;
    spec.suffix = 'stim';
    bf = bids.File(addDate(spec, cfg.fileName.date));
    cfg.fileName.stim = bf.filename;

    if cfg.eyeTracker.do
        spec.entities.recording = 'eyetracking';
        spec.suffix = 'physio';
        spec.ext = '.edf';
        bf = bids.File(addDate(spec, cfg.fileName.date));
        cfg.fileName.eyetracker = bf.filename;
    end

end

function spec = addDate(spec, thisDate)
    spec.entities.date = thisDate;
end
