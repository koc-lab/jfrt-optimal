%% Clear
clc, clear, close all;

%% Parameters
ui = false;
dataset = "sea-surface-temperature.mat";
max_node_count = 100;
max_time_count = 600;
knn_sigma = 100;

k_values = [2, 5, 10];
noise_sigmas = [0.10, 0.15, 0.20];

for k = k_values
  fprintf("Results for k = %d\n", k);

  %% Load data
  [G, X] = init_knn(dataset, k, knn_sigma, max_node_count, max_time_count);
  X = X / max(X(:));

  %% Graph ARMA Laplacian
  G = gsp_create_laplacian(G, 'normalized');
  G = gsp_estimate_lmax(G);
  G = gsp_compute_fourier_basis(G);

  l  = linspace(0, G.lmax, 300);
  M  = sparse(0.5 * G.lmax * speye(G.N) - G.L);
  mu = G.lmax / 2 - l;

  %% Graph ARMA Parameters
  order = 2;
  normalize = true;
  [b, a] = get_arma_coeff(G, mu, order, normalize);
  fprintf("Generating Results for ARMA%d Filter:\n", length(a))

  %% Noise Parameters
  for noise_sigma = noise_sigmas
      % Noise and Covariance matrices
      rng("default");
      noise = noise_sigma * randn(size(X));
      X_noisy = X + noise;
      noise_err = 100 * norm(X - X_noisy, "fro") / norm(X, "fro");
      fprintf("\tNoise  error: %.2f%%\n", noise_err);

      % Filter
      Y = time_varying_arma_filter(M, b, a, X_noisy);
      Y = real(Y);
      filter_err = norm(X - Y, 'fro') / norm(X, 'fro');
      fprintf("\tFilter Error: %.2f%%\n", filter_err * 100);
  end
end
