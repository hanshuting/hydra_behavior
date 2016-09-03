function [acr,prc] = statsClusterAnno(indx,anno)

numClass = max(anno);

labels = unique(indx);
numCluster = length(labels);

acr = zeros(numCluster,numClass);
prc = zeros(numCluster,numClass);

for i = 1:numCluster
   for j = 1:numClass
       indsum = sum(indx==labels(i));
       annosum = sum(anno==j);
       acr(i,j) = sum(indx==labels(i)&anno==j)/indsum;
       prc(j,i) = sum(indx==labels(i)&anno==j)/annosum;
   end
end

acr(isnan(acr)) = 0;
prc(isnan(prc)) = 0;

end