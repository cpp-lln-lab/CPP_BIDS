% (C) Copyright 2020 CPP_BIDS developers

function isQuestionToAsk = getIsQuestionToAsk(questions, responses)
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

    isQuestionToAsk = cell2mat(questions.questionsToAsk(:, 2));
    for j = 1:size(isQuestionToAsk, 1)
        input2check = str2double(responses{j});
        isQuestionToAsk(j, 2) = ~isPositiveInteger(input2check);
    end
    isQuestionToAsk = all(isQuestionToAsk, 2);

end
