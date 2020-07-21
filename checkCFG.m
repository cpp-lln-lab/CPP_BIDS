function [cfg, expParameters] = checkCFG(cfg, expParameters)
    % check that we have all the fields that we need in the experiment parameters

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

    % dataset description json
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

    % mri
    % for json
    fieldsToSet.MRI.repetitionTime = [];
    % for file naming
    fieldsToSet.MRI.ce = [];
    fieldsToSet.MRI.dir = []; % phase encoding direction of acquisition for fMRI
    fieldsToSet.MRI.rec = []; % reconstruction of fMRI images
    fieldsToSet.MRI.echo = []; % echo fMRI images
    fieldsToSet.MRI.acq = []; % acquisition of fMRI images

    expParameters = setDefaults(expParameters, fieldsToSet);

    %% set the cfg defaults

    clear fieldsToSet;
    fieldsToSet.testingDevice = 'pc';
    fieldsToSet.eyeTracker = false;

    cfg = setDefaults(cfg, fieldsToSet);

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
