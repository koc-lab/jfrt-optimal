function plot_jtv_signal_time(X, t, title_str, display_string, max_count)
display_count = min(max_count, size(X, 1));

figure;
hold on;
title(sprintf("\\textbf{%s}", title_str), "Interpreter", "latex", 'fontsize', 15);
ylim([-1.25, 1.55]);
grid on;
for i = 1:display_count
    plot(t, X(i, :), ...
        "DisplayName", sprintf("$\\bf{%s_{%d}}$", display_string, i), ...
        "LineWidth", 1.5);
end
legend([], "interpreter", "latex", ...
           'fontsize', 14, ...
           'Orientation', 'horizontal');
end

