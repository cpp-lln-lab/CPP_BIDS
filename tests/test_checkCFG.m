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

    %% test
    assertEqual(expectedStructure, cfg);

end

function test_checkCfgBasic()

    %% set up
    outputDir = fullfile(fileparts(mfilename('fullpath')), '..', 'output');

    cfg.verbose = false;

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

    expectedStructure.dir.output = outputDir;

    expectedStructure.task.name = 'test task';

    expectedStructure.testingDevice = 'mri';

    expectedStructure.mri.repetitionTime = 1.56;

    expectedStructure.fileName.task = 'testTask';

    expectedStructure.bids.mri.RepetitionTime = 1.56;
    expectedStructure.bids.mri.TaskName = 'test Task';

    expectedStructure.bids.meg.TaskName = 'test Task';

    expectedStructure.bids.datasetDescription.Name = 'dummy';
    expectedStructure.bids.datasetDescription.BIDSVersion =  '1.0.0';
    expectedStructure.bids.datasetDescription.Authors = {'Jane Doe', 'John Doe'};

    expectedStructure = orderfields(expectedStructure);

    %% test
    assertEqual(expectedStructure, cfg);

end

function expectedCfgStructure = returnExpectedCfgStructure()

    expectedCfgStructure.subject.subjectGrp = '';
    expectedCfgStructure.subject.sessionNb = 1;
    expectedCfgStructure.subject.askGrpSess = [true true];

    expectedCfgStructure.verbose = 0;

    expectedCfgStructure.fileName.task = '';
    expectedCfgStructure.fileName.zeroPadding = 3;
    expectedCfgStructure.fileName.dateFormat = 'yyyymmddHHMM';

    expectedCfgStructure.eyeTracker.do = false;

    expectedCfgStructure.mri.contrastEnhancement = [];
    expectedCfgStructure.mri.phaseEncodingDirection = [];
    expectedCfgStructure.mri.reconstruction = [];
    expectedCfgStructure.mri.echo = [];
    expectedCfgStructure.mri.acquisition = [];
    expectedCfgStructure.mri.repetitionTime = [];

    expectedCfgStructure.bids.mri.RepetitionTime = [];
    expectedCfgStructure.bids.mri.SliceTiming = '';
    expectedCfgStructure.bids.mri.TaskName = '';
    expectedCfgStructure.bids.mri.Instructions = '';
    expectedCfgStructure.bids.mri.TaskDescription = '';

    expectedCfgStructure.bids.meg.TaskName = '';
    expectedCfgStructure.bids.meg.SamplingFrequency = [];
    expectedCfgStructure.bids.meg.PowerLineFrequency = [];
    expectedCfgStructure.bids.meg.DewarPosition = [];
    expectedCfgStructure.bids.meg.SoftwareFilters = [];
    expectedCfgStructure.bids.meg.DigitizedLandmarks = [];
    expectedCfgStructure.bids.meg.DigitizedHeadPoints = [];

    expectedCfgStructure.bids.datasetDescription.Name = '';
    expectedCfgStructure.bids.datasetDescription.BIDSVersion =  '';
    expectedCfgStructure.bids.datasetDescription.License = '';
    expectedCfgStructure.bids.datasetDescription.Authors = {''};
    expectedCfgStructure.bids.datasetDescription.Acknowledgements = '';
    expectedCfgStructure.bids.datasetDescription.HowToAcknowledge = '';
    expectedCfgStructure.bids.datasetDescription.Funding = {''};
    expectedCfgStructure.bids.datasetDescription.ReferencesAndLinks = {''};
    expectedCfgStructure.bids.datasetDescription.DatasetDOI = '';

    expectedCfgStructure = orderfields(expectedCfgStructure);

end