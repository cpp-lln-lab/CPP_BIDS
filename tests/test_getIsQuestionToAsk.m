% (C) Copyright 2020 CPP_BIDS developers

function test_suite = test_getIsQuestionToAsk %#ok<*STOUT>
    try % assignment of 'localfunctions' is necessary in Matlab >= 2016
        test_functions = localfunctions(); %#ok<*NASGU>
    catch % no problem; early Matlab versions can use initTestSuite fine
    end
    initTestSuite;
end

function test_isPositiveIntegerBasic()

    questions.questionsToAsk = { ...
                                [], 1; ...
                                [], 0; ...
                                [], 1; ...
                                [], 0 ...
                               };

    responses = { ...
                 '1'
                 '1'
                 '-1'
                 '-1'
                };

    isQuestionToAsk = getIsQuestionToAsk(questions, responses);

    assertEqual(isQuestionToAsk, [false; false; true; false]);

end
