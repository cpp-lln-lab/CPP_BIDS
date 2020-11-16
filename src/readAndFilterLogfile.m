% (C) Copyright 2020 CPP_BIDS developers

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
    %                    (for example for ``trigger`` will be ``trial type``)
    % :type columnName: string
    % :param filterBy: the content of the column you want to filter out. It can take just
    %                  part of the content name (for example, if you want to display the triggers
    %                  and you have ``trigger_motion`` and ``trigger_static``,
    %                  ``trigger`` as input will do)
    % :type filterBy: string
    % :param saveOutputTsv: flag to save output on file
    % :type saveOutputTsv: boolean
    % :param tsvFile: TSV file to filter
    % :type tsvFile: string
    % :param cfg: Configuration. See ``checkCFG()``. If ``cfg`` is given as input the name
    %             of the TSV file to read will be infered from there.
    % :type cfg: structure
    %
    % :returns:
    %
    %           :outputFiltered: dataset with only the specified content, to see it
    %                            in the command window use ``display(outputFiltered)``.
    %

    % Create tag to add to output file in case you want to save it
    outputFilterTag = ['_filteredBy-' columnName '_' filterBy '.tsv'];

    % Checke if input is cfg or the file path and assign the output filename for later saving
    if ischar(varargin{1})

        tsvFile = varargin{1};

    elseif isstruct(varargin{1})

        tsvFile = fullfile(varargin{1}.dir.outputSubject, ...
                           varargin{1}.fileName.modality, ...
                           varargin{1}.fileName.events);

    end

    % Create output file name
    outputFileName = strrep(tsvFile, '.tsv', outputFilterTag);

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

    % Get the index of the target contentent to filter and display
    filterIdx = strncmp(output.(columnName), filterBy, length(filterBy));

    % apply the filter
    listFields = fieldnames(output);
    for iField = 1:numel(listFields)
        output.(listFields{iField})(~filterIdx) = [];
    end

    output = convertStruct(output);

    % Convert the structure to dataset
    try
        outputFiltered = struct2dataset(output);
    catch
        %dataset not yet supported by octave
        outputFiltered = output;
    end

    if saveOutputTsv
        % convert back to struc to save in .tsv 
        outputFiltered = dataset2struct(outputFiltered);
        bids.util.tsvwrite(outputFileName, outputFiltered);

    end

end

function structure = convertStruct(structure)
    % changes the structure
    %
    % from struct.field(i,1) to struct(i,1).field(1)

    fieldsList = fieldnames(structure);
    tmp = struct();

    for iField = 1:numel(fieldsList)
        for i = 1:numel(structure.(fieldsList{iField}))
            tmp(i, 1).(fieldsList{iField}) =  structure.(fieldsList{iField})(i, 1);
        end
    end

    structure = tmp;

end
