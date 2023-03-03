function X_filtered = filter_jvt_signal(graph_weight_mat, X_noisy, gft_method, alpha, beta, ...
    graph_filter_count, time_sampling_freq, time_cutoff_freq)

[gft_mat, ~] = gft_matrix(graph_weight_mat, gft_method);
jfrt_pair = get_jfrt_pair(gft_mat, size(X_noisy, 2), alpha, beta);
X_filtered = jfrt_lowpass_filter(X_noisy, jfrt_pair, ...
                graph_filter_count, time_sampling_freq, time_cutoff_freq);
end
