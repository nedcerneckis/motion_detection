clear variables;
close all;

video1 = '../videos/Video1.mp4';
videoReader1 = VideoReader(video1);

hs = 5;
h_average = fspecial('average', [hs hs]);
framel = readFrame(videoReader1);

videoPlayer1 = vision.VideoPlayer('Name', 'Input_Image', 'Position', [100, 200, 500, 500]);
videoPlayer2 = vision.VideoPlayer('Name', 'Input_Image', 'Position', [1000, 200, 500, 500]);

th = 20;
frame1 = readFrame(videoReader1);
[My, Nx, Sz] = size(frame1);

bg_r_pad = conv2(h_average, frame1(:,:,1));
bg_g_pad = conv2(h_average, frame1(:,:,2));
bg_b_pad = conv2(h_average, frame1(:,:,3));
bg_r = bg_r_pad((hs+1)/2 : My+(hs-1)/2, (hs+1)/2 : Nx+(hs-1)/2);
bg_g = bg_g_pad((hs+1)/2 : My+(hs-1)/2, (hs+1)/2 : Nx+(hs-1)/2);
bg_b = bg_b_pad((hs+1)/2 : My+(hs-1)/2, (hs+1)/2 : Nx+(hs-1)/2);

BGI = zeros(My, Nx);
while hasFrame(videoReader1)
    BGI = zeros(My, Nx);

    frame2 = readFrame(videoReader1);
    f_r_pad = conv2(h_average, frame2(:,:,1));
    f_g_pad = conv2(h_average, frame2(:,:,2));
    f_b_pad = conv2(h_average, frame2(:,:,3));
    f_r = f_r_pad((hs+1)/2 : My+(hs-1)/2, (hs+1)/2:Nx+(hs-1)/2);
    f_g = f_g_pad((hs+1)/2 : My+(hs-1)/2, (hs+1)/2:Nx+(hs-1)/2);
    f_b = f_b_pad((hs+1)/2 : My+(hs-1)/2, (hs+1)/2:Nx+(hs-1)/2);    

    C1 = abs(f_r - bg_r);
    C2 = abs(f_g - bg_g);
    C3 = abs(f_b - bg_b);

    Cabs12 = max(C1, C2);
    Cabs = max(Cabs12, C3);
    Cmax = uint8(Cabs);

    BGI(Cmax>th)=1;
    BGI=uint8(BGI);

    frame3 = frame2;
    frame3(:,:,1) = BGI .* frame2(:,:,1);
    frame3(:,:,2) = BGI .* frame2(:,:,2);
    frame3(:,:,3) = BGI .* frame2(:,:,3);

    videoPlayer1(frame2);
    videoPlayer2(frame3);
    pause(1/videoReader1.FrameRate);
end