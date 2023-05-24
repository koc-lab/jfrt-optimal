%%% This function is a modified version of graph Laplacian generator of GSP
%%% toolbox framework. It takes the ordnary Laplacian L and fractional
%%% order a and produces a graph fractional Fourier transformation out of
%%% it according to Wang et. al 2017 approach.
function Fg_frac = gsp_frac_G(L,a)

        [eigenvectors,eigenvalues,~]=svd(full(L+L')/2);

    
    % Sort eigenvectors and eigenvalues
    [~,inds] = sort(diag(eigenvalues),'ascend');
    eigenvectors=eigenvectors(:,inds);
    
    % Set first component of each eigenvector to be nonnegative
    signs=sign(eigenvectors(1,:));
    signs(signs==0)=1;
    U = eigenvectors*diag(signs);
    [Vfr,Dfr] = eig(U);
    Fg_frac = Vfr * (Dfr^(-a))*inv(Vfr);
end