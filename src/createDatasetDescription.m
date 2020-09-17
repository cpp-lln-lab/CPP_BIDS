% (C) Copyright 2020 CPP_BIDS developers

function createDatasetDescription(cfg)
    % createDatasetDescription(cfg)
    %
    % creates the datasetDescription.json file that goes in the root of a BIDS
    % dataset

    opts.Indent = '    ';

    fileName = fullfile( ...
        cfg.dir.output, 'source', ...
        'dataset_description.json');

    jsonContent = cfg.bids.datasetDescription;

    bids.util.jsonencode(fileName, jsonContent, opts);

end
