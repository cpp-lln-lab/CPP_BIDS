% (C) Copyright 2020 CPP_BIDS developers

function data = nanPadding(cfg, data, expectedLength)
    %
    % For numeric data that don't have the expected length, it will be padded
    % with NaNs. If the vector is too long it will be truncated
    %
    % USAGE::
    %
    %  data = nanPadding(cfg, data, expectedLength)
    %
    %

    if nargin < 2
        expectedLength = [];
    end

    if ~isempty(expectedLength) && isnumeric(data)

        if max(size(data)) < expectedLength
            padding = expectedLength - max(size(data));
            data(end + 1:end + padding) = nan(1, padding);

        elseif max(size(data)) > expectedLength
            warningMessage = ['A field for this event is longer than expected.', ...
                              'Truncating extra values.'];
            throwWarning(cfg, 'nanPadding:arrayTooLong', warningMessage);

            data = data(1:expectedLength);

        end
    end

end
