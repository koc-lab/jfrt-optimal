function disp_best_results(results_mat_path)
results     = load(results_mat_path);
gft_methods = results.gft_methods;
min_errors  = results.min_errors;
glpf_counts = results.glpf_counts;

for k = 1:length(gft_methods)
    if length(size(min_errors)) < 3
        min_error = min_errors;
    else
        min_error = min_errors(:, :, k);
    end
    [~, overall_min_idx] = min(min_error(1:size(min_error, 1)));
    overall_min_error_params = min_error(overall_min_idx, :, :);
    fprintf("Best config for method %s:\n", gft_methods(k));
    fprintf("\tGLPF count: %d\n\tError: %f\n\talpha: %f\n\tbeta: %f\n", ...
        glpf_counts(overall_min_idx), ...
        overall_min_error_params(1), ...
        overall_min_error_params(2), ...
        overall_min_error_params(3));
    if isfield(results, "noise_error")
        fprintf("\tNoise Error: %f\n", results.noise_error);
    end
end
end