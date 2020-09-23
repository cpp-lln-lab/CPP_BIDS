% (C) Copyright 2020 CPP_BIDS developers

function [namesExtraColumns, logFile] = returnNamesExtraColumns(logFile)
    % [namesExtraColumns, logFile] = returnNamesExtraColumns(logFile)
    %

    namesExtraColumns = [];

    if isfield(logFile, 'extraColumns') && ~isempty(logFile(1).extraColumns)
        namesExtraColumns = fieldnames(logFile(1).extraColumns);
    end

end
