function [graph, jtv_signal] = init_knn(dataset_name, knn_count, knn_sigma, max_node_count, max_time_instance, verbose)
% Parameters
if ~exist('dataset_name', 'var')
    dataset_name = "sea-surface-temperature.mat";
end
if ~exist('knn_count', 'var'),          knn_count = 5; end
if ~exist('knn_sigma', 'var'),          knn_sigma =  1; end
if ~exist('max_node_count', 'var'),     max_node_count =  8; end
if ~exist('max_time_instance', 'var'),  max_time_instance =  8; end
if ~exist('verbose', 'var'),            verbose =  false; end

% Load Paths
DATA_PATH = "../../../datasets/";
GRAPH_ARMA_PATH = "../../../graph-arma/";
JTV_ARMA_PATH = "../../../jtv-arma/";
GSP_TOOLBOX_PATH = "../../../gspbox/";
GRAPH_CONSTRUCTION_PATH = "../../../graph-construction/";
addpath(DATA_PATH, GSP_TOOLBOX_PATH, '-frozen');
addpath(GRAPH_ARMA_PATH, JTV_ARMA_PATH, GRAPH_CONSTRUCTION_PATH, '-begin');
gsp_start;

% Load Data
dataset = load(dataset_name, 'data', 'position');
node_count = min(max_node_count, size(dataset.data, 1));
time_instance_count = min(max_time_instance, size(dataset.data, 2));
knn_count = min(knn_count, node_count);

jtv_signal = dataset.data(1:node_count, 1:time_instance_count);
positions  = dataset.position(1:node_count, :);
graph = knn_graph_construction(positions, knn_count, knn_sigma);

if verbose
    disp("Graph Info");
    disp("  - Number of Vertices: " + graph.N);
    disp("  - Number of Edges: " + graph.Ne);

    disp("JTV Signal Info");
    disp("  - Number of Vertices: " + size(jtv_signal, 1));
    disp("  - Number of Time Samples: " + size(jtv_signal, 2));
end

end
