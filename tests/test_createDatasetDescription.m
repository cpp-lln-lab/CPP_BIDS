function test_createDatasetDescription()

    fprintf('\n\n--------------------------------------------------------------------\n\n');

    outputDir = fullfile(fileparts(mfilename('fullpath')), '..', 'output');

    %%% set up part

    expParameters.outputDir = outputDir;

    expParameters.bids.datasetDescription.json.Name = 'dummy_dataset';
    expParameters.bids.datasetDescription.json.BIDSVersion = '1.0.0';
    expParameters.bids.datasetDescription.json.License = 'none';
    expParameters.bids.datasetDescription.json.Authors = {'Jane Doe'};

    cfg = struct();

    [cfg, expParameters] = checkCFG(cfg, expParameters); %#ok<*ASGLU>

    createDatasetDescription(expParameters);

    %%% test part

    % test data
    directory = fullfile(outputDir, 'source');
    filename = 'dataset_description.json';

    % check that the file has the right path and name
    assert(exist(fullfile(directory, filename), 'file') == 2);

end
