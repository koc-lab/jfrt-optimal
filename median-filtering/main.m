%% Clear
clc, clear, close all;

%% 
rng(0);
len = 5;
A = randn(len, len);
A = A + A';
A = A > 0.8;
A = A - diag(diag(A));
A

%%
X = [11 12 13 14 15;
     21 22 23 24 25;
     31 32 33 34 35;
     41 42 43 44 45;
     51 52 53 54 55];

 %%
 node_idx = 5; time_idx = 5;
 tic;
 get_multiset(A, X, node_idx, time_idx, 2)
 toc;
