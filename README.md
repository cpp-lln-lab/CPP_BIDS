**BIDS validator and linter**

[![Build Status](https://travis-ci.com/cpp-lln-lab/CPP_BIDS.svg?branch=master)](https://travis-ci.com/cpp-lln-lab/CPP_BIDS)

**Unit tests**

[![](https://img.shields.io/badge/Octave-CI-blue?logo=Octave&logoColor=white)](https://github.com/cpp-lln-lab/CPP_BIDS/actions)
![](https://github.com/cpp-lln-lab/CPP_BIDS/workflows/CI/badge.svg) 

**Contributors**

[![All Contributors](https://img.shields.io/badge/all_contributors-3-orange.svg?style=flat-square)](#contributors-) 

---
 
# CPP_BIDS

<!-- TOC -->

- [CPP_BIDS](#cpp_bids)
  - [Output format](#output-format)
  - [Modality agnostic aspect](#modality-agnostic-aspect)
  - [Usage](#usage)
    - [To save events.tsv file](#to-save-eventstsv-file)
  - [Functions descriptions](#functions-descriptions)
    - [userInputs](#userinputs)
    - [createFilename](#createfilename)
    - [saveEventsFile](#saveeventsfile)
    - [checkCFG](#checkcfg)
  - [CFG content](#cfg-content)
  - [How to install](#how-to-install)
    - [Download with git](#download-with-git)
    - [Add as a submodule](#add-as-a-submodule)
      - [Example for submodule usage](#example-for-submodule-usage)
    - [Direct download](#direct-download)
  - [Contributing](#contributing)
    - [Guidestyle](#guidestyle)
    - [BIDS naming convention](#bids-naming-convention)
    - [Contributors ✨](#contributors-)

<!-- /TOC -->

A set of function for matlab and octave to create [BIDS-compatible](https://bids-specification.readthedocs.io/en/stable/) folder structure and filenames for the output of behavioral, EEG, fMRI, eyetracking studies.

## Output format

## Modality agnostic aspect

Subjects, session and run number labels will be numbers with zero padding up to 3 values (e.g subject 1 will become `sub-001`).

A session folder will ALWAYS be created even if not requested (default will be `ses-001`).

Task labels will be printed in camelCase in the filenames.

Time stamps are added directly in the filename by adding a suffix `_date-YYYYMMDDHHMM` which makes the file name non-BIDS compliant. This was added to prevent overwriting files in case a certain run needs to be done a second time because of a crash (Some of us are paranoid about keeping even cancelled runs during my experiments). This suffix should be removed to make the data set BIDS compliant. See `convertSourceToRaw.m` for more details.

For example:

```
sub-090/ses-003/sub-090_ses-003_task-auditoryTask_run-023_events_date-202007291536.tsv
```

## Usage

### To save events.tsv file

```matlab

% define the folder where the data will be saved
cfg.outputDir = fullfile(pwd, '..', 'output');

% define the name of the task
cfg.task.name = 'test task';

% can use the userInputs function to collect subject info
% cfg = userInputs;

% or declare it directly
cfg.subject.subjectNb = 1;
cfg.subject.runNb = 1;

% by default we assume you are running things on a behavioral PC with no eyetracker
% cfg.eyeTracker = false;
% cfg.testingDevice = 'PC';

% if the testing device is set to 'PC' then the data will be saved in the `beh` folder
% if set to 'mri' then the data will be saved in the `func` folder
% cfg.testingDevice = 'mri';
% if set to 'eeg' then the data will be saved in the `eeg` folder
% cfg.testingDevice = 'eeg';

% create the filenames: this include a step to check that all the information is there (checkCFG)
[cfg] = createFilename(cfg);

% initialize the events files with the typical BIDS columns (onsets, duration, trial_type)
% logFile = saveEventsFile('open', cfg);

% You can add some more in this case (Speed and is_Fixation)
logFile.extraColumns = {'Speed', 'is_Fixation'};
logFile = saveEventsFile('open', cfg, logFile);

% The information about 2 events that we want to save
% NOTE : If the user DOES NOT provide `onset`, `trial_type`, this events will be skipped.
logFile(1,1).onset = 2;
logFile(1,1).trial_type = 'motion_up';
logFile(1,1).duration = 1;
logFile(1,1).Speed = 2;
logFile(1,1).is_Fixation = true;

logFile(2,1).onset = 3;
logFile(2,1).trial_type = 'static';
logFile(2,1).duration = 4;
logFile(2,1).is_Fixation = 3;

% add those 2 events to the events.tsv file
saveEventsFile('save', cfg, logFile);

% close the file
saveEventsFile('close', cfg, logFile);

```

If you want to save more complex events.tsv file you can save several columns at once.

```matlab
cfg.subject.subjectNb = 1;
cfg.subject.runNb = 1;
cfg.task.name = 'testtask';
cfg.outputDir = outputDir;

cfg.testingDevice = 'mri';

[cfg] = createFilename(cfg);

% You can specify how many columns we want for each variable
% will set 1 columns with name Speed
% will set 12 columns with names LHL24-01, LHL24-02, ...
% will set 1 columns with name is_Fixation

logFile.extraColumns.Speed.length = 1;
logFile.extraColumns.LHL24.length = 12;
logFile.extraColumns.is_Fixation.length = 1;

logFile = saveEventsFile('open', cfg, logFile);

logFile(1, 1).onset = 2;
logFile(end, 1).trial_type = 'motion_up';
logFile(end, 1).duration = 3;
logFile(end, 1).Speed = 2;
logFile(end, 1).is_Fixation = true;
logFile(end, 1).LHL24 = 1:12;

saveEventsFile('save', cfg, logFile);

saveEventsFile('close', cfg, logFile);

```

If you have many columns to define but only a few with several columns, you can do this:

```matlab
% define the extra columns: they will be added to the tsv files in the order the user input them
logFile.extraColumns = {'Speed', 'is_Fixation'};

[cfg] = createFilename(cfg);

% initialize the logFile variable
[logFile] = saveEventsFile('init', cfg, logFile);

% set the real length we really want
logFile.extraColumns.Speed.length = 12;

% open the file
logFile = saveEventsFile('open', cfg, logFile);
```


## Functions descriptions

### userInputs

Get subject, run and session number and make sure they are positive integer values.

By default this will return `cfg.subject.session = 1` even if you asked it to omit enquiring about sessions. This means
that the folder tree will always include a session folder.

```matlab
[cfg] = userInputs(cfg)
```

if you use it with `cfg.subject.askGrpSess = [0 0]`
it won't ask you about group or session

if you use it with `cfg.subject.askGrpSess = [1]`
it will only ask you about group

if you use it with `cfg.subject.askGrpSess = [0 1]`
it will only ask you about session

if you use it with `cfg.subject.askGrpSess = [1 1]`
it will ask you about both
this is the default


### createFilename

Create the BIDS compliant directories  and filenames (but not the files) for the behavioral
output for this subject / session / run.

The folder tree will always include a session folder.

Will also create the right filename for the eye-tracking data file.

For the moment the date of acquisition is appended to the filename
-   can work for behavioral experiment if cfg.testingDevice is set to 'PC'
-   can work for fMRI experiment if cfg.testingDevice is set to 'mri'
-   can work for simple eyetracking data if cfg.eyeTracker is set to 1

### saveEventsFile

Function to save output files for events that will be BIDS compliant.

If the user DOES NOT provide `onset`, `trial_type`, this events will be skipped. `duration` will be set to "NaN" if
no value is provided.

### checkCFG

Check that we have all the fields that we need in the experiment parameters.

## CFG content

```matlab
%% Can be modified by users
% but their effect might only be effective after running
% checkCFG

cfg.verbose = 0;

cfg.subject.subjectGrp = '';
cfg.subject.sessionNb = 1;
cfg.subject.askGrpSess = [true true];

% BOLD MRI details
% some of those will be transferred to the correct fields in cfg.bids by checkCFG
cfg.mri.repetitionTime = [];
cfg.mri.contrastEnhancement = [];
cfg.mri.phaseEncodingDirection = [];
cfg.mri.reconstruction = [];
cfg.mri.echo = [];
cfg.mri.acquisition = [];

cfg.fileName.task = '';
cfg.fileName.zeroPadding = 3; % amount of 0 padding the subject, session, run number

cfg.eyeTracker.do = false;

% content of the json side-car file for bold data
cfg.bids.mri.RepetitionTime = [];
cfg.bids.mri.SliceTiming = '';
cfg.bids.mri.TaskName = '';
cfg.bids.mri.Instructions = '';
cfg.bids.mri.TaskDescription = '';

% content of the json side-car file for MEG
cfg.bids.meg.TaskName = '';
cfg.bids.meg.SamplingFrequency = [];
cfg.bids.meg.PowerLineFrequency = [];
cfg.bids.meg.DewarPosition = [];
cfg.bids.meg.SoftwareFilters = [];
cfg.bids.meg.DigitizedLandmarks = [];
cfg.bids.meg.DigitizedHeadPoints = [];

% content of the datasetDescription.json file
cfg.bids.datasetDescription.Name = '';
cfg.bids.datasetDescription.BIDSVersion =  '';
cfg.bids.datasetDescription.License = '';
cfg.bids.datasetDescription.Authors = {''};
cfg.bids.datasetDescription.Acknowledgements = '';
cfg.bids.datasetDescription.HowToAcknowledge = '';
cfg.bids.datasetDescription.Funding = {''};
cfg.bids.datasetDescription.ReferencesAndLinks = {''};
cfg.bids.datasetDescription.DatasetDOI = '';


%% Should not be modified by users
% many of those fields are set up by checkCFG and you might get non BIDS valid
% output if you touch those
cfg.fileName.dateFormat = 'yyyymmddHHMM'; % actual date of the experiment that is appended to the filename
cfg.fileName.modality
cgf.fileName.suffix.mri
cgf.fileName.suffix.meg
cfg.fileName.stim
cfg.fileName.events
cfg.fileName.datasetDescription

```

## How to install

### Download with git

``` bash
cd fullpath_to_directory_where_to_install
# use git to download the code
git clone https://github.com/cpp-lln-lab/CPP_BIDS.git
# move into the folder you have just created
cd CPP_BIDS
# add the src folder to the matlab path and save the path
matlab -nojvm -nosplash -r "addpath(fullfile(pwd, 'src')); savepath ();"
```

Then get the latest commit:
```bash
# from the directory where you downloaded the code
git pull origin master
```

To work with a specific version, create a branch at a specific version tag number
```bash
# creating and checking out a branch that will be called version1 at the version tag v0.0.1
git checkout -b version1 v0.0.1
```

### Add as a submodule

Add it as a submodule in the repo you are working on.

``` bash
cd fullpath_to_directory_where_to_install
# use git to download the code
git submodule add https://github.com/cpp-lln-lab/CPP_BIDS.git
# move into the folder you have just created
cd CPP_BIDS
# add the src folder to the matlab path and save the path
matlab -nojvm -nosplash -r "addpath(fullfile(pwd, 'src'))"
```

To get the latest commit you then need to update the submodule with the information
on its remote repository and then merge those locally.
```bash
git submodule update --remote --merge
```

Remember that updates to submodules need to be committed as well.

#### Example for submodule usage

So say you want to clone a repo that has some nested submodules, then you would type this to get the content of all the submodules at once (here with assumption that you want to clone my experiment repo):
```bash
# clone the repo
git clone https://github.com/user_name/myExperiment.git

# go into the directory
cd myExperiment

# initialize and get the content of the first level of submodules  (e.g. CPP_PTB and CPP_BIDS)
git submodule init
git submodule update

# get the nested submodules JSONio and BIDS-matlab for CPP_BIDS
git submodule foreach --recursive 'git submodule init'
git submodule foreach --recursive 'git submodule update'
```

**TO DO**
<!-- Submodules
pros: in principle, downloading the experiment you have the whole package plus the benefit to stay updated and use version control of this dependency. Can probably handle a use case in which one uses different version on different projects (e.g. older and newer projects).
cons: for pro users and not super clear how to use it at the moment. -->

### Direct download

Download the code. Unzip. And add to the matlab path.

Pick a specific version:

https://github.com/cpp-lln-lab/CPP_BIDS/releases

Or take the latest commit (NOT RECOMMENDED):

https://github.com/cpp-lln-lab/CPP_BIDS/archive/master.zip

**TO DO**
<!-- Download a specific version and c/p it in a subfun folder
pros: the easiest solution to share the code and 'installing' it on the stimulation computer (usually not the one used to develop the code).
cons: extreme solution useful only at the very latest stage (i.e. one minute before acquiring your data); prone to be customized/modified (is it what we want?) -->

## Contributing

Feel free to open issues to report a bug and ask for improvements.

### Guidestyle

-   We use camelCase.
-   We keep the McCabe complexity as reported by the [check_my_code function](https://github.com/Remi-Gau/check_my_code) below 15.
-   We use the [MISS_HIT linter](https://florianschanda.github.io/miss_hit/style_checker.html) to automatically fix some linting issues.

### BIDS naming convention

Here are the naming templates used.

-   BOLD

`sub-<label>[_ses-<label>]_task-<label>[_acq-<label>][_ce-<label>][_dir-<label>][_rec-<label>][_run-<index>][_echo-<index>]_<contrast_label>.nii[.gz]`

-   iEEG

`sub-<label>[_ses-<label>]_task-<task_label>[_run-<index>]_ieeg.json`

-   EEG

`sub-<label>[_ses-<label>]_task-<label>[_run-<index>]_eeg.<manufacturer_specific_extension>`

-   MEG

???

-   Eyetracker

`sub-<participant_label>[_ses-<label>][_acq-<label>]_task-<task_label>_eyetrack.<manufacturer_specific_extension>`

### Contributors ✨

Thanks goes to these wonderful people ([emoji key](https://allcontributors.org/docs/en/emoji-key)):

<!-- ALL-CONTRIBUTORS-LIST:START - Do not remove or modify this section -->
<!-- prettier-ignore-start -->
<!-- markdownlint-disable -->
<table>
  <tr>
    <td align="center"><a href="https://github.com/CerenB"><img src="https://avatars1.githubusercontent.com/u/10451654?v=4" width="100px;" alt=""/><br /><sub><b>CerenB</b></sub></a><br /><a href="https://github.com/cpp-lln-lab/CPP_BIDS/commits?author=CerenB" title="Code">💻</a> <a href="#design-CerenB" title="Design">🎨</a> <a href="https://github.com/cpp-lln-lab/CPP_BIDS/commits?author=CerenB" title="Documentation">📖</a></td>
    <td align="center"><a href="https://github.com/marcobarilari"><img src="https://avatars3.githubusercontent.com/u/38101692?v=4" width="100px;" alt=""/><br /><sub><b>marcobarilari</b></sub></a><br /><a href="https://github.com/cpp-lln-lab/CPP_BIDS/commits?author=marcobarilari" title="Code">💻</a> <a href="#design-marcobarilari" title="Design">🎨</a> <a href="https://github.com/cpp-lln-lab/CPP_BIDS/commits?author=marcobarilari" title="Documentation">📖</a></td>
    <td align="center"><a href="https://remi-gau.github.io/"><img src="https://avatars3.githubusercontent.com/u/6961185?v=4" width="100px;" alt=""/><br /><sub><b>Remi Gau</b></sub></a><br /><a href="https://github.com/cpp-lln-lab/CPP_BIDS/commits?author=Remi-Gau" title="Code">💻</a> <a href="#design-Remi-Gau" title="Design">🎨</a> <a href="https://github.com/cpp-lln-lab/CPP_BIDS/commits?author=Remi-Gau" title="Documentation">📖</a></td>
  </tr>
</table>

<!-- markdownlint-enable -->
<!-- prettier-ignore-end -->
<!-- ALL-CONTRIBUTORS-LIST:END -->

This project follows the [all-contributors](https://github.com/all-contributors/all-contributors) specification. Contributions of any kind welcome!
