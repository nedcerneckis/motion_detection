clear variables;
close all;

video1 = '~/Documents/MATLAB/videos/Video1.mp4';
videoReader1 = VideoReader(video1);

hs = 5;
h_average = fspecial('average', [hs hs]);
framel = readFrame(videoReader1);

videoPlayer1 = vision.VideoPlayer('Name', 'Input_Image', 'Position', [100, 200, 500, 500]);
videoPlayer2 = vision.VideoPlayer('Name', 'Input_Image', 'Position', [1000, 200, 500, 500]);

previous_frame = readFrame(videoReader1);
th = 30;
[My, Nx, Sz] = size(previous_frame);
previous_r_pad = conv2(h_average, previous_frame(:,:,1));
previous_g_pad = conv2(h_average, previous_frame(:,:,2));
previous_b_pad = conv2(h_average, previous_frame(:,:,3));
previous_r = previous_r_pad((hs+1)/2 : My+(hs-1)/2, (hs+1)/2:Nx+(hs-1)/2);
previous_g = previous_g_pad((hs+1)/2 : My+(hs-1)/2, (hs+1)/2:Nx+(hs-1)/2);
previous_b = previous_b_pad((hs+1)/2 : My+(hs-1)/2, (hs+1)/2:Nx+(hs-1)/2);

set(0,'showHiddenHandles','on')
fig_handle = gcf ;  
fig_handle.findobj % to view all the linked objects with the vision.VideoPlayer
ftw = fig_handle.findobj ('TooltipString', 'Maintain fit to window');   % this will search the object in the figure which has the respective 'TooltipString' parameter.
ftw.ClickedCallback()  % execute the callback linked with this object

i = 1;
while hasFrame(videoReader1)
    BGI = zeros(My, Nx);

    current_frame = readFrame(videoReader1);
    current_r_pad = conv2(h_average, current_frame(:,:,1));
    current_g_pad = conv2(h_average, current_frame(:,:,2));
    current_b_pad = conv2(h_average, current_frame(:,:,3));
    current_r = current_r_pad((hs+1)/2 : My+(hs-1)/2, (hs+1)/2:Nx+(hs-1)/2);
    current_g = current_g_pad((hs+1)/2 : My+(hs-1)/2, (hs+1)/2:Nx+(hs-1)/2);
    current_b = current_b_pad((hs+1)/2 : My+(hs-1)/2, (hs+1)/2:Nx+(hs-1)/2);

    C1 = abs(current_r - previous_r);
    C2 = abs(current_g - previous_g);
    C3 = abs(current_b - previous_b);

    Cabs12 = max(C1, C2);
    Cabs = max(Cabs12, C3);
    Cmax = uint8(Cabs);

    BGI(Cmax>th)=1;
    BGI=uint8(BGI);

    previous_frame = current_frame;
    previous_frame(:,:,1) = BGI .* current_frame(:,:,1);
    previous_frame(:,:,2) = BGI .* current_frame(:,:,2);
    previous_frame(:,:,3) = BGI .* current_frame(:,:,3);

    if(mod(i, 50) == 0)
        previous_r_pad = conv2(h_average, previous_frame(:,:,1));
        previous_g_pad = conv2(h_average, previous_frame(:,:,2));
        previous_b_pad = conv2(h_average, previous_frame(:,:,3));
        previous_r = previous_r_pad((hs+1)/2 : My+(hs-1)/2, (hs+1)/2:Nx+(hs-1)/2);
        previous_g = previous_g_pad((hs+1)/2 : My+(hs-1)/2, (hs+1)/2:Nx+(hs-1)/2);
        previous_b = previous_b_pad((hs+1)/2 : My+(hs-1)/2, (hs+1)/2:Nx+(hs-1)/2);
    end
   % videoPlayer1(current_frame);
    videoPlayer2(previous_frame);
    i = i + 1;
    pause(1/videoReader1.FrameRate);
end