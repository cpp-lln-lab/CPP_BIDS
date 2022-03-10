function [items, cfg] = createQuestionnaire(cfg)
    %
    % It creates a list of default questions to ask the users regarding:
    %   - the subj number
    %   - the run number
    %   - the group ID (if recquired by user)
    %   - and session nb (if recquired by user)
    %
    % USAGE::
    %
    %   [questions] = createQuestionnaire(cfg)
    %
    % :param cfg: Configuration. See ``checkCFG()``.
    % :type cfg: structure
    %
    % :returns:
    %           :questionnaire: (structure) It contains the questions list to ask
    %                           and if the response given to one question
    %                           must be checked to be a positive integer.
    %
    % (C) Copyright 2020 CPP_BIDS developers

    if nargin < 1
        cfg = struct('debug', []);
    end

    if ~isfield(cfg, 'debug') || isempty(cfg.debug)
        cfg.debug.do = false;
    end

    cfg = askForGroupAndOrSession(cfg);

    items = returnDefaultQuestionnaire(cfg);

    % check pre filled answers
    fields = {'subjectGrp', 'subjectNb', 'sessionNb', 'runNb'};
    for i = 1:numel(fields)
        if isfield(cfg.subject, fields{i})
            items(i).response = cfg.subject.(fields{i});
        end
    end

    % subject group
    if ~cfg.subject.askGrpSess(1)
        items(1).show = false;
    end

    % the session number
    if  ~cfg.subject.askGrpSess(2)
        items(3).show = false;
    end

end
