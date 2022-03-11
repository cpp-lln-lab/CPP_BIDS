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

    while any([items.show])

        items = askQuestionsGui(items);

        idx = find([items.show]);
        for i = 1:numel(idx)

            if items(idx(i)).mustBePosInt

                items(idx(i)).response = str2double(items(i).response);

                if ~isPositiveInteger(items(i).response)
                    items(idx(i)).question = 'Please enter a positive integer: ';
                    items(idx(i)).show = true;
                    items(idx(i)).response = '';
                else
                    items(idx(i)).show = false;
                end

            else

                items(idx(i)).show = false;

            end

        end

    end

    %     % boolean for which question should be asked
    %     isQuestionToAsk = ~cellfun('isempty', questions.questionsToAsk(:, 1));
    %
    %     responses = cellstr(string(responses(isQuestionToAsk)));
    %
    %     responses = askQuestionsGui(questions, responses, isQuestionToAsk);
    %
    %     % keep asking the question till we get a positive integer value for each
    %     for iQuestion = 1:size(questions.questionsToAsk)
    %         questions.questionsToAsk{iQuestion} = sprintf('%s %s\n %s', ...
    %                                                       '\color{red}', ...
    %                                                       questions.questionsToAsk{iQuestion}, ...
    %                                                       questions.mustBePositiveInteger);
    %     end
    %

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
