function [frame_r, frame_g, frame_b] = apply_frame_filter(frame, filter, hs)
    [My, Nx, Sz] = size(frame);
    frame_r_pad = conv2(filter, frame(:,:,1));
    frame_g_pad = conv2(filter, frame(:,:,2));
    frame_b_pad = conv2(filter, frame(:,:,3));
    frame_r = frame_r_pad((hs+1)/2 : My+(hs-1)/2, (hs+1)/2:Nx+(hs-1)/2);
    frame_g = frame_g_pad((hs+1)/2 : My+(hs-1)/2, (hs+1)/2:Nx+(hs-1)/2);
    frame_b = frame_b_pad((hs+1)/2 : My+(hs-1)/2, (hs+1)/2:Nx+(hs-1)/2);
end