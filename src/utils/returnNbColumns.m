% (C) Copyright 2020 CPP_BIDS developers

function nbCol = returnNbColumns(logFile, nameExtraColumn)
    %
    % It returns the number of columns associated to one entry of the extra column list.
    %
    % USAGE::
    %
    %   [nbCol] = returnNbColumns(logFile, nameExtraColumn)
    %
    % :param logFile: It contains every information related to the experiment output(s)
    % :type logFile: structure
    % :param nameExtraColumn: An entry of ``logFile.extraColumns``
    % :type nameExtraColumn: string
    %
    % :returns:
    %           - :nbCol: (integer) The number of columns associated to one entry of the extra
    %                     column list.
    %

    thisExtraColumn = logFile(1).extraColumns.(nameExtraColumn);

    nbCol = 1;

    if isfield(thisExtraColumn, 'length')
        nbCol = thisExtraColumn.length;
    end
end
