function [namesExtraColumns, logFile] = returnNamesExtraColumns(logFile)

    namesExtraColumns = [];

    logFile = initializeExtraColumns(logFile);

    if isfield(logFile, 'extraColumns') && ~isempty(logFile(1).extraColumns)
        namesExtraColumns = fieldnames(logFile(1).extraColumns);
    end

end
