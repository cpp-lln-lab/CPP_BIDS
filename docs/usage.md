# Usage

<!-- vscode-markdown-toc -->
* 1. [To save events.tsv file](#Tosaveevents.tsvfile)

<!-- vscode-markdown-toc-config
	numbering=true
	autoSave=true
	/vscode-markdown-toc-config -->
<!-- /vscode-markdown-toc -->



##  1. <a name='Tosaveevents.tsvfile'></a>To save events.tsv file

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