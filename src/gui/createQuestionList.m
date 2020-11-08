% (C) Copyright 2020 CPP_BIDS developers

function questions = createQuestionList(cfg)
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
    end

    % the subject number
    questions.questionsToAsk{2, 1} = questions.subject;
    questions.questionsToAsk{2, 2} = true;

    % the session number
    if  cfg.subject.askGrpSess(2)
        questions.questionsToAsk{3, 1} = questions.session;
        questions.questionsToAsk{3, 2} = true;
    end

    % the run number
    questions.questionsToAsk{4, 1} = questions.run;
    questions.questionsToAsk{4, 2} = true;

end
