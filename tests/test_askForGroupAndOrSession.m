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
    cfg = struct([]);
    cfg = askForGroupAndOrSession(cfg);

    expectedStructure = struct('subject', struct('ask', {{'grp', 'ses', 'run'}}));

    assertEqual(cfg, expectedStructure);

end

function test_askForGroupAndOrSessionBasic_2()

    %% set up
    cfg.subject.subjectNb = 1;
    cfg = askForGroupAndOrSession(cfg);

    expectedStructure = struct('subject', struct('ask', {{'grp', 'ses', 'run'}}, ...
                                                 'subjectNb', 1));

    assertEqual(cfg, expectedStructure);

end

function test_askForGroupAndOrSessionNoGroup()

    cfg.subject.ask = {'ses'};
    cfg = askForGroupAndOrSession(cfg);

    expectedStructure = struct('subject', struct('ask', {{'ses'}}));

    assertEqual(cfg, expectedStructure);

end
