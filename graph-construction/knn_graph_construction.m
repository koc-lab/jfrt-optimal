function G = knn_graph_construction(data_path, k, sigma)
% KNN_GRAPH_CONSTRUCTION: Construct the kNN graph from the data.
% Input:
%   data_path: the path of the data
%   k: the number of nearest neighbors
%   sigma: the parameter of the Gaussian kernel
% Output:
%   G: the kNN graph

load(data_path); % returns data and position
param.k = k;
param.sigma = sigma;
G = gsp_nn_graph(position, param);

end
