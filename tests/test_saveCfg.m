% (C) Copyright 2020 CPP_BIDS developers

function test_suite = test_saveCfg %#ok<*STOUT>
    try % assignment of 'localfunctions' is necessary in Matlab >= 2016
        test_functions = localfunctions(); %#ok<*NASGU>
    catch % no problem; early Matlab versions can use initTestSuite fine
    end
    initTestSuite;
end

function test_saveCfg_basic()

    cfg = setUp();

    filename = saveCfg(cfg);

    expected = fullfile(cfg.dir.outputSubject, ...
                        cfg.fileName.modality, ...
                        strrep(cfg.fileName.events, '_events.tsv', '_cfg.json'));

    assertEqual(filename, expected);

    content = bids.util.jsondecode(filename);

    delete(expected);

end

function test_saveCfg_bare_bone()

    cfg.testingDevice = 'mri';

    filename = saveCfg(cfg);

    expected = fullfile(pwd, ['date-'  datestr(now,  'yyyymmddHHMM') '_cfg.json']);

    assertEqual(filename, expected);

    content = bids.util.jsondecode(filename);

    assertEqual(content, struct('testingDevice', 'mri'));

    delete(expected);

end

function test_saveCfg_filename_provided()

    cfg.testingDevice = 'mri';

    filename = saveCfg(cfg, fullfile(pwd, 'cfg', 'cfg.json'));

    expected = fullfile(pwd, 'cfg', 'cfg.json');

    assertEqual(filename, expected);

    delete(expected);
    rmdir(fullfile(pwd, 'cfg'));

end
