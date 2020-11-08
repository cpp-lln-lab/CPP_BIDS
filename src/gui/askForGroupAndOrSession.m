% (C) Copyright 2020 CPP_BIDS developers

function cfg = askForGroupAndOrSession(cfg)

    askGrpSess = [true true];

    if isfield(cfg, 'subject') && ...
            isfield(cfg.subject, 'askGrpSess') && ...
            ~isempty(cfg.subject.askGrpSess)

        askGrpSess = cfg.subject.askGrpSess;

    end

    if numel(askGrpSess) < 2
        askGrpSess(2) = 1;
    end

    cfg.subject.askGrpSess = askGrpSess;

end
