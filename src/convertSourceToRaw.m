function convertSourceToRaw(varargin)
    %
    % Function attempts to convert a source dataset created with CPP_BIDS into a valid
    % BIDS data set.
    %
    %
    % USAGE::
    %
    %   convertSourceToRaw(cfg)
    %
    % :param cfg: cfg structure is needed only for providing the path in ``cfg.dir.output``.
    % :type cfg: structure
    %
    % :param filter: bids.query fitler to only convert a subset of files.
    % :type filter: structure
    %
    % :output:
    %          - :creates: a dummy README and CHANGE file
    %          - :copies: ``source`` directory to ``raw`` directory
    %          - :removes: the date suffix ``_date-*`` from the files where it is present
    %          - :zips: the ``_stim.tsv`` files.
    %
    % (C) Copyright 2020 CPP_BIDS developers

    args = inputParser;

    default_filter = struct([]);

    args.addRequired('cfg', @isstruct);
    args.addParameter('filter', default_filter, @isstruct);

    args.parse(varargin{:});

    cfg = args.Results.cfg;

    sourceDir = fullfile(cfg.dir.output, 'source');
    rawDir = fullfile(cfg.dir.output, 'raw');

    % add dummy README and CHANGE file
    templateFolder = fullfile(fileparts(mfilename('fullpath')), '..', 'templates');

    copyfile(fullfile(templateFolder, 'README'), ...
             sourceDir);
    copyfile(fullfile(templateFolder, 'CHANGES'), ...
             sourceDir);
    copyfile(fullfile(templateFolder, '.bidsignore'), ...
             sourceDir);

    copyfile(sourceDir, rawDir);

    removeDateEntity(rawDir);

    BIDS = bids.layout(rawDir,  'use_schema', false);
    data = bids.query(BIDS, 'data', 'suffix', {'stim', 'physio' }, 'ext', '.tsv');

    for i = 1:size(data, 1)
        gzip(data{i});
        if exist(data{i}, 'file')
            delete(data{i});
        end
    end

end

function removeDateEntity(pathToDataSet)

    BIDS = bids.layout(pathToDataSet,  'use_schema', false);

    filter = struct('date', {'[0-9]+'});
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
