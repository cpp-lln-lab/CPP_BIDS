%%
cfg = struct('debug', true);
expParameters = struct();

[expParameters] = userInputs(cfg, expParameters);
disp(expParameters);

%%
cfg = struct('debug', false);
expParameters = struct('askGrpSess', 0);

[expParameters] = userInputs(cfg, expParameters);
disp(expParameters);

%%
cfg = struct('debug', false);
expParameters = struct('askGrpSess', [0 0]);

[expParameters] = userInputs(cfg, expParameters);
disp(expParameters);

%%
cfg = struct('debug', false);
expParameters = struct('askGrpSess', [0 1]);

[expParameters] = userInputs(cfg, expParameters);
disp(expParameters);

%%
cfg = struct('debug', false);
expParameters = struct('askGrpSess', []);

[expParameters] = userInputs(cfg, expParameters);
disp(expParameters);
