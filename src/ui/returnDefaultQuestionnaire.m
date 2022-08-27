function [items, cfg] = returnDefaultQuestionnaire(cfg)
    %
    %  Set default questions for subject / session / run number and group ID.
    %  Also sets default values for those when in debug mode.
    %
    %   USAGE ::
    %
    %     q = returnDefaultQuestionnaire()
    %
    % (C) Copyright 2022 CPP_BIDS developers

    if nargin < 1
        cfg = struct('debug', []);
    end

    if ~isfield(cfg, 'debug') || isempty(cfg.debug)
        cfg.debug.do = false;
    end

    items.group = struct('question', 'Enter subject group (leave empty if none): ', ...
                         'response', '', ...
                         'mustBePosInt', false, ...
                         'show', true);

    items.subject.question = 'Enter subject number (1-999): ';
    items.subject.response = '';
    items.subject.mustBePosInt = true;
    items.subject.show = true;

    items.session.question = 'Enter the session number (i.e day ; 1-999): ';
    items.session.response = '';
    items.session.mustBePosInt = true;
    items.session.show = true;

    items.run.question = 'Enter the run number (1-999): ';
    items.run.response = '';
    items.run.mustBePosInt = true;
    items.run.show = true;

    if cfg.debug.do

        items.group.response = 'ctrl';
        items.subject.response = 666;
        items.session.response = 666;
        items.run.response = 666;

        cfg.subject.subjectGrp = items.group.response;
        cfg.subject.subjectNb = items.subject.response;
        cfg.subject.sessionNb = items.session.response;
        cfg.subject.runNb = items.run.response;

    end

end
