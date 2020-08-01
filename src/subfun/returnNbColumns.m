function nbCol = returnNbColumns(logFile, nameExtraColumn)
    % nbCol = returnNbColumns(logFile, nameExtraColumn)
    %

    thisExtraColumn = logFile(1).extraColumns.(nameExtraColumn);

    nbCol = 1;

    if isfield(thisExtraColumn, 'length')
        nbCol = thisExtraColumn.length;
    end
end
