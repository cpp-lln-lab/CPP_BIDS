function talkToMe(cfg, message)
    %
    % USAGE::
    %
    %   talkToMe(cfg, message)
    %

    % (C) Copyright 2020 CPP_BIDS developers

    if isfield(cfg, 'verbose') && cfg.verbose > 0
        fprintf(1, message);
    end

end
