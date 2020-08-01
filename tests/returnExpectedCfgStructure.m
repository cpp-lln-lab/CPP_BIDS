function expectedCfgStructure = returnExpectedCfgStructure()
    
    expectedCfgStructure.subject.subjectGrp = '';
    expectedCfgStructure.subject.sessionNb = 1;
    expectedCfgStructure.subject.askGrpSess = [true true];
    
    expectedCfgStructure.verbose = 0;
    
    expectedCfgStructure.fileName.task = '';
    expectedCfgStructure.fileName.zeroPadding = 3;
    expectedCfgStructure.fileName.dateFormat = 'yyyymmddHHMM';
    
    expectedCfgStructure.eyeTracker.do = false;
    
    expectedCfgStructure.mri.contrastEnhancement = [];
    expectedCfgStructure.mri.phaseEncodingDirection = [];
    expectedCfgStructure.mri.reconstruction = [];
    expectedCfgStructure.mri.echo = [];
    expectedCfgStructure.mri.acquisition = [];
    expectedCfgStructure.mri.repetitionTime = [];
    
    expectedCfgStructure.bids.mri.RepetitionTime = [];
    expectedCfgStructure.bids.mri.SliceTiming = '';
    expectedCfgStructure.bids.mri.TaskName = '';
    expectedCfgStructure.bids.mri.Instructions = '';
    expectedCfgStructure.bids.mri.TaskDescription = '';
    
    expectedCfgStructure.bids.meg.TaskName = '';
    expectedCfgStructure.bids.meg.SamplingFrequency = [];
    expectedCfgStructure.bids.meg.PowerLineFrequency = [];
    expectedCfgStructure.bids.meg.DewarPosition = [];
    expectedCfgStructure.bids.meg.SoftwareFilters = [];
    expectedCfgStructure.bids.meg.DigitizedLandmarks = [];
    expectedCfgStructure.bids.meg.DigitizedHeadPoints = [];
    
    expectedCfgStructure.bids.datasetDescription.Name = '';
    expectedCfgStructure.bids.datasetDescription.BIDSVersion =  '';
    expectedCfgStructure.bids.datasetDescription.License = '';
    expectedCfgStructure.bids.datasetDescription.Authors = {''};
    expectedCfgStructure.bids.datasetDescription.Acknowledgements = '';
    expectedCfgStructure.bids.datasetDescription.HowToAcknowledge = '';
    expectedCfgStructure.bids.datasetDescription.Funding = {''};
    expectedCfgStructure.bids.datasetDescription.ReferencesAndLinks = {''};
    expectedCfgStructure.bids.datasetDescription.DatasetDOI = '';
    
    expectedCfgStructure = orderfields(expectedCfgStructure);
    
end