function [frameIndex] = findFrame(leafPoints,featurePoint)
[~,col] = size(leafPoints);
count = 1;

for i=1:col
    if leafPoints(i).point == featurePoint 
        frameIndex(count) = leafPoints(i).frameIndex;
        count = count+1;
    end
end

end

