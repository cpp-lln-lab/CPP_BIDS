% (C) Copyright 2020 CPP_BIDS developers

function test_suite = test_removeDateSuffix %#ok<*STOUT>
    try % assignment of 'localfunctions' is necessary in Matlab >= 2016
        test_functions = localfunctions(); %#ok<*NASGU>
    catch % no problem; early Matlab versions can use initTestSuite fine
    end
    initTestSuite;
end

function test_removeDateSuffixBasic()

    outputDir = pwd;

    createFiles = 0;
    testDo = 1;

    %% set up
    boldName = 'test_bold_date-202008050730.nii.gz';
    boldName2 = 'test2_bold.nii.gz';
    boldName3 = 'test3_bold_date-202008050730.nii';
    jsonName = 'test_bold_date-202008050730.json';
    eventsName = 'test_events_date-202008050730.tsv';
    stimName = 'test_stim_date-202008050730.tsv';
    stimNameZipped = 'test2_stim_date-202008050730.tsv.gz';
    stimJsonName = 'test_stim_date-202008050730.json';

    filesToProcess = { ...
                      boldName
                      boldName2
                      boldName3
                      jsonName
                      eventsName
                      stimName
                      stimNameZipped
                      stimJsonName
                     };

    % create new files for new tests
    for iFile = 1:numel(filesToProcess)
        system(sprintf('touch %s', filesToProcess{iFile}));
    end

    %% do stuff
    filenames = file_utils('List', outputDir, '^test.*$');

    %% expected data
    expectedBoldName = 'test_bold.nii.gz';
    expectedBoldName2 = 'test2_bold.nii.gz';
    expectedBoldName3 = 'test3_bold.nii';
    expectedJsonName = 'test_bold.json';
    expectedEventsName = 'test_events.tsv';
    expectedStimName = 'test_stim.tsv';
    expectedStimNameZipped = 'test2_stim.tsv.gz';
    expectedStimJson = 'test_stim.json';

    removeDateSuffix(filenames, outputDir);

    %% test
    fprintf(1, fullfile(outputDir, expectedBoldName3));
    assertEqual(exist(fullfile(outputDir, expectedBoldName3), 'file'), 2);
    assertEqual(exist(fullfile(outputDir, expectedJsonName), 'file'), 2);
    fprintf(1, fullfile(outputDir, expectedEventsName));
    assertEqual(exist(fullfile(outputDir, expectedEventsName), 'file'), 2);
    assertEqual(exist(fullfile(outputDir, expectedStimName), 'file'), 2);
    assertEqual(exist(fullfile(outputDir, expectedStimNameZipped), 'file'), 2);
    assertEqual(exist(fullfile(outputDir, expectedBoldName2), 'file'), 2);
    assertEqual(exist(fullfile(outputDir, expectedBoldName), 'file'), 2);
    assertEqual(exist(fullfile(outputDir, expectedStimJson), 'file'), 2);

    % clean up
    delete('*.nii*');
    delete('*.tsv*');
    delete('*.json');

end
