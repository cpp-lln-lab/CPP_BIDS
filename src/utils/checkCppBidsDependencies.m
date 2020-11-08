% (C) Copyright 2020 CPP_BIDS developers

function checkCppBidsDependencies(cfg)
    %
    % Adds dependencies to the matlab path and make sure we got all of them/
    %
    % USAGE::
    %
    %   checkCppBidsDependencies(cfg)
    %

    GITHUB_WORKSPACE = getenv('GITHUB_WORKSPACE');

    if strcmp(GITHUB_WORKSPACE, '/github/workspace')

        pth = GITHUB_WORKSPACE;
        addpath(fullfile(pth, 'lib', 'JSONio'));
        addpath(fullfile(pth, 'lib', 'bids-matlab'));

    elseif isempty(GITHUB_WORKSPACE)  % local

        pth = fullfile(fileparts(mfilename('fullpath')), '..', '..');
        checkSubmodule(fullfile(pth, 'lib', 'JSONio'));
        checkSubmodule(fullfile(pth, 'lib', 'bids-matlab'));

        addpath(fullfile(pth, 'src', 'subfun'));

    end

    addpath(fullfile(pth, 'lib', 'utils'));

    printCreditsCppBids(cfg);

end

function checkSubmodule(pth)
    % If external dir is empty throw an exception
    % and ask user to update submodules.
    if numel(dir(pth)) <= 2 % Means that the external is empty
        error(['Git submodules are not cloned!', ...
               'Try this in your terminal:', ...
               ' git submodule update --recursive ']);
    else
        addpath(pth);
    end
end
