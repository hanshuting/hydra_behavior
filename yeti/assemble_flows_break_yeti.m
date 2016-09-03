function [] = assemble_flows_break_yeti(arrayID)

fileind = 200;
scriptsize = 100;
step = 1;
%indx = (arrayID-1)*scriptsize+1:arrayID*scriptsize;
indx = 1000+(arrayID-10-1)*50+1:1000+(arrayID-10)*50;
movieParam = paramAll_yeti_batch2(fileind,1,step);
savename = ['/vega/brain/users/sh3276/results/flows_assembled/' ...
    movieParam.filenameBasis 'flows_assembled_step_' num2str(step)...
    '_' num2str(arrayID) '.mat'];
uu_all = zeros(movieParam.imageSize(1),movieParam.imageSize(2),...
    length(scriptsize)*scriptsize);
vv_all = zeros(movieParam.imageSize(1),movieParam.imageSize(2),...
    length(scriptsize)*scriptsize);
for ii = 1:length(indx)
    display(indx(ii));
    movieParam = paramAll_yeti_batch2(fileind,1,step);
    filepath = ['/vega/brain/users/sh3276/results/flows/' movieParam.filenameBasis...
        'flows_' num2str(indx(ii)) '_step_' num2str(step) '.mat'];
    load(filepath);
    uu_all(:,:,(ii-1)*scriptsize+1:ii*scriptsize) = uu;
    vv_all(:,:,(ii-1)*scriptsize+1:ii*scriptsize) = vv;
end

uu_all = single(uu_all);
vv_all = single(vv_all);

save(savename,'uu_all','vv_all','-v7.3');
display(savename);

end
