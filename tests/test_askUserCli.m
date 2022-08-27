% (C) Copyright 2020 CPP_BIDS developers

function test_suite = test_askUserCli %#ok<*STOUT>
    try % assignment of 'localfunctions' is necessary in Matlab >= 2016
        test_functions = localfunctions(); %#ok<*NASGU>
    catch % no problem; early Matlab versions can use initTestSuite fine
    end
    initTestSuite;
end

% no one of those tests should go to the prompt.
% if they do they should "fail"

function test_askUserCli_do_not_show_anything()

    items = returnDefaultQuestionnaire();
    items.group.show = false;
    items.subject.show = false;
    items.session.show = false;
    items.run.show = false;

    expected = askUserCli(items);

    assertEqual(items, expected);

end

function test_askUserCli_do_not_show_prefilled_items()

    items = returnDefaultQuestionnaire();
    items.subject.response = 1;

    items.group.show = false;
    items.session.show = false;
    items.run.show = false;

    items = askUserCli(items);
    expected = items;
    items.subject.show = false;

    assertEqual(items, expected);

end

function test_askUserCli_do_not_show_prefilled_items_2()

    cfg = struct();
    cfg.subject.subjectNb = 1;
    cfg.subject.ask = {};

    items = createQuestionnaire(cfg);
    items.run.show = false;

    items = askUserCli(items);

end

function test_askUserCli_do_not_show_prefilled_items_3()

    % we are asking for group but it is prefilled
    cfg = struct();
    cfg.subject.subjectGrp = 'ctrl';
    cfg.subject.subjectNb = 1;
    cfg.subject.ask = {'grp'};

    items = createQuestionnaire(cfg);
    items.run.show = false;

    items = askUserCli(items);

end
