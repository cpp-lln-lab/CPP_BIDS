% (C) Copyright 2020 CPP_BIDS developers

function createDataDictionary(cfg, logFile)
    % createDataDictionary(cfg, logFile)
    %
    % creates the data dictionary to be associated with a _events.tsv file
    % will create empty field that you can then fill in manually in the JSON
    % file

    opts.Indent = '    ';

    fileName = strrep(logFile.filename, '.tsv', '.json');

    fileName = fullfile( ...
                        cfg.dir.outputSubject, ...
                        cfg.fileName.modality, ...
                        fileName);

    jsonContent = struct( ...
                         'onset', struct( ...
                                         'Description', 'time elapsed since experiment start', ...
                                         'Unit', 's'), ...
                         'trial_type', struct( ...
                                              'Description', 'types of trial', ...
                                              'Levels', ''), ...
                         'duration', struct( ...
                                            'Description', 'duration of the event or the block', ...
                                            'Unit', 's') ...
                        );

    % transfer content of extra fields to json content
    namesExtraColumns = returnNamesExtraColumns(logFile);

    for iExtraColumn = 1:numel(namesExtraColumns)

        nbCol = returnNbColumns(logFile, namesExtraColumns{iExtraColumn});

        for iCol = 1:nbCol

            headerName = returnHeaderName(namesExtraColumns{iExtraColumn}, nbCol, iCol);

            jsonContent.(headerName) = ...
                logFile(1).extraColumns.(namesExtraColumns{iExtraColumn}).bids;

        end

    end

    bids.util.jsonencode(fileName, jsonContent, opts);

end
