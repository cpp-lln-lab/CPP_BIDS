function fieldsToSet = transferInfoToBids(fieldsToSet, cfg)
    % fieldsToSet = transferInfoToBids(fieldsToSet, cfg)
    %
    % transfer any info that might have been provided by the user to the
    % relevant field for its reuse for BIDS filenames or JSON later

    if isfield(cfg, 'task') && isfield(cfg.task, 'name')
        [taskName, taskNameValid] = createValidName(cfg.task.name);
        fieldsToSet.fileName.task = taskNameValid;
        fieldsToSet.bids.meg.TaskName = taskName;
        fieldsToSet.bids.mri.TaskName = taskName;
    end

    if isfield(cfg, 'mri') && isfield(cfg.mri, 'repetitionTime')
        fieldsToSet.bids.mri.RepetitionTime = cfg.mri.repetitionTime;
    end

end
