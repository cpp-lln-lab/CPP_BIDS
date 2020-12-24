% (C) Copyright 2020 CPP_BIDS developers

function test_suite = test_checkInput %#ok<*STOUT>
    try % assignment of 'localfunctions' is necessary in Matlab >= 2016
        test_functions = localfunctions(); %#ok<*NASGU>
    catch % no problem; early Matlab versions can use initTestSuite fine
    end
    initTestSuite;
end

function test_checkInputBasic()

    data = checkInput(1);
    assertEqual(data, 1);

    data = checkInput('test');
    assertEqual(data, 'test');

    data = checkInput('');
    assertEqual(data, 'n/a');

    data = checkInput(' ');
    assertEqual(data, 'n/a');

    data = checkInput([]);
    assertEqual(data, nan);

    data = checkInput(true());
    assertEqual(data, 'true');

    data = checkInput(false());
    assertEqual(data, 'false');

end
