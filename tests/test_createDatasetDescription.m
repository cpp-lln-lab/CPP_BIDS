function test_suite = test_createDatasetDescription %#ok<*STOUT>
    try % assignment of 'localfunctions' is necessary in Matlab >= 2016
        test_functions = localfunctions(); %#ok<*NASGU>
    catch % no problem; early Matlab versions can use initTestSuite fine
    end
    initTestSuite;
end

function test_createDatasetDescriptionBasic()

    outputDir = fullfile(fileparts(mfilename('fullpath')), '..', 'output');

    %% set up

    cfg.dir.output = outputDir;

    cfg.verbose = false;

    cfg.bids.datasetDescription.json.Name = 'dummy_dataset';
    cfg.bids.datasetDescription.json.BIDSVersion = '1.0.0';
    cfg.bids.datasetDescription.json.License = 'none';
    cfg.bids.datasetDescription.json.Authors = {'Jane Doe'};

    cfg = checkCFG(cfg);

    createDatasetDescription(cfg);

    %% data to test against
    directory = fullfile(outputDir, 'source');
    filename = 'dataset_description.json';

    %% test
    assertTrue(exist(fullfile(directory, filename), 'file') == 2);

end
