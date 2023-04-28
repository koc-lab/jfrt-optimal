%% Clear
clc, clear, close all;

%%
workDir = pwd();
figDir = fullfile(workDir, "error_surf");
figName = "lap.fig";

[~, figBaseName] = fileparts(figName);
outPath = fullfile(figDir, figBaseName + ".eps");

fig = openfig(fullfile(figDir, figName));
ax = gca;
exportgraphics(ax, outPath, "Resolution", 600);