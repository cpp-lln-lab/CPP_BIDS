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
    counterpart = {'group', 'subject', 'session', 'run'};
    for i = 1:numel(fields)
        if isfield(cfg.subject, fields{i})
            items.(counterpart{i}).response = cfg.subject.(fields{i});
        end
    end

    if ~ismember('grp', cfg.subject.ask)
        items.group.show = false;
    end
    if  ~ismember('ses', cfg.subject.ask)
        items.session.show = false;
    end
    if  ~ismember('run', cfg.subject.ask)
        items.run.show = false;
    end

end
