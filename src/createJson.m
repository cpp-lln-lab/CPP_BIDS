function createJson(varargin)
    %
    % Creates the side car JSON file for a run.
    %
    % For JSON sidecars for bold files, this will only contain the minimum BIDS
    % requirement and will likely be less complete than the info you could from
    % a proper BIDS conversion.
    %
    % USAGE::
    %
    %   createJson(cfg [, modality] [, extraInfo])
    %   createJson(cfg [, extraInfo])
    %
    % :param cfg: Configuration. See ``checkCFG()``.
    % :type cfg: structure
    %
    % :param modality: can be any of the following ``'beh'``, ``'func'``, ``'eeg'``,
    %                  ``'ieeg'``, ``'meg'``) to specify which JSON to save. If it is not
    %                  provided it will read from ``cfg.fileName.modality``.
    % :type modality: string
    %
    % :param extraInfo: contains information in the JSON file. Beware
    %                   that the BIDS validator is pretty strict on what information can
    %                   go in a JSON so this can be useful to store additional information
    %                   in your source dataset but it might have to be cleaned up to create
    %                   a valid BIDS dataset.
    % :type extraInfo: structure
    %
    % :output:
    %          - :``*.json``: (jsonfile) The file name corresponds to the run + suffix depending
    %                         on the arguments passed in.
    %
    %

    % (C) Copyright 2020 CPP_BIDS developers

    %% Parse inputs
    % modality is either given as a string by user or guessed from cfg.fileName
    % extraInfo must be a structure

    args = inputParser;

    default_modality = '';
    default_extraInfo = struct([]);

    charOrStruct = @(x) isstruct(x) || ischar(x);

    args.addRequired('input', @isstruct);
    args.addOptional('modality', default_modality, charOrStruct);
    args.addOptional('extraInfo', default_extraInfo, @isstruct);

    args.parse(varargin{:});

    cfg = args.Results.input;
    modality = args.Results.modality;
    extraInfo = args.Results.extraInfo;

    if ischar(modality) && strcmp(modality, default_modality) && isfield(cfg.fileName, 'modality')
        modality = cfg.fileName.modality;
    end

    if isstruct(modality) && isfield(cfg.fileName, 'modality')
        extraInfo = modality;
        modality = cfg.fileName.modality;
    end

    if ~ischar(modality) || all(~strcmpi(modality, {'beh', 'func', 'eeg', 'ieeg', 'meg'}))
        errorCreateJson('wrongModalityInput', modality);
    end

    % adapt depending on input
    if strcmp(modality, 'func')
        fileName = strrep(cfg.fileName.events, '_events', '_bold');
        jsonContent = cfg.bids.mri;
    else
        fileName = strrep(cfg.fileName.events, '_events', ['_' modality]);
        jsonContent = cfg.bids.(modality);
    end

    fileName = strrep(fileName, '.tsv', '.json');
    fullFilename = getFullFilename(fileName, cfg);

    %% add content of extraInfo to the JSON content

    fieldList = fieldnames(extraInfo);
    for iField = 1:numel(fieldList)
        jsonContent.(fieldList{iField}) =  extraInfo.(fieldList{iField});
    end

    %% save
    bids.util.jsonencode(fullFilename, jsonContent);

end

function errorCreateJson(identifier, varargin)

    switch identifier

        case 'wrongModalityInput'
            errorStruct.message = sprintf(['The given modality is not valid: %s.\n', ...
                                           'Only the following string are accepted: ' ...
                                           'beh, func, eeg, ieeg, meg'], ...
                                          varargin{1});

    end

    errorStruct.identifier = ['createJson:' identifier];

    error(errorStruct);
end
