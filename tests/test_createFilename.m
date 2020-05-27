function test_createFilename()

% test for filename creation and their directories

%% check directory and filename creation (PC)

expParameters.subjectGrp = '';
expParameters.subjectNb = 1;
expParameters.sessionNb = 1;
expParameters.runNb = 1;
expParameters.task = 'testtask';
expParameters.verbose = 1;

cfg.eyeTracker = false;
cfg.device = 'PC';

expParameters = checkCFG(cfg,expParameters);
expParameters = createFilename(cfg,expParameters);

behDir = fullfile(pwd, ...
    '..', '..', ...
    'output', 'source', 'sub-001', 'ses-001', 'beh');

eyetrackerDir = fullfile(pwd, ...
    '..', '..', ...
    'output', 'source', 'sub-001', 'ses-001', 'eyetracker');


assert(exist(behDir, 'dir')==7)

% make sure the eyetracker dir is not created
assert(exist(eyetrackerDir, 'dir')==0) 

assert(strcmp(...
              expParameters.fileName.events, ...
              ['sub-001_ses-001_task-testtask_run-001_events_date-' expParameters.date '.tsv']));
assert(strcmp(...
              expParameters.fileName.stim, ...
              ['sub-001_ses-001_task-testtask_run-001_stim_date-' expParameters.date '.tsv']));
          
%% check directory and filename creation (fMRI and eye tracker)

clear

expParameters.subjectGrp = 'ctrl';
expParameters.subjectNb = 2;
expParameters.sessionNb = 2;
expParameters.runNb = 2;
expParameters.task = 'testtask';

cfg.eyeTracker = true;
cfg.device = 'scanner';

outputDir = fullfile(fileparts(mfilename('fullpath')), '..', 'output');

funcDir = fullfile(outputDir, 'source', 'sub-ctrl002', 'ses-002', 'func');
eyetrackerDir = fullfile(outputDir, 'source', 'sub-ctrl002', 'ses-002', 'eyetracker');

expParameters.outputDir = outputDir;
expParameters = checkCFG(cfg,expParameters);
expParameters = createFilename(cfg,expParameters);

assert(exist(funcDir, 'dir')==7)
assert(exist(eyetrackerDir, 'dir')==7)
assert(strcmp(expParameters.fileName.base, 'sub-ctrl002_ses-002_task-testtask'))
assert(strcmp(...
              expParameters.fileName.events, ...
              ['sub-ctrl002_ses-002_task-testtask_run-002_events_date-' expParameters.date '.tsv']));
          
assert(strcmp(...
              expParameters.fileName.eyetracker, ...
              ['sub-ctrl002_ses-002_task-testtask_run-002_eyetrack_date-' expParameters.date '.edf']));

