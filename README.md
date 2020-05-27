# CPP_BIDS
<!-- ALL-CONTRIBUTORS-BADGE:START - Do not remove or modify this section -->
[![All Contributors](https://img.shields.io/badge/all_contributors-1-orange.svg?style=flat-square)](#contributors-)
<!-- ALL-CONTRIBUTORS-BADGE:END -->

A set of function for matlab and octave to create [BIDS-compatible](https://bids-specification.readthedocs.io/en/stable/) folder structure and filenames for the output of behavioral, EEG, fMRI, eyetracking studies.

Here are the naming templates used.

-   BOLD

`sub-<label>[_ses-<label>]_task-<label>[_acq-<label>][_ce-<label>][_dir-<label>][_rec-<label>][_run-<index>][_echo-<index>]_<contrast_label>.nii[.gz]`

-   iEEG

`sub-<label>[_ses-<label>]_task-<task_label>[_run-<index>]_ieeg.json`

-   EEG

`sub-<label>[_ses-<label>]_task-<label>[_run-<index>]_eeg.<manufacturer_specific_extension>`

-   Eyetracker

`sub-<participant_label>[_ses-<label>][_acq-<label>]_task-<task_label>_eyetrack.<manufacturer_specific_extension>`


## Contributing

Feel free to open issues to report a bug and ask for improvements.

### Guidestyle

-   We use camelCase.
-   We keep the McCabe complexity as reported by the [check_my_code function](https://github.com/Remi-Gau/matlab_checkcode) below 15.

## How to install

### Use the matlab package manager

This repository can be added as a dependencies by listing it in a [mpm-requirements.txt file](.mpm-requirements.txt)
as follows:

```
CPP_BIDS -u https://github.com/cpp-lln-lab/CPP_BIDS.git
```

You can then use the [matlab package manager](https://github.com/mobeets/mpm), to simply download the appropriate version of those dependencies and add them to your path by running a `getDependencies` function like the one below where you just need to replace `YOUR_EXPERIMENT_NAME` by the name of your experiment.


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

## Functions descriptions

### userInputs

Get subject, run and session number and make sure they are positive integer values.


### createFilename

Create the BIDS compliant directories  and filenames (but not the files) for the behavioral output for this subject /
session / run.

Will also create the right filename for the eye-tracking data file.

For the moment the date of acquisition is appended to the filename
-   can work for behavioral experiment if cfg.device is set to 'PC'
-   can work for fMRI experiment if cfg.device is set to 'scanner'
-   can work for simple eyetracking data if cfg.eyeTracker is set to 1

### saveEventsFile

Function to save output files for events that will be BIDS compliant.


### checkCFG
Check that we have all the fields that we need in the experiment parameters.

## Contributors ✨

Thanks goes to these wonderful people ([emoji key](https://allcontributors.org/docs/en/emoji-key)):

<!-- ALL-CONTRIBUTORS-LIST:START - Do not remove or modify this section -->
<!-- prettier-ignore-start -->
<!-- markdownlint-disable -->
<table>
  <tr>
    <td align="center"><a href="https://github.com/CerenB"><img src="https://avatars1.githubusercontent.com/u/10451654?v=4" width="100px;" alt=""/><br /><sub><b>CerenB</b></sub></a><br /><a href="https://github.com/cpp-lln-lab/CPP_BIDS/commits?author=CerenB" title="Code">💻</a> <a href="#design-CerenB" title="Design">🎨</a> <a href="https://github.com/cpp-lln-lab/CPP_BIDS/commits?author=CerenB" title="Documentation">📖</a></td>
  </tr>
</table>

<!-- markdownlint-enable -->
<!-- prettier-ignore-end -->
<!-- ALL-CONTRIBUTORS-LIST:END -->

This project follows the [all-contributors](https://github.com/all-contributors/all-contributors) specification. Contributions of any kind welcome!