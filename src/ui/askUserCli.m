function varargout = askUserCli(items)
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
    % (C) Copyright 2020 CPP_BIDS developers

    for i = 1:numel(items)

        if isempty(items(i).question)
            items(i).show = false;
        end

        % no need to show pre filled items
        if items(i).mustBePosInt && isPositiveInteger(items(i).response)
            items(i).show = false;
        elseif ~isempty(items(i).response) && ischar(items(i).response)
            items(i).show = false;
        end

        while items(i).show

            items(i).response = input(['\n' items(i).question], 's'); %#ok<*AGROW>

            if items(i).mustBePosInt

                items(i).response = str2double(items(i).response);

                if ~isPositiveInteger(items(i).response)
                    items(i).question = 'Please enter a positive integer: ';
                    items(i).show = true;
                else
                    items(i).show = false;
                end

            else

                items(i).show = false;

            end

        end

    end

    varargout = {items};

end
