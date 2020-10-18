function test_suite = test_createDataDictionary %#ok<*STOUT>
    try % assignment of 'localfunctions' is necessary in Matlab >= 2016
        test_functions = localfunctions(); %#ok<*NASGU>
    catch % no problem; early Matlab versions can use initTestSuite fine
    end
    initTestSuite;
end

function test_createDataDictionaryBasic()

    outputDir = fullfile(fileparts(mfilename('fullpath')), '..', 'output');

    %% set up

    cfg.verbose = false;

    cfg.subject.subjectNb = 1;
    cfg.subject.runNb = 1;

    cfg.task.name = 'testtask';

    cfg.dir.output = outputDir;

    cfg.testingDevice = 'mri';

    cfg = createFilename(cfg);

    logFile.extraColumns.Speed.length = 1;
    logFile.extraColumns.LHL24.length = 3;
    logFile = saveEventsFile('init', cfg, logFile);

    logFile = saveEventsFile('open', cfg, logFile);

    createDataDictionary(cfg, logFile);

    %% check that the file has the right path and name

    % data to test against
    funcDir = fullfile(outputDir, 'source', 'sub-001', 'ses-001', 'func');

    jsonFilename = ['sub-001_ses-001_task-testtask_run-001_events_date-' ...
                    cfg.fileName.date '.json'];

    % test
    assertTrue(exist(fullfile(funcDir, jsonFilename), 'file') == 2);

    %% check content
    actualStruct = bids.util.jsondecode(fullfile(funcDir, jsonFilename));

    % data to test against
    expectedStruct = bids.util.jsondecode( ...
                                          fullfile(pwd, 'testData', 'eventsDataDictionary.json'));

    % test
    assertTrue(isequal(expectedStruct, actualStruct));

end
