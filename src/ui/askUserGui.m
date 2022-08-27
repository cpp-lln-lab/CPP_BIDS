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

    fields = fieldnames(items);

    for  i = 1:numel(fields)

        question = items.(fields{i}).question;
        response = items.(fields{i}).response;
        show = items.(fields{i}).show;

        % no need to show empty questions
        if isempty(question)
            show = false;
        end

        % no need to show pre filled items
        if ~isempty(response)

            if items.(fields{i}).mustBePosInt && isPositiveInteger(response)
                show = false;

            elseif ischar(response)
                show = false;

            end

        end

        if show &&  ~ischar(response) && isempty(response)
            response = '';
        end

        items.(fields{i}).question = question;
        items.(fields{i}).response = response;
        items.(fields{i}).show = show;

    end

    refItems = items;

    while any(toShow(items))

        items = askQuestionsGui(items);

        fields = fieldnames(items);

        for i = 1:numel(fields)

            thisItem = items.(fields{i});

            if ~thisItem.show
                continue
            end

            thisItem.show = false;

            if thisItem.mustBePosInt

                thisItem.response = str2double(thisItem.response);

                if ~isPositiveInteger(thisItem.response)
                    thisItem.question = sprintf('%s %s\n %s', ...
                                                '\color{red}', ...
                                                refItems.(fields{i}).question, ...
                                                'Please enter a positive integer');

                    thisItem.show = true;
                    thisItem.response = '';
                end

            end

            items.(fields{i}) = thisItem;

        end

    end

end

function items = askQuestionsGui(items)

    opts.Interpreter = 'tex';

    fieldDim = repmat([1 50], sum(toShow(items)), 1);

    questions = {};
    responses = {};

    fields = fieldnames(items);
    for i = 1:numel(fields)
        if items.(fields{i}).show
            questions{end + 1} = items.(fields{i}).question;
            responses{end + 1} = items.(fields{i}).response;
        end
    end

    currentResp = inputdlg(questions, 'Subject info', fieldDim, responses, opts);

    idx = find(toShow(items));
    for i = 1:numel(idx)
        items.(fields{idx(i)}).response = currentResp{i};
    end

end

function status = toShow(items)

    status = [];

    fields = fieldnames(items);
    for i = 1:numel(fields)
        status(end + 1) = items.(fields{i}).show;
    end

end
