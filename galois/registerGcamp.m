% run registration and segmentation

%% set parameters
%fileIndx = 202:253;
fileIndx = 248:253;
timeStep = 100;
filepath = '/home/sh3276/work/data/';
savepath = '/home/sh3276/work/results/register_param/';
% filepath = 'E:\Data\g6s_indv\leica\';
% savepath = 'E:\Data\register_param\mask\';

%% registration and segmentation
for i = 1:length(fileIndx)
    
    % current file
    movieParam = paramAll_galois(fileIndx(i));
%    movieParam = paramAll(fileIndx(i));
    fprintf('processing sample: %s\n', movieParam.fileName);    

    % registration
    [bw,bg] = gnMaskGcamp(movieParam,0);
    save([savepath '/mask/' movieParam.fileName '_mask.mat'],'bw','-v7.3');
    
    [bwReg,hydraOri,hydraCent,hydraLength] = registerMaskGcamp(movieParam,bw,timeStep);

    % save registration parameteres
    fprintf('saving...\n');
    save([savepath movieParam.fileName '_register_param.mat'],'timeStep',...
     'bwReg','hydraOri','hydraCent','hydraLength','-v7.3');

end
