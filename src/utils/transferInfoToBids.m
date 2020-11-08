% (C) Copyright 2020 CPP_BIDS developers

function fieldsToSet = transferInfoToBids(fieldsToSet, cfg)
    %
    % Short description of what the function does goes here.
    %
    % USAGE::
    %
    %   [argout1, argout2] = templateFunction(argin1, [argin2 == default,] [argin3])
    %
    % :param argin1: (dimension) obligatory argument. Lorem ipsum dolor sit amet,
    %                consectetur adipiscing elit. Ut congue nec est ac lacinia.
    % :type argin1: type
    % :param argin2: optional argument and its default value. And some of the
    %               options can be shown in litteral like ``this`` or ``that``.
    % :type argin2: string
    % :param argin3: (dimension) optional argument
    % :type argin3: integer
    %
    % :returns: - :argout1: (type) (dimension)
    %           - :argout2: (type) (dimension)
    %
    % fieldsToSet = transferInfoToBids(fieldsToSet, cfg)
    %
    % transfer any info that might have been provided by the user to the
    % relevant field for its reuse for BIDS filenames or JSON later

    if isfield(cfg, 'task') && isfield(cfg.task, 'name')
        [taskName, taskNameValid] = createValidName(cfg.task.name);
        fieldsToSet.fileName.task = taskNameValid;
        fieldsToSet.bids.meg.TaskName = taskName;
        fieldsToSet.bids.eeg.TaskName = taskName;
        fieldsToSet.bids.ieeg.TaskName = taskName;
        fieldsToSet.bids.beh.TaskName = taskName;
        fieldsToSet.bids.mri.TaskName = taskName;
    end

    if isfield(cfg, 'task') && isfield(cfg.task, 'instructions')
        fieldsToSet.bids.meg.Instructions = cfg.task.instructions;
        fieldsToSet.bids.eeg.Instructions = cfg.task.instructions;
        fieldsToSet.bids.ieeg.Instructions = cfg.task.instructions;
        fieldsToSet.bids.beh.Instructions = cfg.task.instructions;
        fieldsToSet.bids.mri.Instructions = cfg.task.instructions;
    end

    if isfield(cfg, 'mri') && isfield(cfg.mri, 'repetitionTime')
        fieldsToSet.bids.mri.RepetitionTime = cfg.mri.repetitionTime;
    end

end
