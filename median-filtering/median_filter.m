function filtered_jtv_signal = median_filter(unweighted_adj_mat, jtv_signal, p)
    if ~exist('p', 'var'), p = 1; end

    filtered_jtv_signal = zeros(size(jtv_signal));
    for node_idx = 1:size(jtv_signal, 1)
        for time_idx = 1:size(jtv_signal, 2)
            multiset = get_multiset(unweighted_adj_mat, jtv_signal, node_idx, time_idx, p);
            filtered_jtv_signal(node_idx, time_idx) = median(multiset);
        end
    end
end
