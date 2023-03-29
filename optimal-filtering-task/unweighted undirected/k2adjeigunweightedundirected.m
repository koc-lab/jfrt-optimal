clc;clear all;

for z = 5
  rng(z)
  N = 8; %Number of nodes
%   node(1,:) = [randi([0 10]) randi([0 10])];  
%   node(2,:) = [randi([0 10]) randi([0 10])];
%   node(3,:) = [randi([0 10]) randi([0 10])];
%   node(4,:) = [randi([0 10]) randi([0 10])];
%   node(5,:) = [randi([0 10]) randi([0 10])];
%   node(6,:) = [randi([0 10]) randi([0 10])];
%   node(7,:) = [randi([0 10]) randi([0 10])];
%   node(8,:) = [randi([0 10]) randi([0 10])];
  node = [[2,9];[2,10];[5,6];[8,5];[3,2];[0,8];[4,1];[9,3]];

  A = zeros(N,N);
  disp(node)
  
  K = 2;
  I = zeros(N,K);
  for i = 1:N
      p = node(i,:);
      set = setdiff([1:N],i);
      dist = zeros(1,length(set));
      for k = 1:length(set)
          pk = node(set(k),:);
          dist(k) = norm(pk-p)^2;
      end
      [~,ix] = sort(dist);
      ix = ix(1:K);
      I(i,:) = set(ix);
  
      A(i,I(i,:)) = 1;
      A(I(i,:),1) = 1;
  
  end
  
  
  figure
  for i = 1:N
      plot(node(i,1),node(i,2),'>','LineWidth',2,'Color','k'); hold on;
      text(node(i,1),node(i,2)+0.5,num2str(i));
      
  end
  
  for i = 1:N
       for j = 1:K
          plot([node(i,1),node(I(i,j),1)],[node(i,2),node(I(i,j),2)],'-k'); hold on;
       end
  end
  grid on;
   xlabel('$x$ coordinates in [m]','fontsize',14,'interpreter','latex');
   ylabel('$y$ coordinates in [m]','fontsize',14,'interpreter','latex');
  
   %%
  M = 8; %Number of time instances
  G = randn(M*N,M*N);
  % G = eye(M*N);
  for i = 1:N
      C_XX(i,i) = 2;
      for j = 1:length(I(i,:))
          C_XX(i,I(i,j)) = 1;
          C_XX(I(i,j),i) = 1;
      end
  end
  
  C_TT = eye(M);
  for i = 0:(M-1)
      C_TT(i+1,mod(i+1,M)+1) = 0.5;
      C_TT(i+1,mod(i-1,M)+1) = 0.5;
      C_TT(i+1,mod(i+2,M)+1) = 0.25;
      C_TT(i+1,mod(i-2,M)+1) = 0.25;
  end
  
  C_XX_vec = kron(C_TT,C_XX);
  
  % for i = 1:M-1
  %     C_XX_vec((i-1)*N+1:i*N,(i-1)*N+1:i*N) = C_XX;
  %     C_XX_vec(i*N+1:(i+1)*N,(i-1)*N+1:i*N) = 0.5*C_XX;
  %     C_XX_vec((i-1)*N+1:i*N,i*N+1:(i+1)*N) = 0.5*C_XX;    
  % end
  C_XX_vec((M-1)*N+1:M*N,(M-1)*N+1:M*N) = C_XX; %C_XX_vec = sigma_X
  C_XX = C_XX/(max(abs(eig(C_XX))));
  C_XX_vec = C_XX_vec/(max(abs(eig(C_XX_vec))));
  
  A_GG = G*C_XX_vec*G';
  A_G = G*C_XX_vec;
  t = 1;
  % sigma = [0.5, 1, 1.5];
  N = M*N;
  ar = [0:0.1:2];
  MSE = zeros(11,length(ar));
  [V,~] = eig(A); %inv(V)x will be the GFT of any graph signal x.
  [P,J] = eig(inv(V));
  for kl = 1:11
      kla = ar(kl);
      A_nn = (t^2)*eye(N);
  
      %Now we set the adjacency matrix.
      Fta = dFRT(M,kla);
      Ftma = dFRT(M,-kla);
  
      for r = 1:length(ar)
          a = ar(r);    
          %a is the GFRT order.
  
          Fga = P*(J^a)*inv(P); %%Assuming J is diagonal.
          Fgma = P*(J^(-a))*inv(P);
          Fa = kron(Fta,Fga);
          Fainv = kron(Ftma,Fgma);
          for i = 1:N
              W(i,:,:) = Fainv(:,i)*Fa(i,:);
          end
          a = zeros(N);
          n = zeros(N);
          T = zeros(N);
          for k = 1:N
              for i = 1:N
                  a(k,i) = trace(A_GG*reshape(W(k,:,:),N,N)'*reshape(W(i,:,:),N,N));
                  n(k,i) = trace(A_nn*reshape(W(k,:,:),N,N)'*reshape(W(i,:,:),N,N));
                  T(k,i) = n(k,i) + a(k,i);
              end
          end
          b = zeros(N,1);
          for i = 1:N
              b(i) = trace(A_G*reshape(W(i,:,:),N,N));
          end
          q = conj(b);
          hopt = T\q;
  
          temp = 0;
  
          for i = 1:N
              for j = 1:N
                  temp = temp + conj(hopt(i))*hopt(j)*(a(i,j)+n(i,j)); 
              end
          end
          for i = 1:N
              temp = temp-hopt(i)*b(i)-conj(hopt(i)*b(i));
          end
          temp = temp + trace(C_XX);
          MSE(kl,r) = temp;
          disp(r)
      end
  end
  close all;
  
  save(['fixednodeadj.mat'],'MSE')
  
  
  
  
  
  clear all;
end