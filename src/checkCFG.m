% (C) Copyright 2020 CPP_BIDS developers

function cfg = checkCFG(cfg)
    %
    % Check the fields of the configuration structure ``cfg``. If a required field is
    % missing the default value will be assigned to that field. If this field already
    % exists then the existing value will not be replaced.
    %
    % USAGE::
    %
    %   cfg = checkCFG([cfg])
    %
    % :param cfg: The configuration variable to check.
    % :type cfg: structure
    %
    % :returns: :cfg: (structure)
    %
    % This function reuses a lot of code and comment from the BIDS starter kit:
    %
    % https://github.com/bids-standard/bids-starter-kit/tree/master/matlabCode
    %
    % **Fields descriptions**:
    %  The following section describes the main fields set by ``checkCFG()`` with
    %  their associated default value.
    %
    %   - ``cfg.testingDevice = 'pc'``
    %     sets the way the experiment is run and the different options match the imaging
    %     modality:
    %
    %     - ``pc`` is for behavioral test
    %     - ``mri`` is for fMRI
    %     - ``eeg`` is for EEG...
    %
    %   - ``cfg.verbose = 0``
    %     sets how talkative the code will be. Possible values range from ``0`` to ``2``.
    %
    %     - ``0``: "I don't want to hear anything from CPP_BIDS."
    %     - ``1``: "I want to get my warnings."
    %     - ``2``: "Tell me everything!"
    %
    %     For implementation see ``utils/talkToMe`` and ``utils/throwWarning``.
    %
    %   - ``cfg.useGUI = false``
    %     sets whether a graphic interface should be used for the ``userInputs()``
    %     to query about group name, as well as for session, subject and run number.
    %
    %   - ``cfg.dir.output``
    %     sets where the data will be saved.
    %
    %   Filename options:
    %     sets options that will help in creating the filenames.
    %
    %     - ``cfg.fileName.task = ''``
    %       sets the name to be given to the task
    %     - ``cfg.fileName.zeroPadding = 3``
    %       sets tha amount of 0 padding the subject, session and run number.
    %     - ``cfg.fileName.dateFormat = 'yyyymmddHHMM'``
    %       sets the format of the date and time stamp that will be appended to all files.
    %
    %     The following fields can be used to specify certain of the labels that are used
    %     to specify certain of the acquisition conditions of certain experemental runs
    %     in a BIDS data set. These are mostly for MRI and, if set, will be ignored
    %     for most other modalities. See ``tests/test_createFilename()`` for details on how
    %     to use these.
    %
    %     - ``cfg.suffix.contrastEnhancement = []``
    %     - ``cfg.suffix.phaseEncodingDirection = []``
    %     - ``cfg.suffix.reconstruction = []``
    %     - ``cfg.suffix.echo = []``
    %     - ``cfg.suffix.acquisition = []``
    %     - ``cfg.suffix.recording = []``
    %
    %   Group and session options:
    %     All the fields of ``cfg.subject`` can be set using the ``userInputs()`` function
    %     but can also be set "manually" directly into the ``cfg`` structure.
    %
    %     - ``cfg.subject.subjectGrp = ''``
    %       is set to empty in case no group was provided.
    %     - ``cfg.subject.sessionNb = 1``
    %       always sets to 1 in case no session was provided.
    %     - ``cfg.subject.askGrpSess = [true true]``
    %       means that ``userInputs()`` will always ask for group and session by default.
    %
    %   Eyetracker options:
    %     Those options are mostly work in progress at the moment but should allow to
    %     track the some of the metadata regarding eyetracking data acquisition.
    %
    %     - ``cfg.eyeTracker.do = false``
    %     - ``cfg.eyeTracker.SamplingFrequency = []``
    %     - ``cfg.eyeTracker.PupilPositionType = ''``
    %     - ``cfg.eyeTracker.RawSamples =  []``
    %     - ``cfg.eyeTracker.Manufacturer = ''``
    %     - ``cfg.eyeTracker.ManufacturersModelName = ''``
    %     - ``cfg.eyeTracker.SoftwareVersions = ''``
    %     - ``cfg.eyeTracker.CalibrationType = 'HV5'``
    %     - ``cfg.eyeTracker.CalibrationPosition = ''``
    %     - ``cfg.eyeTracker.CalibrationDistance = ''``
    %     - ``cfg.eyeTracker.MaximalCalibrationError = []``
    %     - ``cfg.eyeTracker.AverageCalibrationError = []``
    %     - ``cfg.eyeTracker.RawDataFilters = {}``
    %
    % ``cfg.bids``:
    %  ``checkCFG()`` will also initialize ``cfg.bids`` that
    %  contains any information related to a BIDS data set and that will end up in
    %  in one of the JSON "sidecar" files containing the metadata of your
    %  experiment.
    %
    %  If the content of some fields of ``cfg`` has been set before running ``checkCFG()``,
    %  that content might be copied into the relevant field in ``cfg.bids``. For example,
    %  if you have set the field ``cfg.mri.repetitionTime``, then when you run ``checkCFG()``,
    %  its content will also be copied into ``cfg.bids.mri.RepetitionTime``.
    %
    %  ``cfg.bids`` is further sub-divided into several fields for the different
    %  "imaging modalities".
    %
    %  - ``cfg.bids.datasetDescription`` will be there for all type of experiments
    %  - ``cfg.bids.beh`` is for purely behavioral experiment with no associated imaging
    %  - ``cfg.bids.mri`` is for fMRI experiments
    %  - ``cfg.bids.eeg`` is for EEG experiments
    %  - ``cfg.bids.meg`` is for MEG experiments
    %  - ``cfg.bids.ieeg`` is for iEEG experiments
    %
    %  The content of each of those subfields matches the different "keys" one can find
    %  in the JSON file for each modality. The content of those different keys is detailed
    %  in the code of ``checkCFG()``,
    %  but a more extensive and updated descriptions will be found in the
    %  BIDS specifications themselves.
    %
    %  https://bids-specification.readthedocs.io/en/stable/
    %
    %  For the content of the ``datasetDescription.json`` files::
    %
    %    cfg.bids.datasetDescription.Name = '';
    %    cfg.bids.datasetDescription.BIDSVersion =  '';
    %    cfg.bids.datasetDescription.License = '';
    %    cfg.bids.datasetDescription.Authors = {''};
    %    cfg.bids.datasetDescription.Acknowledgements = '';
    %    cfg.bids.datasetDescription.HowToAcknowledge = '';
    %    cfg.bids.datasetDescription.Funding = {''};
    %    cfg.bids.datasetDescription.ReferencesAndLinks = {''};
    %    cfg.bids.datasetDescription.DatasetDOI = '';
    %
    %  For the content of the JSON files for behavioral data::
    %
    %    cfg.bids.beh.TaskName = [];
    %    cfg.bids.beh.Instructions = [];
    %
    %  For the content of the JSON files for fMRI data::
    %
    %    cfg.bids.mri.TaskName = '';
    %    cfg.bids.mri.Instructions = '';
    %    cfg.bids.mri.RepetitionTime = [];
    %    cfg.bids.mri.SliceTiming = '';
    %    cfg.bids.mri.TaskDescription = '';
    %
    %  For the content of the JSON files for EEG::
    %
    %    cfg.bids.eeg.TaskName = '';
    %    cfg.bids.eeg.Instructions = '';
    %    cfg.bids.eeg.EEGReference = '';
    %    cfg.bids.eeg.SamplingFrequency = [];
    %    cfg.bids.eeg.PowerLineFrequency = 50;
    %    cfg.bids.eeg.SoftwareFilters = 'n/a';
    %
    %  For the content of the JSON files for iEEG::
    %
    %    cfg.bids.ieeg.TaskName = '';
    %    cfg.bids.ieeg.Instructions = '';
    %    cfg.bids.ieeg.iEEGReference = '';
    %    cfg.bids.ieeg.SamplingFrequency = [];
    %    cfg.bids.ieeg.PowerLineFrequency = 50;
    %    cfg.bids.ieeg.SoftwareFilters = 'n/a';
    %
    %  For the content of the JSON files for MEG::
    %
    %    cfg.bids.meg.TaskName = '';
    %    cfg.bids.meg.Instructions = '';
    %    cfg.bids.meg.SamplingFrequency = [];
    %    cfg.bids.meg.PowerLineFrequency = [];
    %    cfg.bids.meg.DewarPosition = [];
    %    cfg.bids.meg.SoftwareFilters = [];
    %    cfg.bids.meg.DigitizedLandmarks = [];
    %    cfg.bids.meg.DigitizedHeadPoints = [];

    if nargin < 1 || isempty(cfg)
        cfg = struct();
    end

    checkCppBidsDependencies(cfg);

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

    fieldsToSet = datasetDescriptionDefaults(fieldsToSet);
    fieldsToSet = behJsonDefaults(fieldsToSet);
    fieldsToSet = mriJsonDefaults(fieldsToSet);
    fieldsToSet = eegJsonDefaults(fieldsToSet);
    fieldsToSet = ieegJsonDefaults(fieldsToSet);
    fieldsToSet = megJsonDefaults(fieldsToSet);

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

function fieldsToSet = behJsonDefaults(fieldsToSet)
    % for json for BEH data

    fieldsToSet.bids.beh.TaskName = [];

    fieldsToSet.bids.beh.Instructions = [];

    fieldsToSet.bids.beh = orderfields(fieldsToSet.bids.beh);

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
    % upright=15 deg, supine = 90 deg:
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
