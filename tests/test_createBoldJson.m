function test_createBoldJson()

    outputDir = fullfile(fileparts(mfilename('fullpath')), '..', 'output');

    %%% set up part

    expParameters.subjectNb = 1;
    expParameters.runNb = 1;
    expParameters.task = 'testtask';
    expParameters.outputDir = outputDir;

    cfg = struct();
    cfg.testingDevice = 'mri';

    [cfg, expParameters] = createFilename(cfg, expParameters);  %#ok<*ASGLU>

    logFile = saveEventsFile('init', expParameters); %#ok<*NASGU>

    createBoldJson(expParameters);

    %%% test part

    % test data
    funcDir = fullfile(outputDir, 'source', 'sub-001', 'ses-001', 'func');
    eventFilename = ['sub-001_ses-001_task-testtask_run-001_bold_date-' ...
        expParameters.date '.json'];

    % check that the file has the right path and name
    assert(exist(fullfile(funcDir, eventFilename), 'file') == 2);

end
