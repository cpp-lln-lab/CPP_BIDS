function [cfg, responses] = setDefaultResponses(cfg)

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
