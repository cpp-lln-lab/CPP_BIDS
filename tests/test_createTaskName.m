function test_createTaskName()
    %

    taskName = '&|@#-_(§!{})[]ù%£+/=:;.?,\<> visual task';

    [taskName, taskNameValid] = createTaskName(taskName);

    [unvalidCharacters] = regexp(taskNameValid, '[^a-zA-Z0-9]');

    assert(isempty(unvalidCharacters));

    taskName = ' 09 visual task';

    [taskName, taskNameValid] = createTaskName(taskName);

    [unvalidCharacters] = regexp(taskNameValid, '[^a-zA-Z0-9]');

    assert(isempty(unvalidCharacters));

    taskName = 'foo bar';
    [taskName, taskNameValid] = createTaskName(taskName);
    assert(isequal(taskName, 'foo Bar'));
    assert(isequal(taskNameValid, 'fooBar'));

end
