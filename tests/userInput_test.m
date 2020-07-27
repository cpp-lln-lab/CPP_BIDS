%%
cfg.debug = true;

cfg = userInputs(cfg);
disp(cfg);

%%
cfg.debug = false;
cfg.askGrpSess = 0;

cfg = userInputs(cfg);
disp(cfg);

%%
cfg.debug = false;
cfg.askGrpSess = [0 0];

cfg = userInputs(cfg);
disp(cfg);

%%
cfg.debug = false;
cfg.askGrpSess = [0 1];

cfg = userInputs(cfg);
disp(cfg);

%%
cfg.debug = false;
cfg.askGrpSess = [];

cfg = userInputs(cfg);
disp(cfg);
