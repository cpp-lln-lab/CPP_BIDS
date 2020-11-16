% (C) Copyright 2020 CPP_BIDS developers

function [cfg, responses] = setDefaultResponses(cfg)
    %
    % It sets default responses to for all the entries regarding subject group and for
    % session and run number. The defaults are choosen depending on ``cfg.debug.do``.
    %
    % USAGE::
    %
    %   [cfg, responses] = setDefaultResponses(cfg)
    %
    % :param cfg: Configuration. See ``checkCFG()``.
    %
    % :returns: - :responses: (cell) It contains the response set by default
    %           - :cfg: (structure) Configuration update with ``cfg.debug.do`` set to false if not
    %                   set by the user.
    %

    if nargin < 1
        cfg = struct('debug', []);
    end

    if ~isfield(cfg, 'debug') || isempty(cfg.debug)
        cfg.debug.do = false;
    end

    responses{1, 1} = ''; % subjectGrp
    responses{2, 1} = ''; % subjectNb
    responses{3, 1} = 1; % session
    responses{4, 1} = ''; % run

    if cfg.debug.do

        responses{1, 1} = 'ctrl';
        responses{2, 1} = 666;
        responses{3, 1} = 666;
        responses{4, 1} = 666;

    end

end
