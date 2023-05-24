function x = gsp_jtv_istvft(G,kgraph,gtime,a,M,c,param)
% x = gsp_jtv_istvft(G,kgraph,gtime,a,M,c,param)

if nargin<7
    param = struct;
end

N = G.N;
Nk = numel(kgraph);
T = G.jtv.T;
% 1) perform the idgt

c = permute(c,[2,4,1,3]);
c = reshape(c,size(c,1),size(c,2), N*Nk);
xf = idgtreal(c,gtime,a,M,G.jtv.T);

xf = reshape(xf,T,N,Nk);

% 1) perform the transform in the graph domain
x = gsp_filter_synthesis(G,kgraph,gsp_mat2vec(permute(xf,[2,3,1])),param);

end
