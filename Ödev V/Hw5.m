v=VideoReader('cedi.mp4');

eps = 0.001;
count = 1;

while hasFrame(v)
    if abs(v.CurrentTime-2) < eps
        break;
    end
    vidFrame = readFrame(v);
    I = rgb2gray(vidFrame);
    
    if count == 1
        points = detectSURFFeatures(I);
        points = selectStrongest(points,10);
        [features, ~] = extractFeatures(I, points);
        
        for i=1:10
            sacmaPoint = SP();
            sacmaPoint.point = features(i);
            sacmaPoint.frameIndex = count;
            arr(i) = sacmaPoint;
        end
        
        count = count+1;
        continue;
    end
    
    newPoints = detectSURFFeatures(I);
    newPoints = selectStrongest(newPoints,30);
    [newFeatures, ~] = extractFeatures(I, newPoints);
    
    points = cat(2,points,newPoints);
    features = [features;newFeatures];
    
    for i=((count-1)*10+1):count*10
        sacmaPoint = SP();
        sacmaPoint.point = features(i);
        sacmaPoint.frameIndex = count;
        arr(i) = sacmaPoint;
    end
    
    count = count+1;
end

%% Root centroid secildi.
[~, rootLocation] = kmeans(features, 1);
root = Centroid();
root.location = rootLocation;
%% Diger centroidler hesaplaniyor.

k=3;
[idx, centroidLocations] = kmeans(features, k, );
rootChilds = buildTree(features,k,1);


% scatter(pointsMatrix(:,1), pointsMatrix(:,2));
% hold on;
% n=3;


