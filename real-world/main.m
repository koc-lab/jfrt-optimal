%% Clear
clc, clear, close all;

%% Load GSP Toolbox
GSP_TOOLBOX_PATH = "/path/to/gsp/toolbox";
addpath(GSP_TOOLBOX_PATH);
gsp_start;

%% Parameters
rng("default");

gft_methods = ["adj", "lap"];
alphas = linspace(0.9, 1.1, 99);
betas = linspace(0.0, 3.0, 199);

if ~ismember(1.0, alphas)
    alphas = [alphas, 1.0];
end

if ~ismember(1.0, betas)
    betas = [betas, 1.0];
end

%% Generation of Graph
N = 64;
graph_lpf_count = 1;
no_glpf_error = 3.42404;
% no_glpf_error = -1;

% G = gsp_sensor(N);
G = gsp_david_sensor_network(N);
figure;
gsp_plot_graph(G);

%% Joint Time-Vertex Signal Generation
fs = 1000;
Ts = 1 / fs;
t = 0:Ts:100 * Ts - Ts;
T = length(t);

fmin = 20;
fmax = 20;
fc = fmax * 1.5;
f_values = round(linspace(fmin, fmax, N));

X = zeros(N, T);
for i = 1:length(f_values)
    X(i, :) = cos(2 * pi * f_values(i) * t);
end
plot_jtv_signal_time(X, t, "JTV Signal", "x", 1);

%% Add Noise
mu    = 0;
sigma = 0.1;

if true
    noise = mu + sigma * randn(size(X));
else
    noise = mu + sigma * cos(2 * pi * 3 * fmax * t);
end

X_noisy = X + noise;
plot_jtv_signal_time(X_noisy, t, "Noisy JTV Signal", "x^{(noisy)}", 1);

%% Experiment
noise_error = 100 * norm(X - X_noisy, "fro") / norm(X, "fro");
fprintf("Noise error: %g\n", noise_error);
fprintf("Error with no GLPF: %g\n", no_glpf_error);
experiment(G, t, X, X_noisy, gft_methods, alphas, betas, graph_lpf_count, fs, fc);

