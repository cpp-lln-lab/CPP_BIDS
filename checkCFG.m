function [cfg, expParameters] = checkCFG(cfg, expParameters)
    % check that we have all the fields that we need in the experiment parameters

    checkCppBidsDependencies();

    %% set the expParameters defaults

    fieldsToSet.verbose = 0;
    fieldsToSet.outputDir = fullfile( ...
        fileparts(mfilename('fullpath')), ...
        '..', ...
        'output');

    fieldsToSet.subjectGrp = []; % in case no group was provided
    fieldsToSet.sessionNb = 1; % in case no session was provided
    fieldsToSet.askGrpSess = [true true];

    % BIDS
    fieldsToSet = datasetDescriptionDefaults(fieldsToSet);
    fieldsToSet = mriDefaults(fieldsToSet);

    if isfield(expParameters, 'task')
        fieldsToSet.bids.MRI.TaskName = expParameters.task;
    end

    expParameters = setDefaults(expParameters, fieldsToSet);

    %% set the cfg defaults

    clear fieldsToSet;
    fieldsToSet.testingDevice = 'pc';
    fieldsToSet.eyeTracker = false;

    cfg = setDefaults(cfg, fieldsToSet);

    % sort fields alphabetically
    cfg = orderfields(cfg);

end

function structure = setDefaults(structure, fieldsToSet)
    % loop through the defaults fiels to set and update if they don't exist

    names = fieldnames(fieldsToSet);

    for i = 1:numel(names)

        thisField = fieldsToSet.(names{i});

        structure = setFieldToIfNotPresent( ...
            structure, ...
            names{i}, ...
            thisField);

    end

end

function structure = setFieldToIfNotPresent(structure, fieldName, value)
    if ~isfield(structure, fieldName)
        structure.(fieldName) = value;
    end
end

function fieldsToSet = datasetDescriptionDefaults(fieldsToSet)
    % required
    fieldsToSet.bids.datasetDescription.json.Name = '';
    fieldsToSet.bids.datasetDescription.json.BIDSVersion = '';
    % recommended
    fieldsToSet.bids.datasetDescription.json.License = '';
    fieldsToSet.bids.datasetDescription.json.Authors = {''};
    fieldsToSet.bids.datasetDescription.json.Acknowledgements = '';
    fieldsToSet.bids.datasetDescription.json.HowToAcknowledge = '';
    fieldsToSet.bids.datasetDescription.json.Funding = {''};
    fieldsToSet.bids.datasetDescription.json.ReferencesAndLinks = {''};
    fieldsToSet.bids.datasetDescription.json.DatasetDOI = '';
end

function fieldsToSet = mriDefaults(fieldsToSet)

    % for json for funcfional data
    % required
    fieldsToSet.bids.MRI.RepetitionTime = [];
    fieldsToSet.bids.MRI.SliceTiming = '';
    fieldsToSet.bids.MRI.TaskName = '';
    fieldsToSet.bids.MRI.PhaseEncodingDirection = '';
    fieldsToSet.bids.MRI.EffectiveEchoSpacing = '';
    fieldsToSet.bids.MRI.EchoTime = '';
    % recommended
    fieldsToSet.bids.MRI.Instructions = '';
    fieldsToSet.bids.MRI.TaskDescription = '';

    % for file naming
    fieldsToSet.MRI.ce = [];
    fieldsToSet.MRI.dir = []; % phase encoding direction of acquisition for fMRI
    fieldsToSet.MRI.rec = []; % reconstruction of fMRI images
    fieldsToSet.MRI.echo = []; % echo fMRI images
    fieldsToSet.MRI.acq = []; % acquisition of fMRI images

end
