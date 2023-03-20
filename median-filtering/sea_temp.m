%% Clear
clc, clear, close all;

%% Parameters
sigma_values = 0.05:0.05:0.4;
mu = 0;
number_of_trials = 10;

%% Load data
for k = [1, 3, 5, 10];
    fprintf("\n\nFor k = %d\n", k);
    [G, X] = init_knn("sea-surface-temperature.mat", k, 1, false);
    T = 120;
    X = X(:, 1:T);
    X = X / max(X(:));

    fprintf("Sigma\tNoise SNR\tM1 SNR\t\tM2 SNR\n");
    for sigma = sigma_values;
        noise_snr = zeros(number_of_trials, 1);
        y1_snr    = zeros(number_of_trials, 1);
        y2_snr    = zeros(number_of_trials, 1);

        parfor i = 1:number_of_trials
            %% Add Noise
            rng(i);
            noise = mu + sigma * randn(size(X));
            X_noisy = X + noise;

            %% Median Filter
            Y1 = median_filter(G.A, X_noisy, 1);
            Y2 = median_filter(G.A, X_noisy, 2);

            %% SNR
            noise_snr(i) = 10 * log10(norm(X, "fro")^2 / norm(X - X_noisy, "fro")^2);
            y1_snr(i)    = 10 * log10(norm(X, "fro")^2 / norm(X - Y1, "fro")^2);
            y2_snr(i)    = 10 * log10(norm(X, "fro")^2 / norm(X - Y2, "fro")^2);
        end

        noise_snr_mean = mean(noise_snr); noise_snr_std = std(noise_snr);
        y1_snr_mean    = mean(y1_snr);    y1_snr_std    = std(y1_snr);
        y2_snr_mean    = mean(y2_snr);    y2_snr_std    = std(y2_snr);
        fprintf("%.2f\t%.2f±%.2f\t%.2f±%.2f\t%.2f±%.2f\n",...
            sigma, noise_snr_mean, noise_snr_std,...
                   y1_snr_mean, y1_snr_std,...
                   y2_snr_mean, y2_snr_std);
    end
end

