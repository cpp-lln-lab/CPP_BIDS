function [cfg, logFile] = setUp()

    % (C) Copyright 2020 CPP_BIDS developers

    cfg = globalTestSetUp();

    cfg.testingDevice = 'mri';

    cfg = createFilename(cfg);

    logFile.extraColumns = {'Speed', 'LHL24', 'is_Fixation'};

    logFile = saveEventsFile('init', cfg, logFile);

    logFile.extraColumns.Speed.length = 1;
    logFile.extraColumns.LHL24.length = 12;
    logFile.extraColumns.is_Fixation.length = 1;

end
