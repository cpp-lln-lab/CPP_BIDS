[![Build Status](https://travis-ci.com/cpp-lln-lab/CPP_BIDS.svg?branch=master)](https://travis-ci.com/cpp-lln-lab/CPP_BIDS)

<!-- ALL-CONTRIBUTORS-BADGE:START - Do not remove or modify this section -->
[![All Contributors](https://img.shields.io/badge/all_contributors-3-orange.svg?style=flat-square)](#contributors-)
<!-- ALL-CONTRIBUTORS-BADGE:END -->

# CPP_BIDS

<!-- TOC -->

- [CPP_BIDS](#cpp_bids)
  - [Usage](#usage)
  - [Functions descriptions](#functions-descriptions)
    - [userInputs](#userinputs)
    - [createFilename](#createfilename)
    - [saveEventsFile](#saveeventsfile)
    - [checkCFG](#checkcfg)
  - [How to install](#how-to-install)
    - [Use the matlab package manager](#use-the-matlab-package-manager)
  - [Contributing](#contributing)
    - [Guidestyle](#guidestyle)
    - [BIDS naming convention](#bids-naming-convention)

<!-- /TOC -->

A set of function for matlab and octave to create [BIDS-compatible](https://bids-specification.readthedocs.io/en/stable/) folder structure and filenames for the output of behavioral, EEG, fMRI, eyetracking studies.

## Usage

```matlab

% define the folder where the data will be saved
expParameters.outputDir = fullfile(pwd, '..', 'output');

% define the name of the task
expParameters.task = 'testtask';

% can use the userInputs function to collect subject info
% expParameters = userInputs;

% or declare it directly
expParameters.subjectGrp = '';
expParameters.subjectNb = 1;
expParameters.sessionNb = 1;
expParameters.runNb = 1;

% Use the verbose switch to know where your data is being saved
expParameters.verbose = true;

% In case you are using en eyetracker
cfg.eyeTracker = false;

% if the device is set to 'PC' then the data will be saved
% in the `beh` folder
cfg.device = 'PC';

% if the device is set to 'scanner' then the data will be saved
% in the `func` folder
% cfg.device = 'scanner';

% check that cfg and exparameters have all the necessary information
% and fill in any missing field
expParameters = checkCFG(cfg, expParameters);

% create the filenames
expParameters = createFilename(cfg, expParameters);

% initialize the events files with the typical BIDS
% columns (onsets, duration, trial_type)
% and add some more in this case (Speed and is_Fixation)
logFile = saveEventsFile('open', expParameters, [], 'Speed', 'is_Fixation');

% create the information about 2 events that we want to save
logFile(1,1).onset = 2;
logFile(1,1).trial_type = 'motion_up';
logFile(1,1).duration = 1;
logFile(1,1).speed = 2;
logFile(1,1).is_fixation = true;

logFile(2,1).onset = 3;
logFile(2,1).trial_type = 'static';
logFile(2,1).duration = 4;
logFile(2,1).is_fixation = 3;

% add those 2 events to the events.tsv file
saveEventsFile('save', expParameters, logFile, 'speed', 'is_fixation');

% close the file
saveEventsFile('close', expParameters, logFile);

```

## Functions descriptions

### userInputs

Get subject, run and session number and make sure they are positive integer values.

### createFilename

Create the BIDS compliant directories  and filenames (but not the files) for the behavioral
output for this subject / session / run.

Will also create the right filename for the eye-tracking data file.

For the moment the date of acquisition is appended to the filename
-   can work for behavioral experiment if cfg.device is set to 'PC'
-   can work for fMRI experiment if cfg.device is set to 'scanner'
-   can work for simple eyetracking data if cfg.eyeTracker is set to 1

### saveEventsFile

Function to save output files for events that will be BIDS compliant.

### checkCFG
Check that we have all the fields that we need in the experiment parameters.

## How to install

### Use the matlab package manager

This repository can be added as a dependencies by listing it in a
[mpm-requirements.txt file](.mpm-requirements.txt) as follows:

```
CPP_BIDS -u https://github.com/cpp-lln-lab/CPP_BIDS.git
```

You can then use the [matlab package manager](https://github.com/mobeets/mpm), to simply download
the appropriate version of those dependencies and add them to your path by running a
`getDependencies` function like the one below where you just need to replace
`YOUR_EXPERIMENT_NAME` by the name of your experiment.

```matlab
function getDependencies(action)
% Will install on your computer the matlab dependencies specified in the mpm-requirements.txt
%  and add them to the matlab path. The path is never saved so you need to run getDependencies() when
%  you start matlab.
%
% getDependencies('update') will force the update and overwrite previous version of the dependencies.
%
% getDependencies() If you only already have the appropriate version but just want to add them to the matlab path.

experimentName = YOUR_EXPERIMENT_NAME;

if nargin<1
    action = '';
end

switch action
    case 'update'
        % install dependencies
        mpm install -i mpm-requirements.txt -f -c YOUR_EXPERIMENT_NAME
end

% adds them to the path
mpm_folder = fileparts(which('mpm'));
addpath(genpath(fullfile(mpm_folder, 'mpm-packages', 'mpm-collections', experimentName)));

end
```

## Contributing

Feel free to open issues to report a bug and ask for improvements.

### Guidestyle

-   We use camelCase.
-   We keep the McCabe complexity as reported by the [check_my_code function](https://github.com/Remi-Gau/matlab_checkcode) below 15.

### BIDS naming convention

Here are the naming templates used.

-   BOLD

`sub-<label>[_ses-<label>]_task-<label>[_acq-<label>][_ce-<label>][_dir-<label>][_rec-<label>][_run-<index>][_echo-<index>]_<contrast_label>.nii[.gz]`

-   iEEG

`sub-<label>[_ses-<label>]_task-<task_label>[_run-<index>]_ieeg.json`

-   EEG

`sub-<label>[_ses-<label>]_task-<label>[_run-<index>]_eeg.<manufacturer_specific_extension>`

-   Eyetracker

`sub-<participant_label>[_ses-<label>][_acq-<label>]_task-<task_label>_eyetrack.<manufacturer_specific_extension>`
