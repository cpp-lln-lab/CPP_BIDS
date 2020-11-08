% (C) Copyright 2020 CPP_BIDS developers

function removeDateSuffix(filenames, subjectPath)
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
    % removeDateSuffix(filenames, subjectPath)
    %
    %

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
