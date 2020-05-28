function [expParameters, cfg] = checkCFG(cfg, expParameters)
% check that we have all the fields that we need in the experiment
% parameters

if ~isfield(expParameters, 'verbose') || isempty(expParameters.verbose)
    expParameters.verbose = 0;
end

if ~isfield(expParameters, 'outputDir')
    expParameters.outputDir = fullfile(...
        fileparts(mfilename('fullpath')), ...
        '..', ...
        'output');
end

% set empty values for a series of field if they have not been specified
fields2Check = { ...
    'ce', ...
    'dir', ...  % For BIDS file naming: phase encoding direction of acquisition for fMRI
    'rec', ...  % For BIDS file naming: reconstruction of fMRI images
    'echo', ... % For BIDS file naming: echo fMRI images
    'acq'       % For BIDS file naming: acquisition of fMRI images
    };

fields2CheckFalse = { ...
    'eyeTracker'
    }

for iField = 1:numel(fields2Check)
    if ~isfield(expParameters, fields2Check{iField})
        expParameters = setfield(expParameters, fields2Check{iField}, []); %#ok<SFLD>
    end
end

for iField = 1:numel(fields2CheckFalse)
    if ~isfield(cfg, fields2CheckFalse{iField})
        cfg = setfield(cfg, fields2CheckFalse{iField}, false); %#ok<SFLD>
    end
end


end
