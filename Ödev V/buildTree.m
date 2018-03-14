function [out] = buildTree(pointsMatrix,n,parent,level)

if level == 4
   out = parent;
   return; 
end

[idx, centroidLocations] = kmeans(pointsMatrix, n);
pointsToBeSorted = [idx pointsMatrix];
[~,srtIndx] = sort(pointsToBeSorted(:,1,1)); % sort just the first column
sortedPoints = pointsToBeSorted(srtIndx,:,:);   % sort the whole matrix using the sort indices

for i=1:n
    c = Centroid();
    c.location = centroidLocations(i,:);
    c.parent = parent;
    parent.childList = [parent.childList c];
    pMatrix = sortedPoints(sortedPoints(:,1)==i,:,:);
    pMatrix(:,1) = [];
    c = buildTree(pMatrix,n,c,level+1);
end

out = parent;

end

