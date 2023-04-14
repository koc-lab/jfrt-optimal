%% Clear
clc, clear, close all;

%% Parameters
ui = true;
dataset = "sea-surface-temperature.mat";
max_node_count = 5;
max_time_count = 5;
k = 2;
knn_sigma = 10000;

alphas      = 0.7:0.01:1.3;
betas       = 0.7:0.01:1.3;
gft_methods = ["adj", "lap"];
noise_sigma = 0.10;

%% Load data
[G, X] = init_knn(dataset, k, knn_sigma, max_node_count, max_time_count);
X = X / max(X(:));

%% Noise and Covariance matrices
rng("default");
noise = noise_sigma * randn(size(X));
X_noisy = X + noise;
noise_err = 100 * norm(X - X_noisy, "fro") / norm(X, "fro");

Cxx = X(:) * X(:)';
Cxn = zeros(size(Cxx));
Cnx = Cxn';
Cnn = noise_sigma^2 * eye(size(Cxx, 1));

% Prior Filters
Gg = eye(size(X, 1));
Gt = eye(size(X, 2));
Gj = kron(Gt, Gg);

results = struct();
results.alphas = alphas;
results.betas = betas;
results.gft_methods = gft_methods;
results.noise_sigma = noise_sigma;
results.noise_err = noise_err;
results.max_node_count = max_node_count;
results.max_time_count = max_time_count;
results.k = k;
results.knn_sigma = knn_sigma;

cond_multi_waitbar(ui, 'GFT Methods', 0);
for k = 1:length(gft_methods)
    errors = zeros(length(alphas), length(betas));
    [gft_mat, ~] = gft_matrix(full(G.W), gft_methods(k));

    cond_multi_waitbar(ui, 'betas', 0 );
    for j = 1:length(betas)
        [gfrt_mat, igfrt_mat] = gfrt_matrix(gft_mat, betas(j));

        % cond_multi_waitbar(ui, 'alphas', 0 );
        parfor i = 1:length(alphas)
            % Generate optimal filter
            [frt_mat,  ifrt_mat]  = frt_matrix(size(X, 2), alphas(i));
            [joint_jfrt_mat, joint_ijfrt_mat] = get_joint_jfrt_pair(gfrt_mat, igfrt_mat, frt_mat, ifrt_mat);
            hopt = get_optimal_filter_joint(Gj, joint_jfrt_mat, joint_ijfrt_mat, Cxx, Cxn, Cnx, Cnn);
            
            % Apply filter
            X_hat_vec = joint_ijfrt_mat * (hopt .* joint_jfrt_mat) * X_noisy(:);
            X_hat = reshape(X_hat_vec, size(X));
            err = 100 * norm(X - X_hat, 'fro') / norm(X, 'fro');
            errors(i, j) = err;

            % cond_multi_waitbar(ui, 'alphas', i / length(alphas) );
        end
        cond_multi_waitbar(ui, 'betas', j / length(betas) );
    end
    results.("errors_" + gft_methods(k)) = errors;
    cond_multi_waitbar(ui, 'GFT Methods', k / length(gft_methods) );
end
cond_multi_waitbar(ui, 'alphas', 'Close' );
cond_multi_waitbar(ui, 'betas', 'Close' );
cond_multi_waitbar(ui, 'GFT Methods', 'Close' );

%% Save results
save(sprintf("results_%.2f.mat", noise_sigma), "-struct", "results");
