function test_checkCFG()

    cfg.dir.output = fullfile(fileparts(mfilename('fullpath')), '..', 'output');
    cfg = checkCFG(cfg);

    expectedStructure = returnExpectedStructure();
    expectedStructure.dir.output = cfg.dir.output;
    expectedStructure.testingDevice = 'pc';

    testSubFields(expectedStructure, cfg);

    %%
    fprintf('\n--------------------------------------------------------------------');

    clear;

    outputDir = fullfile(fileparts(mfilename('fullpath')), '..', 'output');

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

    %%% test

    % test data
    expectedStructure = returnExpectedStructure();
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

    testSubFields(expectedStructure, cfg);

    fprintf('\n');

end

function expectedStructure = returnExpectedStructure()

    expectedStructure.subject.subjectGrp = '';
    expectedStructure.subject.sessionNb = 1;
    expectedStructure.subject.askGrpSess = [true true];

    expectedStructure.verbose = 0;

    expectedStructure.fileName.task = '';
    expectedStructure.fileName.zeroPadding = 3;
    expectedStructure.fileName.dateFormat = 'yyyymmddHHMM';

    expectedStructure.eyeTracker.do = false;

    expectedStructure.mri.contrastEnhancement = [];
    expectedStructure.mri.phaseEncodingDirection = [];
    expectedStructure.mri.reconstruction = [];
    expectedStructure.mri.echo = [];
    expectedStructure.mri.acquisition = [];
    expectedStructure.mri.repetitionTime = [];

    expectedStructure.bids.mri.RepetitionTime = [];
    expectedStructure.bids.mri.SliceTiming = '';
    expectedStructure.bids.mri.TaskName = '';
    expectedStructure.bids.mri.Instructions = '';
    expectedStructure.bids.mri.TaskDescription = '';

    expectedStructure.bids.meg.TaskName = '';
    expectedStructure.bids.meg.SamplingFrequency = [];
    expectedStructure.bids.meg.PowerLineFrequency = [];
    expectedStructure.bids.meg.DewarPosition = [];
    expectedStructure.bids.meg.SoftwareFilters = [];
    expectedStructure.bids.meg.DigitizedLandmarks = [];
    expectedStructure.bids.meg.DigitizedHeadPoints = [];

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

function testSubFields(expectedStructure, cfg)
    % check that that the structures match
    % if it fails it check from which subfield the error comes from

    try

        assert(isequal(expectedStructure, cfg));

    catch ME

        if isstruct(expectedStructure)

            names = fieldnames(expectedStructure);

            for i = 1:numel(names)

                disp(names{i});
                testSubFields(expectedStructure.(names{i}), cfg.(names{i}));

            end

        end

        expectedStructure;
        cfg;

        rethrow(ME);
    end
end
