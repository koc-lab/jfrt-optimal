function [y, err, b, a, time] = arma(G, X)
    disp(size(X));
    G = gsp_create_laplacian(G, 'normalized');
    G = gsp_estimate_lmax(G);
    G = gsp_compute_fourier_basis(G);

    lambda = G.e;
    U = G.U;

    % Since the eigenvalues might change, sample eigenvalue domain uniformly
    l = linspace(0, G.lmax, 300);

    % For stability, use a shifted version of the Laplacian
    M = sparse(0.5 * G.lmax * speye(G.N) - G.L);
    mu = G.lmax / 2 - l; 

    % desired graph frequency response
    lambda_cut = 0.5;
    step     = @(x,a) double(x>=a);  
    response = @(x) step(x, G.lmax/2 - lambda_cut); 

    Ka     = 2;      % AR filter order (decrease radius for larger values)
    Kb     = 18;     % MA filter order
    radius = 0.95;   % for speed make small, for accuracy increase. Should be below 1 
                     % if the distributed implementation is used. With the (faster) 
                     % conj. gradient implementation, any radius is allowed. 
    [b, a, ~] = agsp_design_ARMA(mu, response, Kb, Ka, radius);

    x = X;
    T = max([5 * max(Ka, Kb) 30]);
    fprintf("T = %d\n", T);
    tic; y = agsp_filter_ARMA(M, b, a, x, T); time = toc;
    err = norm( (U'*y(:,end))./(U'*x) - response(G.lmax/2-lambda)) / norm(response(G.lmax/2-lambda));
end
