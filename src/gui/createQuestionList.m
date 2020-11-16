% (C) Copyright 2020 CPP_BIDS developers

function questions = createQuestionList(cfg)
    %
    % It creates a list of default questions to ask the users regarding the subj ID, the run number,
    % the group ID (if recquired by user) and session nb (if recquired by user).
    %
    % USAGE::
    %
    %   [questions] = createQuestionList(cfg)
    %
    % :param cfg: Configuration. See ``checkCFG()``.
    % :type cfg: structure
    %
    % :returns:
    %           :questions: (structure) It contains the questions list to ask and if the response
    %                       given to one question must be checked to be a positive integer.
    %

    cfg = askForGroupAndOrSession(cfg);

    questions.group = 'Enter subject group (leave empty if none): ';
    questions.subject = 'Enter subject number (1-999): ';
    questions.session = 'Enter the session number (i.e day ; 1-999): ';
    questions.run = 'Enter the run number (1-999): ';
    questions.mustBePositiveInteger = 'Please enter a positive integer: ';
    % questions.questionsToAsk is a cell array : second column is a boolean
    % set to true if we must run inputCheck on the response
    questions.questionsToAsk = cell(4, 2);

    % subject group
    if cfg.subject.askGrpSess(1)
        questions.questionsToAsk{1, 1} = questions.group;
        questions.questionsToAsk{1, 2} = false;
    else
        questions.questionsToAsk{1, 2} = false;
    end

    % the subject number
    questions.questionsToAsk{2, 1} = questions.subject;
    questions.questionsToAsk{2, 2} = true;

    % the session number
    if  cfg.subject.askGrpSess(2)
        questions.questionsToAsk{3, 1} = questions.session;
        questions.questionsToAsk{3, 2} = true;
    else
        questions.questionsToAsk{3, 2} = false;
    end

    % the run number
    questions.questionsToAsk{4, 1} = questions.run;
    questions.questionsToAsk{4, 2} = true;

end
