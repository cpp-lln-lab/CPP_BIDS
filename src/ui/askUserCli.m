function varargout = askUserCli(items)
    %
    % It shows the questions to ask in the command window and checks, when it is necessary, if the
    % given input by the user is an integer.
    %
    % USAGE::
    %
    %   items = askUserCli(items)
    %
    % :param items: It contains the questions list to ask and if the response given to one
    %                   question must be checked to be a positive integer.
    % :type items: structure
    %
    % EXAMPLE::
    %
    %   items = returnDefaultQuestionnaire();
    %   items = askUserCli(items);
    %
    %
    % See also: createQuestionnaire
    %
    %

    % (C) Copyright 2020 CPP_BIDS developers

    fields = fieldnames(items);

    for i = 1:numel(fields)

        if isempty(items.(fields{i}).question)
            items.(fields{i}).show = false;
        end

        % no need to show pre filled items
        if ~isempty(items.(fields{i}).response)

            if items.(fields{i}).mustBePosInt && ...
                isPositiveInteger(items.(fields{i}).response)
                items.(fields{i}).show = false;

            elseif ischar(items.(fields{i}).response)
                items.(fields{i}).show = false;

            end

        end

        while items.(fields{i}).show

            items.(fields{i}).response = input(['\n' items.(fields{i}).question], 's'); %#ok<*AGROW>

            if items.(fields{i}).mustBePosInt

                items.(fields{i}).response = str2double(items.(fields{i}).response);

                if ~isPositiveInteger(items.(fields{i}).response)
                    items.(fields{i}).question = 'Please enter a positive integer: ';
                    items.(fields{i}).show = true;
                else
                    items.(fields{i}).show = false;
                end

            else

                items.(fields{i}).show = false;

            end

        end

    end

    varargout = {items};

end
