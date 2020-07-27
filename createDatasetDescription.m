function createDatasetDescription(cfg)

    opts.Indent = '    ';

    fileName = fullfile( ...
        cfg.outputDir, 'source', ...
        'dataset_description.json');

    jsonContent = cfg.bids.datasetDescription;

    bids.util.jsonencode(fileName, jsonContent, opts);

end
