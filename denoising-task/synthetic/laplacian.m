function L = laplacian(A)
L = diag(sum(A, 2)) - A;
end