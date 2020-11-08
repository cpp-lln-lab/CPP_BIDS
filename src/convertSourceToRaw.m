% (C) Copyright 2020 CPP_BIDS developers

function convertSourceToRaw(cfg)
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
