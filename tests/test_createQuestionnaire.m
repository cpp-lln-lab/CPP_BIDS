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
    expected.subject.response = 1;

    assertEqual(items.subject, expected.subject);

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
    cfg.subject.ask = {'run'};

    items = createQuestionnaire(cfg);

    expected = returnDefaultQuestionnaire();
    expected.group.show = false;
    expected.session.show = false;

    assertEqual(items, expected);

end

function test_createQuestionnaire_debug()

    %% set up
    cfg = struct();
    cfg.debug.do = true;

    items = createQuestionnaire(cfg);

    expected = returnDefaultQuestionnaire(cfg);
    expected.group.response = 'ctrl';
    expected.subject.response = 666;
    expected.session.response = 666;
    expected.run.response = 666;

    assertEqual(items, expected);

end
