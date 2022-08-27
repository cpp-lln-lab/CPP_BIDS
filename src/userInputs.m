function cfg = userInputs(cfg)
    %
    % Get subject, run and session number and make sure they are
    % positive integer values.
    % Can do a graphic user interface if ``cfg.useGUI`` is set to ``true``
    %
    % USAGE::
    %
    %   cfg = userInputs(cfg)
    %
    % :param cfg: Configuration. See ``checkCFG()``.
    % :type cfg: structure
    %
    % :returns:
    %
    %           :cfg: (structure) Configuration update with the name of info about the
    %                 participants.
    %
    % Behavior of this functions depends on ``cfg.subject.askGrpSess``
    % a 1 X 2 array of booleans (default is ``[true true]``):
    %
    % - the first value set to ``false`` will skip asking for the participants group
    % - the second value set to ``false`` will skip asking for the session
    %
    % (C) Copyright 2020 CPP_BIDS developers

    if nargin < 1
        cfg = struct('debug', []);
    end

    cfg = checkCFG(cfg);

    [items, cfg] = createQuestionnaire(cfg);

    if cfg.useGUI

        items = askUserGui(items);

    else

        items = askUserCli(items);

    end

    cfg.subject.subjectGrp = items.group.response;
    cfg.subject.subjectNb = items.subject.response;
    cfg.subject.sessionNb = items.session.response;
    cfg.subject.runNb = items.run.response;

end
