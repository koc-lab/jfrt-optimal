function [joint_jfrt_mtx, joint_ijfrt_mtx] = get_joint_jfrt_pair(gfrt_mtx, igfrt_mtx, frt_mtx, ifrt_mtx)
    joint_jfrt_mtx = kron(frt_mtx, gfrt_mtx);
    joint_ijfrt_mtx = kron(ifrt_mtx, igfrt_mtx);
end
