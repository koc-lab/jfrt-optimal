%% Clear
clc, clear, close all;

%% Load data
[G, X] = init_knn("sea-surface-temperature.mat", 10, 1, false);

%% Parameters
a = [1 -0.5 0.3];
b = [1  0.3 0.1];
arma_iter = 100;

%% Laplacian
G = gsp_create_laplacian(G, 'normalized');
G = gsp_estimate_lmax(G);
G = gsp_compute_fourier_basis(G);

l = linspace(0, G.lmax, 300);
M = sparse(0.5 * G.lmax * speye(G.N) - G.L);
mu = G.lmax / 2 - l;

%% Add Noise
SNR = 15;
X_noisy = awgn(X, SNR, 'measured');
noise_err = norm(X - X_noisy, 'fro') / norm(X, 'fro');
fprintf("Noise Error: %.2f%%\n", noise_err * 100);

%% Filter
Y = time_varying_arma_filter(M, b, a, X_noisy, arma_iter);
filter_err = norm(X - Y, 'fro') / norm(X, 'fro');
fprintf("Time-Varying ARMA Filtering Error: %.2f%%\n", filter_err * 100);

