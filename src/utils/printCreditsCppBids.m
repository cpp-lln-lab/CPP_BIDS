% (C) Copyright 2020 CPP_BIDS developers

function printCreditsCppBids(cfg)
    %
    % Short description of what the function does goes here.
    %
    % USAGE::
    %
    %   [argout1, argout2] = templateFunction(argin1, [argin2 == default,] [argin3])
    %
    % :param argin1: (dimension) obligatory argument. Lorem ipsum dolor sit amet,
    %                consectetur adipiscing elit. Ut congue nec est ac lacinia.
    % :type argin1: type
    % :param argin2: optional argument and its default value. And some of the
    %               options can be shown in litteral like ``this`` or ``that``.
    % :type argin2: string
    % :param argin3: (dimension) optional argument
    % :type argin3: integer
    %
    % :returns: - :argout1: (type) (dimension)
    %           - :argout2: (type) (dimension)
    %

    try
        version = fileread(fullfile(fileparts(mfilename('fullpath')), ...
                                    '..', '..', 'version.txt'));
    catch
        version = 'v1.0.0';
    end

    verbose = 2;
    if ~isempty(cfg) && isfield(cfg, 'verbose') && ~isempty(cfg.verbose)
        verbose = cfg.verbose;
    end

    if verbose > 1

        contributors = { ...
                        'Rémi Gau', ...
                        'Marco Barilari', ...
                        'Ceren Battal'};

        DOI_URL = 'https://doi.org/10.5281/zenodo.4007674';

        repoURL = 'https://github.com/cpp-lln-lab/CPP_BIDS';

        fprintf('\n\n');

        disp('___________________________________________________');
        disp('___________________________________________________');
        disp('                                                   ');
        disp('         ___ ___ ___   ___ ___ ___  ___            ');
        disp('        / __| _ \ _ \ | _ )_ _|   \/ __|');
        disp('       | (__|  _/  _/ | _ \| || |) \__ \');
        disp('        \___|_| |_|   |___/___|___/|___/');
        disp('                                                   ');

        splash = 'Thank you for using the CPP BIDS - version %s. ';
        fprintf(splash, version);
        fprintf('\n\n');

        fprintf('Current list of contributors includes:\n');
        for iCont = 1:numel(contributors)
            fprintf(' %s\n', contributors{iCont});
        end
        fprintf('\b\n\n');

        fprintf('Please cite using the following DOI: \n %s\n\n', DOI_URL);

        fprintf('For bug report, suggestions or contributions see: \n %s\n\n', repoURL);

        disp('___________________________________________________');
        disp('___________________________________________________');

        fprintf('\n\n');

    end

end
