% (C) Copyright 2020 CPP_BIDS developers

function test_suite = test_nanPadding %#ok<*STOUT>
    try % assignment of 'localfunctions' is necessary in Matlab >= 2016
        test_functions = localfunctions(); %#ok<*NASGU>
    catch % no problem; early Matlab versions can use initTestSuite fine
    end
    initTestSuite;
end

function test_nanPaddingBasic()

    cfg.verbose = 1;

    %%
    data = 'test';
    expectedLength = 2;

    data = nanPadding(cfg, data, expectedLength);

    assertEqual(data, 'test');

    %%
    data = [1 0];
    expectedLength = 2;

    data = nanPadding(cfg, data, expectedLength);

    assertEqual(data, [1 0]);

    %%
    data = [1 0];
    expectedLength = 3;

    data = nanPadding(cfg, data, expectedLength);

    assertEqual(data, [1 0 NaN]);

    %%
    %%
    data = [1 0 1];
    expectedLength = 2;

    data = nanPadding(cfg, data, expectedLength);

    assertEqual(data, [1 0]);

end
