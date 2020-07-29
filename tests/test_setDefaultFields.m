function test_setDefaultFields()

    structure = struct();

    fieldsToSet.field = 1;

    structure = setDefaultFields(structure, fieldsToSet);

    expectedStructure.field = 1;

    assert(isequal(expectedStructure, structure));

    fprintf('\n--------------------------------------------------------------------');

    clear;

    structure.field.subfield_1 = 3;

    fieldsToSet.field.subfield_1 = 1;
    fieldsToSet.field.subfield_2 = 1;

    structure = setDefaultFields(structure, fieldsToSet);

    expectedStructure.field.subfield_1 = 3;
    expectedStructure.field.subfield_2 = 1;

    assert(isequal(expectedStructure, structure));

end
