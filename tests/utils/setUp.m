% (C) Copyright 2020 CPP_BIDS developers

function [cfg, logFile] = setUp()

    cfg.verbose = 2;

    cfg.subject.subjectNb = 1;
    cfg.subject.runNb = 1;

    cfg.task.name = 'testtask';

    cfg.testingDevice = 'mri';

    cfg = createFilename(cfg);

    logFile.extraColumns = {'Speed', 'LHL24', 'is_Fixation'};

    logFile = saveEventsFile('init', cfg, logFile);

    logFile.extraColumns.Speed.length = 1;
    logFile.extraColumns.LHL24.length = 12;
    logFile.extraColumns.is_Fixation.length = 1;

end
