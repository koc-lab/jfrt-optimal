%% Clear
clc, clear, close all;

%% Load Path
GSP_TOOLBOX_PATH = "../../gspbox/";
GRAPH_ARMA_PATH = "../../graph-arma/";
JTV_ARMA_PATH = "../../jtv-arma/";
addpath(GSP_TOOLBOX_PATH, '-frozen');
addpath(GRAPH_ARMA_PATH, JTV_ARMA_PATH, '-begin');
gsp_start;

%% Generation of Graph
N = 64;
G = gsp_david_sensor_network(N);

%% Graph ARMA Laplacian
G = gsp_create_laplacian(G, 'normalized');
G = gsp_estimate_lmax(G);
G = gsp_compute_fourier_basis(G);

l  = linspace(0, G.lmax, 300);
M  = sparse(0.5 * G.lmax * speye(G.N) - G.L);
mu = G.lmax / 2 - l;

%% Graph ARMA Parameters
order = 3;
normalize = true;
[b, a] = get_chirp_arma_coeffs(G, mu, order, normalize);
fprintf("Generating Results for ARMA%d Filter:\n", length(a))

%% Noise Parameters
sigmas = [0.1, 0.15, 0.2];

%% Joint Time-Vertex Signal Generation
fs   = 1000;
fmax = 400;
fc   = 450;
delay_multipliers = [20, 25, 30, 35, 40, 45, 50];

Ts = 1 / fs;
t = 0:Ts:100 * Ts - Ts;
T = length(t);

for delay_multiplier = delay_multipliers
    for sigma = sigmas
        delay_coeff = Ts * delay_multiplier;
        delays = vecnorm(G.coords, 2, 2);
        delays = delay_coeff * delays / max(delays);

        X = zeros(N, T);
        for i = 1:N
            t_prime = t + delays(i);
            X(i, :) = chirp(t_prime, 0, 1, fmax);
        end

        % Add Noise
        rng("default");
        noise = sigma * randn(size(X));
        X_noisy = X + noise;

        % Experiment
        fprintf("sigma = %.2f, delay = %d\n", sigma, delay_multiplier);
        noise_error = 100 * norm(X - X_noisy, "fro") / norm(X, "fro");
        fprintf("\tNoise error: %g%%\n", noise_error);

        Y = time_varying_arma_filter(M, b, a, X_noisy);
        Y = real(Y);
        filter_err = norm(X - Y, 'fro') / norm(X, 'fro');
        fprintf("\tEstimation Error: %g%%\n", filter_err * 100);
    end
end
