# functions description

<!-- vscode-markdown-toc -->

-   1. [userInputs](#userInputs)
-   2. [createFilename](#createFilename)
-   3. [saveEventsFile](#saveEventsFile)
-   4. [checkCFG](#checkCFG)
    -   4.1. [CFG content](#CFGcontent)
-   5. [createBoldJson](#createBoldJson)

<!-- vscode-markdown-toc-config
	numbering=true
	autoSave=true
	/vscode-markdown-toc-config -->
<!-- /vscode-markdown-toc -->

## 1. <a name='userInputs'></a>userInputs

Get subject, run and session number and make sure they are positive integer
values.

By default this will return `cfg.subject.session = 1` even if you asked it to
omit enquiring about sessions. This means that the folder tree will always
include a session folder.

```matlab
[cfg] = userInputs(cfg)
```

If you use it with `cfg.subject.askGrpSess = [0 0]`, it won't ask you about
group or session.

If you use it with `cfg.subject.askGrpSess = [1]`, it will only ask you about
group

If you use it with `cfg.subject.askGrpSess = [0 1]`, it will only ask you about
session

If you use it with `cfg.subject.askGrpSess = [1 1]`, it will ask you about both.
This is the default behavior.

## 2. <a name='createFilename'></a>createFilename

Create the BIDS compliant directories and filenames (but not the files) for the
behavioral output for this subject / session / run.

The folder tree will always include a session folder.

It will also create the right filename for the eye-tracking data file if you ask
it.

For the moment the date of acquisition is appended to the filename

-   can work for behavioral experiment if `cfg.testingDevice` is set to `pc`,
-   can work for fMRI experiment if `cfg.testingDevice` is set to `mri`,
-   can work for simple eyetracking data if `cfg.eyeTracker.do` is set to 1.

## 3. <a name='saveEventsFile'></a>saveEventsFile

Function to save output files for events that will be BIDS compliant.

If the user DOES NOT provide `onset`, `trial_type`, this events will be skipped.
`duration` will be set to `n/a` if no value is provided.

## 4. <a name='checkCFG'></a>checkCFG

Check that we have all the fields that we need in the experiment parameters.

### 4.1. <a name='CFGcontent'></a>CFG content

```matlab
% The following can be modified by users but their effect might
% only be effective after running checkCFG

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
% many of those fields are set up by checkCFG and you might get output that is not BIDS valid if you touch those
cfg.fileName.dateFormat = 'yyyymmddHHMM'; % actual date of the experiment that is appended to the filename
cfg.fileName.modality
cgf.fileName.suffix.mri
cgf.fileName.suffix.meg
cfg.fileName.stim
cfg.fileName.events
cfg.fileName.datasetDescription

```

## 5. <a name='createBoldJson'></a>createBoldJson

```
createBoldJson(cfg)
```

This function creates a very light-weight version of the side-car JSON file for
a BOLD functional run.

This will only contain the minimum BIDS requirement and will likely be less
complete than the info you could from DICOM conversion.

If you put the following line at the end of your experiment script, it will dump
the content of the `extraInfo` structure in the json file.

```
createBoldJson(cfg, extraInfo)
```

This allows to add all the parameters that you used to run your experiment in a
human readable format: so that when you write your methods sections 2 years
later ("the reviewer asked me for the size of my fixation cross... FML"), the
info you used WHEN you ran the experiment is saved in an easily accessible text
format. For the love of the flying spaghetti monster do not save all your
parameters in a `.mat` file: think of the case when you won't have matlab or
octave installed on a computer (plus not everyone uses those).

Also to reading your experiment parameters, you won't have to read it from the
`setParameters.m` file and wonder if those might have been modified when running
the experiment and you did not commit and tagged that change with git.
