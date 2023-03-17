function joint_multiset = get_multiset(unweighted_adj_mat, jtv_signal, node_idx, time_idx, p)
    if ~exist('p', 'var'), p = 1; end

    neighborhood_multiset = get_neighborhood_multiset(unweighted_adj_mat, jtv_signal(:, time_idx), node_idx);
    time_multiset = get_time_multiset(jtv_signal(node_idx, :), time_idx);
    joint_multiset = [neighborhood_multiset; time_multiset];

    if p == 2
        if time_idx == 1
            prev_neighbor_multiset = [];
        else
            prev_neighbor_multiset = get_neighborhood_multiset(unweighted_adj_mat, jtv_signal(:, time_idx - 1), node_idx);
        end

        if time_idx == size(jtv_signal, 2)
            next_neighbor_multiset = [];
        else
            next_neighbor_multiset = get_neighborhood_multiset(unweighted_adj_mat, jtv_signal(:, time_idx + 1), node_idx);
        end

        joint_multiset = [joint_multiset; prev_neighbor_multiset; next_neighbor_multiset];
    end
end

function multiset = get_time_multiset(time_signal, time_idx)
    if time_idx == 1
        multiset = time_signal(1:2);
    elseif time_idx == length(time_signal)
        multiset = time_signal(end-1:end);
    else
        multiset = time_signal(time_idx-1:time_idx+1);
    end
    multiset = multiset(:);
end

function multiset = get_neighborhood_multiset(unweighted_adj_mat, graph_signal, node_idx)
   logic_map = logical(unweighted_adj_mat(node_idx, :));
   multiset = graph_signal(logic_map);
   multiset = multiset(:);
end

