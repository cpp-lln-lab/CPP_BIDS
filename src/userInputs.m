% (C) Copyright 2020 CPP_BIDS developers

function cfg = userInputs(cfg)
    % cfg = userInputs(cfg)
    %
    % Get subject, run and session number and make sure they are
    % positive integer values.
    % Will do ii with a graphic interface if possible.
    %
    % expParameters.subject.askGrpSess
    % a 1 X 2 array of booleans (default is [true true] ):
    %    - the first value set to false will skip asking for the participants
    %    group
    %    - the second value set to false will skip asking for the session

    if nargin < 1
        cfg = struct('debug', []);
    end

    cfg = checkCFG(cfg);

    [cfg, responses] = setDefaultResponses(cfg);

    if ~cfg.debug.do

        questions = createQuestionList(cfg);

        if cfg.useGUI

            try
                responses = askUserGui(questions, responses);
            catch
                responses = askUserCli(questions, responses);
            end

        else

            responses = askUserCli(questions, responses);

        end

    end

    cfg.subject.subjectGrp = responses{1, 1};
    cfg.subject.subjectNb = responses{2, 1};
    cfg.subject.sessionNb = responses{3, 1};
    cfg.subject.runNb = responses{4, 1};

end
