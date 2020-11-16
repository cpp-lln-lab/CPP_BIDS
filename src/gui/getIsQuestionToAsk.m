% (C) Copyright 2020 CPP_BIDS developers

function isQuestionToAsk = getIsQuestionToAsk(questions, responses)
    %
    % While using the GUI interface to input the experiment information, it flags any question that
    % will be presented in the GUI. If a response is not valid (e.g. is not an integer) it will keep
    % flagging it as a 'question to ask' and represent the GUI.
    %
    % USAGE::
    %
    %   isQuestionToAsk = getIsQuestionToAsk(questions, responses)
    %
    % :param questions: It contains the questions list to ask and if the response given to one
    %                   question must be checked to be an integer.
    % :type questions: structure
    % :param responses: It contains the responses set by default or as input by the user
    % :type responses: cell
    %
    % :returns: - :argout1: (type) (dimension)
    %           - :argout2: (type) (dimension)
    %

    isQuestionToAsk = cell2mat(questions.questionsToAsk(:, 2));
    for j = 1:size(isQuestionToAsk, 1)
        input2check = str2double(responses{j});
        isQuestionToAsk(j, 2) = ~isPositiveInteger(input2check);
    end
    isQuestionToAsk = all(isQuestionToAsk, 2);

end
