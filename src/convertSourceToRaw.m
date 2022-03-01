function convertSourceToRaw(cfg)
    %
    % Function attempts to convert a source dataset created with CPP_BIDS into a valid
    % BIDS data set.
    %
    %
    % USAGE::
    %
    %   convertSourceToRaw(cfg)
    %
    % :param cfg: cfg structure is needed only for providing the path in ``cfg.dir.output``.
    % :type cfg: structure
    %
    % :output:
    %          - :creates: a dummy README and CHANGE file
    %          - :copies: ``source`` directory to ``raw`` directory
    %          - :removes: the date suffix ``_date-*`` from the files where it is present
    %          - :zips: the ``_stim.tsv`` files.
    %
    % (C) Copyright 2020 CPP_BIDS developers

    sourceDir = fullfile(cfg.dir.output, 'source');
    rawDir = fullfile(cfg.dir.output, 'raw');

    % add dummy README and CHANGE file
    templateFolder = fullfile(fileparts(mfilename('fullpath')), '..', 'templates');

    copyfile(fullfile(templateFolder, 'README'), ...
             sourceDir);
    copyfile(fullfile(templateFolder, 'CHANGES'), ...
             sourceDir);
    copyfile(fullfile(templateFolder, '.bidsignore'), ...
             sourceDir);

    copyfile(sourceDir, rawDir);
    
    BIDS = bids.layout(rawDir,  'use_schema', false);
    
    data = bids.query(BIDS, 'data');

    for i = 1:size(data, 1)
      bf = bids.File(data{i});
      if isfield(bf.entities, 'date')
        sourceJson = fullfile(fileparts(bf.path), bf.json_filename);
        metadata = bids.util.jsondecode(sourceJson);
        bf.entities.date = '';
        bf.rename('dry_run', false, 'force', true);
        bids.util.jsonencode(fullfile(fileparts(bf.path), bf.json_filename), metadata);
        delete(sourceJson);
      end
    end

end


function compressFiles(filenames, subjectPath)
    if isempty(filenames)
        filenames = {};
    else
        filenames = cellstr(filenames);
    end

    for i = 1:numel(filenames)

        gzip(fullfile(subjectPath, filenames{i}));
        delete(fullfile(subjectPath, filenames{i}));

    end
end

