% (C) Copyright 2020 CPP_BIDS developers

function removeDateSuffix(filenames, subjectPath)
    %
    % Function removes the date suffix in a given filename(s)
    % Function will look for regular expression in filenames with ``_date-``

    %
    % USAGE::
    %
    %   removeDateSuffix(filenames, subjectPath)
    %
    % :param filenames: File names with _date- suffix
    % :type filenames: string
    %
    % :param subjectPath: Location/path of the files
    % :type subjectPath: string
    %
    % :output: - files are renamed by removing '_date-*' suffix

    if isempty(filenames)
        filenames = {};
    else
        filenames = cellstr(filenames);
    end

    for i = 1:numel(filenames)

        [~, name, ext] = fileparts(filenames{i});

        if strcmp(ext, '.gz')
            [~, name, ext2] = fileparts(name);
            ext = [ext2, ext]; %#ok<AGROW>
        end

        [parts, ~] = regexp(name, '(?:_date-)+', 'split', 'match');

        % remove suffix file if there was one
        if ~strcmp(filenames{i}, [parts{1} ext])
            movefile(fullfile(subjectPath, filenames{i}), ...
                     fullfile(subjectPath, [parts{1} ext]));
        end

    end

end
