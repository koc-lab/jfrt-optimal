%% Clear
clc, clear, close all;

%% Load GSP Toolbox
GSP_TOOLBOX_PATH = "../gspbox/";
addpath(GSP_TOOLBOX_PATH, '-frozen');
gsp_start;

%% Create graph
dataset_path = '../datasets/sea-surface-temperature.mat';
dataset = load(dataset_path, 'position');
positions = dataset.position;

k = 5;
sigma = 1;
G = knn_graph_construction(positions, k, sigma);
gsp_plot_graph(G);


