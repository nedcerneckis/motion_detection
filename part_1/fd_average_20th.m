clear variables;
close all;
vid = '~/Documents/MATLAB/videos/Video1.mp4';

videoReader1 = VideoReader(vid);
videoPlayer1 = vision.VideoPlayer('Name', 'Original Video', 'Position', [100, 200, 500, 500]);
videoPlayer2 = vision.VideoPlayer('Name', 'Smoothed video, average (th=20)', 'Position', [1000, 200, 500, 500]);

th = 20;
previous_frame = readFrame(videoReader1);
previous_frame_r = previous_frame(:,:,1);
previous_frame_g = previous_frame(:,:,2);
previous_frame_b = previous_frame(:,:,3);
[My, Nx, Sz] = size(previous_frame);

i = 1;
while hasFrame(videoReader1)
    BGI=zeros(My,Nx);
   
    current_frame = readFrame(videoReader1);
    current_frame_r = current_frame(:,:,1);
    current_frame_g = current_frame(:,:,2);
    current_frame_b = current_frame(:,:,3);

    C1=abs(current_frame_r-previous_frame_r);
    C2=abs(current_frame_g-previous_frame_g);
    C3=abs(current_frame_b-previous_frame_b);

    Cmax=uint8(max(max(C1,C2),C3));

    BGI(Cmax>th)=255;
    BGI=uint8(BGI);

    previous_frame = current_frame;
    previous_frame_r = current_frame(:,:,1);
    previous_frame_g = current_frame(:,:,2);
    previous_frame_b = current_frame(:,:,3);
    
    i = i + 1;
    videoPlayer1(current_frame);
    videoPlayer2(BGI);
    pause(1/videoReader1.FrameRate);
end