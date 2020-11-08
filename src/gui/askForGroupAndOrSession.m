% (C) Copyright 2020 CPP_BIDS developers

function cfg = askForGroupAndOrSession(cfg)
    %
    % Short description of what the function does goes here.
    %
    % USAGE::
    %
    %   [argout1, argout2] = templateFunction(argin1, [argin2 == default,] [argin3])
    %
    % :param argin1: (dimension) obligatory argument. Lorem ipsum dolor sit amet,
    %                consectetur adipiscing elit. Ut congue nec est ac lacinia.
    % :type argin1: type
    % :param argin2: optional argument and its default value. And some of the
    %               options can be shown in litteral like ``this`` or ``that``.
    % :type argin2: string
    % :param argin3: (dimension) optional argument
    % :type argin3: integer
    %
    % :returns: - :argout1: (type) (dimension)
    %           - :argout2: (type) (dimension)
    %

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
