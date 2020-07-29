function test_transferInfoToBids()
    
    %%
    cfg = struct();
    fieldsToSet = struct();
    cfg = transferInfoToBids(fieldsToSet, cfg);
    
    expectedStruct = struct();
    
    assert(isequal(expectedStruct, fieldsToSet))
    
    %%
    cfg.task.name = 'foo bar';
    
    fieldsToSet = transferInfoToBids(fieldsToSet, cfg);
    
    expectedStruct.fileName.task = 'fooBar';
    expectedStruct.bids.meg.TaskName = 'foo Bar';
    expectedStruct.bids.mri.TaskName = 'foo Bar';
    
    assert(isequal(expectedStruct, fieldsToSet))
    
    %%
    clear cfg fieldsToSet expectedStruct
    
    cfg.mri.repetitionTime = 1.56;
    
    fieldsToSet = struct();
    fieldsToSet = transferInfoToBids(fieldsToSet, cfg);

    expectedStruct.bids.mri.RepetitionTime = 1.56;
    
    assert(isequal(expectedStruct, fieldsToSet))
    
end