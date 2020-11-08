% (C) Copyright 2020 CPP_BIDS developers

function createJson(varargin)
    %
    % Creates the side car JSON file for a run.
    %
    % For JSON sidecars for bold files,  this will only contain the minimum BIDS
    % requirement and will likey be less complete than the info you could from
    % a proper BIDS conversion.
    %
    % USAGE::
    %
    %   createJson(cfg [, modality] [, extraInfo])
    %   createJson(cfg [, extraInfo])
    %
    % :param cfg: Configuration. See ``checkCFG()``.
    % :type cfg: structure
    % :param modality: can be any of the following ``'beh'``, ``'func'``, ``'eeg'``,
    %                  ``'ieeg'``, ``'meg'``) to specify which JSON to save. If it is not
    %                  provided it will read from ``cfg.fileName.modality``.
    % :type modality: string
    % :param extraInfo: contains information in the JSON file. Beware
    %                   that the BIDS validator is pretty strict on what information can
    %                   go in a JSON so this can be useful to store additional information
    %                   in your source dataset but it might have to be cleaned up to create
    %                   a valid BIDS dataset.
    % :type extraInfo: structure
    %
    % .. TODO:
    %
    %    - use input parser for this one
    %

    [cfg, modality, extraInfo] = checkInput(varargin);

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
    opts.Indent = '    ';
    bids.util.jsonencode(fullFilename, jsonContent, opts);

end

function [cfg, modality, extraInfo] = checkInput(varargin)

    % trying to parse inputs
    % modality is either given as a string by user or guessed from cfg.fileName
    % extraInfo must be a structure

    input = varargin{1};

    modality = '';
    extraInfo = struct();

    switch numel(input)

        case 0
            errorCreateJson('notEnoughInput');

        case 1
            cfg = input{1};
            if isfield(cfg.fileName, 'modality')
                modality = cfg.fileName.modality;
            end

        case 2
            cfg = input{1};
            if ischar(input{2})
                modality = input{2};
            elseif isstruct(input{2})
                modality = cfg.fileName.modality;
                extraInfo = input{2};
            else
                errorCreateJson('wrongInputType');
            end

        otherwise
            cfg = input{1};
            modality = input{2};
            extraInfo = input{3};

    end

    if ~ischar(modality) || ...
            all(~strcmpi(modality, {'beh', 'func', 'eeg', 'ieeg', 'meg'}))
        errorCreateJson('wrongModalityInput', modality);
    end

    if ~isstruct(extraInfo)
        warning('Additional info added to a json file must be a structure.');
    end

end

function errorCreateJson(identifier, varargin)

    switch identifier
        case 'notEnoughInput'
            errorStruct.message = 'First input must be a valid cfg structure.';

        case 'wrongInputType'
            errorStruct.message = ['The second input must be a string (modality)' ...
                                   'or a structure (extraInfo)'];
        case 'wrongModalityInput'
            errorStruct.message = sprintf(['The given modality is not valid: %s.\n', ...
                                           'Only the following string are accepted: ' ...
                                           'beh, func, eeg, ieeg, meg'], ...
                                          varargin{1});

    end

    errorStruct.identifier = ['createJson:' identifier];

    error(errorStruct);
end
