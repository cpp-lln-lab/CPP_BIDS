clear;
clc;

%%
fprintf('Debug\n');
cfg.debug = true;

cfg = userInputs(cfg);
disp(cfg.subject);

%%
fprintf('No Group\n');
cfg.debug = false;
cfg.subject.askGrpSess = 0;

cfg = userInputs(cfg);
disp(cfg.subject);

%%
fprintf('No Group or session\n');
cfg.debug = false;
cfg.subject.askGrpSess = [0 0];

cfg = userInputs(cfg);
disp(cfg.subject);

%%
fprintf('No session\n');
cfg.debug = false;
cfg.subject.askGrpSess = [1 0];

cfg = userInputs(cfg);
disp(cfg.subject);

%%
fprintf('Default\n');
cfg.debug = false;
cfg.subject.askGrpSess = [];

cfg = userInputs(cfg);
disp(cfg.subject);
