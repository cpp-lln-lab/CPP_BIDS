function createDatasetDescription(expParameters)

    opts.Indent = '    ';

    fileName = fullfile( ...
        expParameters.outputDir, 'source', ...
        'dataset_description.json');

    jsonContent = expParameters.bids.datasetDescription;

    bids.util.jsonencode(fileName, jsonContent, opts);

end
