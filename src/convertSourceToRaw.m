% (C) Copyright 2020 CPP_BIDS developers

function convertSourceToRaw(cfg)
    %
    % Function attempts to convert a source dataset created with CPP_BIDS into a valid
    % BIDS data set.
    %
    %
    % USAGE::
    %
    %   convertSourceToRaw(cfg)
    %
    % :param cfg: cfg structure is needed only for providing the path in ``cfg.dir.output``.
    % :type cfg: structure
    %
    % :output:
    %          - :creates: a dummy README and CHANGE file
    %          - :copies: ``source`` directory to ``raw`` directory
    %          - :removes: the date suffix ``_date-*`` from the files where it is present
    %          - :zips: the ``_stim.tsv`` files.

    sourceDir = fullfile(cfg.dir.output, 'source');
    rawDir = fullfile(cfg.dir.output, 'raw');

    % add dummy README and CHANGE file
    copyfile(fullfile( ...
                      fileparts(mfilename('fullpath')), '..', 'manualTests', 'dummyData', ...
                      'README'), ...
             sourceDir);
    copyfile(fullfile( ...
                      fileparts(mfilename('fullpath')), '..', 'manualTests', 'dummyData', ...
                      'CHANGES'), ...
             sourceDir);
    copyfile(fullfile( ...
                      fileparts(mfilename('fullpath')), '..', 'manualTests', 'dummyData', ...
                      '.bidsignore'), ...
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
            removeAllDateSuffix(rawDir, subjects{su}, sess{se});
        end

    end

end
