function [childs] = buildTree(features,k,level, maxDepth)
childs = {};

if level == maxDepth || k > size(features, 1)
   childs = features;
   return; 
end

[idx, centroidLocations] = kmeans(features, k);
pointsToBeSorted = [idx features];
[~,srtIndx] = sort(pointsToBeSorted(:,1)); % sort just the first column
sortedPoints = pointsToBeSorted(srtIndx,:);% sort the whole matrix using the sort indices

for i=1:k
    c = Centroid();
    c.location = centroidLocations(i,:);
    pMatrix = sortedPoints(sortedPoints(:,1)==i,:);
    pMatrix(:,1) = [];    
    c.childList = buildTree(pMatrix,k,level+1, maxDepth);
    childs{i} = c;
end

return;

end

