%% Clear
clc, clear, close all;

%% Load data
for k = 1:10
fprintf("\n\nFor k = %d\n", k);
[G, X] = init_knn("sea-surface-temperature.mat", k, 1, true);
T = 120;
X = X(:, 1:T);
X = X / max(X(:));

%% Add Noise
rng("default");

fprintf("sigma\tnoise\tM1\tM2\n");
mu = 0;

for sigma = 0.05:0.05:0.40;
    noise = mu + sigma * randn(size(X));
    X_noisy = X + noise;

    %% Median Filter
    Y1 = median_filter(G.A, X_noisy, 1);
    Y2 = median_filter(G.A, X_noisy, 2);

    %% SNR
    noise_snr = 10 * log10(norm(X, "fro")^2 / norm(X - X_noisy, "fro")^2);
    y1_snr    = 10 * log10(norm(X, "fro")^2 / norm(X - Y1, "fro")^2);
    y2_snr    = 10 * log10(norm(X, "fro")^2 / norm(X - Y2, "fro")^2);

    fprintf("%.2f\t%.2f\t%.2f\t%.2f\n", sigma, noise_snr, y1_snr, y2_snr);
end
end

%% Plot
figure;
plot(X(1, :), "LineWidth", 2);
hold on;
plot(X_noisy(1, :), "LineWidth", 2);
legend("Original", "Noisy");

figure;
plot(X(1, :), "LineWidth", 2);
hold on;
plot(Y1(1, :), "LineWidth", 2);
legend("Original", "Filtered");

