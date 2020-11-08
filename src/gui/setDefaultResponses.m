% (C) Copyright 2020 CPP_BIDS developers

function [cfg, responses] = setDefaultResponses(cfg)
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
