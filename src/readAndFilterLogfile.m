function outputFiltered = readAndFilterLogfile(columnName, filterBy, saveOutputTsv, varargin)
    %
    % It will display in the command window the content of the ``output.tsv``
    % filtered by one element of a target column.
    %
    % USAGE::
    %
    %   outputFiltered = readAndFilterLogfile(columnName, filterBy, saveOutputTsv, tsvFile)
    %
    %   outputFiltered = readAndFilterLogfile(columnName, filterBy, saveOutputTsv, cfg)
    %
    % :param columnName: the header of the column where the content of interest is stored
    %                    (for example for ``trigger`` will be ``trial_type``)
    % :type columnName: char
    %
    % :param filterBy: The content of the column you want to filter out.
    %                  Relies on the ``filter`` transformer of bids.matlab
    %                  Supports:
    %
    %                    - ``>``, ``<``, ``>=``, ``<=``, ``==`` for numeric values
    %                    - ``==`` for string operation (case sensitive)
    %
    %                  For example, ``trial_type==trigger`` or `onset > 1`.
    % :type filterBy: char
    %
    % :param saveOutputTsv: flag to save the filtered output in a tsv file
    % :type saveOutputTsv: boolean
    %
    % :param tsvFile: TSV file to filter
    % :type tsvFile: string
    %
    % :param cfg: Configuration. See ``checkCFG()``. If ``cfg`` is given as input the name
    %             of the TSV file to read will be infered from there.
    % :type cfg: structure
    %
    % :returns:
    %
    %           :outputFiltered: dataset with only the specified content, to see it
    %                            in the command window use ``display(outputFiltered)``.
    %
    %
    % See also: bids.transformers.filter
    %
    %

    % (C) Copyright 2020 CPP_BIDS developers

    % Check if input is cfg or the file path and assign the output filename for later saving
    if ischar(varargin{1})

        tsvFile = varargin{1};

    elseif isstruct(varargin{1})

        tsvFile = fullfile(varargin{1}.dir.outputSubject, ...
                           varargin{1}.fileName.modality, ...
                           varargin{1}.fileName.events);

    end

    % Check if the file exists
    if ~exist(tsvFile, 'file')
        error([newline 'Input file does not exist: %s'], tsvFile);
    end

    try
        % Read the the tsv file and store each column in a field of `output` structure
        output = bids.util.tsvread(tsvFile);
    catch
        % Add the 'bids-matlab' in case is not in the path
        addpath(genpath(fullfile(pwd, '..', 'lib')));
        % Read the the tsv file and store each column in a field of `output` structure
        output = bids.util.tsvread(tsvFile);
    end

    transformers{1} = struct('Name', 'Filter', ...
                             'Input', columnName, ...
                             'Query', filterBy);

    output = bids.transformers(transformers, output);

    % remove nans
    if isnumeric(output.(columnName))
        rowsToRemove = isnan(output.(columnName));
    elseif iscell(output.(columnName))
        rowsToRemove = cellfun(@(x) numel(x) == 1 && isnan(x), ...
                               output.(columnName));
    end
    listFields = fieldnames(output);
    for iField = 1:numel(listFields)
        output.(listFields{iField})(rowsToRemove) = [];
    end

    % Convert the structure to dataset
    try
        outputFiltered = struct2dataset(output);
    catch
        % dataset not yet supported by octave
        outputFiltered = output;
    end

    if saveOutputTsv

        % Create tag to add to output file in case you want to save it
        outputFilterTag = ['_filteredOn-' columnName '.tsv'];

        % Create output file name
        outputFileName = strrep(tsvFile, '.tsv', outputFilterTag);

        bids.util.tsvwrite(outputFileName, output);

    end

end
