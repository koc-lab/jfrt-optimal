function [gfrt_mat, igfrt_mat] = gfrt_matrix(gft_matrix, alpha, decomposition)
minArgs = 2;
maxArgs = 3;
narginchk(minArgs, maxArgs);

if nargin == 2
    decomposition = "eig";
end

% select decomposition method, default to eigen
if strcmp(decomposition, "jordan")
    [V, D] = jordan(gft_matrix);
else
    [V, D] = eig(gft_matrix);
end

% equivalent to V * D^{alpha} * V^{-1}
gfrt_mat = V * ((D^alpha) / V);
if nargout > 1
    igfrt_mat = V * ((D^(-alpha)) / V);
end
end