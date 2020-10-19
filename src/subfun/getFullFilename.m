% (C) Copyright 2020 CPP_BIDS developers

function fullFilename = getFullFilename(fileName, cfg)

    fullFilename = fullfile( ...
                            cfg.dir.outputSubject, ...
                            cfg.fileName.modality, ...
                            fileName);

end
