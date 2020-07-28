function cfg = userInputs(cfg)
    % Get subject, run and session number and make sure they are
    % positive integer values
    %
    % expParameters.askGrpSess
    % a 1 X 2 array of booleans (default is [true true] ):
    %    - the first value set to false will skip asking for the participants
    %    group
    %    - the second value set to false will skip asking for the session

    if nargin < 1
        cfg = [];
    end
    if isempty(cfg.debug)
        cfg.debug = false;
    end

    askGrpSess = [true true];
    if isfield(cfg, 'askGrpSess') && ~isempty(cfg.subject.askGrpSess)
        askGrpSess = cfg.subject.askGrpSess;
    end
    if numel(askGrpSess) < 2
        askGrpSess(2) = 1;
    end

    subjectGrp = '';
    subjectNb = []; %#ok<*NASGU>
    sessionNb = [];
    runNb = [];

    % When in debug more this function returns some dummy values
    if cfg.debug
        subjectGrp = 'ctrl';
        subjectNb = 666;
        runNb = 666;
        sessionNb = 666;

        % Otherwise it prompts the user for some information
    else

        % subject group
        if askGrpSess(1)
            subjectGrp = lower(input('Enter subject group (leave empty if none): ', 's'));
        end

        % the subject number
        subjectNb = str2double(input('Enter subject number (1-999): ', 's'));
        subjectNb = checkInput(subjectNb);

        % the session number
        if  numel(askGrpSess) > 1 && askGrpSess(2)
            sessionNb = str2double(input('Enter the session (i.e day - 1-999)) number: ', 's'));
            sessionNb = checkInput(sessionNb);
        end

        % the run number
        runNb = str2double(input('Enter the run number (1-999): ', 's'));
        runNb = checkInput(runNb);

    end

    cfg.subject.subjectGrp = subjectGrp;
    cfg.subject.subjectNb = subjectNb;
    cfg.subject.sessionNb = sessionNb;
    cfg.subject.runNb = runNb;

end

function input2check = checkInput(input2check)
    % this function checks the input to makes sure the user enters a positive integer
    while isnan(input2check) || fix(input2check) ~= input2check || input2check < 0
        input2check = str2double(input('Please enter a positive integer: ', 's'));
    end
end
