function convertSourceToRaw(cfg)
    % convertSourceToRaw(cfg)
    %
    % attempts to convert a source dataset created with CPP_BIDS into a valid
    % BIDS data set.
    % - creates dummy README and CHANGE file
    % - copy source dir to raw dir
    % - remove the date suffix (_date-YYYYMMDDHHMM) from the files where it is present
    %

    sourceDir = fullfile(cfg.dir.output, 'source');
    rawDir = fullfile(cfg.dir.output, 'rawdata');

    % add dummy readme and change file
    copyfile(fullfile( ...
        fileparts(mfilename('fullpath')), '..', 'dummyData', 'README'), ...
        sourceDir);
    copyfile(fullfile( ...
        fileparts(mfilename('fullpath')), '..', 'dummyData', 'CHANGES'), ...
        sourceDir);

    copyfile(sourceDir, rawDir);

    % list subjects
    subjects = cellstr(file_utils('List', rawDir, 'dir', '^sub-.*$'));

    if isequal(subjects, {''})
        error('No subjects found in BIDS directory.');
    end

    for su = 1:numel(subjects)

        sess = cellstr(file_utils('List', fullfile(rawDir, subjects{su}), 'dir', '^ses-.*$'));

        for se = 1:numel(sess)
            parseFunc(rawDir, subjects{su}, sess{se});
        end

    end

end

function parseFunc(rawDir, subjName, sesName)

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

    end
end

function removeDateSuffix(filenames, subjectPath)
    if isempty(filenames)
        filenames = {};
    else
        filenames = cellstr(filenames);
    end

    for i = 1:numel(filenames)

        [~, name, ext] = fileparts(filenames{i});

        [parts, ~] = regexp(name, '(?:_date-)+', 'split', 'match');

        movefile(fullfile(subjectPath, filenames{i}), ...
            fullfile(subjectPath, [parts{1} ext]));

    end
end
