% (C) Copyright 2020 CPP_BIDS developers

function responses = askUserGui(questions, responses)

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
