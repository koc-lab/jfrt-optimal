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

%% Disp Graph and JTV Signal Info
disp("Graph Info");
disp("  - Number of Vertices: " + graph.N);
disp("  - Number of Edges: " + graph.Ne);

disp("JTV Signal Info");
disp("  - Number of Vertices: " + size(jtv_signal, 1));
disp("  - Number of Time Samples: " + size(jtv_signal, 2));

%% Graph ARMA
arma_iter = 10;
ar_order = 2;
ma_order = 2;
[filtered_jtv_signal, b, a, response] = arma(graph, jtv_signal, arma_iter, ar_order, ma_order);
err = norm(jtv_signal - filtered_jtv_signal, 'fro') / norm(jtv_signal, 'fro');
fprintf("Error: %.2f%%\n", err * 100);

%% Plot
figure;
plot(jtv_signal(1, :), 'LineWidth', 2);
hold on;
plot(filtered_jtv_signal(1, :), 'LineWidth', 2);

% figure;
% gsp_plot_signal(graph, jtv_signal(:, 1));
