function [gft_mat, igft_mat, eig_vals] = gft_matrix(weight_matrix, method, decomposition_method)
minArgs = 1;
maxArgs = 3;
narginchk(minArgs, maxArgs);

default_method = "adj";
default_decomp = "eig";

if nargin == 1
    method = default_method;
    decomposition_method = default_decomp;
elseif nargin == 2
    decomposition_method = default_decomp;
end

if strcmp(method, "lap")
    matrix = laplacian(weight_matrix);
    [V, D] = ascending_decomp(matrix, decomposition_method);
elseif strcmp(method, "adj")
    inv_degree_matrix = diag(1./sum(weight_matrix, 2));
    matrix = inv_degree_matrix * weight_matrix;
    [V, D] = graph_tv_decomp(matrix, decomposition_method);
else
    error("`method` can be either `adj` | `lap`");
end

igft_mat = V;
if strcmp(method, "lap") || issymmetric(matrix)
    gft_mat = V';
else
    gft_mat = inv(V);
end
if nargout > 2
    eig_vals = diag(D);
end

end
