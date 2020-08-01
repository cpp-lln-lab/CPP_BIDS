function checkSubFields(expectedStructure, cfg)
    % check that that the structures match
    % if it fails it check from which subfield the error comes from
    
    try
        
        assertEqual(expectedStructure, cfg);
        
    catch ME
        
        if isstruct(expectedStructure)
            
            names = fieldnames(expectedStructure);
            
            for i = 1:numel(names)
                
                disp(names{i});
                testSubFields(expectedStructure.(names{i}), cfg.(names{i}));
                
            end
            
        end
        
        disp(expectedStructure);
        disp(cfg);
        
        rethrow(ME);
    end
end
