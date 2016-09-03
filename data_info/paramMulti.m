function [movieParamMulti] = paramMulti(fileInd)

%t_step = 1;
numSample = length(fileInd);
movieParamMulti = cell(numSample,1);

for i = 1:length(fileInd)
    
    movieParamMulti{i} = paramAll(fileInd(i));
    
    %movieParam{i} = struct;
    %[movieParam{i}.filenameImages,movieParam{i}.filenameBasis,numImages] = fileinfo(fileInd(i));
    %movieParam{i}.frameStart = 0; %number of first image in movie
    %movieParam{i}.frameEnd = numImages-1; %number of last image in movie
    %movieParam{i}.digitNum = 4; %number of digits used for frame enumeration (1-4).
    %movieParam{i}.numImages = floor((movieParam{i}.frameEnd-movieParam{i}.frameStart+1)/t_step);

    % store tiff file names
    %movieParam{i}.enumString = repmat('0',movieParam{i}.numImages,movieParam{i}.digitNum);
    %formatString = ['%0' num2str(movieParam{i}.digitNum) 'i'];
    %for j = movieParam{i}.frameStart:t_step:movieParam{i}.frameEnd
    %    movieParam{i}.enumString(floor((j-movieParam{i}.frameStart)/t_step)+1,:) = num2str(j,formatString);
    %end

    % read the first image and get movie information
    %im1 = double(imread([movieParam{i}.filenameImages movieParam{i}.filenameBasis...
    %    movieParam{i}.enumString(1,:) '.tif']));
    %movieParam{i}.imageSize = size(im1);
    
end

end