%% Clear
clc, clear, close all;

%% Load data
results = load("results_0.10.mat");
display_info(results, "adj");
display_info(results, "lap");

%% Helper functions
function display_info(results, gft_method)
    [min_err, best_alpha, best_beta, jft_result] = analyze(results, gft_method);
    fprintf("Displaying results for %s gft method\n", gft_method);
    fprintf("Noise error: %.2f\n", results.noise_err);
    fprintf("JFT   error: %.2f\n", jft_result);
    fprintf("JFRT  error: %.2f, achieved by:\n", min_err);
    fprintf("\talpha: %.2f\n", best_alpha);
    fprintf("\tbeta : %.2f\n", best_beta);
    fprintf("\n");
end

function [min_err, best_alpha, best_beta, jft_result] = analyze(results, gft_method)
    if strcmp(gft_method, "adj")
        errors = results.errors_adj;
    elseif strcmp(gft_method, "lap")
        errors = results.errors_lap;
    else
        error("Invalid gft_method");
    end

    min_err = min(errors(:));
    [alpha_idx, beta_idx] = min_matrix_idx(errors);
    best_alpha = results.alphas(alpha_idx);
    best_beta = results.betas(beta_idx);
    jft_result = find_jft_result(errors, results.alphas, results.betas);
end

function err = find_jft_result(errors, alphas, betas)
    alpha1_idx = find(alphas == 1); alpha1_idx = alpha1_idx(1);
    beta1_idx = find(betas == 1); beta1_idx = beta1_idx(1);
    err = errors(alpha1_idx, beta1_idx);
end
