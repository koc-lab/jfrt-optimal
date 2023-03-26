%% Clear
clc, clear, close all;

%% Load Path
GSP_TOOLBOX_PATH = "../../gspbox/";
MEDIAN_FILTERING_PATH = "../../median-filtering/";
addpath(GSP_TOOLBOX_PATH, '-frozen');
addpath(MEDIAN_FILTERING_PATH, '-begin');
gsp_start;

%% Median Filter Parameters
median_filter_p = 2;

%% Generation of Graph
N = 64;
G = gsp_david_sensor_network(N);

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

        Y = median_filter(G.A, X_noisy, median_filter_p);
        filter_err = norm(X - Y, 'fro') / norm(X, 'fro');
        fprintf("\tEstimation Error: %g%%\n", filter_err * 100);
    end
end

