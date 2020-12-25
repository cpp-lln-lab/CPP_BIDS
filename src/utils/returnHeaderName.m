% (C) Copyright 2020 CPP_BIDS developers

function headerName = returnHeaderName(columnName, nbCol, iCol)
    %
    % It returns one by one the column name to be used as a header in a recently opened event file
    %
    % USAGE::
    %
    %   headerName = returnHeaderName(columnName, nbCol, iCol)
    %
    % :param columnName: The column name to print
    % :type columnName: string
    % :param nbCol: It is the number of columns associated to one entry of the extra column list
    % :type nbCol: integer
    % :param iCol: Index of the columns associated to one entry of the extra column list
    % :type iCol: integer
    %
    % :returns: - :headerName: (string) return the extra column name to be used as header
    %

    if nbCol == 1
        headerName = sprintf('%s', columnName);
    else
        headerName = sprintf('%s_%02.0f', columnName, iCol);
    end

end
