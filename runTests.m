function runTests()
    %
    % (C) Copyright 2022 CPP_BIDS developers

    % Elapsed time is ??? seconds.

    tic;

    thisPath = fileparts(mfilename('fullpath'));

    cd(thisPath);

    fprintf('\nHome is %s\n', getenv('HOME'));

    warning('OFF');

    addpath(fullfile(thisPath, 'lib', 'JSONio'));
    addpath(fullfile(thisPath, 'lib', 'bids-matlab'));

    folderToCover = fullfile(thisPath, 'src');
    addpath(genpath(folderToCover));
    testFolder = fullfile(thisPath, 'tests');
    addpath(testFolder);
    addpath(fullfile(testFolder, 'utils'));

    success = moxunit_runtests(testFolder, ...
                               '-verbose', '-recursive', '-with_coverage', ...
                               '-cover', folderToCover, ...
                               '-cover_xml_file', 'coverage.xml', ...
                               '-cover_html_dir', fullfile(thisPath, 'coverage_html'));

    if success
        system('echo 0 > test_report.log');
    else
        system('echo 1 > test_report.log');
    end

    toc;

end
