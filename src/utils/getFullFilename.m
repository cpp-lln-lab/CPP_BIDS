% (C) Copyright 2020 CPP_BIDS developers

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

    fullFilename = fullfile( ...
                            cfg.dir.outputSubject, ...
                            cfg.fileName.modality, ...
                            fileName);

end
