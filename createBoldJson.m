function createBoldJson(cfg)

    opts.Indent = '    ';

    fileName = strrep(cfg.fileName.events, '_events', '_bold');
    fileName = strrep(fileName, '.tsv', '.json');

    fileName = fullfile( ...
        cfg.subjectOutputDir, ...
        cfg.modality, ...
        fileName);

    jsonContent = cfg.bids.MRI;

    bids.util.jsonencode(fileName, jsonContent, opts);

end
