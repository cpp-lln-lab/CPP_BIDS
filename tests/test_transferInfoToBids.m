% (C) Copyright 2020 CPP_BIDS developers

function test_suite = test_transferInfoToBids %#ok<*STOUT>
    try % assignment of 'localfunctions' is necessary in Matlab >= 2016
        test_functions = localfunctions(); %#ok<*NASGU>
    catch % no problem; early Matlab versions can use initTestSuite fine
    end
    initTestSuite;
end

function test_transferInfoToBidsBasic()
    % basic behavior

    cfg = struct();
    fieldsToSet = struct();
    cfg = transferInfoToBids(fieldsToSet, cfg);

    expectedStruct = struct();

    assert(isequal(expectedStruct, fieldsToSet));

end

function test_transferInfoToBidsTaskname()
    % make sure the file name gets trasnferred where it should

    cfg.task.name = 'foo bar';
    cfg.task.instructions = 'do this';

    fieldsToSet = struct();
    fieldsToSet = transferInfoToBids(fieldsToSet, cfg);

    expectedStruct.fileName.task = 'fooBar';
    expectedStruct.bids.meg.TaskName = 'foo Bar';
    expectedStruct.bids.eeg.TaskName = 'foo Bar';
    expectedStruct.bids.ieeg.TaskName = 'foo Bar';
    expectedStruct.bids.beh.TaskName = 'foo Bar';
    expectedStruct.bids.mri.TaskName = 'foo Bar';
    expectedStruct.bids.meg.Instructions = 'do this';
    expectedStruct.bids.eeg.Instructions = 'do this';
    expectedStruct.bids.ieeg.Instructions = 'do this';
    expectedStruct.bids.beh.Instructions = 'do this';
    expectedStruct.bids.mri.Instructions = 'do this';

    assert(isequal(expectedStruct, fieldsToSet));

end

function test_transferInfoToBidsMRI()
    % make sure the file name gets trasnferred where it should

    cfg.mri.repetitionTime = 1.56;

    fieldsToSet = struct();
    fieldsToSet = transferInfoToBids(fieldsToSet, cfg);

    expectedStruct.bids.mri.RepetitionTime = 1.56;

    assert(isequal(expectedStruct, fieldsToSet));

end
