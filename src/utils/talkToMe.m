% (C) Copyright 2020 CPP_BIDS developers

function talkToMe(cfg, message)
    if cfg.verbose > 0
        fprintf(1, message);
    end
end
