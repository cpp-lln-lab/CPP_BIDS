% (C) Copyright 2020 CPP_BIDS developers

function test_suite = test_askUserCli %#ok<*STOUT>
    try % assignment of 'localfunctions' is necessary in Matlab >= 2016
        test_functions = localfunctions(); %#ok<*NASGU>
    catch % no problem; early Matlab versions can use initTestSuite fine
    end
    initTestSuite;
end

function test_askUserCli_do_not_show_anything()

    items = returnDefaultQuestionnaire();
    items(1).show = false;
    items(2).show = false;
    items(3).show = false;
    items(4).show = false;

    expected = askUserCli(items);

    assertEqual(items, expected);

end

function test_askUserCli_do_not_show_prefilled_items()

    items = returnDefaultQuestionnaire();
    items(2).response = 1;

    items(1).show = false;
    items(3).show = false;
    items(4).show = false;

    items = askUserCli(items);
    expected = items;
    items(2).show = false;

    assertEqual(items, expected);

end

function test_askUserCli_do_not_show_prefilled_items_2()

    cfg = struct();
    cfg.subject.subjectNb = 1;
    cfg.subject.askGrpSess = [false false];

    items = createQuestionnaire(cfg);
    items(4).show = false;

    items = askUserCli(items);

    expected = returnDefaultQuestionnaire();
    expected(1).show = false;
    expected(2).show = false;
    expected(2).response = 1;
    expected(3).show = false;
    expected(3).show = false;

end
