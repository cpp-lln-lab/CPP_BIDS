function [ logFile ] = saveEventsFile(action, expParameters, logFile, varargin)
% Function to save output files for events that will be BIDS compliant.
%
% INPUTS
%
% action:
%  - 'open': will create the file ID and return it in logFile.eventLogFile using the information in
% the expParameters structure. This file ID is then reused when calling that function to save data
% into this file.
% This creates the header with the obligatory 'onset', 'trial_type', 'duration' required bt BIDS and other
% coluns can be specified in varargin.
% example : logFile = saveEventsFile('open', expParameters, [], 'direction', 'speed', 'target');
%
%  - 'save': will save the data contained in logfile by using the file ID logFile.eventLogFile;
% logfile must then contain:
%     - logFile.onset
%     - logFile.trial_type
%     - logFile.duration
% The name of any extra column whose content must be saved should be listed in varargin.
%
%  - 'close': closes the file with file ID logFile.eventLogFile. If expParameters.verbose is set to true
% then this will tell you where the file is located.
%
% See test_saveEventsFile in the test folder for more details on how to use it.

if nargin<3 || isempty(logFile)
    logFile = struct();
end

switch action

    case 'open'

        logFile = struct();

        % Initialize txt logfiles and empty fields for the standard BIDS
        %  event file
        logFile.eventLogFile = fopen(...
            fullfile(expParameters.outputDir, expParameters.modality, expParameters.fileName.events), ...
            'w');

        % print the basic BIDS columns
        fprintf(logFile.eventLogFile, '%s\t%s\t%s\t', 'onset', 'trial_type', 'duration');

        % print any extra column specified by the user
        %  also prepare an empty field in the structure to collect data
        %  for those
        for iExtraColumn = 1:numel(varargin)
            fprintf(logFile.eventLogFile,'%s\t', lower(varargin{iExtraColumn}));
        end

        % next line so we start printing at the right place
        fprintf(logFile.eventLogFile, '\n');


    case 'save'

        % appends to the logfile all the data stored in the structure
        % first with the standard BIDS data and then any extra things
        for iEvent = 1:size(logFile,1)

            fprintf(logFile(1).eventLogFile,'%f\t%s\t%f\t',...
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
                    fprintf(logFile(1).eventLogFile, '%s\t', data);
                else
                    fprintf(logFile(1).eventLogFile, '%f\t', data);
                end

            end

            fprintf(logFile(1).eventLogFile, '\n');
        end

    case 'close'

        % close txt log file
        fclose(logFile(1).eventLogFile);

        if expParameters.verbose
            fprintf(1,'\nData were saved in this file:\n\n%s\n\n', ...
                fullfile(...
                expParameters.outputDir, ...
                expParameters.modality, ...
                expParameters.fileName.events));

        end

end
