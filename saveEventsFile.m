function [logFile] = saveEventsFile(action, expParameters, logFile, varargin)
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

    if nargin < 3 || isempty(logFile)
        logFile = struct();
    end

    switch action

        case 'open'

            logFile = struct();

            % Initialize txt logfiles and empty fields for the standard BIDS
            %  event file
            logFile.fileID = fopen( ...
                fullfile( ...
                expParameters.subjectOutputDir, ...
                expParameters.modality, ...
                expParameters.fileName.events), ...
                'w');

            initializeHeader(logFile, varargin);

        case 'open_stim'
            logFile = struct();

            % Initialize txt logfiles and empty fields for the standard BIDS
            %  event file
            logFile.fileID = fopen( ...
                fullfile( ...
                expParameters.subjectOutputDir, ...
                expParameters.modality, ...
                expParameters.fileName.stim), ...
                'w');

            initializeHeader(logFile, varargin);

        case 'save'

            if ~isstruct(logFile) || size(logFile, 2) > 1
                error('The variable containing the n events to save must be a nx1 structure.');
            end

            % appends to the logfile all the data stored in the structure
            % first with the standard BIDS data and then any extra things
            for iEvent = 1:size(logFile, 1)

                fprintf(logFile(1).fileID, '%f\t%s\t%f\t', ...
                    logFile(iEvent).onset, ...
                    logFile(iEvent).trial_type, ...
                    logFile(iEvent).duration);

                for iExtraColumn = 1:numel(varargin)

                    % if the field we are looking for does not exist or is empty in the
                    % action logFile structure we will write a NaN otherwise we
                    % write its content

                    if ~isfield(logFile, varargin{iExtraColumn})
                        data = [];
                    else
                        data = getfield(logFile(iEvent), varargin{iExtraColumn});
                    end

                    if isempty(data)
                        data = NaN;
                    end

                    if ischar(data)
                        fprintf(logFile(1).fileID, '%s\t', data);
                    else
                        fprintf(logFile(1).fileID, '%f\t', data);
                    end

                end

                fprintf(logFile(1).fileID, '\n');
            end

        case 'close'

            % close txt log file
            fclose(logFile(1).fileID);

            if expParameters.verbose
                fprintf(1, '\nData were saved in this file:\n\n%s\n\n', ...
                    fullfile( ...
                    expParameters.subjectOutputDir, ...
                    expParameters.modality, ...
                    expParameters.fileName.events));

            end

    end

end

function initializeHeader(logFile, varargin)

    % print the basic BIDS columns
    fprintf(logFile.fileID, '%s\t%s\t%s\t', 'onset', 'trial_type', 'duration');

    % print any extra column specified by the user
    %  also prepare an empty field in the structure to collect data
    %  for those
    for iExtraColumn = 1:numel(varargin{1})
        fprintf(logFile.fileID, '%s\t', lower(varargin{1}{iExtraColumn}));
    end

    % next line so we start printing at the right place
    fprintf(logFile.fileID, '\n');

end
