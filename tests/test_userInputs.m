% (C) Copyright 2020 CPP_BIDS developers

function test_suite = test_userInputs %#ok<*STOUT>
    try % assignment of 'localfunctions' is necessary in Matlab >= 2016
        test_functions = localfunctions(); %#ok<*NASGU>
    catch % no problem; early Matlab versions can use initTestSuite fine
    end
    initTestSuite;
end

function test_userInputs_prefilled_cfg_ignored_by_debug()

    %%
    cfg.debug.do = true;
    cfg.subject.subjectGrp = 'foo';
    cfg.subject.subjectNb = 2;
    cfg.subject.sessionNb = 2;
    cfg.subject.runNb = 2;

    cfg = checkCFG(cfg);

    cfg = userInputs(cfg);

    assertEqual(cfg.subject.subjectGrp, 'ctrl');
    assertEqual(cfg.subject.subjectNb, 666);
    assertEqual(cfg.subject.sessionNb, 666);
    assertEqual(cfg.subject.runNb, 666);

end

function test_userInputs_prefilled_cfg_cli()

    %%
    cfg.debug.do = false;
    cfg.subject.askGrpSess = [false false];
    cfg.subject.subjectNb = 2;
    cfg.subject.runNb = 2;

    expected = cfg;
    expected.subject.sessionNb = [];
    expected.subject.subjectGrp = [];

    cfg = userInputs(cfg);

    assertEqual(cfg.subject, expected.subject);

end

function test_userInputs_prefilled_cfg_gui()

    %%
    cfg.debug.do = false;
    cfg.subject.askGrpSess = [false false];
    cfg.subject.subjectNb = 2;
    cfg.subject.runNb = 2;

    expected = cfg;
    expected.subject.sessionNb = [];
    expected.subject.subjectGrp = [];

    cfg.useGUI = true;
    cfg = userInputs(cfg);

    assertEqual(cfg.subject, expected.subject);

end

function test_userInputs_prefilled_cfg_2()

    %%
    cfg.debug.do = false;
    cfg.subject.subjectGrp = 'foo';
    cfg.subject.subjectNb = 2;
    cfg.subject.sessionNb = 2;
    cfg.subject.runNb = 2;

    cfg = checkCFG(cfg);

    expected = userInputs(cfg);

    assertEqual(cfg.subject, expected.subject);

    cfg.useGUI = true;
    expected = userInputs(cfg);

    assertEqual(cfg.subject, expected.subject);

end
