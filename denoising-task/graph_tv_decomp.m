function [V, D] = graph_tv_decomp(A, decomposition_method)
minArgs = 1;
maxArgs = 2;
narginchk(minArgs, maxArgs);

if nargin == 1
    decomposition_method = "eig";
end

if strcmp(decomposition_method, "jordan")
    [V, D] = jordan(A);
elseif strcmp(decomposition_method, "eig")
    [V, D] = eig(A);
else
    error("`decomposition_method` can be either `jordan` | `eig`");
end

max_eig_value = max(abs(diag(D)));
A_normalized = A / max_eig_value;

difference = V - A_normalized * V;
tv = vecnorm(difference, 1, 1);
[~, sort_idx] = sort(tv);
V = V(:, sort_idx);
D = D(sort_idx, sort_idx);
end

