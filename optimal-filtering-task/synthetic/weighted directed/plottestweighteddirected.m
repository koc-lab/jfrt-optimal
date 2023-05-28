 close all;
 

%     name = ['data/rng5-k5-adj-eig-weighteddirected'];
%     name = ['data/eig2ptsnewesttestwd5']; 
    name = ['data/fixednode.mat'];
    load( name);
    fig = figure;
    MSE = real(MSE);
    a = 0:0.1:2;
    b = 0:0.1:1;
    % MSE for directed graph with independent time
    p = surf(a,b,MSE);
    colormap('pink');
    z = min(min(MSE));
    [x,y] = find(MSE==z);
    datatip(p,'DataIndex', find(MSE==z));
    p.DataTipTemplate.DataTipRows(1) = ['Graph fraction: ',num2str(a(y))];
    p.DataTipTemplate.DataTipRows(2) = ['Time fraction: ',num2str(b(x))];
    p.DataTipTemplate.DataTipRows(3) = ['MSE: ', num2str(z)];
    ylabel("Time fraction")
    xlabel("Graph fraction")
    zlabel("MSE")
    saveas(gcf,'figs/fixednode', 'epsc')
    savefig(fig,'weighted_directed.fig')
