v=VideoReader('asd.mp4');
frameSelected = 135;
vidFrame = read(v, frameSelected);
testFrame = rgb2gray(vidFrame);
testFrame = testFrame(50:end,500:750);
imshow(testFrame);


% v=VideoReader('ex1.mp4');
% frameSelected = 2600;
% vidFrame = read(v, frameSelected);
% testFrame = rgb2gray(vidFrame);
% testFrame = testFrame(120:end,340:420);
