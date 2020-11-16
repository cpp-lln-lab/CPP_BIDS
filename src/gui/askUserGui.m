% (C) Copyright 2020 CPP_BIDS developers

function responses = askUserGui(questions, responses)
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

    % boolean for which question should be asked
    isQuestionToAsk = ~cellfun('isempty', questions.questionsToAsk(:, 1));

    responses = cellstr(string(responses(isQuestionToAsk)));

    responses = askQuestionsGui(questions, responses, isQuestionToAsk);

    % keep asking the question till we get a positive integer value for each
    for iQuestion = 1:size(questions.questionsToAsk)
        questions.questionsToAsk{iQuestion} = sprintf('%s %s\n %s', ...
                                                      '\color{red}', ...
                                                      questions.questionsToAsk{iQuestion}, ...
                                                      questions.mustBePositiveInteger);
    end

    while 1
        isQuestionToAsk = getIsQuestionToAsk(questions, responses);
        if all(~isQuestionToAsk)
            break
        end
        responses = askQuestionsGui(questions, responses, isQuestionToAsk);
    end

end

function resp = askQuestionsGui(quest, resp, isQuestionToAsk)

    opts.Interpreter = 'tex';

    fieldDim = repmat([1 50], sum(isQuestionToAsk), 1);

    currentResp = inputdlg(quest.questionsToAsk(isQuestionToAsk, 1), ...
                           'Subject info', ...
                           fieldDim, ...
                           resp(isQuestionToAsk), ...
                           opts);

    resp(isQuestionToAsk) = currentResp;

end
