function test_createDataDictionary()

    fprintf('\n\n--------------------------------------------------------------------\n\n');

    outputDir = fullfile(fileparts(mfilename('fullpath')), '..', 'output');

    %%% set up part

    expParameters.subjectNb = 1;
    expParameters.runNb = 1;
    expParameters.task = 'testtask';
    expParameters.outputDir = outputDir;

    cfg = struct();
    cfg.testingDevice = 'mri';

    [cfg, expParameters] = createFilename(cfg, expParameters);
    logFile = saveEventsFile('open', expParameters);

    createDataDictionary(expParameters, logFile);

    %%% test part

    % test data
    funcDir = fullfile(outputDir, 'source', 'sub-001', 'ses-001', 'func');
    eventFilename = ['sub-001_ses-001_task-testtask_run-001_events_date-' ...
        expParameters.date '.json'];

    % check that the file has the right path and name
    assert(exist(fullfile(funcDir, eventFilename), 'file') == 2);

end
