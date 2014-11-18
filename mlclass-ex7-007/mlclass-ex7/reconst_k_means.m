function XKmeans_reduce = reconst_k_means(X, centroids, idx)
    
XKmeans_reduce = X;
for i = 1:1:size(X,1)
    

        XKmeans_reduce(i,:) = centroids(idx(i),:);


end

end