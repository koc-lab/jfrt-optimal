%% Clear
clc, clear, close all;

%% Load GSP Toolbox
GSP_TOOLBOX_PATH = "/Users/tunakasif/Dev/gspbox";
addpath(GSP_TOOLBOX_PATH);
gsp_start;

%% Parameters
rng("default");

gft_methods = ["adj", "lap"];
alphas = linspace(0.5, 1.5, 101);
betas = linspace(0.5, 1.5, 101);

if ~ismember(1.0, alphas)
    alphas = [alphas, 1.0];
end

if ~ismember(1.0, betas)
    betas = [betas, 1.0];
end

%% Generation of Graph
N = 64;
graph_lpf_count = 0;
% no_glpf_error = 12.9267;
no_glpf_error = -1;

% G = gsp_sensor(N);
G = gsp_david_sensor_network(N);
figure;
gsp_plot_graph(G);

%% Joint Time-Vertex Signal Generation
fs = 1000;
fmax = 400;
fc = fmax * 1.1;

Ts = 1 / fs;
t = 0:Ts:100 * Ts - Ts;
T = length(t);

delay_coeff = Ts * 40;
delays = vecnorm(G.coords, 2, 2);
delays = delay_coeff * delays / max(delays);

X = zeros(N, T);
for i = 1:N
    t_prime = t + delays(i);
    X(i, :) = chirp(t_prime, 0, 1, fmax);
end
plot_jtv_signal_time(X, t, "JTV Signal", "x", 1);

%% Add Noise
mu    = 0;
sigma = 0.15;
noise = mu + sigma * randn(size(X));

X_noisy = X + noise;
plot_jtv_signal_time(X_noisy, t, "Noisy JTV Signal", "x^{(noisy)}", 1);

%% Experiment
noise_error = 100 * norm(X - X_noisy, "fro") / norm(X, "fro");
fprintf("Noise error: %g\n", noise_error);
fprintf("Error with no GLPF: %g\n", no_glpf_error);

%%
for count = 0:(N - 1)
    fprintf("%d\n", count);
    experiment(G, t, X, X_noisy, gft_methods, alphas, betas, count, fs, fc);
    fprintf("\n", count);
    close all;
end

%%
figure;
gs_params = struct("climits", [min(X(:)), max(X(:))]);
for tt = 1:T
    title(sprintf("t = %g", tt));
    gsp_plot_signal(G, X(:, tt), gs_params);
    pause(0.1);
end
