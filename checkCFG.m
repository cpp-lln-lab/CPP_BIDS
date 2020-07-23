function [cfg, expParameters] = checkCFG(cfg, expParameters)
    % check that we have all the fields that we need in the experiment parameters

    checkCppBidsDependencies();

    %% set the expParameters defaults

    fieldsToSet.verbose = 0;
    fieldsToSet.outputDir = fullfile( ...
        fileparts(mfilename('fullpath')), ...
        '..', ...
        'output');

    fieldsToSet = mriDefaults(fieldsToSet);

    fieldsToSet.subjectGrp = ''; % in case no group was provided
    fieldsToSet.sessionNb = 1; % in case no session was provided
    fieldsToSet.askGrpSess = [true true];

    expParameters = setDefaultFields(expParameters, fieldsToSet);

    %% BIDS
    clear fieldsToSet;
    fieldsToSet = struct();
    fieldsToSet = datasetDescriptionDefaults(fieldsToSet);

    expParameters.bids.datasetDescription = ...
        setDefaultFields(expParameters.bids.datasetDescription, fieldsToSet);

    clear fieldsToSet;
    fieldsToSet = struct();
    fieldsToSet = mriJsonDefaults(fieldsToSet);
    if isfield(expParameters, 'task')
        fieldsToSet.TaskName = expParameters.task;
    end

    expParameters.bids.MRI = struct();
    expParameters.bids.MRI = ...
        setDefaultFields(expParameters.bids.MRI, fieldsToSet);

    % sort fields alphabetically
    expParameters = orderfields(expParameters);

    %% set the cfg defaults

    clear fieldsToSet;
    fieldsToSet.testingDevice = 'pc';
    fieldsToSet.eyeTracker = false;

    cfg = setDefaultFields(cfg, fieldsToSet);

    % sort fields alphabetically
    cfg = orderfields(cfg);

end

function fieldsToSet = mriDefaults(fieldsToSet)

    % for file naming
    fieldsToSet.MRI.ce = [];
    fieldsToSet.MRI.dir = []; % phase encoding direction of acquisition for fMRI
    fieldsToSet.MRI.rec = []; % reconstruction of fMRI images
    fieldsToSet.MRI.echo = []; % echo fMRI images
    fieldsToSet.MRI.acq = []; % acquisition of fMRI images

end

function fieldsToSet = datasetDescriptionDefaults(fieldsToSet)
    % required
    fieldsToSet.Name = '';
    fieldsToSet.BIDSVersion = '';
    % recommended
    fieldsToSet.License = '';
    fieldsToSet.Authors = {''};
    fieldsToSet.Acknowledgements = '';
    fieldsToSet.HowToAcknowledge = '';
    fieldsToSet.Funding = {''};
    fieldsToSet.ReferencesAndLinks = {''};
    fieldsToSet.DatasetDOI = '';
end

function fieldsToSet = mriJsonDefaults(fieldsToSet)

    % for json for funcfional data
    % required
    fieldsToSet.RepetitionTime = [];
    fieldsToSet.SliceTiming = [];
    fieldsToSet.TaskName = [];
    %     fieldsToSet.PhaseEncodingDirection = [];
    %     fieldsToSet.EffectiveEchoSpacing = [];
    %     fieldsToSet.EchoTime = [];
    % recommended
    fieldsToSet.Instructions = [];
    fieldsToSet.TaskDescription = [];

end
