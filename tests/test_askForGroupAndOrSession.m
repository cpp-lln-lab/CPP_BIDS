% (C) Copyright 2020 CPP_BIDS developers

function test_suite = test_askForGroupAndOrSession %#ok<*STOUT>
    try % assignment of 'localfunctions' is necessary in Matlab >= 2016
        test_functions = localfunctions(); %#ok<*NASGU>
    catch % no problem; early Matlab versions can use initTestSuite fine
    end
    initTestSuite;
end

function test_askForGroupAndOrSessionBasic()

    %% set up
    cfg = struct();
    cfg = askForGroupAndOrSession(cfg);

    expectedStructure = struct('subject', struct('askGrpSess', [true true]));

    assertEqual(expectedStructure, cfg);

end

function test_askForGroupAndOrSessionNoGroup()

    cfg.subject.askGrpSess = 0;
    cfg = askForGroupAndOrSession(cfg);

    expectedStructure = struct('subject', struct('askGrpSess', [false true]));

    assertEqual(expectedStructure, cfg);

end

function test_askForGroupAndOrSessionNoGroupNoSession()

    cfg.subject.askGrpSess = [0 0];
    cfg = askForGroupAndOrSession(cfg);

    expectedStructure = struct('subject', struct('askGrpSess', [false false]));

    assertEqual(expectedStructure, cfg);

end

function test_askForGroupAndOrSessionNoSession()

    cfg.subject.askGrpSess = [1 0];
    cfg = askForGroupAndOrSession(cfg);

    expectedStructure = struct('subject', struct('askGrpSess', [true false]));

    assertEqual(expectedStructure, cfg);

end
