function [gft_mat, igft_mat, eig_vals] = gft_matrix(matrix, method)
if ~exist('method', 'var'), method = "tv"; end

if strcmp(method, "tv")
    [V, D] = graph_tv_decomp(matrix, "eig");
elseif strcmp(method, "asc")
    [V, D] = ascending_decomp(matrix, "eig");
else
    error("`method` can be either `asc` | `tv`");
end

igft_mat = V;
if issymmetric(matrix)
    gft_mat = V';
else
    gft_mat = inv(V);
end
if nargout > 2
    eig_vals = diag(D);
end
end
