function hopt = get_optimal_filter_joint(Gj, joint_jfrt_mat, joint_ijfrt_mat, Cxx, Cxn, Cnx, Cnn);
    T = zeros(size(joint_jfrt_mat));
    q = zeros(size(joint_jfrt_mat, 1), 1);
    W = zeros([size(joint_jfrt_mat, 1), size(joint_jfrt_mat)]);

    for i = 1:size(W, 1)
        W(i, :, :) = joint_ijfrt_mat(:, i) * joint_jfrt_mat(i, :);
    end

    for m = 1:size(T, 1)
        Wm = squeeze(W(m, :, :));

        q1 = trace(Gj' * Wm  * Cxx);
        q2 = trace(      Wm' * Cxn);
        q(m) = q1 + q2;

        for n = 1:size(T, 2)
            Wn = squeeze(W(n, :, :));
            Wmn = Wm' * Wn;
            T1  = trace(Gj' * Wmn * Gj * Cxx);
            T2  = trace(      Wmn * Gj * Cxn);
            T3  = trace(Gj' * Wmn *      Cnx);
            T4  = trace(      Wmn *      Cnn);
            T(m, n) = T1 + T2 + T3 + T4;
        end
    end
    hopt = T \ q;
end
