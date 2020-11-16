% (C) Copyright 2020 CPP_BIDS developers

function removeAllDateSuffix(rawDir, subjName, sesName)
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
    % removeAllDateSuffix(rawDir, subjName, sesName)
    %

    labels = {'func', 'bold', 'eeg', 'ieeg', 'meg', 'beh'};

    for iModality = 1:numel(labels)

        subjectPath = fullfile(rawDir, subjName, sesName, labels{iModality});

        if exist(subjectPath, 'dir')

            % do events
            filenames = file_utils('List', subjectPath, ...
                                   sprintf('^%s.*_task-.*_events_date-.*$', subjName));

            removeDateSuffix(filenames, subjectPath);

            for iLabel = 1:numel(labels)
                filenames = file_utils('List', subjectPath, ...
                                       sprintf('^%s.*_task-.*_%s_date-.*$', ...
                                               subjName, labels{iLabel}));

                removeDateSuffix(filenames, subjectPath);
            end

            % do stim
            filenames = file_utils('List', subjectPath, ...
                                   sprintf('^%s.*_task-.*_stim_date-.*json$', subjName));
            removeDateSuffix(filenames, subjectPath);

            filenames = file_utils('List', subjectPath, ...
                                   sprintf('^%s.*_task-.*_stim_date-.*tsv$', subjName));
            compressFiles(filenames, subjectPath);
            filenames = file_utils('List', subjectPath, ...
                                   sprintf('^%s.*_task-.*_stim_date-.*tsv.gz$', subjName));
            removeDateSuffix(filenames, subjectPath);

        end

    end
end

function compressFiles(filenames, subjectPath)
    if isempty(filenames)
        filenames = {};
    else
        filenames = cellstr(filenames);
    end

    for i = 1:numel(filenames)

        gzip(fullfile(subjectPath, filenames{i}));
        delete(fullfile(subjectPath, filenames{i}));

    end
end
