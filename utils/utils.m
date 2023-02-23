%% Clear
clc, clear, close all;

%%
N = 4;
F = dftmtx(N) / sqrt(N)
A = diag(ones(N - 1, 1), -1); A(1, end) = 1;
[GFT, IGFT, gfreq] = gft_matrix(A, "asc");

%%
GFT
Fnew = unitary_normalize(GFT, "row")

