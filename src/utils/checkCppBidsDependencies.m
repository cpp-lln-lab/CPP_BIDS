function checkCppBidsDependencies(cfg)
    %
    % Adds dependencies to the Matlab / Octave path and make sure we got all of them.
    %
    % USAGE::
    %
    %   checkCppBidsDependencies(cfg)
    %
    % :param cfg: Configuration. See ``checkCFG()``.
    % :type cfg: structure
    %

    % (C) Copyright 2020 CPP_BIDS developers

    global CPP_BIDS_INITIALIZED

    GITHUB_WORKSPACE = getenv('GITHUB_WORKSPACE');

    if isempty(CPP_BIDS_INITIALIZED)

        if strcmp(GITHUB_WORKSPACE, '/github/workspace')

            pth = GITHUB_WORKSPACE;
            addpath(genpath(fullfile(pth, 'lib')));

        elseif isempty(GITHUB_WORKSPACE)  % local

            pth = fullfile(fileparts(mfilename('fullpath')), '..', '..');
            addpath(fullfile(pth, 'lib', 'utils'));

            checkSubmodule(fullfile(pth, 'lib', 'JSONio'));
            checkSubmodule(fullfile(pth, 'lib', 'bids-matlab'));

            addpath(genpath(fullfile(pth, 'src')));

        end

        printCreditsCppBids(cfg);

        CPP_BIDS_INITIALIZED = true();

    else
        talkToMe(cfg, '\n\nCPP_BIDS already initialized\n\n');

    end

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
