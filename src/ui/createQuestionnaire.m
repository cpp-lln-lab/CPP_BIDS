function [items, cfg] = createQuestionnaire(cfg)
    %
    % It creates a list of default questions to ask the users regarding:
    %
    %   - the subj number
    %   - the run number
    %   - the group ID (if required by user)
    %   - and session nb (if required by user)
    %
    % USAGE::
    %
    %   [items, cfg] = createQuestionnaire(cfg)
    %
    % :param cfg: Configuration. See ``checkCFG()``.
    % :type cfg: structure
    %
    % :returns:
    %           :items: (structure) It contains the questions list to ask
    %                           and if the response given to one question
    %                           must be checked to be a positive integer.
    %
    %
    % EXAMPLE
    %
    %   items(1).question = 'Enter subject number (1-999): ';
    %   items(1).response = '';
    %   items(1).mustBePosInt = true;
    %   items(1).show = true;
    %
    %
    % See also: returnDefaultQuestionnaire
    %
    % (C) Copyright 2020 CPP_BIDS developers

    if nargin < 1
        cfg = struct('debug', []);
    end

    if ~isfield(cfg, 'debug') || isempty(cfg.debug)
        cfg.debug.do = false;
    end

    cfg = askForGroupAndOrSession(cfg);

    [items, cfg] = returnDefaultQuestionnaire(cfg);

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
