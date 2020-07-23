function headerName = returnHeaderName(columnName, nbCol, iCol)
    if nbCol == 1
        headerName = sprintf('%s', columnName);
    else
        headerName = sprintf('%s_%02.0f', columnName, iCol);
    end
end
