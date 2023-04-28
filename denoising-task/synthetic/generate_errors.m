function errors = generate_errors(graph_weight_mat, X, X_noisy, gft_methods, alphas, betas, ...
    graph_filter_count, time_sampling_freq, time_cutoff_freq)
errors = zeros(length(alphas), length(betas), length(gft_methods));
keys = ["GFRT", "FRT_T", "IGFRT", "IFRT_T"];
for k = 1:length(gft_methods)
    % Generate GFT Matrix
    [gft_mat, ~] = gft_matrix(graph_weight_mat, gft_methods(k));

    progress_bar = waitbar(0, 'Beta Values');
    for j = 1:length(betas)
        % Generate GFRT Matrix
        [gfrt_mat, igfrt_mat] = gfrt_matrix(gft_mat, betas(j));

        for i = 1:length(alphas)
            % Generate FRT Matrix and take transpose
            [frt_mat, ifrt_mat] = frt_matrix(size(X_noisy, 2), alphas(i));
            frt_mat_tr = frt_mat.'; % nonconjugate transpose
            ifrt_mat_tr = ifrt_mat.'; % nonconjugate transpose

            % Generate JFRT Pair
            matrices = {gfrt_mat, frt_mat_tr, igfrt_mat, ifrt_mat_tr};
            jfrt_pair = containers.Map(keys, matrices);

            % Filter Noisy Signal
            X_filtered = jfrt_lowpass_filter(X_noisy, jfrt_pair, ...
                graph_filter_count, time_sampling_freq, time_cutoff_freq);

            % Calculate Error
            errors(i, j, k) = 100 * norm(X - X_filtered, "fro") / norm(X, "fro");
        end

        progress_msg = sprintf('Progress of %s: %d %%', ...
            gft_methods(k), floor(100 * j / length(betas)));
        waitbar(j / length(betas), progress_bar, progress_msg);
    end
    close(progress_bar);
end
end
