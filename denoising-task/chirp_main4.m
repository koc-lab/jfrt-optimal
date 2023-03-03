%% Clear
clc, clear, close all;

%% Load GSP Toolbox
GSP_TOOLBOX_PATH = "/Users/tunakasif/Dev/gspbox";
addpath(GSP_TOOLBOX_PATH);
gsp_start;

%% Parameters
disp_plot = false;
gft_methods = ["adj", "lap"];
alphas = linspace(0.6, 1.4, 101);
betas = linspace(0.9, 1.1, 101);

if ~ismember(1.0, alphas)
    alphas = [alphas, 1.0];
end

if ~ismember(1.0, betas)
    betas = [betas, 1.0];
end

%% Generation of Graph
N = 64;
G = gsp_david_sensor_network(N);

if disp_plot
    figure;
    gsp_plot_graph(G);
end

%% Joint Time-Vertex Signal Generation
fs   = 1000;
fmax = 400;
fc   = 450;

Ts = 1 / fs;
t = 0:Ts:100 * Ts - Ts;
T = length(t);

for delay_multiplier = [20, 25, 30, 35, 40, 45, 50]
    delay_coeff = Ts * delay_multiplier;
    delays = vecnorm(G.coords, 2, 2);
    delays = delay_coeff * delays / max(delays);

    X = zeros(N, T);
    for i = 1:N
        t_prime = t + delays(i);
        X(i, :) = chirp(t_prime, 0, 1, fmax);
    end
    if disp_plot
        plot_jtv_signal_time(X, t, "JTV Signal", "x", 5);
    end

    % Add Noise
    rng("default");
    mu    = 0;
    sigma = 0.1;
    noise = mu + sigma * randn(size(X));

    X_noisy = X + noise;
    if disp_plot
        plot_jtv_signal_time(X_noisy, t, "Noisy JTV Signal", "x^{(noisy)}", 5);
    end

    % Experiment
    noise_error = 100 * norm(X - X_noisy, "fro") / norm(X, "fro");
    fprintf("Noise error: %g\n", noise_error);

    glpf_counts = 0:(N - 1);
    min_errors = zeros(length(glpf_counts), 3, length(gft_methods));

    for i = 1:length(glpf_counts)
        fprintf("%d\n", glpf_counts(i));
        multi_errors = experiment(G, t, X, X_noisy, gft_methods, alphas, betas, ...
            glpf_counts(i), fs, fc, disp_plot);

        for k = 1:length(gft_methods)
            if length(size(multi_errors)) < 3
                error = multi_errors;
            else
                error = multi_errors(:, :, k);
            end

            % Find minimum error location
            [min_row, min_col] = min_matrix_idx(error);
            min_errors(i, 1, k) = error(min_row, min_col);
            min_errors(i, 2, k) = alphas(min_row);
            min_errors(i, 3, k) = betas(min_col);
        end

        fprintf("\n");
    end

    % Save and Display Best Results
    results = struct( ...
        "gft_methods", gft_methods, ...
        "min_errors", min_errors, ...
        "glpf_counts", glpf_counts, ...
        "noise_error", noise_error);
    mat_filename = sprintf("results_n01_a06_delay_multip%d.mat", delay_multiplier);
    save(mat_filename, '-struct', "results");
    disp_best_results(mat_filename);
end

%% Display graph signals for each time index
if disp_plot
    figure;
    gs_params = struct("climits", [min(X(:)), max(X(:))]);
    for tt = 1:1
        title(sprintf("t = %g", tt));
        gsp_plot_signal(G, X(:, tt), gs_params);
        pause(0.1);
    end
end

