%%% The original code was taken from "A Time-Vertex Signal Processing 
%%% Framework: Scalable Processing and Meaningful Representations for 
% Time-Series on Graphs". The code is modified for fractional JFT
% clustering.
%% Clustering of dynamic mesh using STVFT and comparison with other methods
%
%   In this demo, we try to cluster a dynamic mesh representing a man
%   dancing, based on the movements during the dance. To do so, we will use
%   Short Time-Vertex Fourier Transform and we compare the accuracy with
%   other transforms JFT, DFT and GFT and signal amplitude.
%   Ground truth is obtained by manual annotation. 
%   Dataset can be found at http://research.microsoft.com/en-us/um/redmond/events/geometrycompression/data/default.html
%

% Author: Francesco Grassi
% Date: April 2017

close all
clear
clc

addpath(genpath('../ltfat'))
addpath(genpath('../unlocbox'))
addpath(genpath('../gspbox'))


ltfatstart
init_unlocbox
gsp_start

load dancer.mat

X = X(:,1:570,:,:);

%% Parameters
winl = 50;
step = 20;
overlap = (winl-step)/winl;

ncl = 3;
ground = [3 1 1 1 1 1 1 1 1 3 3 3 3 3 3 3 3 3 2 2 2 2 2 2 2 2 2]';
kmeansiter = 1000;
itermax = 20;

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

%% Mother Kernel
% a = 20;
% M = 50;
% L = lcm(a,M).*ceil(T./lcm(a,M));
% 
% % Design in time
% gtime = gabwin('rect',a,M);
% [B1,B2] = gabframebounds(gtime,a,M);
% gtime = gtime/sqrt(B2);
% 
% % Design in graph spectral domain
% Ng = 4;
% kgraph = gsp_design_itersine(G,Ng);
% 
% % Analysis and synthesis operator
% A  = @(x) gsp_jtv_stvft(G,kgraph,gtime,a,M,x,param);
% At = @(c) gsp_jtv_istvft(G,kgraph,gtime,a,M,c,param);

%%These variables set time and graph tranforms and later create them to
%%hold them in memory.
F_set = zeros(winl,winl,21);
F_g_set = zeros(G.N,G.N,21);
time_fracs = 0.84:0.02:1.16 ;
graph_fracs = 0.84:0.02:1.16;
err = zeros(length(time_fracs),length(time_fracs),itermax);
% F_1 = dFRT(winl,1);
% F_g = gsp_frac_G(G.L,1);
%%% gsp_frac_G gives the fractional transformation obtained from graph
%%% Laplacian. It is a modified function taken from GSPBOX framework. See
%%% more details there.
for indeks = 1:length(time_fracs)
    F_set(:,:,indeks) = dFRT(winl,time_fracs(indeks));
    F_g_set(:,:,indeks) = gsp_frac_G(G.L,graph_fracs(indeks));
    disp(indeks)
end
rng(1)
fprintf('Finished the set \n');
for iter = 1:itermax
    
    
    %Signal and noise
    X1 = X(:,:,1) - repmat(mean(X(:,:,1),1),[N,1]);
    X2 = X(:,:,2) - repmat(mean(X(:,:,2),1),[N,1]);
    X3 = X(:,:,3) - repmat(mean(X(:,:,3),1),[N,1]);
    
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
    
    %% -----------------------------------------------------
    % COMPARISON BETWEEN STVFT JFT DFT GFT and SIGNAL
    % -----------------------------------------------------
    
    %STVFT
%     Xwin1 = A(X1);Xwin1=Xwin1(:,:,:,1:nwin);
%     Xwin2 = A(X2);Xwin2=Xwin2(:,:,:,1:nwin);
%     Xwin3 = A(X3);Xwin3=Xwin3(:,:,:,1:nwin);
%     Xwin = permute(cat(5,Xwin1,Xwin2,Xwin3),[1 2 3 5 4]);
%     Gc = gsp_nn_graph(abs(reshape(Xwin, [],nwin))',param);
%     Gc = gsp_create_laplacian(Gc,'normalized');
%     Gc = gsp_compute_fourier_basis(Gc);
%     features = [Gc.U(:,2:3)];
%     
%     [cluster] = kmeans(features,ncl,'Replicates',kmeansiter);
%     err(1,iter) = clustering_purity(cluster,ground);
%     fprintf('STVFT accuracy: %.4f\n',err(1,iter))
    
%     % JFT
%     Xwin1 = [];
%     Xwin2 = [];
%     Xwin3 = [];
%     
%     for ii=1:nwin
%         Xwin1(:,:,:,ii) = gsp_jft(G,X1(:,win(ii,:)));
%         Xwin2(:,:,:,ii) = gsp_jft(G,X2(:,win(ii,:)));
%         Xwin3(:,:,:,ii) = gsp_jft(G,X3(:,win(ii,:)));
%     end
%     
%     Xwin = cat(3,Xwin1,Xwin2,Xwin3);
%     Gc = gsp_nn_graph(abs(reshape(Xwin, [],nwin))',param);
%     Gc = gsp_create_laplacian(Gc,'normalized');
%     Gc = gsp_compute_fourier_basis(Gc);
%     features = [Gc.U(:,2:3)];
%     
%     [cluster] = kmeans(features,ncl,'Replicates',kmeansiter);
%     err(1,iter) = clustering_purity(cluster,ground);
%     fprintf('JFT accuracy: %.4f\n',err(1,iter))
%     
    % JFRT clusteings
    for timo = 1:length(time_fracs)
        for gimo = 1:length(graph_fracs)
            Xwin1 = [];
            Xwin2 = [];
            Xwin3 = [];
        
            for ii=1:nwin
                Xwin1(:,:,:,ii) = F_g_set(:,:,gimo)*X1(:,win(ii,:))*(F_set(:,:,timo).');
                Xwin2(:,:,:,ii) =  F_g_set(:,:,gimo)*X2(:,win(ii,:))*(F_set(:,:,timo).');
                Xwin3(:,:,:,ii) =  F_g_set(:,:,gimo)*X3(:,win(ii,:))*(F_set(:,:,timo).');
            end
            
            Xwin = cat(3,Xwin1,Xwin2,Xwin3);
            Gc = gsp_nn_graph(abs(reshape(Xwin, [],nwin))',param);
            Gc = gsp_create_laplacian(Gc,'normalized');
            Gc = gsp_compute_fourier_basis(Gc);
            features = [Gc.U(:,2:3)];
            
            [cluster] = kmeans(features,ncl,'Replicates',kmeansiter);
            err(timo,gimo,iter) = clustering_purity(cluster,ground);
            fprintf(sprintf('Graph order %.2f, Time order = %.2f, iter %d, accuracy: %.2f \n',graph_fracs(gimo),time_fracs(timo),iter,err(timo,gimo,iter)))
        end
     end
%     % GFT
%     Xwin1 = [];
%     Xwin2 = [];
%     Xwin3 = [];
%     
%     for ii=1:nwin
%         Xwin1(:,:,:,ii) = gsp_gft(G,X1(:,win(ii,:)));
%         Xwin2(:,:,:,ii) = gsp_gft(G,X2(:,win(ii,:)));
%         Xwin3(:,:,:,ii) = gsp_gft(G,X3(:,win(ii,:)));
%     end
%     
%     Xwin = cat(3,Xwin1,Xwin2,Xwin3);
%     Gc = gsp_nn_graph(abs(reshape(Xwin, [],nwin))',param);
%     Gc = gsp_create_laplacian(Gc,'normalized');
%     Gc = gsp_compute_fourier_basis(Gc);
%     features = [Gc.U(:,2:3)];
%     
%     [cluster] = kmeans(features,ncl,'Replicates',kmeansiter);
%     err(3,iter) = clustering_purity(cluster,ground);
%     fprintf('GFT accuracy: %.4f\n',err(3,iter))
%     
%     % signal
%     Xwin1 = [];
%     Xwin2 = [];
%     Xwin3 = [];
%     
%     for ii=1:nwin
%         Xwin1(:,:,:,ii) = X1(:,win(ii,:));
%         Xwin2(:,:,:,ii) = X2(:,win(ii,:));
%         Xwin3(:,:,:,ii) = X3(:,win(ii,:));
%     end
%     
%     Xwin = cat(3,Xwin1,Xwin2,Xwin3);
%     Gc = gsp_nn_graph((reshape(Xwin, [],nwin))',param);
%     Gc = gsp_create_laplacian(Gc,'normalized');
%     Gc = gsp_compute_fourier_basis(Gc);
%     features = [Gc.U(:,2:3)];
%     [cluster] = kmeans(features,ncl,'Replicates',kmeansiter);
%     
%     err(4,iter) = clustering_purity(cluster,ground);
%     fprintf('Signal accuracy: %.4f\n',err(4,iter))
end
%save('err_twenty.mat','err')
% 
% %% Summary statistics
% boxplot(err','sym','+','color','k')
% set(gca,'XTickLabel',{'JFT' 'DFT' 'GFT' 'Signal'})
% ylabel('Classification accuracy','Fontsize',13)
% set(gca,'Fontsize',13)
% ax = get(gca,'children');
% obj = ax.Children;
% for ii=1:numel(obj)
%     if strcmpi(obj(ii).Tag,'Outliers')
%         set(obj(ii),'MarkerSize',8)
%     elseif strcmpi(obj(ii).Tag,{'Box' 'Lower Whisker' 'Upper Whisker' 'Lower Adjacent Value' 'Lower Adjacent Value' 'Median'})
%         set(obj(ii),'LineWidth',1);
%     end
% end
% 
% 
% %% -----------------------------------------------------
% % PLOT RESULTS WITH JFT
% % -----------------------------------------------------
% if plotflag
%     Xwin1 = [];
%     Xwin2 = [];
%     Xwin3 = [];
%     for ii=1:nwin
%         Xwin1(:,:,:,ii) = gsp_jft(G,X1(:,win(ii,:)));
%         Xwin2(:,:,:,ii) = gsp_jft(G,X2(:,win(ii,:)));
%         Xwin3(:,:,:,ii) = gsp_jft(G,X3(:,win(ii,:)));
%     end
%     
%     Xwin = cat(3,Xwin1,Xwin2,Xwin3);
%     
%     % Spectral clustering
%     Gc = gsp_nn_graph(abs(reshape(Xwin, [],nwin))',param);
%     Gc = gsp_create_laplacian(Gc,'normalized');
%     Gc = gsp_compute_fourier_basis(Gc);
%     
%     ncl = 3;
%     features = [Gc.U(:,2:3)];
%     [cluster,centroids] = kmeans(features,ncl);
%     
%     dist                = pdist2(features,centroids);
%     [~,indc]            = min(dist);
%     
%     % Representative signal per class
%     rX1 = gsp_ijft(G,Xwin(:,:,:,indc(1)));
%     rX2 = gsp_ijft(G,Xwin(:,:,:,indc(2)));
%     rX3 = gsp_ijft(G,Xwin(:,:,:,indc(3)));
%     
%     % Plot
%     limit = [min(vec(X(:,:,1))) max(vec(X(:,:,1))) min(vec(X(:,:,2))) max(vec(X(:,:,2))) min(vec(X(:,:,3))) max(vec(X(:,:,3))) ];
%     param.view = [0 90];
%     figure(   'Position',[1          41        1366         651]);
%     t0 = 100;
%     step = 100;
%     sstep = 4;
%     
%     subplot(231)
%     scatter3(rX1(1:sstep:end,20,1),rX1(1:sstep:end,20,2),rX1(1:sstep:end,20,3),'k.')
%     axis(limit)
%     view(param.view )
%     
%     subplot(232)
%     scatter3(rX3(1:sstep:end,20,1),rX3(1:sstep:end,20,2),rX3(1:sstep:end,20,3),'k.')
%     axis(limit)
%     view(param.view )
%     
%     subplot(233)
%     scatter3(rX2(1:sstep:end,20,1),rX2(1:sstep:end,20,2),rX2(1:sstep:end,20,3),'k.')
%     axis(limit)
%     view(param.view )
%     
%     subplot(2,3,4:6)
%     plot(linspace(1,T,nwin),dist(:,1),'k-',linspace(1,T,nwin),dist(:,2),'k-o',linspace(1,T,nwin),dist(:,3),'k--')
%     xlim([1 T])
%     xlabel('Time','fontsize',14)
%     ylabel('Distance from centroids','fontsize',14)
%     legend('Arms','Legs','Body','Location','best')
% end
% 
