function createBoldJson(cfg, extraInfo)
    % createBoldJson(cfg, extraInfo)
    %
    % Creates the side car JSON file for a BOLD functional run.
    % This will only contain the minimum BIDS requirement and will likey be less
    % complete than the info you could from DICOM conversion.
    %
    % Extra content can be added to the JSON file

    opts.Indent = '    ';
    
    if nargin<2
        extraInfo = struct();
    end

    fileName = strrep(cfg.fileName.events, '_events', '_bold');
    fileName = strrep(fileName, '.tsv', '.json');

    fileName = fullfile( ...
        cfg.dir.outputSubject, ...
        cfg.fileName.modality, ...
        fileName);

    jsonContent = cfg.bids.mri;
    
    % add content of extraInfo to the JSON content
    if ~isstruct(extraInfo)
        warning('additional info added to a json file must be a structure')
    end   
    fieldList = fieldnames(extraInfo);
    for iField = 1:numel(fieldList)
        jsonContent.(fieldList{iField}) =  extraInfo.(fieldList{iField});
    end

    bids.util.jsonencode(fileName, jsonContent, opts);

end
