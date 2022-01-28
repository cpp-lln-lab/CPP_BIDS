function throwWarning(cfg, identifier, warningMessage)
    %
    % (C) Copyright 2020 CPP_BIDS developers

    if cfg.verbose > 0 && ...
            nargin == 3 && ...
            ~isempty(identifier) && ...
            ~isempty(warningMessage)

        warning(identifier, warningMessage);
    end
end
