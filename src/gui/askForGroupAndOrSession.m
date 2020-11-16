% (C) Copyright 2020 CPP_BIDS developers

function cfg = askForGroupAndOrSession(cfg)
    %
    % It checks ``cfg`` if ``group`` and ``session`` are recquired in ``cfg.subject.askGrpSess`` by
    % the user. If not specified, it will add these as ``true`` by default.
    %
    % USAGE::
    %
    %   [cfg] = askForGroupAndOrSession(cfg)
    %
    % :param cfg: Configuration. See ``checkCFG()``.
    % :type cfg: structure
    %
    % :returns:
    %           :cfg: (structure) Configuration update with the instructions if to ask for ``group``
    %                 and ``session``.

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
