% (C) Copyright 2020 CPP_BIDS developers

function trueOrFalse = isPositiveInteger(input2check)
    %
    %
    %
    % USAGE::
    %
    %   trueOrFalse = isPositiveInteger(input2check)
    %
    % :param input2check:
    % :type input2check: column vector
    %
    % :returns: :trueOrFalse: (boolean)
    %

    trueOrFalse = ~any([ ...
                        ~isnumeric(input2check), ...
                        isnan(input2check), ...
                        fix(input2check) ~= input2check, ...
                        input2check < 0 ...
                       ]);

end
