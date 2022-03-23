function fullFilename = getFullFilename(fileName, cfg)
    %
    % Returns the full path of a file (fo a given subject and modality in a run).
    %
    % USAGE::
    %
    %   fullFilename = getFullFilename(fileName, cfg)
    %
    % :param fileName:
    % :type fileName: string
    % :param cfg: Configuration. See ``checkCFG()``.
    % :type cfg: structure
    %
    % (C) Copyright 2020 CPP_BIDS developers

    if isfield(cfg, 'dir') && isfield(cfg.dir, 'outputSubject') && ...
        isfield(cfg, 'fileName') && isfield(cfg.fileName, 'modality')

        fullFilename = fullfile(cfg.dir.outputSubject, ...
                                cfg.fileName.modality, ...
                                fileName);
    else
        warning('Not enough information to build a fullpath filename');
        fullFilename = fileName;

    end

end
