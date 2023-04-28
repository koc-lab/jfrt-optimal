function [V, D] = ascending_decomp(A, decomposition_method)
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

[~, sort_idx] = sort(diag(D));
V = V(:, sort_idx);
D = D(sort_idx, sort_idx);
end