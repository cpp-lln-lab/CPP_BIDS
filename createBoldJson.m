function createBoldJson(cfg)
    % createBoldJson(cfg)
    %
    % Creates the side car JSON file for a BOLD functional run.
    % This will only contain the minimum BIDS requirement and will likey be less
    % complete than the info you could from DICOM conversion.

    opts.Indent = '    ';

    fileName = strrep(cfg.fileName.events, '_events', '_bold');
    fileName = strrep(fileName, '.tsv', '.json');

    fileName = fullfile( ...
        cfg.dir.outputSubject, ...
        cfg.fileName.modality, ...
        fileName);

    jsonContent = cfg.bids.mri;

    bids.util.jsonencode(fileName, jsonContent, opts);

end
