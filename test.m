vid = '~/Documents/MATLAB/videos/Video1.mp4';

videoReader1 = VideoReader(vid);
videoPlayer1 = vision.VideoPlayer('Name', 'Input_Image', 'Position', [100, 200, 500, 500]);
videoPlayer2 = vision.VideoPlayer('Name', 'Input_Image', 'Position', [1000, 200, 500, 500]);

hs = 3;
th = 25;
h_average = fspecial('average', [hs hs]);
frame1 = readFrame(videoReader1);
[My, Nx, Sz] = size(frame1);
bg_r_pad = conv2(h_average, frame1(:,:,1));
bg_g_pad = conv2(h_average, frame1(:,:,2));
bg_b_pad = conv2(h_average, frame1(:,:,3));
bg_r = bg_r_pad((hs+1)/2 : My+(hs-1)/2, (hs+1)/2 : Nx+(hs-1)/2);
bg_g = bg_g_pad((hs+1)/2 : My+(hs-1)/2, (hs+1)/2 : Nx+(hs-1)/2);
bg_b = bg_b_pad((hs+1)/2 : My+(hs-1)/2, (hs+1)/2 : Nx+(hs-1)/2);

i = 1;
while hasFrame(videoReader1)
    BGI=zeros(My,Nx);
   
    frame2 = readFrame(videoReader1);
    fr_r_pad = conv2(h_average, frame2(:,:,1));
    fr_g_pad = conv2(h_average, frame2(:,:,2));
    fr_b_pad = conv2(h_average, frame2(:,:,3));
    fr_r = fr_r_pad((hs+1)/2 : My+(hs-1)/2, (hs+1)/2 : Nx+(hs-1)/2);
    fr_g = fr_g_pad((hs+1)/2 : My+(hs-1)/2, (hs+1)/2 : Nx+(hs-1)/2);
    fr_b = fr_b_pad((hs+1)/2 : My+(hs-1)/2, (hs+1)/2 : Nx+(hs-1)/2);

    C1=abs(fr_r-bg_r);
    C2=abs(fr_g-bg_g);
    C3=abs(fr_b-bg_b);

    Cmax=uint8(max(max(C1,C2),C3));

    BGI(Cmax>th)=255;
    BGI=uint8(BGI);

    bg_r_pad = conv2(h_average, frame2(:,:,1));
    bg_g_pad = conv2(h_average, frame2(:,:,2));
    bg_b_pad = conv2(h_average, frame2(:,:,3));
    bg_r = bg_r_pad((hs+1)/2 : My+(hs-1)/2, (hs+1)/2 : Nx+(hs-1)/2);
    bg_g = bg_g_pad((hs+1)/2 : My+(hs-1)/2, (hs+1)/2 : Nx+(hs-1)/2);
    bg_b = bg_b_pad((hs+1)/2 : My+(hs-1)/2, (hs+1)/2 : Nx+(hs-1)/2);

    i = i + 1;
    videoPlayer1(frame2);
    videoPlayer2(BGI);
    pause(1/videoReader1.FrameRate);
end
