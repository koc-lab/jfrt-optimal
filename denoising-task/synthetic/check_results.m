%% Clear
clc, clear, close all;

%% Check Results
delay_multiplier = [20, 25, 30, 35, 40, 45, 50];
for d = delay_multiplier
    filename = sprintf("results-a-0_5-1_5-b-0_5-1_5/results_delay_multip%d.mat", d);
    fprintf("Result for delay %d:\n", d);
    disp_best_results(filename);
    fprintf("\n");
end