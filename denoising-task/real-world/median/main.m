%% Clear
clc, clear, close all;

%% Parameters
ui = false;
dataset = "sea-surface-temperature.mat";
max_node_count = 100;
max_time_count = 120;
knn_sigma = 10;

k_values = [2, 5, 10];
noise_sigmas = [0.10, 0.15, 0.20];
median_filter_ps = [1, 2];

for k = k_values
  fprintf("Results for k = %d\n", k);

  %% Load data
  [G, X] = init_knn(dataset, k, knn_sigma, max_node_count, max_time_count);
  X = X / max(X(:));

  %% Median Filtering
  for p = median_filter_ps
      fprintf("\tResults for median filter p = %d:\n", p);
      for noise_sigma = noise_sigmas
          % Noise and Covariance matrices
          rng("default");
          noise = noise_sigma * randn(size(X));
          X_noisy = X + noise;
          noise_err = 100 * norm(X - X_noisy, "fro") / norm(X, "fro");
          fprintf("\t\tNoise  error: %.2f%%\n", noise_err);

          % Filter
          Y = median_filter(G.A, X_noisy, p);
          filter_err = norm(X - Y, 'fro') / norm(X, 'fro');
          fprintf("\t\tFilter Error: %.2f%%\n", filter_err * 100);
      end
  end
end
