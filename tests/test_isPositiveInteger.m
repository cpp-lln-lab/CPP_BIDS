% (C) Copyright 2020 CPP_BIDS developers

function test_suite = test_isPositiveInteger %#ok<*STOUT>
    try % assignment of 'localfunctions' is necessary in Matlab >= 2016
        test_functions = localfunctions(); %#ok<*NASGU>
    catch % no problem; early Matlab versions can use initTestSuite fine
    end
    initTestSuite;
end

function test_isPositiveIntegerBasic()

    assertTrue(isPositiveInteger(1));
    assertFalse(isPositiveInteger(nan()));
    assertFalse(isPositiveInteger(0.3));
    assertFalse(isPositiveInteger(-1));
    assertFalse(isPositiveInteger('1'));

end
