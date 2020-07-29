function test_createBoldJson()

    outputDir = fullfile(fileparts(mfilename('fullpath')), '..', 'output');

    %%% set up part

    cfg.subject.subjectNb = 1;
    cfg.subject.runNb = 1;
    cfg.task.name = 'testtask';
    cfg.dir.output = outputDir;

    % cfg = struct();
    cfg.testingDevice = 'mri';

    cfg = createFilename(cfg);

    logFile = saveEventsFile('init', cfg); %#ok<*NASGU>

    createBoldJson(cfg);

    %%% test part

    % test data
    funcDir = fullfile(outputDir, 'source', 'sub-001', 'ses-001', 'func');
    eventFilename = ['sub-001_ses-001_task-testtask_run-001_bold_date-' ...
        cfg.fileName.date '.json'];

    % check that the file has the right path and name
    assert(exist(fullfile(funcDir, eventFilename), 'file') == 2);

end
