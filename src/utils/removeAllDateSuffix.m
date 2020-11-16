% (C) Copyright 2020 CPP_BIDS developers

function removeAllDateSuffix(rawDir, subjName, sesName)
    %
    % Function removes the date suffix in the _events and _stim.tsv files in 
    % given raw, session and subject folder. And zips the _stim.tsv files.
    %
    % USAGE::
    %
    %   removeAllDateSuffix(rawDir, subjName, sesName)
    %
    % :param rawDir: obligatory argument. 
    % :type rawDir: string
    % :param subjName: obligatory argument. Some of the
    %               options can be ``sub-001`` or ``sub-pilot001``.
    % :type subjName: string
    % :param sesName: obligatory argument. Some of the
    %               options can be ``ses-001`` or ``ses-003``.
    % :type sesName: string
    %
    % :returns: - files are renamed after removing 'yyyymmddHHMM' date
    %         suffix.
    %
    %
    % 
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
