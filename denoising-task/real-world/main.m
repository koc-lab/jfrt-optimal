%% Clear
clc, clear, close all;

%% Parameters
ui = false;
dataset = "sea-surface-temperature.mat";
max_node_count = 100;
max_time_count = 120;
k = 2;
knn_sigma = 1000;

alphas      = 0.7:0.01:1.3;
betas       = 0.7:0.01:1.3;
gft_methods = ["adj", "lap"];
noise_sigma = 0.10;

%% Load data
[G, X] = init_knn(dataset, k, knn_sigma, max_node_count, max_time_count, 1);
X = X / max(X(:));
c_values = 1:(size(X, 1) - 1);

%% Noise and Covariance matrices
rng("default");
noise = noise_sigma * randn(size(X));
X_noisy = X + noise;
noise_err = 100 * norm(X - X_noisy, "fro") / norm(X, "fro");

results = struct();
results.alphas = alphas;
results.betas = betas;
results.c_values = c_values;
results.gft_methods = gft_methods;
results.noise_sigma = noise_sigma;
results.noise_err = noise_err;
results.k = k;
results.knn_sigma = knn_sigma;

HT = time_filter(size(X, 2), floor(0.15 * size(X, 2)));
c_length = length(c_values); % to use parfor

cond_multi_waitbar(ui, 'GFT Methods', 0);
for k = 1:length(gft_methods)
errors = zeros(length(c_values), length(alphas), length(betas));
    [gft_mat, ~] = gft_matrix(full(G.W), gft_methods(k));

    cond_multi_waitbar(ui, 'betas', 0 );
    for j = 1:length(betas)
        [gfrt_mat, igfrt_mat] = gfrt_matrix(gft_mat, betas(j));

        parfor i = 1:length(alphas)
            [frt_mat,  ifrt_mat]  = frt_matrix(size(X, 2), alphas(i));

            for l = 1:c_length
                HG = diag([ones(size(X, 1) - c_values(l), 1); zeros(c_values(l), 1)]);
                X_hat = igfrt_mat * HG * gfrt_mat * X_noisy * frt_mat * HT * ifrt_mat;
                err = 100 * norm(X - X_hat, 'fro') / norm(X, 'fro');
                errors(l, i, j) = err;
            end

        end
        cond_multi_waitbar(ui, 'betas', j / length(betas) );
    end
    results.("errors_" + gft_methods(k)) = errors;
    cond_multi_waitbar(ui, 'GFT Methods', k / length(gft_methods) );
end
cond_multi_waitbar(ui, 'betas', 'Close' );
cond_multi_waitbar(ui, 'GFT Methods', 'Close' );

%% Save results
save(sprintf("results_k%d_%.2f.mat", k, noise_sigma), "-struct", "results");


%% Helper Functions
function H = time_filter(length, n)
if 2 * n >= length
    warning("Cutoff frequency larger than half sampling frequency, no filtering.");
end
   
h = zeros(length, 1);

h(1:n) = 1;
h(end - n + 1:end) = 1;

H = diag(h);
end
