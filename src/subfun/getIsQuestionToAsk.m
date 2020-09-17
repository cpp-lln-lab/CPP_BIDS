% (C) Copyright 2020 CPP_BIDS developers

function isQuestionToAsk = getIsQuestionToAsk(questions, responses)

    isQuestionToAsk = cell2mat(questions.questionsToAsk(:, 2));
    for j = 1:size(isQuestionToAsk, 1)
        input2check = str2double(responses{j});
        isQuestionToAsk(j, 2) = ~isPositiveInteger(input2check);
    end
    isQuestionToAsk = all(isQuestionToAsk, 2);

end
