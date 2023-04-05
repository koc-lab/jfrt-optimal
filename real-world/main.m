%% Clear
clc, clear, close all;

%% Load data
[G, X] = init_knn("sea-surface-temperature.mat", 2, 10000, 8, 8);
X = X / max(X(:));

% Add Noise
rng("default");
mu    = 0;
sigma = 0.1;
noise = mu + sigma * randn(size(X));
X_noisy = X + noise;

Gg = eye(size(X, 1));
Gt = eye(size(X, 2));

for method = ["adj"]
    for alpha = [1.0]
        for beta = [1.0]
            [gft_mat, ~] = gft_matrix(full(G.W), method);
            jfrt_pair = get_jfrt_pair(gft_mat, size(X, 2), alpha, beta);
            [T, q] = get_optimal_filter(Gt, Gg, jfrt_pair, X, noise);

            % X_transform = jfrt_pair("GFRT") * X_noisy * jfrt_pair("FRT_T");
            % X_transform_filtered = Hg * X_transform * Ht;
            % X_filtered = real(jfrt_pair("IGFRT") * X_transform_filtered * jfrt_pair("IFRT_T"));
        end
    end
end

% %% SNR
% noise_snr    = 10 * log10(norm(X, "fro")^2 / norm(X - X_noisy, "fro")^2);
% filtered_snr = 10 * log10(norm(X, "fro")^2 / norm(X - X_filtered, "fro")^2);

% fprintf("SNR before filtering: %.2f dB\n", noise_snr);
% fprintf("SNR after  filtering: %.2f dB\n", filtered_snr);

% %% Plot
% figure;
% plot(X(1, :), "LineWidth", 2);
% hold on;
% plot(X_noisy(1, :), "LineWidth", 2);
% legend("Original", "Noisy");

% figure;
% plot(X(1, :), "LineWidth", 2);
% hold on;
% plot(X_filtered(1, :), "LineWidth", 2);
% legend("Original", "Filtered");


