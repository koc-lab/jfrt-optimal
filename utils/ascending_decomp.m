function [V, D] = ascending_decomp(A, decomposition_method)

if ~exist('decomposition_method', 'var'), decomposition_method = "eig"; end

if strcmp(decomposition_method, "jordan")
    [V, D] = jordan(A);
elseif strcmp(decomposition_method, "eig")
    [V, D] = eig(A);
else
    error("`decomposition_method` can be either `jordan` | `eig`");
end

[d, sort_idx] = complex_sort_02pi(diag(D));
V = V(:, sort_idx);
D = diag(d);
end
