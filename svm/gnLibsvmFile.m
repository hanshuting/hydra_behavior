function [] = gnLibsvmFile(label,data,filename)
% generate dataset for libsvm: <label> <index>:<value> ...
% SYNOPSIS:
%     gnLibsvmFile(label,data,filename)
% INPUT:
%     label: vector with training label
%     data: training data matrix
%     filename: full path and name of the output file
% 
% Shuting Han, 2015

dims = size(data);

fileID = fopen(filename,'w');
for i = 1:dims(1)
    fprintf(fileID,'%u\t',label(i));
    for j = 1:dims(2)
        fprintf(fileID,'%u:%f\t',j,data(i,j));
    end
    fprintf(fileID,'\n');
end

fclose(fileID);

end