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
        for i=1:10
            sacmaPoint = SP();
            sacmaPoint.point = points(i);
            sacmaPoint.frameIndex = count;
            arr(i) = sacmaPoint;
        end
        
        count = count+1;
        continue;
    end
    
    newPoints = detectSURFFeatures(I);
    newPoints = selectStrongest(newPoints,10);
    points = cat(2,points,newPoints);
    
    for i=((count-1)*10+1):count*10
        sacmaPoint = SP();
        sacmaPoint.point = points(i);
        sacmaPoint.frameIndex = count;
        arr(i) = sacmaPoint;
    end
    count = count+1;
    
end
%asd(1,:) = arr.point(:);
asd = {arr.point};

pointsMatrix = points.Location;

scatter(pointsMatrix(:,1), pointsMatrix(:,2));
hold on;
n=3;
[idx, C] = kmeans(pointsMatrix, n);