function test_suite = test_createBoldJson %#ok<*STOUT>
    try % assignment of 'localfunctions' is necessary in Matlab >= 2016
        test_functions = localfunctions(); %#ok<*NASGU>
    catch % no problem; early Matlab versions can use initTestSuite fine
    end
    initTestSuite;
end

function test_createBoldJsonExtra()

    outputDir = fullfile(fileparts(mfilename('fullpath')), 'output');

    %% set up

    cfg.verbose = false;

    cfg.subject.subjectNb = 1;
    cfg.subject.runNb = 1;

    cfg.task.name = 'testtask';

    cfg.dir.output = outputDir;

    cfg.testingDevice = 'mri';

    cfg = createFilename(cfg);

    logFile = saveEventsFile('init', cfg); %#ok<*NASGU>
    
    extraInfo = struct('extraInfo', struct('nestedExtraInfo', 'something extra'));

    createBoldJson(cfg, extraInfo);

    %% check content
    fileName = strrep(cfg.fileName.events, '_events', '_bold');
    fileName = strrep(fileName, '.tsv', '.json');
    
    actualStruct = bids.util.jsondecode(fullfile( ...
        cfg.dir.outputSubject, ...
        cfg.fileName.modality, ...
        fileName));

    % data to test against
    expectedStruct = bids.util.jsondecode( ...
        fullfile(pwd, 'testData', 'extra_bold.json'));

    % test
    assertEqual(expectedStruct, actualStruct);

end
