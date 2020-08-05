function convertSourceToRaw(cfg)
    % convertSourceToRaw(cfg)
    %
    % attempts to convert a source dataset created with CPP_BIDS into a valid
    % BIDS data set.
    % - creates dummy README and CHANGE file
    % - copy source dir to raw dir
    % - remove the date suffix (_date-YYYYMMDDHHMM) from the files where it is present
    %
    % Only covers func folder at the moment

    sourceDir = fullfile(cfg.dir.output, 'source');
    rawDir = fullfile(cfg.dir.output, 'rawdata');

    % add dummy README and CHANGE file
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

    % go through the subject files and parses them to remove the date suffix
    for su = 1:numel(subjects)

        sess = cellstr(file_utils('List', fullfile(rawDir, subjects{su}), 'dir', '^ses-.*$'));

        for se = 1:numel(sess)
            parseFunc(rawDir, subjects{su}, sess{se});
        end

    end

end




