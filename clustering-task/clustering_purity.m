function res = clustering_purity(cluster,ground)
n = length(cluster);
confuc = zeros(n);
for ilo = 1:n
    confuc(ground(ilo),cluster(ilo)) = confuc(ground(ilo),cluster(ilo)) + 1;
end
res = 0;
for ilo = 1:n
    res = res + max(confuc(ilo,:));
end
res = 100*res/n;
end