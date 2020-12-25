% (C) Copyright 2020 CPP_BIDS developers

function responses = askUserCli(questions, responses)
    %
    % It shows the questions to ask in the command window and checks, when it is necessary, if the
    % given input by the user is an integer.
    %
    % USAGE::
    %
    %   [responses] = askUserCli(questions, responses)
    %
    % :param questions: It contains the questions list to ask and if the response given to one
    %                   question must be checked to be a positive integer.
    % :type questions: structure
    % :param responses: It contains the responses set by default.
    % :type responses: cell
    %
    % :returns: - :responses: (cell) Response updated with the user inputs.
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
