% (C) Copyright 2020 CPP_BIDS developers

function test_suite = test_checkCFG %#ok<*STOUT>
    try % assignment of 'localfunctions' is necessary in Matlab >= 2016
        test_functions = localfunctions(); %#ok<*NASGU>
    catch % no problem; early Matlab versions can use initTestSuite fine
    end
    initTestSuite;
end

function test_checkCfgDefault()

    %% set up
    cfg.dir.output = fullfile(fileparts(mfilename('fullpath')), '..', 'output');
    cfg = checkCFG(cfg);

    %% create test data
    expectedStructure = returnExpectedCfgStructure();
    expectedStructure.dir.output = cfg.dir.output;
    expectedStructure.testingDevice = 'pc';

    expectedStructure = orderfields(expectedStructure);

    %% test
    assertEqual(cfg, expectedStructure);

end

function test_checkCfgBasic()

    %% set up
    outputDir = fullfile(fileparts(mfilename('fullpath')), '..', 'output');

    cfg.verbose = 0;

    cfg.subject.subjectNb = 1;
    cfg.subject.runNb = 1;

    cfg.task.name = 'test task';

    cfg.dir.output = outputDir;

    cfg.bids.datasetDescription.Name = 'dummy';
    cfg.bids.datasetDescription.BIDSVersion = '1.0.0';
    cfg.bids.datasetDescription.Authors = {'Jane Doe', 'John Doe'};

    cfg.mri.repetitionTime = 1.56;

    cfg.testingDevice = 'mri';

    cfg = checkCFG(cfg);

    %% create test data
    expectedStructure = returnExpectedCfgStructure();
    expectedStructure.subject.subjectNb = 1;
    expectedStructure.subject.runNb = 1;

    assertEqual(cfg.subject, expectedStructure.subject);

    expectedStructure.dir.output = outputDir;

    assertEqual(cfg.dir, cfg.dir);

    expectedStructure.task.name = 'test task';

    assertEqual(cfg.task, expectedStructure.task);

    expectedStructure.testingDevice = 'mri';

    assertEqual(cfg.testingDevice, expectedStructure.testingDevice);

    expectedStructure.mri.repetitionTime = 1.56;

    assertEqual(cfg.mri, expectedStructure.mri);

    expectedStructure.fileName.task = 'testTask';

    assertEqual(cfg.fileName, expectedStructure.fileName);

    expectedStructure.bids.mri.RepetitionTime = 1.56;

    expectedStructure.bids.mri.TaskName = 'testTask';
    expectedStructure.bids.beh.TaskName = 'testTask';
    expectedStructure.bids.ieeg.TaskName = 'testTask';
    expectedStructure.bids.eeg.TaskName = 'testTask';
    expectedStructure.bids.meg.TaskName = 'testTask';

    expectedStructure.bids.datasetDescription.Name = 'dummy';
    expectedStructure.bids.datasetDescription.BIDSVersion =  '1.0.0';
    expectedStructure.bids.datasetDescription.Authors = {'Jane Doe', 'John Doe'};

    assertEqual(cfg.bids.datasetDescription, expectedStructure.bids.datasetDescription);
    assertEqual(cfg.bids.mri, expectedStructure.bids.mri);
    assertEqual(cfg.bids, expectedStructure.bids);

    expectedStructure = orderfields(expectedStructure);

    %% test
    assertEqual(cfg, expectedStructure);

end

function expected = returnExpectedCfgStructure()

    expected.subject.subjectGrp = [];
    expected.subject.sessionNb = [];
    expected.subject.runNb = [];
    expected.subject.subjectNb = [];
    expected.subject.askGrpSess = [true true];

    expected.verbose = 0;

    expected.useGUI = false;

    expected.fileName.task = '';
    expected.fileName.zeroPadding = 3;
    expected.fileName.dateFormat = 'yyyymmddHHMM';

    expected.eyeTracker.do = false;

    expected.suffix.ce = [];
    expected.suffix.dir = [];
    expected.suffix.rec = [];
    expected.suffix.echo = [];
    expected.suffix.acq = [];
    expected.suffix.recording = [];

    expected.bids.beh.TaskName = '';
    expected.bids.beh.Instructions = '';

    expected.bids.mri.RepetitionTime = [];
    expected.bids.mri.SliceTiming = '';
    expected.bids.mri.TaskName = '';
    expected.bids.mri.Instructions = '';
    expected.bids.mri.TaskDescription = '';

    expected.bids.eeg.TaskName = '';
    expected.bids.eeg.Instructions = '';
    expected.bids.eeg.EEGReference = '';
    expected.bids.eeg.SamplingFrequency = [];
    expected.bids.eeg.PowerLineFrequency = 50;
    expected.bids.eeg.SoftwareFilters = 'n/a';

    expected.bids.ieeg.TaskName = '';
    expected.bids.ieeg.Instructions = '';
    expected.bids.ieeg.iEEGReference = '';
    expected.bids.ieeg.SamplingFrequency = [];
    expected.bids.ieeg.PowerLineFrequency = 50;
    expected.bids.ieeg.SoftwareFilters = 'n/a';

    expected.bids.meg.TaskName = '';
    expected.bids.meg.Instructions = '';
    expected.bids.meg.SamplingFrequency = [];
    expected.bids.meg.PowerLineFrequency = 50;
    expected.bids.meg.DewarPosition = [];
    expected.bids.meg.SoftwareFilters = 'n/a';
    expected.bids.meg.DigitizedLandmarks = [];
    expected.bids.meg.DigitizedHeadPoints = [];

    expected.bids.datasetDescription.Name = '';
    expected.bids.datasetDescription.BIDSVersion =  '';
    expected.bids.datasetDescription.License = '';
    expected.bids.datasetDescription.Authors = {''};
    expected.bids.datasetDescription.Acknowledgements = '';
    expected.bids.datasetDescription.HowToAcknowledge = '';
    expected.bids.datasetDescription.Funding = {''};
    expected.bids.datasetDescription.ReferencesAndLinks = {''};
    expected.bids.datasetDescription.DatasetDOI = '';

    expected.eyeTracker.do = false;
    expected.eyeTracker.SamplingFrequency = [];
    expected.eyeTracker.PupilPositionType = '';
    expected.eyeTracker.RawSamples =  [];
    expected.eyeTracker.Manufacturer = '';
    expected.eyeTracker.ManufacturersModelName = '';
    expected.eyeTracker.SoftwareVersions = '';
    expected.eyeTracker.CalibrationType = 'HV5';
    expected.eyeTracker.CalibrationPosition = '';
    expected.eyeTracker.CalibrationDistance = '';
    expected.eyeTracker.MaximalCalibrationError = [];
    expected.eyeTracker.AverageCalibrationError = [];
    expected.eyeTracker.RawDataFilters = {};

    expected.bids = orderfields(expected.bids);

    expected = orderfields(expected);

end
