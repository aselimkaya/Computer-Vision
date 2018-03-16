v=VideoReader('example.mp4');

eps = 0.001;
count = 1;
images = {};

while hasFrame(v)
    if abs(v.CurrentTime-1) < eps
        break;
    end
    vidFrame = readFrame(v);
    I = rgb2gray(vidFrame);
    images{count} = I;
    
    if count == 1
        points = detectSURFFeatures(I);
        [features, ~] = extractFeatures(I, points);
        [row,~] = size(features);
        start = row;
        
        for i=1:row
            leafPoint = SP();
            leafPoint.point = features(i,:);
            leafPoint.frameIndex = count;
            leafPointMatrix(i) = leafPoint;
        end
        count = count+1;
        continue;
    end
    
    newPoints = detectSURFFeatures(I);
    [newFeatures, ~] = extractFeatures(I, newPoints);
    points = cat(2,points,newPoints);
    features = [features; newFeatures];
    [row,~] = size(newFeatures);
    finish = row + start;
    
    for i=start:finish
        leafPoint = SP();
        leafPoint.point = features(i,:);
        leafPoint.frameIndex = count;
        leafPointMatrix(i) = leafPoint;
    end
    
    start = finish;
    
    count = count+1;
    
end

%% Root centroid secildi.
[~, rootLocation] = kmeans(features, 1);
root = Centroid();
root.location = rootLocation;
%% Diger centroidler hesaplaniyor.
k=2;
[idx, centroidLocations] = kmeans(features, k);
rootChilds = buildTree(features,k,1);

%% Yeni bir videodan bir frame seciliyor.
v=VideoReader('example.mp4');

eps = 0.001;
count = 1;
frameSelected = 15;

while hasFrame(v)
    if abs(v.CurrentTime-1) < eps
        break;
    end
    vidFrame = readFrame(v);
    
    if(frameSelected == count)
        testFrame = rgb2gray(vidFrame);
        %testFrame = testFrame(1:250,1:250);
        newPoints = detectSURFFeatures(testFrame);
        [testFeatures, ~] = extractFeatures(I, newPoints);
        count = count+1;
    end
    
    count = count +1;
end

imshow(testFrame);
figure;

[row,col] = size(testFeatures);
votingMatrix = zeros(size(images));

for i=1:row
    ind = traverseAndVote(testFeatures(i,:), k, rootChilds,leafPointMatrix,votingMatrix);
    votingMatrix(ind) = votingMatrix(ind)+1;
end

[~,imIndex] = max(votingMatrix);
votingMatrix(imIndex) = -1;
imshow(images{imIndex});

figure;
[~,imIndex] = max(votingMatrix);
votingMatrix(imIndex) = -1;
imshow(images{imIndex});

figure;
[~,imIndex] = max(votingMatrix);
votingMatrix(imIndex) = -1;
imshow(images{imIndex});





