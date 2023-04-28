%% Clear
clc, clear, close all;

%% Import Data
folderName = "results-a-0_6-1_4-b-0_9-1_1";
sigma = 0.15;

%
workDir = pwd;
folderDir = fullfile(workDir, folderName);

mat_files = dir(fullfile(folderDir, "*.mat"));
mat_paths = fullfile(folderDir, string({mat_files.name}'));

%%
varNames = ["sigma", "delay", "noise_error", "method", "glpf_count", ...
            "est_error", "alpha", "beta"];
varTypes = ["double", "int32", "double", "string", "int32", ...
            "double", "double", "double"];
sz = [2 * length(mat_paths), length(varNames)];
csv_table = table('Size', sz, ...
                  'VariableTypes', varTypes, ...
                  'VariableNames', varNames);

for i = 1:length(mat_paths)
    p = mat_paths(i);
    [~, mat_name] = fileparts(p);
    mat_name_arr = str2mat(mat_name);
    delay = str2num(string(mat_name_arr(end-1:end)));
    results = load(p, "-mat");

    gft_methods = results.gft_methods;
    min_errors  = results.min_errors;
    glpf_counts = results.glpf_counts;
    if isfield(results, "noise_error")
        noise_error = results.noise_error;
    else
        noise_error = 20.9307;
    end

    

    for j = 1:length(gft_methods)
        if length(size(min_errors)) < 3
            min_error = min_errors;
        else
            min_error = min_errors(:, :, j);
        end
        [~, overall_min_idx] = min(min_error(1:size(min_error, 1)));
        overall_min_error_params = min_error(overall_min_idx, :, :);

        k = j + (i - 1) * length(gft_methods);
        csv_table(k, :) = {sigma, delay, noise_error, gft_methods(j), ...
            glpf_counts(overall_min_idx), ...
            overall_min_error_params(1), ...
            overall_min_error_params(2), ...
            overall_min_error_params(3)};
    end
end

%%
writetable(csv_table, fullfile(folderDir, 'results.csv'));