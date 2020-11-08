% (C) Copyright 2020 CPP_BIDS developers

function [name, nameValid] = createValidName(name)
    % [taskName, taskNameValid] = createTaskName(taskName)
    %
    % Name of the task (for resting state use the "rest" prefix). No two tasks
    % should have the same name. Task label is derived from this field by
    % removing all non alphanumeric ([a-zA-Z0-9]) characters.

    % camel case: upper case for first letter for all words but the first one
    spaceIdx = regexp(name, '[a-zA-Z0-9]*', 'start');
    name(spaceIdx(2:end)) = upper(name(spaceIdx(2:end)));

    % remove invalid characters
    [unvalidCharacters] = regexp(name, '[^a-zA-Z0-9]');
    nameValid = name;
    nameValid(unvalidCharacters) = [];

end
