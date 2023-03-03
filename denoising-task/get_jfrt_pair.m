function pair = get_jfrt_pair(gft_mat, time_lenght, alpha, beta, with_inverse)
minArgs = 4;
maxArgs = 5;
narginchk(minArgs, maxArgs);

if nargin == 4
    with_inverse = true;
end

if with_inverse
    [gfrt_mat, igfrt_mat] = gfrt_matrix(gft_mat, beta);
    [frt_mat,  ifrt_mat]  = frt_matrix(time_lenght, alpha);
    frt_mat_tr  = frt_mat.';   % nonconjugate transpose
    ifrt_mat_tr = ifrt_mat.'; % nonconjugate transpose
    keys = ["GFRT", "FRT_T", "IGFRT", "IFRT_T"];
    matrices = {gfrt_mat, frt_mat_tr, igfrt_mat, ifrt_mat_tr};
    pair = containers.Map(keys, matrices);
else
    gfrt_mat   = gfrt_matrix(gft_mat, beta);
    frt_mat    = frt_matrix(time_lenght, alpha);
    frt_mat_tr = frt_mat.';   % nonconjugate transpose
    keys = ["GFRT", "FRT_T"];
    matrices = {gfrt_mat, frt_mat_tr};
    pair = containers.Map(keys, matrices);
end
end