% (C) Copyright 2020 CPP_BIDS developers

function removeAllDateSuffix(rawDir, subjName, sesName)
    %
    % Function removes the date suffix in the _events and _stim (.tsv and .json)
    % files in given raw, session and subject folder. And zips the _stim files.
    % Function will look for files with suffix of ``_date-*``
    %
    % USAGE::
    %
    %   removeAllDateSuffix(rawDir, subjName, sesName)
    %
    % :param rawDir: BIDS raw folder directory.
    % :type rawDir: string
    %
    % :param subjName: Some of the options can be ``sub-001`` or ``sub-pilot001``.
    % :type subjName: string
    %
    % :param sesName: Some of the options can be ``ses-001`` or ``ses-003``.
    % :type sesName: string

    % :output: - files are renamed by removing '_date-*' suffix
    %         and _stim files are zipped

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
