% (C) Copyright 2020 CPP_BIDS developers

function logFile = saveEventsFile(action, cfg, logFile)
    %
    % Function to save output files for events that will be BIDS compliant.
    %
    % USAGE::
    %
    %   [logFile] = saveEventsFile(action, cfg, logFile)
    %
    % :param action: Defines the operation to do. The different possibilities are
    %                ``'init'``, ``'init_stim'``, ``'open'``, ``'save'`` or ``'close'``.
    %                For more information on each case see below.
    % :type action: string
    % :param cfg: Configuration variable. See ``checkCFG()``.
    % :type cfg: structure
    % :param logFile: (n x 1) The ``logFile`` variable that contains the n events
    %                 you want to save must be a nx1 structure.
    % :type logFile: structure
    %
    % .. todo:
    %    - more details about how to structure the logFile variable
    %
    % See ``tests/test_saveEventsFile()`` for more details on how to use it.
    %
    % Example::
    %
    %   logFile(1,1).onset = 2;
    %   logFile(1,1).trial_type = 'motion_up';
    %   logFile(1,1).duration = 1;
    %
    % Actions:
    %
    %   Example::
    %
    %     logFile = saveEventsFile('init', cfg, logFile)
    %     logFile = saveEventsFile('init_stim', cfg, logFile)
    %     logFile = saveEventsFile('open', cfg, logFile)
    %     logFile = saveEventsFile('save', cfg, logFile)
    %
    %   - ``'init'`` and ``'init_stim'`` are used for events and stimuli tsv files respectively.
    %     This initializes the extra columns to be save.
    %
    %   - ``'open'`` will create the file ID and return it in ``logFile.fileID`` using
    %     the information in the ``cfg`` structure.
    %     This file ID is then reused when calling that function to save data into this file.
    %     This creates the header with the obligatory ``'onset'``, ``'duration'`` required
    %     by BIDS and other columns can be specified in varargin.
    %
    %     Example::
    %
    %       logFile = saveEventsFile('open', cfg, logFile);
    %
    %   - ``'save'`` will save the data contained in logfile by using the file ID
    %     ``logFile.fileID``.
    %     If saving a stimulus file then the only the fields of ``logFile.extraColumns``
    %     will be saved.
    %     For regular _events.tsv files, then ``logFile`` must then contain:
    %
    %     - logFile.onset
    %     - logFile.duration
    %
    %     Otherwise it will be skipped.
    %
    %     Example::
    %
    %       logFile = saveEventsFile('save', cfg, logFile);
    %
    %   - ``'close'`` closes the file with file ID ``logFile.fileID``.
    %     If ``cfg.verbose`` is superior to ``1`` then this will tell you
    %     where the file is located.
    %
    %     Example::
    %
    %       logFile = saveEventsFile('close', cfg, logFile)
    %
    %

    if nargin < 2
        errorSaveEventsFile('missingArgument');
    end

    if nargin < 3 || isempty(logFile)
        logFile = checklLogFile('init');
    end

    switch action

        case 'init'
            % flag to indicate that this will be an _events file
            logFile(1).isStim = false;

            if isfield(cfg, 'fileName') && ...
                                        isfield(cfg.fileName, 'events') && ...
                                        ~isempty(cfg.fileName.events)
                logFile(1).filename = cfg.fileName.events;
            else
                logFile(1).filename = '';
            end
            logFile = initializeFile(logFile);

        case 'init_stim'
            % flag to indicate that this will be an _stim file
            logFile(1).isStim = true;

            if isfield(cfg, 'fileName') && ...
                                        isfield(cfg.fileName, 'stim') && ...
                                        ~isempty(cfg.fileName.stim)
                logFile(1).filename = cfg.fileName.stim;
            else
                logFile(1).filename = '';
            end
            logFile = initializeStimFile(logFile);

        case 'open'
            logFile = openFile(cfg, logFile);

        case 'save'
            checklLogFile('checkID', logFile);
            checklLogFile('type&size', logFile);

            logFile = saveToLogFile(logFile, cfg);

        case 'close'
            checklLogFile('checkID', logFile);

            % close txt log file
            fclose(logFile(1).fileID);

            message = sprintf('\nData were saved in this file:\n\n%s\n\n', ...
                              fullfile( ...
                                       cfg.dir.outputSubject, ...
                                       cfg.fileName.modality, ...
                                       logFile.filename));
            talkToMe(cfg, message);

        otherwise
            errorSaveEventsFile('unknownActionType');

    end

    logFile = resetLogFileVar(logFile);

end

function logFile = checklLogFile(action, logFile, iEvent, cfg)

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
                errorSaveEventsFile('wrongLogSize');
            end

        case 'fields'
            for iFields = {'onset', 'trial_type', 'duration'}
                if ~isfield(logFile, iFields) || isempty(logFile(iEvent).(iFields{1}))
                    logFile(iEvent).(iFields{1}) = nan;
                end
            end

            logFile = checkExtracolumns(logFile, iEvent, cfg);

    end

end

function logFile = initializeFile(logFile)
    % This function creates the bids field structure for json files for the
    % three basic bids event columns, and for all requested extra columns.
    %
    % Note that subfields (e.g. unit, levels etc. can be changed by the user
    % before calling openFile.

    % initialize holy trinity (onset, trial_type, duration) columns
    logFile(1).columns = struct( ...
                                'onset', struct( ...
                                                'Description', ...
                                                'time elapsed since experiment start', ...
                                                'Units', 's'), ...
                                'trial_type', struct( ...
                                                     'Description', 'types of trial', ...
                                                     'Levels', ''), ...
                                'duration', struct( ...
                                                   'Description', ...
                                                   'duration of the event or the block', ...
                                                   'Units', 's') ...
                               );

    logFile = initializeExtraColumns(logFile);

end

function logFile = initializeStimFile(logFile)
    logFile = initializeExtraColumns(logFile);
end

function logFile = openFile(cfg, logFile)

    createDataDictionary(cfg, logFile);

    % Initialize txt logfiles and empty fields for the standard BIDS
    % event file
    logFile(1).fileID = fopen( ...
                              fullfile( ...
                                       cfg.dir.outputSubject, ...
                                       cfg.fileName.modality, ...
                                       logFile.filename), ...
                              'w');

    if ~logFile(1).isStim
        % print the basic BIDS columns
        fprintf(logFile(1).fileID, '%s\t%s\t%s', 'onset', 'duration', 'trial_type');
        fprintf(1, '%s\t%s\t%s', 'onset', 'duration', 'trial_type');

        printHeaderExtraColumns(logFile);

        % next line so we start printing at the right place
        fprintf(logFile(1).fileID, '\n');
        fprintf(1, '\n');

    elseif logFile(1).isStim
        % don't print column headers for _stim.tsv

    end

end

function printHeaderExtraColumns(logFile)
    % print any extra column specified by the user

    [namesExtraColumns] = returnNamesExtraColumns(logFile);
    for iExtraColumn = 1:numel(namesExtraColumns)

        nbCol = returnNbColumns(logFile, namesExtraColumns{iExtraColumn});

        for iCol = 1:nbCol
            headerName = returnHeaderName(namesExtraColumns{iExtraColumn}, nbCol, iCol);
            fprintf(logFile(1).fileID, '\t%s', headerName);
            fprintf(1, '\t%s', headerName);
        end

    end

end

function logFile = checkExtracolumns(logFile, iEvent, cfg)
    % loops through the extra columns
    % if the field we are looking for does not exist or is empty in the action logFile structure
    % we will write a n/a
    % otherwise we write its content

    namesExtraColumns = returnNamesExtraColumns(logFile);
    for iExtraColumn = 1:numel(namesExtraColumns)

        nbCol = returnNbColumns(logFile, namesExtraColumns{iExtraColumn});

        data = 'n/a';
        if isfield(logFile, namesExtraColumns{iExtraColumn})
            data = logFile(iEvent).(namesExtraColumns{iExtraColumn});
        end

        data = checkInput(data);

        data = nanPadding(cfg, data, nbCol);

        logFile(iEvent).(namesExtraColumns{iExtraColumn}) = data;

        if ~ischar(data)

            warningMessage = [];
            if any(isnan(data))
                warningMessage = sprintf( ...
                                         'Missing some %s data for this event.', ...
                                         namesExtraColumns{iExtraColumn});

            elseif all(isnan(data))
                warningMessage = sprintf( ...
                                         'Missing %s data for this event.', ...
                                         namesExtraColumns{iExtraColumn});

            end
            throwWarning(cfg, 'saveEventsFile:missingData', warningMessage);

            if cfg.verbose > 1
                disp(logFile(iEvent));
            end

        end

    end

end

function logFile = saveToLogFile(logFile, cfg)

    % appends to the logfile all the data stored in the structure
    % first with the standard BIDS data and then any extra things
    for iEvent = 1:size(logFile, 1)

        logFile = checklLogFile('fields', logFile, iEvent, cfg);

        % check if this event should be skipped
        skipEvent = false;
        warningMessageID = [];
        warningMessage = [];

        % if this is _events file, we skip events with onset or duration
        % that are empty, nan or char.
        if ~logFile(1).isStim

            onset = logFile(iEvent).onset;
            duration = logFile(iEvent).duration;

            if any(cell2mat(cellfun(@isnan, {onset duration}, 'UniformOutput', false))) || ...
               any(cellfun(@ischar, {onset duration})) || ...
               any(isempty({onset duration}))

                skipEvent = true;

                warningMessageID = 'saveEventsFile:emptyEvent';
                warningMessage = sprintf(['Skipping saving this event. \n '...
                                          'onset: %s \n duration: %s \n'], ...
                                         onset, ...
                                         duration);
            end

            % if this is _stim file, we skip missing events (i.e. events where
            % all extra columns have NO values)
        elseif logFile(1).isStim

            namesExtraColumns = returnNamesExtraColumns(logFile);
            isValid = ones(1, numel(namesExtraColumns));

            for iExtraColumn = 1:numel(namesExtraColumns)
                data = logFile(iEvent).(namesExtraColumns{iExtraColumn});
                if isempty(data) || all(isnan(data)) || (ischar(data) && strcmp(data, 'n/a'))
                    isValid(iExtraColumn) = 0;
                end
            end

            if all(~isValid)
                skipEvent = true;

                warningMessageID = 'saveEventsFile:emptyEvent';
                warningMessage = sprintf(['Skipping saving this event. \n', ...
                                          'No values defined. \n']);

            elseif any(~isValid)
                skipEvent = false;

                warningMessageID = 'saveEventsFile:missingData';
                warningMessage = sprintf('Missing some %s data for this event. \n', ...
                                         namesExtraColumns{find(isValid)});
            end
        end

        % now save the event to log file (if not skipping)
        throwWarning(cfg, warningMessageID, warningMessage);

        printToFile(cfg, logFile, skipEvent, iEvent);

    end

end

function printToFile(cfg, logFile, skipEvent, iEvent)

    if ~skipEvent

        if ~logFile(1).isStim
            printData(logFile(1).fileID, logFile(iEvent).onset, cfg);
            printData(logFile(1).fileID, logFile(iEvent).duration, cfg);
            printData(logFile(1).fileID, logFile(iEvent).trial_type, cfg);
        end

        printExtraColumns(logFile, iEvent, cfg);

        fprintf(logFile(1).fileID, '\n');
        fprintf(1, '\n');

    end
end

function printExtraColumns(logFile, iEvent, cfg)
    % loops through the extra columns and print them
    namesExtraColumns = returnNamesExtraColumns(logFile);
    for iExtraColumn = 1:numel(namesExtraColumns)
        data = logFile(iEvent).(namesExtraColumns{iExtraColumn});
        printData(logFile(1).fileID, data, cfg);
    end
end

function printData(output, data, cfg)
    % write char
    % for numeric data we replace any nan by n/a
    if ischar(data)
        content = sprintf('%s\t', data);
        fprintf(output, content);
        talkToMe(cfg, content);

    else
        for i = 1:numel(data)
            if isnan(data(i))
                content = sprintf('%s\t', 'n/a');
            else
                content = sprintf('%f\t', data(i));
            end
            fprintf(output, content);
            talkToMe(cfg, content);
        end

    end
end

function logFile = resetLogFileVar(logFile)
    % removes the content of all the events from (2:end)

    logFile(2:end) = [];

    namesColumns = {'onset', 'duration', 'trial_type'};
    if logFile(1).isStim
        namesColumns = {};
    end
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
        case 'missingArgument'
            errorStruct.message = ['Missing arguments. Please specify <action input> ', ...
                                   'and <cfg file> as the first two arguments'];

        case 'unknownActionType'
            errorStruct.message = 'unknown action for saveEventsFile';

        case 'missingFileID'
            errorStruct.message = 'logFile must contain a valid fileID field';

        case 'wrongLogSize'
            errorStruct.message = 'logFile must be a nx1 structure';

    end

    errorStruct.identifier = ['saveEventsFile:' identifier];
    error(errorStruct);

end
