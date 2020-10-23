% (C) Copyright 2020 CPP_BIDS developers

function createDataDictionary(cfg, logFile)
    %
    % It creates the data dictionary to be associated with a _events.tsv file. It will create empty
    % fields that you can then fill in manually in the JSON file.
    %
    % USAGE::
    %
    %   createDataDictionary(cfg, logFile)
    %
    % :param cfg: Configuration. See ``checkCFG()``.
    % :type cfg: structure
    % :param logFile: Contains the data you want to save.
    % :type logFile: structure

    fileName = strrep(logFile(1).filename, '.tsv', '.json');
    fullFilename = getFullFilename(fileName, cfg);

    jsonContent = setJsonContent(fullFilename, logFile);

    opts.Indent = '    ';
    
    bids.util.jsonencode(fullFilename, jsonContent, opts);

end

function jsonContent = setJsonContent(fullFilename, logFile)

    

    if ismember('_stim', fullFilename)

        samplingFrequency = nan;
        startTime = nan;

        if isfield(logFile, 'SamplingFrequency')
            samplingFrequency = logFile(1).SamplingFrequency;
        end
        if isfield(logFile, 'StartTime')
            startTime = logFile(1).StartTime;
        end

        jsonContent = struct( ...
                             'SamplingFrequency', samplingFrequency, ...
                             'StartTime',  startTime, ...
                             'Columns', []);

    else
    
        % add holy trininty columns to the json content
        jsonContent = logFile.columns; 
    
    end
    
    % transfer content of extra fields to json content
    namesExtraColumns = returnNamesExtraColumns(logFile);
    
    for iExtraColumn = 1:numel(namesExtraColumns)

        nbCol = returnNbColumns(logFile, namesExtraColumns{iExtraColumn});

        for iCol = 1:nbCol

            headerName = returnHeaderName(namesExtraColumns{iExtraColumn}, nbCol, iCol);

            if ismember('_stim', fullFilename)

                jsonContent.Columns{end + 1} = headerName;

            end

            jsonContent.(headerName) = ...
                logFile(1).extraColumns.(namesExtraColumns{iExtraColumn}).bids;

        end

    end

end
