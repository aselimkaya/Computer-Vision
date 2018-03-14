function [out] = findNearestCentroid(point,centroids)
    loc = point.Location;
    x = loc(1);
    y = loc(2);
    
    c1 = centroids{1}.Location;
    c1x = c1(1);
    c1y = c1(2);

    c2 = centroids{2}.Location;
    c2x = c2(1);
    c2y = c2(2);

    c3 = centroids{3}.Location;
    c3x = c3(1);
    c3y = c3(2);

    
    distances = zeros(3,1);
    
    distances(1) = sqrt((c1x-x)^2+(c1y-y)^2);
    distances(2) = sqrt((c2x-x)^2+(c2y-y)^2);
    distances(3) = sqrt((c3x-x)^2+(c3y-y)^2);
    
    [~,ind] = min(distances);
    out = centroids{ind};
    
end

