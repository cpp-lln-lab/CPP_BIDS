function expParameters = createFilename(cfg,expParameters)
% create the BIDS compliant directories and filenames for the behavioral output for this subject /
% session / run using the information from cfg and expParameters.
% Will also create the right filename for the eyetracking data file.
%
% For the moment the date of acquisition is appended to the filename
%
% can work for behavioral experiment if cfg.device is set to 'PC'
% can work for fMRI experiment if cfg.device is set to 'scanner'
% can work for simple eyetracking data if cfg.eyeTracker is set to 1
%
% BOLD
% sub-<label>[_ses-<label>]_task-<label>[_acq-<label>][_ce-<label>][_dir-<label>][_rec-<label>][_run-<index>][_echo-<index>]_<contrast_label>.nii[.gz]
%
% iEEG
% sub-<label>[_ses-<label>]_task-<task_label>[_run-<index>]_ieeg.json
%
% EEG
% sub-<label>[_ses-<label>]_task-<label>[_run-<index>]_eeg.<manufacturer_specific_extension>
%
% EYETRACKER
% sub-<participant_label>[_ses-<label>][_acq-<label>]_task-<task_label>_eyetrack.<manufacturer_specific_extension>
%
%
% See test_createFilename in the test folder for more details on how to use it.

zeroPadding = 3;
pattern = ['%0' num2str(zeroPadding) '.0f'];

dateFormat = 'yyyymmdd_HHMM';

% Setting some defaults: no need to change things here
[expParameters, cfg] = checkCFG(cfg,expParameters);

% extract input
subjectGrp = expParameters.subjectGrp;
subjectNb = expParameters.subjectNb;
sessionNb = expParameters.sessionNb;
runNb = expParameters.runNb;

expParameters.date = datestr(now, dateFormat);

% output dir
expParameters.outputDir = fullfile (...
    expParameters.outputDir, ...
    'source', ...
    ['sub-' subjectGrp, sprintf(pattern, subjectNb)], ...
    ['ses-', sprintf(pattern, sessionNb)]);

% create base filename
expParameters.fileName.base = ...
    ['sub-', subjectGrp, sprintf(pattern, subjectNb), ...
    '_ses-', sprintf(pattern, sessionNb) , ...
    '_task-', expParameters.task];

runSuffix = ['_run-' sprintf(pattern, runNb)];


switch lower(cfg.device)
    case 'pc'
        modality = 'beh';
    case 'scanner'
        modality = 'func';
    otherwise
        modality = 'beh';
end

expParameters.modality = modality;


% set values for the suffixes for the different fields in the BIDS name
fields2Check = { ...
    'ce', ...
    'dir', ...  % For BIDS file naming: phase encoding direction of acquisition for fMRI
    'rec', ...  % For BIDS file naming: reconstruction of fMRI images
    'echo', ... % For BIDS file naming: echo fMRI images
    'acq'       % For BIDS file naming: acquisition of fMRI images
    };

for iField = 1:numel(fields2Check)
    if isempty (getfield(expParameters, fields2Check{iField}) ) %#ok<*GFLD>
        expParameters = setfield(expParameters, [fields2Check{iField} 'Suffix'], ...
            ''); %#ok<*SFLD>
    else
        expParameters = setfield(expParameters, [fields2Check{iField} 'Suffix'], ...
            ['_' fields2Check{iField} '-' getfield(expParameters, fields2Check{iField})]);
    end
end


%% create directories
[~, ~, ~] = mkdir(expParameters.outputDir);
[~, ~, ~] = mkdir(fullfile(expParameters.outputDir, modality));

if cfg.eyeTracker
    [~, ~, ~] = mkdir(fullfile(expParameters.outputDir, 'eyetracker'));
end


%% create filenames

switch modality
    
    case 'beh'
        
        expParameters.fileName.events = ...
            [expParameters.fileName.base, runSuffix, '_events_date-' expParameters.date '.tsv'];
        
        expParameters.fileName.stim = ...
            [expParameters.fileName.base, runSuffix, '_stim_date-' expParameters.date '.tsv'];
        
    case 'func'
        
        expParameters.fileName.events = ...
            [expParameters.fileName.base, ...
            expParameters.acqSuffix, expParameters.ceSuffix, ...
            expParameters.dirSuffix, expParameters.recSuffix, ...
            runSuffix, expParameters.echoSuffix, ...
            '_events_date-' expParameters.date '.tsv'];
        
        expParameters.fileName.stim = ...
            [expParameters.fileName.base, ...
            expParameters.acqSuffix, expParameters.ceSuffix, ...
            expParameters.dirSuffix, expParameters.recSuffix, ...
            runSuffix, expParameters.echoSuffix, ...
            '_stim_date-' expParameters.date '.tsv'];
        
end


if cfg.eyeTracker
    expParameters.fileName.eyetracker = ...
        [expParameters.fileName.base, expParameters.acqSuffix, ...
        runSuffix, '_eyetrack_date-' expParameters.date '.edf'];
    
end

if expParameters.verbose
    
    fprintf(1,'\nData will be saved in this directory:\n\t%s\n', ...
        fullfile(expParameters.outputDir, modality));
    
    fprintf(1,'\nData will be saved in this file:\n\t%s\n', ...
        expParameters.fileName.events);
    
    if cfg.eyeTracker
        
        fprintf(1,'\nEyetracking data will be saved in this directory:\n\t%s\n', ...
            fullfile(expParameters.outputDir, 'eyetracker'));
        
        fprintf(1,'\nEyetracking data will be saved in this file:\n\t%s\n', ...
            expParameters.fileName.eyetracker);
        
    end
    
end


end
