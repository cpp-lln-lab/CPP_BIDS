% (C) Copyright 2020 CPP_BIDS developers

function test_suite = test_createQuestionList %#ok<*STOUT>
    try % assignment of 'localfunctions' is necessary in Matlab >= 2016
        test_functions = localfunctions(); %#ok<*NASGU>
    catch % no problem; early Matlab versions can use initTestSuite fine
    end
    initTestSuite;
end

function test_createQuestionListBasic()

    %% set up
    cfg = struct();

    questions = createQuestionList(cfg);

    expectedCell = { ...
                    'Enter subject group (leave empty if none): ', false
                    'Enter subject number (1-999): ', true
                    'Enter the session number (i.e day ; 1-999): ', true
                    'Enter the run number (1-999): ', true};

    assertEqual(expectedCell, questions.questionsToAsk);

end

function test_createQuestionListRestricted()

    %% set up
    cfg = struct();
    cfg.subject.askGrpSess = [false false];

    questions = createQuestionList(cfg);

    expectedCell = { ...
                    [], false
                    'Enter subject number (1-999): ', true
                    [], false
                    'Enter the run number (1-999): ', true};

    assertEqual(expectedCell, questions.questionsToAsk);

end
