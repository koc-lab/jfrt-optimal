function multi_errors = experiment(G, t, X, X_noisy, gft_methods, alphas, betas, ...
        graph_filter_count, time_sampling_freq, time_cutoff_freq, disp_plot)
minArgs = 10;
maxArgs = 11;
narginchk(minArgs, maxArgs);

if nargin == minArgs
    disp_plot = true;
end

multi_errors = generate_errors(full(G.W), X, X_noisy, gft_methods, alphas, betas, ...
    graph_filter_count, time_sampling_freq, time_cutoff_freq);

for k = 1:length(gft_methods)
    if length(size(multi_errors)) < 3
        error = multi_errors;
    else
        error = multi_errors(:, :, k);
    end
    
    % Find minimum error location
    [min_row, min_col] = min_matrix_idx(error);
    min_alpha = alphas(min_row);
    min_beta = betas(min_col);
    min_error = error(min_row, min_col);

    fprintf("For method %s:\n\tBest alpha=%f, beta=%f, err=%g\n", ...
        gft_methods(k), min_alpha, min_beta, min_error);

    if disp_plot
        % Regenerate results for minimum location
        X_filtered = filter_jvt_signal(full(G.W), X_noisy, gft_methods(k), min_alpha, ...
            min_beta, graph_filter_count, time_sampling_freq, time_cutoff_freq);

        plot_jtv_signal_time(X_filtered, t, ...
            "\textbf{Estimation with} {\boldmath$\alpha$} $\bf{= "+num2str(min_alpha)+ ...
            "}$, {\boldmath$\beta$} $\bf{= "+num2str(min_beta)+"}$, \textbf{error} $\bf{= " + num2str(min_error) + ...
            "}$", "x^{(est)}", 3);
        plot_error_surface(alphas, betas, error, min_row, min_col, gft_methods(k));
    end
end
end
