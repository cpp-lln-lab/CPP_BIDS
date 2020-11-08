% (C) Copyright 2020 CPP_BIDS developers

function cfg = checkCFG(cfg)
    %
    % Short description of what the function does goes here.
    %
    % USAGE::
    %
    %   [argout1, argout2] = templateFunction(argin1, [argin2 == default,] [argin3])
    %
    % :param argin1: (dimension) obligatory argument. Lorem ipsum dolor sit amet,
    %                consectetur adipiscing elit. Ut congue nec est ac lacinia.
    % :type argin1: type
    % :param argin2: optional argument and its default value. And some of the
    %               options can be shown in litteral like ``this`` or ``that``.
    % :type argin2: string
    % :param argin3: (dimension) optional argument
    % :type argin3: integer
    %
    % :returns: - :argout1: (type) (dimension)
    %           - :argout2: (type) (dimension)
    %
    % cfg = checkCFG(cfg)
    %
    % check that we have all the fields that we need in the experiment parameters
    % reuses a lot of code from the BIDS starter kit

    if nargin < 1 || isempty(cfg)
        cfg = struct();
    end

    checkCppBidsDependencies(cfg);

    %% list the defaults to set

    fieldsToSet.verbose = 0;

    fieldsToSet.useGUI = false;

    fieldsToSet.fileName.task = '';
    fieldsToSet.fileName.zeroPadding = 3;
    fieldsToSet.fileName.dateFormat = 'yyyymmddHHMM';

    fieldsToSet.dir.output = fullfile( ...
                                      fileparts(mfilename('fullpath')), ...
                                      '..', ...
                                      'output');

    fieldsToSet.subject.askGrpSess = [true true];
    fieldsToSet.subject.sessionNb = 1; % in case no session was provided
    fieldsToSet.subject.subjectGrp = ''; % in case no group was provided

    fieldsToSet.testingDevice = 'pc';

    fieldsToSet = eyetrackerDefaults(fieldsToSet);

    fieldsToSet = setSuffixes(fieldsToSet);

    %% BIDS

    fieldsToSet = behJsonDefaults(fieldsToSet);
    fieldsToSet = datasetDescriptionDefaults(fieldsToSet);
    fieldsToSet = eegJsonDefaults(fieldsToSet);
    fieldsToSet = ieegJsonDefaults(fieldsToSet);
    fieldsToSet = megJsonDefaults(fieldsToSet);
    fieldsToSet = mriJsonDefaults(fieldsToSet);

    fieldsToSet = transferInfoToBids(fieldsToSet, cfg);

    %% Set defaults
    cfg = setDefaultFields(cfg, fieldsToSet);

end

function fieldsToSet = setSuffixes(fieldsToSet)

    % for file naming and JSON
    fieldsToSet.suffix.contrastEnhancement = [];
    fieldsToSet.suffix.phaseEncodingDirection = [];
    fieldsToSet.suffix.reconstruction = [];
    fieldsToSet.suffix.echo = [];
    fieldsToSet.suffix.acquisition = [];
    fieldsToSet.suffix.repetitionTime = [];
    fieldsToSet.suffix.recording = [];

    fieldsToSet.suffix = orderfields(fieldsToSet.suffix);

end

function fieldsToSet = datasetDescriptionDefaults(fieldsToSet)

    % REQUIRED name of the dataset
    fieldsToSet.bids.datasetDescription.Name = '';

    % REQUIRED The version of the BIDS standard that was used
    fieldsToSet.bids.datasetDescription.BIDSVersion = '';

    % RECOMMENDED
    % what license is this dataset distributed under? The
    % use of license name abbreviations is suggested for specifying a license.
    % A list of common licenses with suggested abbreviations can be found in appendix III.
    fieldsToSet.bids.datasetDescription.License = '';

    % RECOMMENDED List of individuals who contributed to the
    % creation/curation of the dataset
    fieldsToSet.bids.datasetDescription.Authors = {''};

    % RECOMMENDED who should be acknowledge in helping to collect the data
    fieldsToSet.bids.datasetDescription.Acknowledgements = '';

    % RECOMMENDED Instructions how researchers using this
    % dataset should acknowledge the original authors. This field can also be used
    % to define a publication that should be cited in publications that use the
    % dataset.
    fieldsToSet.bids.datasetDescription.HowToAcknowledge = '';

    % RECOMMENDED sources of funding (grant numbers)
    fieldsToSet.bids.datasetDescription.Funding = {''};

    % RECOMMENDED a list of references to
    % publication that contain information on the dataset, or links.
    fieldsToSet.bids.datasetDescription.ReferencesAndLinks = {''};

    % RECOMMENDED the Document Object Identifier of the dataset
    % (not the corresponding paper).
    fieldsToSet.bids.datasetDescription.DatasetDOI = '';

    % sort fields alphabetically
    fieldsToSet.bids.datasetDescription = orderfields(fieldsToSet.bids.datasetDescription);

end

function fieldsToSet = mriJsonDefaults(fieldsToSet)
    % for json for funcfional MRI data

    % REQUIRED The time in seconds between the beginning of an acquisition of
    % one volume and the beginning of acquisition of the volume following it
    % (TR). Please note that this definition includes time between scans
    % (when no data has been acquired) in case of sparse acquisition schemes.
    % This value needs to be consistent with the pixdim[4] field
    % (after accounting for units stored in xyzt_units field) in the NIfTI header
    fieldsToSet.bids.mri.RepetitionTime = [];

    % REQUIRED for sparse sequences that do not have the DelayTime field set.
    % This parameter is required for sparse sequences. In addition without this
    % parameter slice time correction will not be possible.
    %
    % In addition without this parameter slice time correction will not be possible.
    % The time at which each slice was acquired within each volume (frame) of  the acquisition.
    % The time at which each slice was acquired during the acquisition. Slice
    % timing is not slice order - it describes the time (sec) of each slice
    % acquisition in relation to the beginning of volume acquisition. It is
    % described using a list of times (in JSON format) referring to the acquisition
    % time for each slice. The list goes through slices along the slice axis in the
    % slice encoding dimension.
    fieldsToSet.bids.mri.SliceTiming = [];

    % REQUIRED Name of the task (for resting state use the "rest" prefix). No two tasks
    % should have the same name. Task label is derived from this field by
    % removing all non alphanumeric ([a-zA-Z0-9]) characters.
    fieldsToSet.bids.mri.TaskName = '';

    % RECOMMENDED Text of the instructions given to participants before the scan.
    % This is especially important in context of resting state fMRI and
    % distinguishing between eyes open and eyes closed paradigms.
    fieldsToSet.bids.mri.Instructions = '';

    % RECOMMENDED Longer description of the task.
    fieldsToSet.bids.mri.TaskDescription = '';

    % fieldsToSet.PhaseEncodingDirection = [];
    % fieldsToSet.EffectiveEchoSpacing = [];
    % fieldsToSet.EchoTime = [];

    fieldsToSet.bids.mri = orderfields(fieldsToSet.bids.mri);

end

function fieldsToSet = megJsonDefaults(fieldsToSet)
    % for json for MEG data

    % REQUIRED Name of the task (for resting state use the "rest" prefix). No two tasks
    % should have the same name. Task label is derived from this field by
    % removing all non alphanumeric ([a-zA-Z0-9]) characters.
    fieldsToSet.bids.meg.TaskName = '';

    fieldsToSet.bids.meg.Instructions = '';

    % REQUIRED Sampling frequency
    fieldsToSet.bids.meg.SamplingFrequency = [];

    % REQUIRED Frequency (in Hz) of the power grid at the geographical location of
    % the MEG instrument (i.e. 50 or 60):
    fieldsToSet.bids.meg.PowerLineFrequency = 50;

    % REQUIRED Position of the dewar during the MEG scan: "upright", "supine" or
    % "degrees" of angle from vertical: for example on CTF systems,
    % upright=15°, supine = 90°:
    fieldsToSet.bids.meg.DewarPosition = [];

    % REQUIRED List of temporal and/or spatial software filters applied, or ideally
    % key:value pairs of pre-applied software filters and their parameter
    % values: e.g., {"SSS": {"frame": "head", "badlimit": 7}},
    % {"SpatialCompensation": {"GradientOrder": Order of the gradient
    % compensation}}. Write "n/a" if no software filters applied.
    fieldsToSet.bids.meg.SoftwareFilters = 'n/a';

    % REQUIRED Boolean ("true" or "false") value indicating whether anatomical
    % landmark points (i.e. fiducials) are contained within this recording.
    fieldsToSet.bids.meg.DigitizedLandmarks = [];

    % REQUIRED Boolean ("true" or "false") value indicating whether head points
    % outlining the scalp/face surface are contained within this recording
    fieldsToSet.bids.meg.DigitizedHeadPoints = [];

    fieldsToSet.bids.meg = orderfields(fieldsToSet.bids.meg);

end

function fieldsToSet = eegJsonDefaults(fieldsToSet)
    % for json for EEG data

    fieldsToSet.bids.eeg.TaskName = '';

    fieldsToSet.bids.eeg.Instructions = '';

    fieldsToSet.bids.eeg.EEGReference = '';

    fieldsToSet.bids.eeg.SamplingFrequency = [];

    fieldsToSet.bids.eeg.PowerLineFrequency = 50;

    fieldsToSet.bids.eeg.SoftwareFilters = 'n/a';

    fieldsToSet.bids.eeg = orderfields(fieldsToSet.bids.eeg);

end

function fieldsToSet = ieegJsonDefaults(fieldsToSet)
    % for json for iEEG data

    fieldsToSet.bids.ieeg.TaskName = '';

    fieldsToSet.bids.ieeg.Instructions = '';

    fieldsToSet.bids.ieeg.iEEGReference = '';

    fieldsToSet.bids.ieeg.SamplingFrequency = [];

    fieldsToSet.bids.ieeg.PowerLineFrequency = 50;

    fieldsToSet.bids.ieeg.SoftwareFilters = 'n/a';

    fieldsToSet.bids.ieeg = orderfields(fieldsToSet.bids.ieeg);

end

function fieldsToSet = behJsonDefaults(fieldsToSet)
    % for json for BEH data

    fieldsToSet.bids.beh.TaskName = [];

    fieldsToSet.bids.beh.Instructions = [];

    fieldsToSet.bids.ieeg = orderfields(fieldsToSet.bids.beh);

end

function fieldsToSet = eyetrackerDefaults(fieldsToSet)

    fieldsToSet.eyeTracker.do = false;
    fieldsToSet.eyeTracker.SamplingFrequency = [];
    fieldsToSet.eyeTracker.PupilPositionType = '';
    fieldsToSet.eyeTracker.RawSamples =  [];
    fieldsToSet.eyeTracker.Manufacturer = '';
    fieldsToSet.eyeTracker.ManufacturersModelName = '';
    fieldsToSet.eyeTracker.SoftwareVersions = '';
    fieldsToSet.eyeTracker.CalibrationType = 'HV5';
    fieldsToSet.eyeTracker.CalibrationPosition = '';
    fieldsToSet.eyeTracker.CalibrationDistance = '';
    fieldsToSet.eyeTracker.MaximalCalibrationError = [];
    fieldsToSet.eyeTracker.AverageCalibrationError = [];
    fieldsToSet.eyeTracker.RawDataFilters = {};

end
