function [frameIndex] = traverseAndVote(testFeature, k, nodeList, leafPointMatrix, votingMatrix)
[row,col] = size(nodeList);   
    if row == 1 && col == k
        ind = findCentroid(testFeature,nodeList);
        frameIndex = traverseAndVote(testFeature, k, nodeList{ind}.childList, leafPointMatrix, votingMatrix);        
    else
        leafFeatures = nodeList; %34x64        
        element = findLeaf(testFeature,leafFeatures);
        frameIndex = findFrame(leafPointMatrix,element);
    end
end

