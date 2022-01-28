function trueOrFalse = isPositiveInteger(input2check)
    %
    % It checks whether the input is a positive integer and report it as ``true`` or ``false``
    %
    % USAGE::
    %
    %   trueOrFalse = isPositiveInteger(input2check)
    %
    % :param input2check: (1xn) The input to check (either a number or ``NaN``)
    % :type input2check: vector
    %
    % :returns: :trueOrFalse: (boolean)
    %
    % (C) Copyright 2020 CPP_BIDS developers

    trueOrFalse = ~any([ ...
                        ~isnumeric(input2check), ...
                        isnan(input2check), ...
                        fix(input2check) ~= input2check, ...
                        input2check < 0 ...
                       ]);

end
