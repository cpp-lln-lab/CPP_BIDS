% (C) Copyright 2020 CPP_BIDS developers

function createDatasetDescription(cfg)
    %
    % It creates ``dataset_description.json`` and writes in every entry contained in
    % ``cfg.bids.datasetDescription``. The file should go in the root of a BIDS dataset.
    %
    % USAGE::
    %
    %   createDatasetDescription(cfg)
    %
    % :param cfg: Configuration. See ``checkCFG()``.
    % :type cfg: structure
    %
    % :output: - :``dataset_description.json``: (jsonfile)
    %

    opts.Indent = '    ';

    fileName = fullfile( ...
                        cfg.dir.output, 'source', ...
                        'dataset_description.json');

    jsonContent = cfg.bids.datasetDescription;

    bids.util.jsonencode(fileName, jsonContent, opts);

end
