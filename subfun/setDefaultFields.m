function structure = setDefaultFields(structure, fieldsToSet)
    % loop through the defaults fiels to set and update if they don't exist

    names = fieldnames(fieldsToSet);

    for i = 1:numel(names)

        thisField = fieldsToSet.(names{i});

        structure = setFieldToIfNotPresent( ...
            structure, ...
            names{i}, ...
            thisField);

    end

end

function structure = setFieldToIfNotPresent(structure, fieldName, value)
    if ~isfield(structure, fieldName)
        structure.(fieldName) = value;
    end
end
