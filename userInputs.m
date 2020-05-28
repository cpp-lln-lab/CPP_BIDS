function [expParameters] = userInputs(cfg, expParameters, askGrpSess)
% Get subject, run and session number and make sure they are
% positive integer values
%
% skipGrpSess
% a 1 X 2 array of booleans (default is [true true] ):
%    - the first value set to false will skip asking for the participants
%    group
%    - the second value set to false will skip asking for the session

if nargin<1
    cfg.debug = false;
end
if nargin<2
    expParameters = [];
end
if nargin<3
    askGrpSess = [true true];
end


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
    subjectNb = str2double(input('Enter subject number (1-999): ', 's') );
    subjectNb = checkInput(subjectNb);
    
    % the session number
    if askGrpSess(2)
        sessionNb = str2double(input('Enter the session (i.e day - 1-999)) number: ', 's'));
        sessionNb = checkInput(sessionNb);
    end
    
    % the run number
    runNb = str2double(input('Enter the run number (1-999): ', 's'));
    runNb = checkInput(runNb);
    
end

expParameters.subjectGrp = subjectGrp;
expParameters.subjectNb = subjectNb;
expParameters.sessionNb = sessionNb;
expParameters.runNb = runNb;

end

function input2check = checkInput(input2check)
% this function checks the input to makes sure the user enters a positive integer
while isnan(input2check) || fix(input2check) ~= input2check || input2check<0
    input2check = str2double(input('Please enter a positive integer: ', 's'));
end
end
