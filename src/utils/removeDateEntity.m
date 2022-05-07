function removeDateEntity(varargin)
    %
    % Removes the date entity from all the files in a BIDS data set
    %
    %
    % USAGE::
    %
    %   removeDateEntity(pathToDataSet, 'filter', filter)
    %
    %
    % (C) Copyright 2022 CPP_BIDS developers

    args = inputParser;

    default_filter = struct([]);

    args.addRequired('pathToDataSet', @isdir);
    args.addParameter('filter', default_filter, @isstruct);

    args.parse(varargin{:});

    pathToDataSet = args.Results.pathToDataSet;
    filter = args.Results.filter;

    BIDS = bids.layout(pathToDataSet,  'use_schema', false);

    filter.date = '[0-9]+';
    data = bids.query(BIDS, 'data', filter);
    metadata = bids.query(BIDS, 'metadata', filter);

    for i = 1:size(data, 1)
        bf = bids.File(data{i});
        % TODO probably JSON renaming should be passed to bids-matlab
        sourceJson = fullfile(fileparts(bf.path), bf.json_filename);
        bf.entities.date = '';
        bf.rename('dry_run', false, 'force', true);
        bids.util.jsonencode(fullfile(fileparts(bf.path), bf.json_filename), metadata{i});
        delete(sourceJson);
    end

end
