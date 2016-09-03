
fileind = 23;
indx = 1:178;
scriptsize = 50;
movieParam = paramAllBatchYeti(fileind,1,scriptsize);

savepath = ['/vega/brain/users/sh3276/results/flow_assembled/' movieParam.fileName '_flows_assembled_int16.mat'];
uu_all = int16(zeros(movieParam.imageSize(1),movieParam.imageSize(2),indx(end)*scriptsize));
vv_all = int16(zeros(movieParam.imageSize(1),movieParam.imageSize(2),indx(end)*scriptsize));

movieParam = paramAllYeti(fileind);
for ii = 1:length(indx)
    display(indx(ii));
    filepath = ['/vega/brain/users/sh3276/results/flows/' movieParam.fileName '_flows_int16_' num2str(indx(ii)) '.mat'];
    load(filepath);
    uu_all(:,:,(ii-1)*scriptsize+1:(ii-1)*scriptsize+size(uu,3)) = uu;
    vv_all(:,:,(ii-1)*scriptsize+1:(ii-1)*scriptsize+size(vv,3)) = vv;
end

uu_all = int16(uu_all);
vv_all = int16(vv_all);

save(savepath,'uu_all','vv_all','-v7.3');
display(savepath);
