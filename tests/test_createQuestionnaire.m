% (C) Copyright 2020 CPP_BIDS developers

function test_suite = test_createQuestionnaire %#ok<*STOUT>
    try % assignment of 'localfunctions' is necessary in Matlab >= 2016
        test_functions = localfunctions(); %#ok<*NASGU>
    catch % no problem; early Matlab versions can use initTestSuite fine
    end
    initTestSuite;
end

function test_createQuestionnaire_prefilled()

    %% set up
    cfg = struct();
    cfg.subject.subjectNb = 1;

    items = createQuestionnaire(cfg);

    expected = returnDefaultQuestionnaire();
    expected(2).response = 1;

    assertEqual(items(2), expected(2));

end

function test_createQuestionnaire_basic()

    %% set up
    cfg = struct();

    items = createQuestionnaire(cfg);

    expected = returnDefaultQuestionnaire();

    assertEqual(items, expected);

end

function test_createQuestionnaire_restricted()

    %% set up
    cfg = struct();
    cfg.subject.askGrpSess = [false false];

    items = createQuestionnaire(cfg);

    expected = returnDefaultQuestionnaire();
    expected(1).show = false;
    expected(3).show = false;

    assertEqual(items, expected);

end

function test_createQuestionnaire_debug()

    %% set up
    cfg = struct();
    cfg.debug.do = true;

    items = createQuestionnaire(cfg);

    expected = returnDefaultQuestionnaire(cfg);
    expected(1).response = 'ctrl';
    expected(2).response = 666;
    expected(3).response = 666;
    expected(4).response = 666;

    assertEqual(items, expected);

end
