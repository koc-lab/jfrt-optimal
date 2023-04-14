function [T, q] = get_optimal_filter(Gt, Gg, jfrt_pair, X, N)
    G_joint = kron(Gt, Gg);
    cov_xx = X(:) * X(:)';
    cov_xn = X(:) * N(:)';
    cov_nx = cov_xn';
    cov_nn = N(:) * N(:)';

    joint_jfrt  = gather(kron(gpuArray(complex(jfrt_pair("FRT_T").')), ...
                       gpuArray(complex(jfrt_pair("GFRT")))));
    joint_ijfrt = gather(kron(gpuArray(complex(jfrt_pair("IFRT_T").')),...
                       gpuArray(complex(jfrt_pair("IGFRT")))));

    T = zeros(size(joint_jfrt));
    q = zeros(size(joint_jfrt, 1), 1);

    for m = 1:size(joint_jfrt, 1)
        wm            = joint_ijfrt(:, m);
        wm_tilde_T    = joint_jfrt(m, :);
        wm_tilde_conj = joint_jfrt(m, :)';

        q(m) = trace((G_joint' * wm) * (wm_tilde_T * cov_xx) + (wm_tilde_conj * (wm' * cov_xn)));

        for n = 1:size(joint_jfrt, 2)
            wn          = joint_ijfrt(:, n);
            wn_tilde_T  = joint_jfrt(n, :);

            term1 = (G_joint' * wm_tilde_conj) * ((wn_tilde_T * G_joint) * (cov_xx + cov_nx));
            term2 = wm_tilde_conj * (((wn_tilde_T * G_joint) * cov_xn) + (wn_tilde_T * cov_nn));
            T(m, n) = (wm' * wn) * trace(term1 + term2);
        end
    end
end
