function test_suite = test_removeDateSuffix %#ok<*STOUT>
    try % assignment of 'localfunctions' is necessary in Matlab >= 2016
        test_functions = localfunctions(); %#ok<*NASGU>
    catch % no problem; early Matlab versions can use initTestSuite fine
    end
    initTestSuite;
end


function test_removeDateSuffixBasic()

    %% set up
    cfg.dir.output = fullfile(fileparts(mfilename('fullpath')), '..', 'output');
    
    % clean up
    if isdir(cfg.dir.output)
        rmdir(cfg.dir.output, 's');
    end
    [~, ~, ~] = mkdir(cfg.dir.output);
    
    % TODO
    % make sure we use the default date parameter (to implement?)
    % cfg = checkCFG(cfg);

    %% set up
    boldName = 'test_bold_date-202008050730.nii.gz';
    boldName2 = 'test2_bold.nii.gz';
    boldName3 = 'test3_bold_date-202008050730.nii';
    jsonName = 'test_bold_date-202008050730.json';
    eventsName = 'test_events_date-202008050730.tsv';
    stimName = 'test_stim_date-202008050730.tsv';
    stimNameZipped = 'test2_stim_date-202008050730.tsv.gz';
    
    filesToProcess = { ...
        boldName ;
        boldName2 ;
        boldName3 ;
        jsonName ;
        eventsName ;
        stimName ;
        stimNameZipped ;
        };

    for iFile = 1:numel(filesToProcess)
        copyfile( ...
            fullfile('..', 'dummyData', 'dummyData.nii.gz'), ...
            fullfile(cfg.dir.output, filesToProcess{iFile}));
    end
    
    %% do stuff
    filenames = file_utils('List', cfg.dir.output, '^test.*$');

    removeDateSuffix(filenames, cfg.dir.output);
    
    %% expected data
    expectedBoldName = 'test_bold.nii.gz';
    expectedBoldName2 = 'test2_bold.nii.gz';
    expectedBoldName3 = 'test3_bold.nii';
    expectedJsonName = 'test_bold.json';
    expectedEventsName = 'test_events.tsv';
    expectedStimName = 'test_stim.tsv';
    expectedStimNameZipped = 'test2_stim.tsv.gz';

    %% test
    assertEqual(exist(fullfile(cfg.dir.output, expectedBoldName3), 'file'), 2);
    assertEqual(exist(fullfile(cfg.dir.output, expectedJsonName), 'file'), 2);
    assertEqual(exist(fullfile(cfg.dir.output, expectedEventsName), 'file'), 2);
    assertEqual(exist(fullfile(cfg.dir.output, expectedStimName), 'file'), 2);
    assertEqual(exist(fullfile(cfg.dir.output, expectedStimNameZipped), 'file'), 2);
    assertEqual(exist(fullfile(cfg.dir.output, expectedBoldName2), 'file'), 2);
    assertEqual(exist(fullfile(cfg.dir.output, expectedBoldName), 'file'), 2);

end






