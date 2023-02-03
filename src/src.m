%% Clear
clc, clear, close all;

%% Parameters
knn_count = 10;
knn_sigma = 1;

%% Load Paths
DATA_PATH = "../datasets/";
GRAPH_ARMA_PATH = "../graph-arma/";
GRAPH_CONSTRUCTION_PATH = "../graph-construction/";
GSP_TOOLBOX_PATH = "../gspbox/";
addpath(DATA_PATH, GRAPH_ARMA_PATH, GRAPH_CONSTRUCTION_PATH, GSP_TOOLBOX_PATH, '-frozen');
gsp_start;

%% Load Data
dataset_name = "sea-surface-temperature.mat";
dataset = load(dataset_name, 'data', 'position');

jtv_signal = dataset.data;
graph = knn_graph_construction(dataset.position, knn_count, knn_sigma);

%% Plot
figure;
gsp_plot_graph(graph);

figure;
gsp_plot_signal(graph, jtv_signal(:, 1));
