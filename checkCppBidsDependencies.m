function checkCppBidsDependencies()
    % (C) Copyright 2020 CPP_BIDS developers

    warning(sprintf(['\n\nDEPRECATION WARNING:\n', ...
                     '"checkCppBidsDependencies" is deprecated ', ...
                     'and will be removed in a future release.\n', ...
                     '\nPlease use "cpp_bids(''init'')" instead.'])); %#ok<SPWRN>

    cpp_bids('init');

end
