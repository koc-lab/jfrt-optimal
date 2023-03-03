%% Clear
clc, clear, close all;

%% Load GSP Toolbox
GSP_TOOLBOX_PATH = "/Users/tunakasif/Dev/gspbox";
addpath(GSP_TOOLBOX_PATH);
gsp_start;

%% 
N = 64;
G = gsp_david_sensor_network(N);
gft_methods = ["adj", "lap"];
eigen_idx = [1, 4, 16, N];

%%
for method = gft_methods
    [gft_mat, igft_mat, eig_vals] = gft_matrix(full(G.W), method);
    V = igft_mat;
    gs_params = struct("climits", [min(V(:)), max(V(:))]);

    for i = eigen_idx
        figure;
        gsp_plot_signal(G, V(:, i), gs_params);  
    end
    figure;
    plot(eig_vals);
end