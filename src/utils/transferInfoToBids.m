% (C) Copyright 2020 CPP_BIDS developers

function fieldsToSet = transferInfoToBids(fieldsToSet, cfg)
    %
    % Transfers any info that might have been provided
    % by the user in ``cfg`` to the relevant field of ``fieldsToSet``
    % for its reuse later for BIDS filenames or JSON.
    %
    % USAGE::
    %
    %   fieldsToSet = transferInfoToBids(fieldsToSet, cfg)
    %
    % :param fieldsToSet: List of the fields to set. See ``checkCFG()``.
    % :type fieldsToSet: structure
    % :param cfg: The configuration variable where the user has predefined some fields.
    %             See ``checkCFG()``.
    % :type cfg: structure
    %
    % :returns: :fieldsToSet: Updated list of the fields to set.
    %
    % This can be used for example to make sure that the repetition time set
    % manually in ``cfg.mri.repetitionTime`` or in ``cfg.task.name``
    % will be passed to the correct field in right fields of ``cfg.bids``.
    %

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
