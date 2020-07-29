function test_createDatasetDescription()

    outputDir = fullfile(fileparts(mfilename('fullpath')), '..', 'output');

    %%% set up part

    cfg.dir.output = outputDir;

    cfg.bids.datasetDescription.json.Name = 'dummy_dataset';
    cfg.bids.datasetDescription.json.BIDSVersion = '1.0.0';
    cfg.bids.datasetDescription.json.License = 'none';
    cfg.bids.datasetDescription.json.Authors = {'Jane Doe'};

    cfg = checkCFG(cfg);

    createDatasetDescription(cfg);

    %%% test part

    % test data
    directory = fullfile(outputDir, 'source');
    filename = 'dataset_description.json';

    % check that the file has the right path and name
    assert(exist(fullfile(directory, filename), 'file') == 2);

end
