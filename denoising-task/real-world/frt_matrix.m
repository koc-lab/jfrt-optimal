function [frt_mat, ifrt_mat] = frt_matrix(N, a)
frt_mat = dFRT(N, a);
if nargout > 1
    ifrt_mat = dFRT(N, -a);
end
end