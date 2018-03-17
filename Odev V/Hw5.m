warning off;
v=VideoReader('cedi.mp4');

images = {};

numberOfFrame = 10;

numberOfChilds = 2;
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

%% Ba�lang�� centroidleri hesaplan�yor.

rootChilds = buildTree(features, numberOfChilds, 1, maxDepth);

%% Test i�in videodan bir frame se�iliyor.
v=VideoReader('cedi.mp4');

frameSelected = 5;

vidFrame = read(v, frameSelected);

testFrame = rgb2gray(vidFrame);
%testFrame = testFrame(1:250,1:250);
testPoints = detectSURFFeatures(testFrame);
[testFeatures, ~] = extractFeatures(I, testPoints);

[row,col] = size(testFeatures);
votingMatrix = zeros(size(images));

for i=1:row
    ind = traverseAndVote(testFeatures(i,:), k, rootChilds,leafPointMatrix);
    votingMatrix(ind) = votingMatrix(ind)+1;
end

maxVotes = zeros(1,3);

%% Test Frame
imshow(testFrame);
figure;

%% Test Frame'ine en �ok benzerlik g�steren frame'ler
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