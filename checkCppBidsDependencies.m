function checkCppBidsDependencies(cfg)
    % (C) Copyright 2020 CPP_BIDS developers

    warning(sprintf(['\n\nDEPRECATION WARNING:\n', ...
                     '"checkCppBidsDependencies" is deprecated ', ...
                     'and will be removed in a future release.\n', ...
                     '\nPlease use "cpp_bids(''init'')" instead.'])); %#ok<SPWRN>

    verbose = false;
    if nargin > 0 && ~isempty(cfg) && isfield(cfg, 'verbose') && ~isempty(cfg.verbose)
        verbose = cfg.verbose;
    end

    cpp_bids('init', 'verbose', verbose);

end
