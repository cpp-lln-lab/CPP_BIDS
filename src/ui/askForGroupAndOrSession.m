function cfg = askForGroupAndOrSession(cfg)
    %
    % It checks ``cfg`` if ``group``, ``session``, ``run`` are required
    % in ``cfg.subject.ask`` by the user.
    % If not specified, it will add these by default.
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
    %

    % (C) Copyright 2020 CPP_BIDS developers

    if isempty(cfg)

        cfg = struct('subject', struct('ask', {{'grp', 'ses', 'run'}}));

    end

    if ~isfield(cfg, 'subject')

        cfg.subject.ask = {'grp', 'ses', 'run'};

    end

    if isfield(cfg, 'subject') && ...
       ~isfield(cfg.subject, 'ask')

        cfg.subject.ask = {'grp', 'ses', 'run'};

    end

end
