filepath = 'C:\Shuting\Data\results\DT_demo_video\';
filename = 'tentacle_sway_20151107_2_5s_0.5_0043';

v = VideoReader([filepath filename '.webm']);
vidWidth = v.Width;
vidHeight = v.Height;

k = 1;
mov = struct('cdata',zeros(vidHeight,vidWidth,3,'uint8'),'colormap',[]);
while hasFrame(v)
    mov(k).cdata = readFrame(v);
    k = k+1;
end

% writerobj = VideoWriter(['C:\Users\shuting\Desktop\temp\outputs\' ...
%     filename '.avi']);
writerobj = VideoWriter([filepath filename '.avi']);
open(writerobj);

hf = figure;set(hf,'color','w');
for i = 1:length(mov)
        imshow(mov(i).cdata);
        pause(0.01);
        F = getframe(hf);
        writeVideo(writerobj,F);
end
close(writerobj);
close(hf);