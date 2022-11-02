function convertSourceToRaw(varargin)
    %
    % Function attempts to convert a source dataset created with CPP_BIDS into a valid
    % BIDS data set.
    %
    %
    % USAGE::
    %
    %   convertSourceToRaw(cfg, 'filter', filter)
    %
    % :param cfg: cfg structure is needed only for providing the path in ``cfg.dir.output``.
    % :type cfg: structure
    %
    % :param filter: bids.query filter to only convert a subset of files.
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
    filter = args.Results.filter;

    sourceDir = fullfile(cfg.dir.output, 'source');
    rawDir = fullfile(cfg.dir.output, 'raw');

    % back up description to not overwrite
    % TODO bids malab should be smart enought to not do that
    isFile = @(x) exist(x, 'file');
    if isFile(fullfile(rawDir, 'dataset_description.json'))
        copyfile(fullfile(rawDir, 'dataset_description.json'), ...
                 fullfile(rawDir, 'dataset_description_bu.json'));
    end

    % trick use bids matlab copy dataset function
    bids.copy_to_derivative(sourceDir, ...
                            'pipeline_name', '.', ...
                            'out_path', rawDir, ...
                            'filter', filter, ...
                            'unzip', false, ...
                            'force', true, ...
                            'skip_dep', false, ...
                            'use_schema', false, ...
                            'verbose', true);

    if isFile(fullfile(rawDir, 'dataset_description_bu.json'))
        copyfile(fullfile(rawDir, 'dataset_description_bu.json'), ...
                 fullfile(rawDir, 'dataset_description.json'));
        delete(fullfile(rawDir, 'dataset_description_bu.json'));
    else
        % clean up description
        description = bids.util.jsondecode(fullfile(rawDir, 'dataset_description.json'));
        description.BIDSVersion = '1.7.0';
        description.Name = 'FIXME';
        description.DatasetType = 'raw';
        description = rmfield(description, 'GeneratedBy');
        description = rmfield(description, 'SourceDatasets');
        bids.util.jsonencode(fullfile(rawDir, 'dataset_description.json'), description);
    end

    removeDateEntity(rawDir, 'filter', filter);

    gunzipTimeSeries(rawDir);

    % add dummy README and CHANGE file
    templateFolder = fullfile(fileparts(mfilename('fullpath')), '..', 'templates');

    if ~isFile(fullfile(rawDir, 'README'))
        copyfile(fullfile(templateFolder, 'README'), ...
                 rawDir);
    end
    if ~isFile(fullfile(rawDir, 'CHANGES'))
        copyfile(fullfile(templateFolder, 'CHANGES'), ...
                 rawDir);
    end
    if ~isFile(fullfile(rawDir, '.bidsignore'))
        copyfile(fullfile(templateFolder, '.bidsignore'), ...
                 rawDir);
    end

end

function gunzipTimeSeries(pathToDataSet)

    BIDS = bids.layout(pathToDataSet,  'use_schema', false);
    data = bids.query(BIDS, 'data', 'suffix', {'stim', 'physio' }, 'ext', '.tsv');

    for i = 1:size(data, 1)
        gzip(data{i});
        if exist(data{i}, 'file')
            delete(data{i});
        end
    end
end
