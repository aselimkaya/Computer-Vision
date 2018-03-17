function [index] = findCentroid(point,pointList)
[~,col] = size(pointList);
distances = zeros(1,col);

for i=1:col
    x = point;
    y = pointList{i}.location;
    dist = 0;
    
    for j=1:64
        dist = dist + (x(j)-y(j))^2;
    end
    
    dist = sqrt(dist);
    distances(i) = dist;
end

[~,index] = min(distances);

end

