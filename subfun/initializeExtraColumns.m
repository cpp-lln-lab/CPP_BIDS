function logFile = initializeExtraColumns(logFile)
    %    initialize the fields for the extra columns
    %    USAGE
    %       logfile.extraColumns{'Speed', 'Response key'}
    %       logFile = initializeExtraColumns(logFile)

    fieldsToSet.length = 1;
    fieldsToSet.bids.LongName = '';
    fieldsToSet.bids.Description = '';
    fieldsToSet.bids.Levels = '';
    fieldsToSet.bids.TermURL = '';

    % convert the cell of column name into a structure
    if iscell(logFile(1).extraColumns)

        nbExtraColumns = numel(logFile(1).extraColumns);
        tmp = struct();

        for iExtraColumn = 1:nbExtraColumns
            extraColumnName = logFile(1).extraColumns{iExtraColumn};
            tmp.(extraColumnName) = struct( ...
                'length', 1);
            tmp.(extraColumnName) = setDefaultFields(tmp.(extraColumnName), fieldsToSet);
        end

        logFile(1).extraColumns = tmp;

    end

    [namesExtraColumns] = returnNamesExtraColumns(logFile);
    for iExtraColumn = 1:numel(namesExtraColumns)

        logFile(1).extraColumns.(namesExtraColumns{iExtraColumn}) = ...
            setDefaultFields( ...
            logFile(1).extraColumns.(namesExtraColumns{iExtraColumn}), ...
            fieldsToSet);

    end

end
