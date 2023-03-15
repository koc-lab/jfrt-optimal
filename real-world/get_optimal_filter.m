function [joint_jfrt] = get_optimal_filter(Gt, Gg, jfrt_pair, X, N)
    G_joint = kron(Gt, Gg);
    cov_xx = X(:) * X(:)';
    cov_xn = X(:) * N(:)';
    cov_nx = cov_xn';
    cov_nn = N(:) * N(:)';

    joint_jfrt  = gather(kron(gpuArray(complex(jfrt_pair("FRT_T").')), ...
                       gpuArray(complex(jfrt_pair("GFRT")))));
    joint_ijfrt = gather(kron(gpuArray(complex(jfrt_pair("IFRT_T").')),...
                       gpuArray(complex(jfrt_pair("IGFRT")))));
end
