% script for assembling optical flow results

% parameters
fileind = 19;
indx = 1:162;
scriptsize = 50;
movieParam = paramAll(fileind);
filepath = 'C:\Shuting\Data\yeti\flows\raw\20130813_6\';
savepath = 'C:\Shuting\Data\yeti\flows\flows_int16_1000\';

% initialize
uu_all = int16(zeros(movieParam.imageSize(1),movieParam.imageSize(2),movieParam.numImages));
vv_all = int16(zeros(movieParam.imageSize(1),movieParam.imageSize(2),movieParam.numImages));

for ii = 1:length(indx)

    fprintf('processing file %u\n',indx(ii));
    
    % read files
    load([filepath movieParam.fileName '_flows_int16_' num2str(indx(ii)) '.mat']);
    
    % store results
    uu_all(:,:,(ii-1)*scriptsize+1:(ii-1)*scriptsize+size(uu,3)) = int16(uu);
    vv_all(:,:,(ii-1)*scriptsize+1:(ii-1)*scriptsize+size(vv,3)) = int16(vv);

end

save([savepath movieParam.fileName '_flows_assembled_int16.mat'],'uu_all','vv_all','-v7.3');
