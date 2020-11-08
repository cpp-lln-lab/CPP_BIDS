% (C) Copyright 2020 CPP_BIDS developers

function headerName = returnHeaderName(columnName, nbCol, iCol)
    %
    % Short description of what the function does goes here.
    %
    % USAGE::
    %
    %   [argout1, argout2] = templateFunction(argin1, [argin2 == default,] [argin3])
    %
    % :param argin1: (dimension) obligatory argument. Lorem ipsum dolor sit amet,
    %                consectetur adipiscing elit. Ut congue nec est ac lacinia.
    % :type argin1: type
    % :param argin2: optional argument and its default value. And some of the
    %               options can be shown in litteral like ``this`` or ``that``.
    % :type argin2: string
    % :param argin3: (dimension) optional argument
    % :type argin3: integer
    %
    % :returns: - :argout1: (type) (dimension)
    %           - :argout2: (type) (dimension)
    %
    % headerName = returnHeaderName(columnName, nbCol, iCol)
    %

    if nbCol == 1
        headerName = sprintf('%s', columnName);
    else
        headerName = sprintf('%s_%02.0f', columnName, iCol);
    end

end
