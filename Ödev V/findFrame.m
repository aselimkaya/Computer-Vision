function [frameIndex] = findFrame(leafPoints,featurePoint)
[~,col] = size(leafPoints);
frameIndex = -1;

for i=1:col
    if leafPoints(i).point == featurePoint 
        frameIndex = leafPoints(i).frameIndex;
        break;
    end
end

end

