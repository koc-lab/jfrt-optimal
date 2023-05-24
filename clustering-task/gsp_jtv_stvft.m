function c = gsp_jtv_stvft(G,kgraph,gtime,a,M,x,param)
%c = gsp_jtv_stvft(G,kgraph,gtime,a,M,x,param)

if nargin<7
    param = struct;
end

N = G.N;
Nk = numel(kgraph);

% 1) perform the transform in the graph domain
xf = permute(gsp_vec2mat(gsp_filter_analysis(G,kgraph,x,param),Nk),[3,1,2]);

% 2) perform the dgt
[c] = dgtreal(xf,gtime,a,M);
c = reshape(c,size(c,1),size(c,2),N,Nk);
c = permute(c,[3,1,4,2]);


end

