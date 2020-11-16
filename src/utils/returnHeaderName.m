% (C) Copyright 2020 CPP_BIDS developers

function headerName = returnHeaderName(columnName, nbCol, iCol)
    %
    % It return one by one the column name to be used as a header in a fresh opened event file
    %
    % USAGE::
    %
    %   headerName = returnHeaderName(columnName, nbCol, iCol)
    %
    % :param columnName: The column name to print
    % :type columnName: string
    % :param nbCol: It is the number of columns associated to one entry of the extra column list
    % :type nbCol: integer
    % :param iCol: index of the columns associated to one entry of the extra column list
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
