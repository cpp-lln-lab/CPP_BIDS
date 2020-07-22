function logFile = initializeExtraColumns(logFile)
    %    initialize the fields for the extra columns
    %    USAGE
    %       logfile.extraColumns{'Speed', 'Response key'}
    %       logFile = initializeExtraColumns(logFile)

    % convert the cell of column name into a structure
    if iscell(logFile(1).extraColumns)
        tmp = struct();
        for iExtraColumn = 1:numel(logFile(1).extraColumns)
            extraColumnName = logFile(1).extraColumns{iExtraColumn};
            tmp.(extraColumnName) = struct( ...
                'length', 1, ...
                'LongName', '', ...,
                'Description', '', ...
                'Levels', '', ...
                'Units', '', ...
                'TermURL', '');
        end
        logFile(1).extraColumns = tmp;
    end

end
