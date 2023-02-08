function [Y, b, a, response] = arma(G, X, arma_iter, ar_order, ma_order, radius)

    if ~exist('ar_order', 'var'),  ar_order  = 2;    end
    if ~exist('ma_order', 'var'),  ma_order  = 18;   end
    if ~exist('radius', 'var'),    radius    = 0.85; end
    if ~exist('arma_iter', 'var')
        arma_iter = max([5 * max(ar_order, ma_order) 30]);
        disp(['arma_iter not specified, using default value of ' num2str(arma_iter)]);
    end

    G = gsp_create_laplacian(G, 'normalized');
    G = gsp_estimate_lmax(G);
    G = gsp_compute_fourier_basis(G);

    % lambda = G.e;
    % U = G.U;

    % Since the eigenvalues might change, sample eigenvalue domain uniformly
    l = linspace(0, G.lmax, 300);

    % For stability, use a shifted version of the Laplacian
    % M = sparse(0.5 * G.lmax * speye(G.N) - G.L);
    % mu = G.lmax / 2 - l; 
    M = G.L;
    mu = l;

    % desired graph frequency response
    lambda_cut = 0.5;
    % lambda_cut = G.lmax / 2;
    step       = @(x,a) double(x>=a);  
    response = @(x) step(x, lambda_cut); 
    [b, a, ~] = agsp_design_ARMA(mu, response, ma_order, ar_order, radius);

    % Filter
    Y = zeros(size(X));
    for i = 1:size(X, 2)
        y_all_iterations = agsp_filter_ARMA(M, b, a, X(:, i), arma_iter); 
        Y(:, i) = y_all_iterations(:, end);
        % Y(:, i) = X(:, i);
    end
    % err = norm( (U'*y(:,end))./(U'*x) - response(G.lmax/2-lambda)) / norm(response(G.lmax/2-lambda));
end
