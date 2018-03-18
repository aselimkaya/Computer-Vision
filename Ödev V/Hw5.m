warning off;
v=VideoReader('video.mp4');

images = {};

numberOfFrame = 110; %videonun ilk 110 frame'indeki feature lar extract edilecek.

numberOfChilds = 4;
maxDepth = 10;

for frameCount = 1:numberOfFrame
    
    vidFrame = read(v, frameCount);
    I = rgb2gray(vidFrame);
    images{frameCount} = I;
    
    if frameCount == 1
        points = detectSURFFeatures(I);
        [features, ~] = extractFeatures(I, points);
        [row,~] = size(features);
        start = row;
        
        for i=1:row
            leafPoint = SP();
            leafPoint.point = features(i,:);
            leafPoint.frameIndex = frameCount;
            leafPointMatrix(i) = leafPoint;
        end
        continue;
    end
    
    testPoints = detectSURFFeatures(I);
    [newFeatures, ~] = extractFeatures(I, testPoints);
    points = cat(2,points,testPoints);
    features = [features; newFeatures];
    [row,~] = size(newFeatures);
    finish = row + start;
    
    for i=start:finish
        leafPoint = SP();
        leafPoint.point = features(i,:);
        leafPoint.frameIndex = frameCount;
        leafPointMatrix(i) = leafPoint;
    end
    
    start = finish;
end

%% Baþlangýç centroidleri hesaplanýyor.

rootChilds = buildTree(features, numberOfChilds, 1, maxDepth);

%% Test için videodan bir frame seçiliyor.
v=VideoReader('testVideo.mp4');
frameSelected = 135;
vidFrame = read(v, frameSelected);
testFrame = rgb2gray(vidFrame);
testFrame = testFrame(50:end,500:750);
imshow(testFrame);


testPoints = detectSURFFeatures(testFrame);
[testFeatures, ~] = extractFeatures(I, testPoints);

[row,col] = size(testFeatures);
votingMatrix = zeros(size(images));

for i=1:row
    ind = traverseAndVote(testFeatures(i,:), numberOfChilds, rootChilds,leafPointMatrix);
    [row2,col2] = size(ind);
    for j=1:col2    
        votingMatrix(ind(j)) = votingMatrix(ind(j))+1;
    end
end

maxVotes = zeros(1,3);

%% Test Frame
imshow(testFrame);
figure;

%% Test Frame'ine en çok benzerlik gösteren frame'ler
[maxVal,imIndex] = max(votingMatrix);
maxVotes(1,1) = maxVal;
votingMatrix(imIndex) = -1;
imshow(images{imIndex});

figure;
[maxVal,imIndex] = max(votingMatrix);
maxVotes(1,2) = maxVal;
votingMatrix(imIndex) = -1;
imshow(images{imIndex});

figure;
[maxVal,imIndex] = max(votingMatrix);
maxVotes(1,3) = maxVal;
votingMatrix(imIndex) = -1;
imshow(images{imIndex});