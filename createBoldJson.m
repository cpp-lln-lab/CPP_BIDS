function createBoldJson(cfg)

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
