function plot_error_surface(alphas, betas, errors, min_row, min_col, method_name)
[B, A] = meshgrid(betas, alphas);
figure;
s = surf(B, A, errors);
colormap("pink");
colorbar
hold on;
title(sprintf("Error surface with method %s", method_name));
xlabel('Graph fraction $\\\beta$', 'Interpreter', 'latex');
ylabel('Time fraction $\\\alpha$', 'Interpreter', 'latex');
zlabel('MSE (%)');


min_point = plot3(B(min_row, min_col), A(min_row, min_col), errors(min_row, min_col), ...
    '.r', ...
    'MarkerSize', 30);

labels  = ["\beta", "\alpha", "MSE"];
formats = ["auto", "auto", "percentage"];
plt = {s, min_point};

for j = 1:length(plt)
    for i = 1:length(plt{j}.DataTipTemplate.DataTipRows)
        plt{j}.DataTipTemplate.DataTipRows(i).Label  = labels(i);
        plt{j}.DataTipTemplate.DataTipRows(i).Format = formats(i);
    end
    plt{j}.DataTipTemplate.Interpreter = "tex";
end

datatip(min_point, 'Location', 'southeast');
end

