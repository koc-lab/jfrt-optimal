%% Clear
clc, clear, close all;

%% GSP Toolbox
GSP_TOOLBOX_PATH = "../../../gspbox";
addpath(GSP_TOOLBOX_PATH, '-frozen');
gsp_start;

%% Create Graph
nodes = [[2,9];[2,10];[5,6];[8,5];[3,2];[0,8];[4,1];[9,3]];
param.type = 'knn';
param.k = 2;
G = gsp_nn_graph(double(nodes), param);
A = full(G.A) % create_graph(8, 2);

%%
rng(5);
N = 8; %Number of nodes
T = 8;
if T < 5, error("T < 5"); end

% G = randn(T*N, T*N);

tic;
C_GG = (A ~= 0);
C_GG = C_GG - diag(diag(C_GG)) + 2 * eye(N);
C_TT = toeplitz([1, 0.5, 0.25, zeros(1, T - 5) 0.25, 0.5]);
C_XX_vec = kron(C_TT, C_GG);

[X_vec, flag] = chol(C_XX_vec);
if flag ~= 0
    [V, d] = eig(C_XX_vec, 'vector');
    d_sqrt = sqrt(d);
    X_vec = V * diag(d_sqrt);
end
all(all(X_vec' * X_vec == C_XX_vec))
toc;

% for i = 1:T-1
%     C_XX_vec((i-1)*N+1:i*N,(i-1)*N+1:i*N) = C_XX;
%     C_XX_vec(i*N+1:(i+1)*N,(i-1)*N+1:i*N) = 0.5*C_XX;
%     C_XX_vec((i-1)*N+1:i*N,i*N+1:(i+1)*N) = 0.5*C_XX;    
% end
% C_XX_vec((T-1)*N+1:T*N,(T-1)*N+1:T*N) = C_XX; %C_XX_vec = sigma_X
% C_XX = C_XX/(max(abs(eig(C_XX))));
% C_XX_vec = C_XX_vec/(max(abs(eig(C_XX_vec))));
