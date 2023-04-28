%% Clear
clc, clear, close all;

%% Load data
for k = [2, 5, 10]
    for sigma = [0.10, 0.15, 0.20]
        s = sprintf("sst-results-ht020/results_k%d_%.3f.mat", k, sigma);
        results = load(s);
        fprintf("k = %d, sigma = %.3f\n", k, sigma);
        display_info(results, "adj");
        display_info(results, "lap");
        fprintf("========================================\n");
    end
end

%% Helper functions
function display_info(results, gft_method)
    [min_err, best_alpha, best_beta, best_c, jft_err, jft_c] = analyze(results, gft_method);
    fprintf("Displaying results for %s gft method\n", gft_method);
    fprintf("Noise error: %.2f\n", results.noise_err);
    fprintf("JFT   error: %.2f (c = %d)\n", jft_err, jft_c);
    fprintf("JFRT  error: %.2f, achieved by:\n", min_err);
    fprintf("\talpha: %.2f\n", best_alpha);
    fprintf("\tbeta : %.2f\n", best_beta);
    fprintf("\tc    : %d\n", best_c);
    fprintf("\n");
end

function [min_err, best_alpha, best_beta, best_c, jft_err, jft_c] = analyze(results, gft_method)
    if strcmp(gft_method, "adj")
        errors = results.errors_adj;
    elseif strcmp(gft_method, "lap")
        errors = results.errors_lap;
    else
        error("Invalid gft_method");
    end

    min_err = min(errors(:));
    [c_idx, alpha_idx, beta_idx] = min_matrix_idx(errors);
    best_alpha = results.alphas(alpha_idx);
    best_beta = results.betas(beta_idx);
    best_c = results.c_values(c_idx);
    [jft_err, jft_c] = find_jft_result(errors, results.alphas, results.betas, results.c_values);
end

function [err, c] = find_jft_result(errors, alphas, betas, c_values)
    alpha1_idx = find(alphas == 1); alpha1_idx = alpha1_idx(1);
    beta1_idx = find(betas == 1); beta1_idx = beta1_idx(1);
    errs = errors(:, alpha1_idx, beta1_idx);
    [err, c_idx] = min(errs);
    c = c_values(c_idx);
end
