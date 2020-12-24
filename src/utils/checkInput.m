% (C) Copyright 2020 CPP_BIDS developers

function data = checkInput(data)
    %
    % Check the data to write and convert to the proper format if needed.
    %
    % Default will be 'n/a' for chars and NaN for numeric data.
    %
    % USAGE::
    %
    %   data = checkInput(data)
    %

    if islogical(data) && data
        data = 'true';
    elseif islogical(data) && ~data
        data = 'false';
    end

    if ischar(data) && isempty(data) || strcmp(data, ' ')
        data = 'n/a';
    elseif isempty(data)
        % Important to not set this to n/a as we might still need to check if this
        % numeric value has the right length and needs to be nan padded
        data = nan;
    end

end
