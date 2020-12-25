% (C) Copyright 2020 CPP_BIDS developers

function [namesExtraColumns] = returnNamesExtraColumns(logFile)
    %
    % It returns the extra columns name(s), in ``cfg.extraColumns``,  as header to add to the
    % ``event`` file
    %
    % USAGE::
    %
    %   [namesExtraColumns] = returnNamesExtraColumns(logFile)
    %
    % :param logFile: It contains all the information to be saved in the event/stim file
    % :type logFile: structure
    %
    % :returns: - :namesExtraColumns: (cell) (nx1)
    %

    namesExtraColumns = [];

    if isfield(logFile, 'extraColumns') && ~isempty(logFile(1).extraColumns)
        namesExtraColumns = fieldnames(logFile(1).extraColumns);
    end

end
