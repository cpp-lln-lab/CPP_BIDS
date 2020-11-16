% (C) Copyright 2020 CPP_BIDS developers

function responses = askUserCli(questions, responses)
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
    % response = askUserCli(questions)
    %
    % command line interface to ask questions to user
    %

    for iQuestion = 1:size(questions.questionsToAsk, 1)

        if ~isempty(questions.questionsToAsk{iQuestion, 1})

            thisResponse = ...
                input(['\n' questions.questionsToAsk{iQuestion, 1}], 's'); %#ok<*AGROW>

            if questions.questionsToAsk{iQuestion, 2}
                thisResponse = checkInput(thisResponse, questions);
            end

            responses{iQuestion, 1} = thisResponse;

        end

    end

end

function input2check = checkInput(input2check, questions)
    % this function checks the input to makes sure the user enters a positive integer
    input2check = str2double(input2check);
    while ~isPositiveInteger(input2check)
        input2check = str2double(input(questions.mustBePositiveInteger, 's'));
    end

end
