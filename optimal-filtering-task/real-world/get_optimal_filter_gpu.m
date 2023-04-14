function [T, q] = get_optimal_filter(Gt, Gg, jfrt_pair, X, N)
    G_joint = gpuArray(kron(Gt, Gg));
    cov_xx = gpuArray(X(:) * X(:)');
    cov_xn = gpuArray(X(:) * N(:)');
    cov_nx = cov_xn';
    cov_nn = gpuArray(N(:) * N(:)');

    joint_jfrt  = gather(kron(gpuArray(complex(jfrt_pair("FRT_T").')), ...
                       gpuArray(complex(jfrt_pair("GFRT")))));
    joint_ijfrt = gather(kron(gpuArray(complex(jfrt_pair("IFRT_T").')),...
                       gpuArray(complex(jfrt_pair("IGFRT")))));

    T = zeros(size(joint_jfrt));
    q = zeros(size(joint_jfrt, 1), 1);

    for m = 1:size(joint_jfrt, 1)
        wm            = gpuArray(joint_ijfrt(:, m));
        wm_tilde_T    = gpuArray(joint_jfrt(m, :));
        wm_tilde_conj = gpuArray(joint_jfrt(m, :)');

        q(m) = trace(gather((G_joint' * wm) * (wm_tilde_T * cov_xx) + (wm_tilde_conj * (wm' * cov_xn))));

        for n = 1:size(joint_jfrt, 2)
            fprintf("m = %d, n = %d\n", m, n);
            wn          = joint_ijfrt(:, n);
            wn_tilde_T  = joint_jfrt(n, :);

            term1 = gather((G_joint' * wm_tilde_conj) * ((wn_tilde_T * G_joint) * (cov_xx + cov_nx)));
            term2 = gather(wm_tilde_conj * (((wn_tilde_T * G_joint) * cov_xn) + (wn_tilde_T * cov_nn)));
            T(m, n) = gather(wm' * wn) * trace(term1 + term2);
        end
    end
end
