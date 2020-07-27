function test_checkCFG()

    cfg.outputDir = fullfile(fileparts(mfilename('fullpath')), '..', 'output');
    cfg = checkCFG(cfg);

    expectedStructure = returnExpectedStructure();
    expectedStructure.outputDir = cfg.outputDir;
    expectedStructure.testingDevice = 'pc';

    assert(isequal(expectedStructure, cfg));

    %%
    fprintf('\n--------------------------------------------------------------------');

    clear;

    outputDir = fullfile(fileparts(mfilename('fullpath')), '..', 'output');

    cfg.subjectNb = 1;
    cfg.runNb = 1;
    cfg.task = 'testtask';
    cfg.outputDir = outputDir;

    cfg.bids.datasetDescription.Name = 'dummy';
    cfg.bids.datasetDescription.BIDSVersion = '1.0.0';
    cfg.bids.datasetDescription.Authors = {'Jane Doe', 'John Doe'};

    cfg.bids.MRI.RepetitionTime = 1.56;

    cfg.testingDevice = 'mri';

    cfg = checkCFG(cfg);

    %%% test

    % test data
    expectedStructure = returnExpectedStructure();
    expectedStructure.subjectNb = 1;
    expectedStructure.runNb = 1;

    expectedStructure.outputDir = outputDir;

    expectedStructure.task = 'testtask';
    expectedStructure.testingDevice = 'mri'

    expectedStructure.bids.MRI.RepetitionTime = 1.56;
    expectedStructure.bids.MRI.TaskName = 'testtask';

    expectedStructure.bids.datasetDescription.Name = 'dummy';
    expectedStructure.bids.datasetDescription.BIDSVersion =  '1.0.0';
    expectedStructure.bids.datasetDescription.Authors = {'Jane Doe', 'John Doe'};

    expectedStructure = orderfields(expectedStructure);

    assert(isequal(expectedStructure, cfg));

    fprintf('\n');

end

function expectedStructure = returnExpectedStructure()

    expectedStructure.subjectGrp = '';
    expectedStructure.sessionNb = 1;

    expectedStructure.verbose = 0;
    expectedStructure.askGrpSess = [true true];
    
    expectedStructure.eyeTracker = false;
    
    expectedStructure.MRI.ce = [];
    expectedStructure.MRI.dir = [];
    expectedStructure.MRI.rec = [];
    expectedStructure.MRI.echo = [];
    expectedStructure.MRI.acq = [];

    expectedStructure.bids.MRI.RepetitionTime = [];
    expectedStructure.bids.MRI.SliceTiming = '';
    expectedStructure.bids.MRI.TaskName = '';
    %     expectedStructure.bids.MRI.PhaseEncodingDirection = '';
    %     expectedStructure.bids.MRI.EffectiveEchoSpacing = '';
    %     expectedStructure.bids.MRI.EchoTime = '';
    expectedStructure.bids.MRI.Instructions = '';
    expectedStructure.bids.MRI.TaskDescription = '';

    expectedStructure.bids.datasetDescription.Name = '';
    expectedStructure.bids.datasetDescription.BIDSVersion =  '';
    expectedStructure.bids.datasetDescription.License = '';
    expectedStructure.bids.datasetDescription.Authors = {''};
    expectedStructure.bids.datasetDescription.Acknowledgements = '';
    expectedStructure.bids.datasetDescription.HowToAcknowledge = '';
    expectedStructure.bids.datasetDescription.Funding = {''};
    expectedStructure.bids.datasetDescription.ReferencesAndLinks = {''};
    expectedStructure.bids.datasetDescription.DatasetDOI = '';

    expectedStructure = orderfields(expectedStructure);
end
