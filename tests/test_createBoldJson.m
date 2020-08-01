function test_suite = test_createBoldJson %#ok<*STOUT>
    try % assignment of 'localfunctions' is necessary in Matlab >= 2016
        test_functions = localfunctions(); %#ok<*NASGU>
    catch % no problem; early Matlab versions can use initTestSuite fine
    end
    initTestSuite;
end

function test_createBoldJsonBasic()

    outputDir = fullfile(fileparts(mfilename('fullpath')), '..', 'output');

    %% set up 

    cfg.verbose = false;
    
    cfg.subject.subjectNb = 1;
    cfg.subject.runNb = 1;
    
    cfg.task.name = 'testtask';
    
    cfg.dir.output = outputDir;

    cfg.testingDevice = 'mri';

    cfg = createFilename(cfg);

    logFile = saveEventsFile('init', cfg); %#ok<*NASGU>

    createBoldJson(cfg);

    %% data to test against
    funcDir = fullfile(outputDir, 'source', 'sub-001', 'ses-001', 'func');
    
    eventFilename = ['sub-001_ses-001_task-testtask_run-001_bold_date-' ...
        cfg.fileName.date '.json'];

    %% test
    assertTrue(exist(fullfile(funcDir, eventFilename), 'file') == 2);

end
