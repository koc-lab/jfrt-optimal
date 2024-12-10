%% Clear
clc, clear, close all;

%% Add dependency paths and initialize
addpath(genpath('../ltfat'))
addpath(genpath('../unlocbox'))
addpath(genpath('../gspbox'))

ltfatstart
init_unlocbox
gsp_start

%% Load data
load dancer.mat
X = X(:,1:570,:,:);

%% Parameters
winl = 50;
step = 20;
overlap = (winl-step)/winl;

ncl = 3;
ground = [3 1 1 1 1 1 1 1 1 3 3 3 3 3 3 3 3 3 2 2 2 2 2 2 2 2 2]';
kmeansiter = 1000;
itermax = 1;

N = size(X,1);
T = size(X,2);
time = 1:T;
%SNR is modified here. In dBs.
SNR =-10;

plotflag = 1;
%% Split time in overlapping windows
H    = hankel(1:(T-winl+1), (T-winl+1):T);
win  = time(H(1:step:end,:));
nwin = size(win,1);

%% Graph
x0 = squeeze(mean(X,2));

param.k = 5;
paramnn.use_full = 1;
G = gsp_nn_graph(x0,paramnn);
G = gsp_compute_fourier_basis(G);
G = gsp_jtv_graph(G,size(X,2));

%% Time and Graph Tranforms
time_fracs = 0.5:0.1:1.5; %0.84:0.02:1.16 ;
graph_fracs = 0.5:0.1:1.5; %0.84:0.02:1.16;
F_set = zeros(winl,winl,length(time_fracs));
F_g_set = zeros(G.N,G.N,length(graph_fracs));
err = zeros(length(time_fracs),length(graph_fracs),itermax);

for indeks = 1:length(time_fracs)
    F_set(:,:,indeks) = dFRT(winl,time_fracs(indeks));
end
for indeks = 1:length(graph_fracs)
    F_g_set(:,:,indeks) = gsp_frac_G(G.L,graph_fracs(indeks));
    fprintf("Graph Index %d/%d\n",indeks,length(graph_fracs));
end
rng(1)
fprintf('Finished the set \n');

%Signal
X1 = X(:,:,1) - repmat(mean(X(:,:,1),1),[N,1]);
X2 = X(:,:,2) - repmat(mean(X(:,:,2),1),[N,1]);
X3 = X(:,:,3) - repmat(mean(X(:,:,3),1),[N,1]);
for iter = 1:itermax
    % noise
    Y1 = sprandn(N,T,0.1);Y1 = Y1/norm(Y1,'fro');
    Y2 = sprandn(N,T,0.1);Y2 = Y2/norm(Y2,'fro');
    Y3 = sprandn(N,T,0.1);Y3 = Y3/norm(Y3,'fro');

    sigma2 = 10^(SNR/10);

    Y1 = Y1*norm(X1(:),'fro')/sigma2;
    Y2 = Y2*norm(X2(:),'fro')/sigma2;
    Y3 = Y3*norm(X3(:),'fro')/sigma2;
    fprintf('SNR: %.2f\n',snr([X1;X2;X3] ,[X1+Y1;X2+Y2;X3+Y3]))
    X1 = X1 + Y1;
    X2 = X2 + Y2;
    X3 = X3 + Y3;

    % JFRT clusteings
    for timo = 1:length(time_fracs)
        fprintf("Time Index %d/%d\n",timo,length(time_fracs));
        F_set_curr_tr = F_set(:, :, timo).';
        for gimo = 1:length(graph_fracs)
            Xwin = zeros(G.N, winl, 3, nwin);
            F_g_set_curr = F_g_set(:, :, gimo);
            for ii = 1:nwin
                temp = pagemtimes(F_g_set_curr, cat(3, X1(:, win(ii, :)), X2(:, win(ii, :)), X3(:, win(ii, :))));
                temp = pagemtimes(temp, F_set_curr_tr);
                Xwin(:, :, :, ii) = permute(temp, [1, 2, 4, 3]);
            end

            Gc = gsp_nn_graph(abs(reshape(Xwin, [],nwin))',param);
            Gc = gsp_create_laplacian(Gc,'normalized');
            Gc = gsp_compute_fourier_basis(Gc);
            features = [Gc.U(:,2:3)];

            [cluster] = kmeans(features,ncl,'Replicates',kmeansiter);
            err(timo,gimo,iter) = clustering_purity(cluster,ground);
            % fprintf(sprintf('Graph order %.2f, Time order = %.2f, iter %d, accuracy: %.2f \n',graph_fracs(gimo),time_fracs(timo),iter,err(timo,gimo,iter)))
        end
     end
end
save('err_new_eff.mat','err', 'time_fracs', 'graph_fracs');

