% (C) Copyright 2020 CPP_BIDS developers

function logFile = initializeExtraColumns(logFile)
    %
    % Initialize the fields for the extra columns
    %
    % USAGE::
    %
    %   logFile = initializeExtraColumns(logFile)
    %
    % :param logFile:
    % :type logFile: structure
    %
    % :returns: :logFile: (structure) (dimension)
    %
    % Example::
    %
    %   logfile.extraColumns{'Speed', 'Response key'}
    %   logFile = initializeExtraColumns(logFile)
    %
    %

    fieldsToSet.length = 1;
    fieldsToSet.bids.LongName = '';
    fieldsToSet.bids.Description = '';
    fieldsToSet.bids.Levels = '';
    fieldsToSet.bids.TermURL = '';
    fieldsToSet.bids.Units = '';

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
