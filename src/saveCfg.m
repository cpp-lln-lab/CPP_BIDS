function filename = saveCfg(varargin)
    %
    % Saves config as JSON
    %
    % USAGE::
    %
    %   createJson(cfg [, filename])
    %
    % :param cfg: Configuration. See ``checkCFG()``.
    % :type cfg: structure
    %
    % :param filename: fullpath filename for the output file.
    % :type filename: path
    %
    % :output:
    %          - filename:
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

    filename = strrep(cfg.fileName.events, '_events', '_cfg');
    filename = strrep(filename, '.tsv', '.json');
    filename = getFullFilename(filename, cfg);

    jsonContent = cfg;

    %% save
    bids.util.jsonencode(filename, jsonContent);

end
