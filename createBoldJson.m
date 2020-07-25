function createBoldJson(expParameters)

    opts.Indent = '    ';

    fileName = strrep(expParameters.fileName.events, '_events', '_bold');
    fileName = strrep(fileName, '.tsv', '.json');

    fileName = fullfile( ...
        expParameters.subjectOutputDir, ...
        expParameters.modality, ...
        fileName);

    jsonContent = expParameters.bids.MRI;

    bids.util.jsonencode(fileName, jsonContent, opts);

end
