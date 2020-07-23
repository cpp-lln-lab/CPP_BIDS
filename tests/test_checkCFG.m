function test_checkCFG()

    clear;

    outputDir = fullfile(fileparts(mfilename('fullpath')), '..', 'output');

    expParameters.subjectNb = 1;
    expParameters.runNb = 1;
    expParameters.task = 'testtask';
    expParameters.outputDir = outputDir;

    expParameters.bids.datasetDescription.Name = 'dummy';
    expParameters.bids.datasetDescription.BIDSVersion = '1.0.0';
    expParameters.bids.datasetDescription.Authors = {'Jane Doe', 'John Doe'};

    expParameters.bids.MRI.RepetitionTime = 1.56;

    cfg.testingDevice = 'mri';

    [~, expParameters] = checkCFG(cfg, expParameters);

    %%% test

    % test data
    expectedStructure.subjectNb = 1;
    expectedStructure.runNb = 1;
    expectedStructure.subjectGrp = '';
    expectedStructure.sessionNb = 1;

    expectedStructure.verbose = 0;
    expectedStructure.askGrpSess = [true true];

    expectedStructure.outputDir = outputDir;

    expectedStructure.task = 'testtask';

    expectedStructure.MRI.ce = [];
    expectedStructure.MRI.dir = [];
    expectedStructure.MRI.rec = [];
    expectedStructure.MRI.echo = [];
    expectedStructure.MRI.acq = [];

    expectedStructure.bids.MRI.RepetitionTime = 1.56;
    expectedStructure.bids.MRI.SliceTiming = '';
    expectedStructure.bids.MRI.TaskName = 'testtask';
    %     expectedStructure.bids.MRI.PhaseEncodingDirection = '';
    %     expectedStructure.bids.MRI.EffectiveEchoSpacing = '';
    %     expectedStructure.bids.MRI.EchoTime = '';
    expectedStructure.bids.MRI.Instructions = '';
    expectedStructure.bids.MRI.TaskDescription = '';

    expectedStructure.bids.datasetDescription.Name = 'dummy';
    expectedStructure.bids.datasetDescription.BIDSVersion =  '1.0.0';
    expectedStructure.bids.datasetDescription.License = '';
    expectedStructure.bids.datasetDescription.Authors = {'Jane Doe', 'John Doe'};
    expectedStructure.bids.datasetDescription.Acknowledgements = '';
    expectedStructure.bids.datasetDescription.HowToAcknowledge = '';
    expectedStructure.bids.datasetDescription.Funding = {''};
    expectedStructure.bids.datasetDescription.ReferencesAndLinks = {''};
    expectedStructure.bids.datasetDescription.DatasetDOI = '';

    expectedStructure = orderfields(expectedStructure);

    expectedStructure.bids.MRI;
    expParameters.bids.MRI;

    assert(isequal(expectedStructure, expParameters));

end
