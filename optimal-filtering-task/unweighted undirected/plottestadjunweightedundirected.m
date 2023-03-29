close all;
% name = 'data/rng5-k2-adj-eig-unweightedundirected';
% name = 'data/2ptsadjnewtests5';
name = 'data/fixednodeadj';
load( name);
MSE = real(MSE);
a = 0:0.1:2;
b = 0:0.1:1;
% MSE for directed graph with independent time
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
  saveas(gcf,'figs/fixednodeadj', 'epsc')
