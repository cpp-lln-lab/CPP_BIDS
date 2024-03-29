function cpp_bids(varargin)
    %
    % General intro function for CPP BIDS
    %
    % USAGE::
    %
    %   cpp_bids
    %   cpp_bids('init')
    %   cpp_bids('uninit')
    %   cpp_bids('dev')
    %
    % :param action:
    % :type action: string
    %
    % :returns: - :action: (type) (dimension)
    %
    % Example::
    %

    % (C) Copyright 2022 CPP_BIDS developers

    p = inputParser;

    defaultAction = 'init';

    addOptional(p, 'action', defaultAction, @ischar);
    addParameter(p, 'verbose', true);

    parse(p, varargin{:});

    action = p.Results.action;
    verbose = p.Results.verbose;

    switch lower(action)

        case 'init'

            initCppBids(verbose);

        case 'dev'

            initCppBids(verbose);
            thisDirectory = fileparts(mfilename('fullpath'));
            testFolder = fullfile(thisDirectory, 'tests');
            addpath(testFolder, '-begin');
            utilFolder = fullfile(thisDirectory, 'tests', 'utils');
            addpath(utilFolder, '-begin');

        case 'uninit'

            uninitCppBids();

        case 'run_tests'

            runTests();

    end

end

function initCppBids(verbose)
    %
    % Adds the relevant folders to the path for a given session.
    % Has to be run to be able to use CPP_BIDS.
    %
    % USAGE::
    %
    %   initCppPtb()
    %

    % (C) Copyright 2022 CPP_BIDS developers

    thisDirectory = fileparts(mfilename('fullpath'));

    global CPP_BIDS_INITIALIZED
    global CPP_BIDS_PATHS

    if isempty(CPP_BIDS_INITIALIZED)

        pathSep = ':';
        if ~isunix
            pathSep = ';';
        end

        CPP_BIDS_PATHS = fullfile(thisDirectory);
        CPP_BIDS_PATHS = cat(2, CPP_BIDS_PATHS, ...
                             pathSep, ...
                             genpath(fullfile(thisDirectory, 'src')));
        assert(isdir(fullfile(thisDirectory, 'lib', 'bids-matlab', '+bids')));
        CPP_BIDS_PATHS = cat(2, CPP_BIDS_PATHS, pathSep, ...
                             fullfile(thisDirectory, 'lib', 'bids-matlab'));
        assert(isdir(fullfile(thisDirectory, 'lib', 'JSONio')));
        CPP_BIDS_PATHS = cat(2, CPP_BIDS_PATHS, pathSep, ...
                             fullfile(thisDirectory, 'lib', 'JSONio'));

        addpath(CPP_BIDS_PATHS, '-begin');

        CPP_BIDS_INITIALIZED = true();

        detectCppBids();

        if verbose
            printCreditsCppBids();
        end

    else
        if verbose
            fprintf('\n\nCPP_BIDS already initialized\n\n');
        end

    end

end

function detectCppBids()

    workflowsDir = cellstr(which('saveEventsFile.m', '-ALL'));

    if isempty(workflowsDir)
        error('CPP_BIDS is not in your MATLAB / Octave path.\n');

    elseif numel(workflowsDir) > 1
        fprintf('CPP_BIDS seems to appear in several different folders:\n');
        for i = 1:numel(workflowsDir)
            fprintf('  * %s\n', fullfile(workflowsDir{i}, '..', '..'));
        end
        error('Remove all but one with ''pathtool'' .\n'); % or ''spm_rmpath

    end
end

function uninitCppBids()
    %
    % Removes the added folders from the path for a given session.
    %
    % USAGE::
    %
    %   uninitCppPtb()
    %

    % (C) Copyright 2021 CPP_BIDS developers

    global CPP_BIDS_INITIALIZED
    global CPP_BIDS_PATHS

    if isempty(CPP_BIDS_INITIALIZED) || ~CPP_BIDS_INITIALIZED
        fprintf('\n\nCPP_BIDS not initialized\n\n');
        return

    else
        rmpath(CPP_BIDS_PATHS);

        if isOctave
            clear -g CPP_BIDS_INITIALIZED CPP_BIDS_PATHS;
        else
            clearvars -GLOBAL CPP_BIDS_INITIALIZED CPP_BIDS_PATHS;
        end

    end

end

function retval = isOctave()
    %
    % Returns true if the environment is Octave.
    %
    % USAGE::
    %
    %   retval = isOctave()
    %
    % :returns: :retval: (boolean)
    %

    % (C) Copyright 2020 Agah Karakuzu
    % (C) Copyright 2022 CPP_BIDS developers

    persistent cacheval   % speeds up repeated calls

    if isempty (cacheval)
        cacheval = (exist ('OCTAVE_VERSION', 'builtin') > 0);
    end

    retval = cacheval;
end
