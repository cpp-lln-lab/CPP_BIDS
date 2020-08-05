function parseFunc(rawDir, subjName, sesName)
    % parseFunc(rawDir, subjName, sesName)
    %

    subjectPath = fullfile(rawDir, subjName, sesName, 'func');

    if exist(subjectPath, 'dir')

        % do events
        filenames = file_utils('List', subjectPath, ...
            sprintf('^%s.*_task-.*_events_date-.*$', subjName));

        removeDateSuffix(filenames, subjectPath);

        % do bold
        filenames = file_utils('List', subjectPath, ...
            sprintf('^%s.*_task-.*_bold_date-.*$', subjName));

        removeDateSuffix(filenames, subjectPath);

        % do stim
        filenames = file_utils('List', subjectPath, ...
            sprintf('^%s.*_task-.*_stim_date-.*tsv$', subjName));
        compressFiles(filenames, subjectPath);
        filenames = file_utils('List', subjectPath, ...
            sprintf('^%s.*_task-.*_stim_date-.*tsv.gz$', subjName));
        removeDateSuffix(filenames, subjectPath);

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
