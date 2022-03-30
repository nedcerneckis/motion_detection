clear variables;
close all;
vid = '~/Documents/MATLAB/videos/Video1.mp4';

videoReader1 = VideoReader(vid);
videoPlayer1 = vision.VideoPlayer('Name', 'Original Video', 'Position', [100, 200, 500, 500]);
videoPlayer2 = vision.VideoPlayer('Name', 'Smoothed video, average (th=30, hs=5)', 'Position', [1000, 200, 500, 500]);

hs = 5;
th = 30;
h_average = fspecial('average', [hs hs]);
previous_frame = readFrame(videoReader1);
[My, Nx, Sz] = size(previous_frame);

previous_frame_r_pad = conv2(h_average, previous_frame(:,:,1));
previous_frame_g_pad = conv2(h_average, previous_frame(:,:,2));
previous_frame_b_pad = conv2(h_average, previous_frame(:,:,3));
previous_frame_r = previous_frame_r_pad((hs+1)/2 : My+(hs-1)/2, (hs+1)/2:Nx+(hs-1)/2);
previous_frame_g = previous_frame_g_pad((hs+1)/2 : My+(hs-1)/2, (hs+1)/2:Nx+(hs-1)/2);
previous_frame_b = previous_frame_b_pad((hs+1)/2 : My+(hs-1)/2, (hs+1)/2:Nx+(hs-1)/2);

i = 1;
while hasFrame(videoReader1)
    BGI=zeros(My,Nx);
   
    current_frame = readFrame(videoReader1);
    current_frame_r_pad = conv2(h_average, current_frame(:,:,1));
    current_frame_g_pad = conv2(h_average, current_frame(:,:,2));
    current_frame_b_pad = conv2(h_average, current_frame(:,:,3));
    current_frame_r = current_frame_r_pad((hs+1)/2 : My+(hs-1)/2, (hs+1)/2:Nx+(hs-1)/2);
    current_frame_g = current_frame_g_pad((hs+1)/2 : My+(hs-1)/2, (hs+1)/2:Nx+(hs-1)/2);
    current_frame_b = current_frame_b_pad((hs+1)/2 : My+(hs-1)/2, (hs+1)/2:Nx+(hs-1)/2);

    C1=abs(current_frame_r-previous_frame_r);
    C2=abs(current_frame_g-previous_frame_g);
    C3=abs(current_frame_b-previous_frame_b);

    Cmax=uint8(max(max(C1,C2),C3));

    BGI(Cmax>th)=255;
    BGI=uint8(BGI);

    previous_frame = current_frame;
    previous_frame_r_pad = conv2(h_average, current_frame(:,:,1));
    previous_frame_g_pad = conv2(h_average, current_frame(:,:,2));
    previous_frame_b_pad = conv2(h_average, current_frame(:,:,3));
    previous_frame_r = current_frame_r_pad((hs+1)/2 : My+(hs-1)/2, (hs+1)/2:Nx+(hs-1)/2);
    previous_frame_g = current_frame_g_pad((hs+1)/2 : My+(hs-1)/2, (hs+1)/2:Nx+(hs-1)/2);
    previous_frame_b = current_frame_b_pad((hs+1)/2 : My+(hs-1)/2, (hs+1)/2:Nx+(hs-1)/2);

    i = i + 1;
    videoPlayer1(current_frame);
    videoPlayer2(BGI);
    pause(1/videoReader1.FrameRate);
end