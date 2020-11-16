% (C) Copyright 2020 CPP_BIDS developers

function [name, nameValid] = createValidName(name)
    %
    % Creates a BIDS valid name: for the task in file names.
    %
    % USAGE::
    %
    %   [taskName, taskNameValid] = createTaskName(taskName)
    %
    % :param taskName: (dimension) obligatory argument. Lorem ipsum dolor sit amet,
    %                consectetur adipiscing elit. Ut congue nec est ac lacinia.
    % :type argin1: string
    %
    % :returns:
    %           :name: (string) returns the input with an upper case for first letter
    %                  for all words but the first one (``camelCase``).
    %           :nameValid: (string) same as above but removes invalid characters (like spaces).
    %
    % Name of the task (for resting state use the "rest" prefix). No two tasks
    % should have the same name. Task label is derived from this field by
    % removing all non alphanumeric ([a-zA-Z0-9]) characters.
    %
    % Example:
    % % taskName = 'foo bar';
    % % [taskName, taskNameValid] = createValidName(taskName);
    % % disp(taskName),
    % % || 'foo Bar'
    % % disp(taskNameValid)
    % % || 'fooBar'
    %

    % camel case: upper case for first letter for all words but the first one
    spaceIdx = regexp(name, '[a-zA-Z0-9]*', 'start');
    name(spaceIdx(2:end)) = upper(name(spaceIdx(2:end)));

    % remove invalid characters
    [unvalidCharacters] = regexp(name, '[^a-zA-Z0-9]');
    nameValid = name;
    nameValid(unvalidCharacters) = [];

end
