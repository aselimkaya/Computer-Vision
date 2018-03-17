function [frameIndex] = traverseAndVote(testFeature, k, nodeList, leafPointMatrix)
[row,col] = size(nodeList);   
    if row == 1 && col == k
        ind = findCentroid(testFeature,nodeList);
        frameIndex = traverseAndVote(testFeature, k, nodeList{ind}.childList, leafPointMatrix);        
    else
        leafFeatures = nodeList;      
        element = findLeaf(testFeature,leafFeatures);
        frameIndex = findFrame(leafPointMatrix,element);
    end
end