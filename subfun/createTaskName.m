function [taskName, taskNameValid] = createTaskName(taskName)
    % [taskName, taskNameValid] = createTaskName(taskName)
    %
    % Name of the task (for resting state use the "rest" prefix). No two tasks
    % should have the same name. Task label is derived from this field by
    % removing all non alphanumeric ([a-zA-Z0-9]) characters.

    % camel case: upper case for first letter for all words but the first one
    spaceIdx = regexp(taskName, '[a-zA-Z0-9]*', 'start');
    taskName(spaceIdx(2:end)) = upper(taskName(spaceIdx(2:end)));

    % remove invalid characters
    [unvalidCharacters] = regexp(taskName, '[^a-zA-Z0-9]');
    taskNameValid = taskName;
    taskNameValid(unvalidCharacters) = [];

end
