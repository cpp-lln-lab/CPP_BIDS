% (C) Copyright 2020 CPP_BIDS developers

function test_suite = test_userInputs %#ok<*STOUT>
    try % assignment of 'localfunctions' is necessary in Matlab >= 2016
        test_functions = localfunctions(); %#ok<*NASGU>
    catch % no problem; early Matlab versions can use initTestSuite fine
    end
    initTestSuite;
end

function test_userInputs_prefilled_cfg()

    %%
    cfg.debug.do = false;
    cfg.subject.askGrpSess = [false false];
    cfg.subject.subjectGrp = 'foo';
    cfg.subject.subjectNb = 2;
    cfg.subject.sessionNb = 2;
    cfg.subject.runNb = 2;

    expected = userInputs(cfg);

    assertEqual(cfg.subject, expected.subject);

end
