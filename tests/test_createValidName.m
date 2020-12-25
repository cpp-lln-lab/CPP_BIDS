% (C) Copyright 2020 CPP_BIDS developers

function test_suite = test_createValidName %#ok<*STOUT>
    try % assignment of 'localfunctions' is necessary in Matlab >= 2016
        test_functions = localfunctions(); %#ok<*NASGU>
    catch % no problem; early Matlab versions can use initTestSuite fine
    end
    initTestSuite;
end

function test_createTaskNameRemoveInvalidCharacters()

    %% set up

    taskName = '&|@#-_(!{})[]%+/=:;.?,\<> visual task';

    [~, taskNameValid] = createValidName(taskName);

    [unvalidCharacters] = regexp(taskNameValid, '[^a-zA-Z0-9]');

    %% test
    assertTrue(isempty(unvalidCharacters));

    %% set up
    taskName = ' 09 visual task';

    [~, taskNameValid] = createValidName(taskName);

    [unvalidCharacters] = regexp(taskNameValid, '[^a-zA-Z0-9]');

    %% test
    assertTrue(isempty(unvalidCharacters));

    taskName = 'foo bar';
    [taskName, taskNameValid] = createValidName(taskName);
    assert(isequal(taskName, 'foo Bar'));
    assert(isequal(taskNameValid, 'fooBar'));

end

function test_createTaskNameCamelCase()

    %% set up
    taskName = 'foo bar';
    [taskName, taskNameValid] = createValidName(taskName);

    %% test
    assertEqual(taskName, 'foo Bar');
    assertEqual(taskNameValid, 'fooBar');

end
