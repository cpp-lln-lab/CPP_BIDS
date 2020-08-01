function test_suite = test_createTaskName %#ok<*STOUT>
    try % assignment of 'localfunctions' is necessary in Matlab >= 2016
        test_functions = localfunctions(); %#ok<*NASGU>
    catch % no problem; early Matlab versions can use initTestSuite fine
    end
    initTestSuite;
end

function test_createTaskNameRemoveInvalidCharacters()

    %% set up

    taskName = '&|@#-_(§!{})[]ù%£+/=:;.?,\<> visual task';

    [taskName, taskNameValid] = createTaskName(taskName);

    [unvalidCharacters] = regexp(taskNameValid, '[^a-zA-Z0-9]');

    %% test
    assertTrue(isempty(unvalidCharacters));

    %% set up
    taskName = ' 09 visual task';

    [taskName, taskNameValid] = createTaskName(taskName);

    [unvalidCharacters] = regexp(taskNameValid, '[^a-zA-Z0-9]');

    %% test
    assertTrue(isempty(unvalidCharacters));

    taskName = 'foo bar';
    [taskName, taskNameValid] = createTaskName(taskName);
    assert(isequal(taskName, 'foo Bar'));
    assert(isequal(taskNameValid, 'fooBar'));

end

function test_createTaskNameCamelCase()

    %% set up
    taskName = 'foo bar';
    [taskName, taskNameValid] = createTaskName(taskName);

    %% test
    assertEqual(taskName, 'foo Bar');
    assertEqual(taskNameValid, 'fooBar');

end
