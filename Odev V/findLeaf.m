function [element] = findLeaf(testFeature,leafFeatures)
[row,~] = size(leafFeatures);
distances = zeros(row,1);

for i=1:row
    x = testFeature;
    y = leafFeatures(i,:);
    dist = 0;   
    
    for j=1:64
        dist = dist + (x(j)-y(j))^2;
    end
    
    dist = sqrt(dist);
    distances(i) = dist;
end

[~,index] = min(distances);
element = leafFeatures(index,:);

end
