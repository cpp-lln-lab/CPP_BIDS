function [cfg, expParameters] = checkCFG(cfg, expParameters)
    % check that we have all the fields that we need in the experiment parameters

    %% set the expParameters defaults
    
    fieldsToSet.verbose = 0;
    fieldsToSet.outputDir = fullfile( ...
            fileparts(mfilename('fullpath')), ...
            '..', ...
            'output');

    % For BIDS file naming
    fieldsToSet.ce = [];
    fieldsToSet.dir = []; % phase encoding direction of acquisition for fMRI
    fieldsToSet.rec = []; % reconstruction of fMRI images
    fieldsToSet.echo = []; % echo fMRI images
    fieldsToSet.acq = []; % acquisition of fMRI images
    
    fieldsToSet.subjectGrp = []; % in case no group was provided
    fieldsToSet.sessionNb = []; % in case no session was provided
    fieldsToSet.askGrpSess = [true true];
    
    % loop through the defaults and set them in expParameters if they don't exist
    names = fieldnames(fieldsToSet);
    
    for i = 1:numel(names)
        expParameters = setFieldToIfNotPresent(...
            expParameters, ...
            names{i}, ...
            getfield(fieldsToSet, names{i})); %#ok<GFLD>
    end
    
    %% set the cfg defaults
    
    clear fieldsToSet
    fieldsToSet.testingDevice = 'pc';
    fieldsToSet.eyeTracker = false;
    
    % loop through the defaults and set them in cfg if they don't exist
    names = fieldnames(fieldsToSet);
    
    for i = 1:numel(names)
        cfg = setFieldToIfNotPresent(...
            cfg, ...
            names{i}, ...
            getfield(fieldsToSet, names{i})); %#ok<GFLD>
    end

end


function struct = setFieldToIfNotPresent(struct, fieldName, value)
    if ~isfield(struct, fieldName)
        struct = setfield(struct, fieldName, value); %#ok<SFLD>
    end
end