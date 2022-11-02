function printCreditsCppBids(cfg)
    %
    % It will print the credits of this repo. Depending on the level of verbosity set in
    % ``cfg.verbose`` (default is 2 if not set), it will print the graphic and general information.
    %
    % USAGE::
    %
    %   printCreditsCppBids(cfg)
    %
    % :param cfg: Configuration. See ``checkCFG()``.
    % :type cfg: structure
    %

    % (C) Copyright 2020 CPP_BIDS developers

    version = getVersion();

    verbose = 2;
    if nargin > 0 && ~isempty(cfg) && isfield(cfg, 'verbose') && ~isempty(cfg.verbose)
        verbose = cfg.verbose;
    end

    try

        content = bids.util.jsondecode(fullfile(returnRootDir(), '.all-contributorsrc'));
        contributors = {content.contributors.name}';
        contributors = contributors(randperm(numel(contributors)));
        contributors = cat(1, contributors, 'Why not be the next?');

    catch

        contributors =          {'Remi Gau', ...
                                 'Marco Barilari', ...
                                 'Ceren Battal', ...
                                 'Tomas Lenc', ...
                                 'Iqra Shahzad'};
    end

    if verbose > 1

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
