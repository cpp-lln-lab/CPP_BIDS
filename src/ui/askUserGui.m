function items = askUserGui(items)
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
    % (C) Copyright 2020 CPP_BIDS developers

    for  i = 1:numel(items)

        if isempty(items(i).question)
            items(i).show = false;
        end

        % no need to show pre filled items
        if ~isempty(items(i).response)

            if items(i).mustBePosInt && isPositiveInteger(items(i).response)
                items(i).show = false;

            elseif ischar(items(i).response)
                items(i).show = false;

            end

        end

        if items(i).show && ~ischar(items(i).response) && isempty(items(i).response)
            items(i).response = '';
        end

    end

    refItems = items;

    while any([items.show])

        items = askQuestionsGui(items);

        idx = find([items.show]);
        for i = 1:numel(idx)

            thisItem = items(idx(i));

            if thisItem.mustBePosInt

                thisItem.response = str2double(thisItem.response);

                if ~isPositiveInteger(thisItem.response)
                    thisItem.question = sprintf('%s %s\n %s', ...
                                                '\color{red}', ...
                                                refItems(idx(i)).question, ...
                                                'Please enter a positive integer');

                    thisItem.show = true;
                    thisItem.response = '';
                else
                    thisItem.show = false;
                end

            else

                thisItem.show = false;

            end

            items(idx(i)) = thisItem;

        end

    end

end

function items = askQuestionsGui(items)

    opts.Interpreter = 'tex';

    fieldDim = repmat([1 50], sum([items.show]), 1);

    currentResp = inputdlg({items([items.show]).question}, ...
                           'Subject info', ...
                           fieldDim, ...
                           {items([items.show]).response}, ...
                           opts);

    idx = find([items.show]);
    for i = 1:numel(idx)
        items(idx(i)).response = currentResp{i};
    end

end
