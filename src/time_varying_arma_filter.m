function [Z, psi, phi] = agsp_filter_ARMA_parallel(M, b, a, X, T, verbose)
% INPUT ARGUMENTS
%   M:   This is the shifted Laplacian matrix M = 0.5*norm(L)I - L,
%        where L is the combinatorial/normalized Laplacian. 
%        (Shifting the Laplacian helps the stability.) 
%        
%   b,a: are the coefficient of the numerator and denominator polynomials 
%        of the filter's spectral response:
%        $$r(mu) = \frac{ sum_{j=0}^{K-1} b(j+1) mu^{j} }{ sum_{j=0}^{K}
%        a(j+1) mu^{j} }$$.
%        Note that mu here should be the eigenvalues of M. This means that
%        since M = 0.5*norm(L)I - L, the polynomials should also
%        be expressed in terms of the eigenvalues mu of M.
% 
%  X:   The JTV signal to be filtered.
% 
%  T:    How many iterations should the ARMA recursions be run for?
% 
%  verbose: Set to 1 to see more information, 0 otherwize
% 
% OUTPUT ARGUMENTS
% 
%  Z:    The filtered signal
% 
%  phi,psi: The coefficients of the parallel ARMA recursions.
% 
% Tuna Alikaşifoğlu
% February 2023

if ~exist('verbose', 'var'), verbose = 0; end

n = size(M, 1);

% first compute the phi/psi coefficients
num = b; den = a;

% partial fraction expansion
[residues,poles,addTerm] = residue(wrev(num), wrev(den));

if isempty(addTerm), addTerm = 0; end
if addTerm ~= 0, disp('warning: addTerm non zero'); addTerm = sum(addTerm); end


% recursion coefficients (y_{t+1} = psi M y_{t} + phi x)
K = numel(poles);
psi = zeros(K,1); phi = zeros(K,1);
for j = 1:K,
    psi(j) = 1/poles(j);
    phi(j) = -residues(j)/poles(j);
end

% test for stability
if verbose,
    poles = 1./psi;
    if min(abs(poles)) > norm(full(M)),
        disp('filter is stable');
    else
        disp('warning: filter is unstable. Unexpected behavior expected!');
    end
end

x = X(:, 1); % for test output added for jtv

% parallel ARMA recursion
if size(x,2) == 1, x = repmat(x,1,T); end
y = zeros(n, K, T+1); y(:,:,1) = repmat(x(:,1), 1, K);
z = zeros(n,T+1); z(:,1) = x(:,1);
for t = 1:T,
    for j = 1:K,
        y(:,j,t+1) = psi(j) * M * y(:,j,t) + phi(j) * x(:,t);
    end
    z(:,t+1) = sum(y(:,:,t+1), 2) + addTerm*x(:,t);
end

Z = repmat(z(:,end),1, size(X,2)); % for test output added for jtv

% plot
if verbose, 
    response = @(mu) polyval(wrev(b), mu) ./ polyval(wrev(a), mu);
    [U, mu] = eig(M, 'vector'); [mu, idx] = sort(mu); U = U(:,idx);
    
    x_GFT = U' * x(:,1);
    z_GFT = U' * z(:,end);
    
    figure; set(gcf, 'Position', [680 558 760 350]);
    subplot(1,2,1); hold on;
    plot(z'); xlabel('iteration'); ylabel('filter output');
    subplot(1,2,2); hold on;
    plot(mu, response(mu), 'k-', 'DisplayName', 'r(mu)');
    plot(mu, abs(z_GFT./x_GFT), 'rx', 'DisplayName', 'abs(z_GFT./x_GFT)')
    xlabel('mu'); ylabel('filter response');
end
end


