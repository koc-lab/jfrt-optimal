function G = knn_graph_construction(positions, k, sigma)
% KNN_GRAPH_CONSTRUCTION: Construct the kNN graph from the data.
% Input:
%   positions: N x 2 matrix containing locations of the nodes,
%              where N is the number of nodes
%   k: the number of nearest neighbors
%   sigma: the parameter of the Gaussian kernel
% Output:
%   G: the kNN graph

param.k = k;
param.sigma = sigma;
G = gsp_nn_graph(positions, param);

end
