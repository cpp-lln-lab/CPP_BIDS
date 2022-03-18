function filename = saveCfg(varargin)
    %
    % Saves config as JSON.
    %
    % USAGE::
    %
    %   createJson(cfg [, filename])
    %
    % :param cfg: Required. Configuration. See ``checkCFG()``.
    % :type cfg: structure
    %
    % :param filename: Optional. Fullpath filename for the output file.
    % :type filename: path
    %
    % :output: filename
    %
    % If a filename is provided, this will be used as an output file (and will
    % create any required directory)
    %
    % If no filename is provided, it will try to create one based on the content
    % of ``cfg.fileName`` and ``cfg.dir``. If this fails it will save the file
    % in the ``pwd`` under ``'date-yyyymmddHHMM_cfg.json'``.
    %
    %
    % (C) Copyright 2022 CPP_BIDS developers

    %% Parse inputs
    % modality is either given as a string by user or guessed from cfg.fileName
    % extraInfo must be a structure

    args = inputParser;

    default_filename = '';

    args.addRequired('cfg', @isstruct);
    args.addOptional('filename', default_filename, @ischar);

    args.parse(varargin{:});

    cfg = args.Results.cfg;
    filename = args.Results.filename;

    % if no name, get name from config
    if strcmp(filename, '')

        if isfield(cfg, 'fileName') && isfield(cfg.fileName, 'events')
            filename = strrep(cfg.fileName.events, '_events.tsv', '_cfg.json');
            filename = getFullFilename(filename, cfg);
        end

    end

    % if this did not work we make one up
    if strcmp(filename, '')
        tmp = checkCFG();
        bf = struct('suffix', 'cfg', ...
                    'ext', '.json', ...
                    'entities', struct('date', datestr(now, tmp.fileName.dateFormat)));
        bf = bids.File(bf);
        filename = fullfile(pwd, bf.filename);
    end

    if ~isdir(fileparts(filename))
        bids.util.mkdir(fileparts(filename));
    end

    %% save
    jsonContent = cfg;
    bids.util.jsonencode(filename, jsonContent);

end
