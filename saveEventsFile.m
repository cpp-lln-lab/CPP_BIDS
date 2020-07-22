function [logFile] = saveEventsFile(action, expParameters, logFile)
    % Function to save output files for events that will be BIDS compliant.
    %
    % INPUTS
    %
    % logFile:
    %   When you want to save your data logFile contains the data you want to save.
    % The logFile variable that contains the n events you want to % save must be a nx1 structure.
    % Each field will be saved in a separate column.
    %
    % example:
    % logFile(1,1).onset = 2;
    % logFile(1,1).trial_type = 'motion_up';
    % logFile(1,1).duration = 1;
    % logFile(1,1).speed = 2;
    % logFile(1,1).is_fixation = true;
    %
    % logFile(2,1).onset = 3;
    % logFile(2,1).trial_type = 'static';
    % logFile(2,1).duration = 4;
    % logFile(2,1).is_fixation = 3;
    %
    %
    % action:
    %  - 'open': will create the file ID and return it in logFile.fileID using the information in
    % the expParameters structure. This file ID is then reused when calling that function
    % to save data into this file.
    % This creates the header with the obligatory 'onset', 'trial_type', 'duration' required
    % by BIDS and other columns can be specified in varargin.
    %
    % example : logFile = saveEventsFile('open', expParameters, [], 'direction', 'speed', 'target');
    %
    %  - 'save': will save the data contained in logfile by using the file ID logFile.fileID;
    % logfile must then contain:
    %     - logFile.onset
    %     - logFile.trial_type
    %     - logFile.duration
    % The name of any extra column whose content must be saved should be listed in varargin.
    %
    %  - 'close': closes the file with file ID logFile.fileID. If expParameters.verbose is set
    % to true then this will tell you where the file is located.
    %
    % See test_saveEventsFile in the test folder for more details on how to use it.

    if nargin < 1
        errror('Missing action input');
    end

    if nargin < 3 || isempty(logFile)
        logFile = checklLogFile('init');
    end

    switch action

        case 'open'

            logFile.filename = expParameters.fileName.events;

            logFile = initializeFile(expParameters, logFile);

        case 'open_stim'

            logFile.filename = expParameters.fileName.stim;

            logFile = initializeFile(expParameters, logFile);

        case 'save'

            checklLogFile('checkID', logFile);
            checklLogFile('type&size', logFile);

            % appends to the logfile all the data stored in the structure
            % first with the standard BIDS data and then any extra things
            for iEvent = 1:size(logFile, 1)

                onset = checkInput(logFile(iEvent).onset);
                duration = checkInput(logFile(iEvent).duration);
                trial_type = checkInput(logFile(iEvent).trial_type);

                if any(isnan([onset trial_type])) || ...
                        any(isempty([onset trial_type])) || ...
                        any(strcmp({onset, trial_type}, 'NA'))

                    warning('\nSkipping saving this event.\n onset: %f \n trial_type: %s\n', ...
                        onset, ...
                        trial_type);

                else

                    fprintf(logFile(1).fileID, '%f\t%s\t%f\t', ...
                        onset, ...
                        trial_type, ...
                        duration);

                    printExtraColumns(logFile, iEvent);

                    fprintf(logFile(1).fileID, '\n');

                end
            end

        case 'close'

            checklLogFile('checkID', logFile);

            % close txt log file
            fclose(logFile(1).fileID);

            fprintf(1, '\nData were saved in this file:\n\n%s\n\n', ...
                fullfile( ...
                expParameters.subjectOutputDir, ...
                expParameters.modality, ...
                logFile.filename));

        otherwise

            errorSaveEventsFile('unknownActionType');

    end

    logFile = resetLogFileVar(logFile);

end

function logFile = checklLogFile(action, logFile)

    switch action

        case 'init'

            logFile = struct('filename', [], 'extraColumns', cell(1));
            logFile(1).filename = '';

        case 'checkID'

            if ~isfield(logFile(1), 'fileID') || isempty(logFile(1).fileID)
                errorSaveEventsFile('missingFileID');
            end

        case 'type&size'

            if ~isstruct(logFile) || size(logFile, 2) > 1
                errorSaveEventsFile('wrongFileID');
            end

    end

end

function logFile = initializeFile(expParameters, logFile)

    % Initialize txt logfiles and empty fields for the standard BIDS
    %  event file
    logFile.fileID = fopen( ...
        fullfile( ...
        expParameters.subjectOutputDir, ...
        expParameters.modality, ...
        logFile.filename), ...
        'w');

    % print the basic BIDS columns
    fprintf(logFile.fileID, '%s\t%s\t%s\t', 'onset', 'trial_type', 'duration');

    logFile = printHeaderExtraColumns(logFile);

    % next line so we start printing at the right place
    fprintf(logFile.fileID, '\n');

end

function [namesExtraColumns, logFile] = returnNamesExtraColumns(logFile)

    namesExtraColumns = [];

    % convert the cell of column name into a structure
    if iscell(logFile(1).extraColumns)
        tmp = struct();
        for iExtraColumn = 1:numel(logFile(1).extraColumns)
            extraColumnName = logFile(1).extraColumns{iExtraColumn};
            tmp.(extraColumnName) = struct('length', 1);
        end
        logFile(1).extraColumns = tmp;
    end

    if isfield(logFile, 'extraColumns') && ~isempty(logFile(1).extraColumns)
        namesExtraColumns = fieldnames(logFile(1).extraColumns);
    end

end

function logFile = printHeaderExtraColumns(logFile)
    % print any extra column specified by the user

    [namesExtraColumns, logFile] = returnNamesExtraColumns(logFile);

    for iExtraColumn = 1:numel(namesExtraColumns)

        nbCol = returnNbColumns(logFile, namesExtraColumns{iExtraColumn});

        if ~isfield(logFile(1).extraColumns.(namesExtraColumns{iExtraColumn}), 'length')
            logFile(1).extraColumns.(namesExtraColumns{iExtraColumn}).length = nbCol;
        end

        for iColNb = 1:nbCol

            if nbCol == 1
                headerName = sprintf('%s', namesExtraColumns{iExtraColumn});
            else
                headerName = sprintf('%s-%02.0f', namesExtraColumns{iExtraColumn}, iColNb);
            end

            fprintf(logFile.fileID, '%s\t', headerName);

        end

    end

end

function nbCol = returnNbColumns(logFile, nameExtraColumn)

    thisExtraColumn = logFile(1).extraColumns.(nameExtraColumn);

    nbCol = 1;

    if isfield(thisExtraColumn, 'length')
        nbCol = thisExtraColumn.length;
    end
end

function data = checkInput(data, expectedLength)
    % check the data to write
    % default will be 'NA' for chars and NaN for numeric data
    % for numeric data that don't have the expected length, it will be padded with NaNs

    if nargin < 2
        expectedLength = [];
    end

    if ischar(data) && isempty(data) || strcmp(data, ' ')
        data = 'NA';
    elseif isempty(data)
        data = nan;
    end

    if islogical(data) && data
        data = 'true';
    elseif islogical(data) && ~data
        data = 'false';
    end

    if ~isempty(expectedLength) && isnumeric(data) && max(size(data)) < expectedLength
        padding = expectedLength - max(size(data));
        data(end + 1:end + padding) = nan(1, padding);
    end

end

function printExtraColumns(logFile, iEvent)

    namesExtraColumns = returnNamesExtraColumns(logFile);

    for iExtraColumn = 1:numel(namesExtraColumns)

        nbCol = returnNbColumns(logFile, namesExtraColumns{iExtraColumn});

        % if the field we are looking for does not exist or is empty in the
        % action logFile structure we will write a NaN otherwise we
        % write its content
        data = 'NA';
        if isfield(logFile, namesExtraColumns{iExtraColumn})
            data = logFile(iEvent).(namesExtraColumns{iExtraColumn});
        end

        data = checkInput(data, nbCol);

        if any(isnan(data))
            warning('Missing some %s data for this event.', namesExtraColumns{iExtraColumn});
            disp(logFile(iEvent));
        elseif  all(isnan(data)) || strcmp(data, 'NA')
            warning('Missing %s data for this event.', namesExtraColumns{iExtraColumn});
            disp(logFile(iEvent));
        end

        if ischar(data)
            fprintf(logFile(1).fileID, '%s\t', data);
        else
            fprintf(logFile(1).fileID, '%f\t', data);
        end

    end

end

function logFile = resetLogFileVar(logFile)

    logFile(2:end) = [];

    namesColumns = {'onset', 'duration', 'trial_type'};
    namesExtraColumns = returnNamesExtraColumns(logFile);
    namesColumns = cat(2, namesColumns, namesExtraColumns');

    for iColumn = 1:numel(namesColumns)

        if isfield(logFile, namesColumns{iColumn})
            logFile = rmfield(logFile, namesColumns{iColumn});
        end

    end

end

function errorSaveEventsFile(identifier)

    switch identifier
        case 'unknownActionType'
            errorStruct.message = 'unknown action for saveEventsFile';

        case 'missingFileID'
            errorStruct.message = 'logFile must contain a valid fileID field';

        case 'wrongFileID'
            errorStruct.message = 'logFile must be a nx1 structure';

    end

    errorStruct.identifier = ['saveEventsFile:' unknownActionType];
    error(errorStruct);
end
