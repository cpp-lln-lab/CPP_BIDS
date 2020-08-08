function cfg = userInputs(cfg)
    % cfg = userInputs(cfg)
    %
    % Get subject, run and session number and make sure they are
    % positive integer values
    %
    % expParameters.subject.askGrpSess
    % a 1 X 2 array of booleans (default is [true true] ):
    %    - the first value set to false will skip asking for the participants
    %    group
    %    - the second value set to false will skip asking for the session
    
    if nargin < 1
        cfg = struct('debug', []);
    end
    
    if isempty(cfg.debug)
        cfg.debug.do = false;
    end
    
    responses{1,1} = ''; % subjectGrp
    responses{2,1} = []; % subjectNb
    responses{3,1} = 1; % runNb
    responses{4,1} = []; % sessionNb

    % When in debug more this function returns some dummy values
    if cfg.debug.do
        
        responses{1,1} = 'ctrl';
        responses{2,1} = 666;
        responses{3,1} = 666;
        responses{4,1} = 666;
        
        % Otherwise it prompts the user for some information
    else

        questions = createQuestionList(cfg);
        
        responses = askUserCli(questions);
        
    end
    
    cfg.subject.subjectGrp = responses{1,1};
    cfg.subject.subjectNb = responses{2,1};
    cfg.subject.sessionNb = responses{3,1};
    cfg.subject.runNb = responses{4,1};
    
end


function responses = askUserCli(questions)
    % response = askUserCli(questions)
    %
    % command line interface to ask questions to user
    %
    
    for iQuestion = 1:size(questions.questionsToAsk, 1)
        
        if ~isempty(questions.questionsToAsk{iQuestion,1})
            
            responses{iQuestion, 1} = ...
                input(questions.questionsToAsk{iQuestion,1}, 's'); %#ok<*AGROW>
            
            if questions.questionsToAsk{iQuestion,2}
                responses{iQuestion, 1} = str2double(responses);
                responses{iQuestion, 1} = checkInput(responses, questions);
            end
            
        end
        
    end
    
end


function input2check = checkInput(input2check, questions)
    % this function checks the input to makes sure the user enters a positive integer
    
    while ~isPositiveInteger(input2check)
        input2check = str2double(input(questions.mustBePositiveInteger, 's'));
    end
    
end
