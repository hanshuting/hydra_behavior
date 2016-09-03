% run registration and segmentation

%% set parameters
fileIndx = [1:5,7:11,13:24,26:28,30:34];
%fileIndx = 301:324;
% fileIndx = 202:222;
timeStep = 25;
filepath = '/home/sh3276/work/data/';
savepath = '/home/sh3276/work/results/register_param/';


%% registration and segmentation
for i = 1:length(fileIndx)
    
    % current file
    movieParam = paramAll_galois(fileIndx(i));
    fprintf('processing sample: %s\n', movieParam.fileName);    

    % segmentation
    [bw,bg] = gnMask(movieParam,0);
    save([savepath 'mask/' movieParam.fileName '_mask.mat'],'bw','-v7.3');
    
    % registration
    [bwReg,hydraOri,hydraCent,hydraLength] = registerMask(movieParam,bw,timeStep);
    save([savepath movieParam.fileName '_register_param.mat'],'timeStep',...
    'bwReg','hydraOri','hydraCent','hydraLength','-v7.3');

end
