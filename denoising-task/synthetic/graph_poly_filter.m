function [H, D, vandermonde] = graph_poly_filter(eig_vals, cutoff_count, poly_deg)
minArgs = 2;
maxArgs = 3;
narginchk(minArgs, maxArgs);

eig_vals = eig_vals(:); % make sure column vector

if nargin == 2
    vandermonde = fliplr(vander(eig_vals));
else
    power_values = (0:1:poly_deg);
    vandermonde = eig_vals .^ power_values;
end

N = length(eig_vals);
desired = [ones(N - cutoff_count, 1); zeros(cutoff_count, 1)];
D = diag(desired);

filter_coeffs = vandermonde \ desired;
H = diag(vandermonde * filter_coeffs);
end