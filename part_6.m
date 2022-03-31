clear variables;
close all;

vid = '~/Documents/MATLAB/videos/Video2.mp4';
videoPlayer1 = vision.VideoPlayer('Name', 'Original Video', 'Position', [100, 200, 500, 500]); 
videoPlayer2 = vision.VideoPlayer('Name', 'Background subtraction video', 'Position', [1000, 200, 500, 500]);
videoReader = VideoReader(vid);
foregroundDetector = vision.ForegroundDetector('NumGaussians', 4, 'NumTrainingFrames', 100);
se = strel('square', 5);

while hasFrame(videoReader)
    current_frame = readFrame(videoReader);
    BGI_logical = step(foregroundDetector, current_frame);
    f_frame = imopen(BGI_logical, se);
    BGI = uint8(f_frame);

    processed_frame(:,:,1) = BGI .* current_frame(:,:,1);
    processed_frame(:,:,2) = BGI .* current_frame(:,:,2);
    processed_frame(:,:,3) = BGI .* current_frame(:,:,3);
    
    videoPlayer1(current_frame);
    videoPlayer2(processed_frame);
    pause(1/videoReader.FrameRate);
end