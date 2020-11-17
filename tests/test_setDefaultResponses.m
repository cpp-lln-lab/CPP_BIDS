% (C) Copyright 2020 CPP_BIDS developers

function test_suite = test_setDefaultResponses %#ok<*STOUT>
    try % assignment of 'localfunctions' is necessary in Matlab >= 2016
        test_functions = localfunctions(); %#ok<*NASGU>
    catch % no problem; early Matlab versions can use initTestSuite fine
    end
    initTestSuite;
end

function test_setDefaultResponsesBasic()

    %%
    [~, responses] = setDefaultResponses(); %#ok<*NODEF>

    expectedCell{1, 1} = '';
    expectedCell{2, 1} = '';
    expectedCell{3, 1} = 1;
    expectedCell{4, 1} = '';

    assertEqual(expectedCell, responses);

    %%
    cfg.debug.do = true;
    [~, responses] = setDefaultResponses(cfg);

    expectedCell{1, 1} = 'ctrl';
    expectedCell{2, 1} = 666;
    expectedCell{3, 1} = 666;
    expectedCell{4, 1} = 666;

    assertEqual(expectedCell, responses);

end
