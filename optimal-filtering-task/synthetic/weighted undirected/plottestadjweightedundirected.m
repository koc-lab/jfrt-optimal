 close all;


%     name = 'data/rng5-k5-adj-eig-weightedundirected.mat';
%     name = 'data/k5adjnewestwund5';
    name = 'data/fixednodeadj.mat';


    load( name);
    MSE = real(MSE);
    a = 0:0.1:3;
    b = 0:0.1:1;
    % MSE for directed graph with independent time
    fig = figure;
    p = surf(a,b,MSE);
    colormap('gray');
    z = min(min(MSE));
    [x,y] = find(MSE==z);
    datatip(p,'DataIndex', find(MSE==z));
    p.DataTipTemplate.DataTipRows(1) = ['Graph fraction: ',num2str(a(y))];
    p.DataTipTemplate.DataTipRows(2) = ['Time fraction: ',num2str(b(x))];
    p.DataTipTemplate.DataTipRows(3) = ['MSE: ', num2str(z)];
    ylabel("Time fraction")
    xlabel("Graph fraction")
    zlabel("MSE")
    ax = gca;
    ax.FontSize = 16;
    dataline = ax.Children;
    dataline.DataTipTemplate.FontSize = 14;
    saveas(gcf,'figs/fixednodeadj', 'epsc')
    savefig(fig,'weighted_undirected_adj.fig')

