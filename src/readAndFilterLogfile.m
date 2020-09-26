function outputFiltered = readAndFilterLogfile(columnName, filterBy, saveOutputTsv, varargin)
    % outputFiltered = readOutputFilter(filterHeader, filterContent, varargin)
    %
    % It will display in the command window the content of the `output.tsv' filtered by one element
    % of a target column.
    %
    % DEPENDENCIES:
    %  - bids_matlab (from CPP_BIDS)
    %
    % INPUT:
    %
    %  - columnName: string, the header of the column where the content of insterest is stored
    %    (e.g., for 'trigger' will be 'trial type')
    %  - filterBy: string, the content of the column you want to filter out. It can take just
    %    part of the content name (e.g., you want to display the triggers and you have
    %    'trigger_motion' and 'trigger_static', 'trigger' as input will do)
    %  - saveOutputTsv: boolean to save the filtered ouput 
    %  - varargin: either cfg (to display the last run output) or the file path as string
    %
    % OUTPUT:
    %
    %  - outputFiltered: dataset with only the specified content, to see it in the command window
    %    use display(outputFiltered)

    
    % Create tag to add to output file in case you want to save it
    outputFilterTag = [ '_filteredBy-' columnName '_' filterBy '.tsv'];
    
    % Checke if input is cfg or the file path and assign the output filename for later saving
    if ischar(varargin{1})
        
        tsvFile = varargin{1};
        
        % Divide path and file name 
        fileSepPos = find(tsvFile == filesep, 1, 'last');
        path1 = tsvFile(1:fileSepPos-1);
        path2 = tsvFile(fileSepPos+1:end-4);
        
        % Create output file name
        outputFileName = fullfile(path1, ...
            [ path2 ...
            outputFilterTag ]);

    elseif isstruct(varargin{1})
        
        tsvFile = fullfile(varargin{1}.dir.outputSubject, ...
                           varargin{1}.fileName.modality, ...
                           varargin{1}.fileName.events);
        
        % Create output file name
        outputFileName = fullfile(varargin{1}.dir.outputSubject, ...
                           varargin{1}.fileName.modality, ...
                           [ varargin{1}.fileName.events(1:end-4) ...
                           outputFilterTag] );
    end

    % Check if the file exists
    if ~exist(tsvFile, 'file')
        error([newline 'Input file does not exist']);
    end

    try
        % Read the the tsv file and store each column in a field of `output` structure
        output = bids.util.tsvread(tsvFile);
    catch
        % Add the 'bids-matlab' in case is not in the path
        addpath(genpath(fullfile(pwd, '../lib'))) 
        % Read the the tsv file and store each column in a field of `output` structure
        output = bids.util.tsvread(tsvFile);
    end

    % Get the index of the target contentent to filter and display
    filterIdx = find(strncmp(output.(columnName), filterBy, length(filterBy)));

    % Convert the structure to dataset
    outputDataset = struct2dataset(output);

    % Get the dataset with the content of intereset
    outputFiltered = outputDataset(filterIdx, :);
    
    if saveOutputTsv
        
        bids.util.tsvwrite(outputFileName, output)
    
    end
    
end
