% (C) Copyright 2020 CPP_BIDS developers

function responses = askUserGui(questions, responses)
    %
    % It shows the questions to ask in in a GUI interface and checks, when it is necessary, if the
    % given input by the user is a positive integer. If not, it keeps showing the
    % GUI interface.
    %
    % USAGE::
    %
    %   [responses] = askUserGui(questions, responses)
    %
    % :param questions: It contains the questions list to ask and if the response given to one
    %                   question must be checked to be an integer number.
    % :type questions: structure
    % :param responses: It contains the responses set by default.
    % :type responses: cell
    %
    % :returns: - :responses: (cell) Response updated with the user inputs.
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
