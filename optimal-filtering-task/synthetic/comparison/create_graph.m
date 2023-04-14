function A = create_graph(N, K, node)
    if ~exist('N', 'var'), N = 8; end
    if ~exist('K', 'var'), K = 2; end
    if ~exist('node', 'var')
        node = [[2,9];[2,10];[5,6];[8,5];[3,2];[0,8];[4,1];[9,3]];
    end

    A = zeros(N, N);
    I = zeros(N, K);

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
        A(I(i,:),i) = 1;
  end
end
