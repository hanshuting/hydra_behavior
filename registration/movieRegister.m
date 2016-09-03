function [reg] = movieRegister(movieParam)
% register video frame by frame

reg = zeros(movieParam.imageSize(1),movieParam.imageSize(2),movieParam.numImages);
[optimizer,metric] = imregconfig('multimodal');

optimizer.InitialRadius = 6.25e-4;
optimizer.Epsilon = 1e-7;
optimizer.GrowthFactor = 1.1;
optimizer.MaximumIterations = 300;

for i = 1:movieParam.numImages-1
    i
    moving = double(imread([movieParam.filenameImages movieParam.filenameBasis...
        movieParam.enumString(i,:) '.tif']));
    if i==1
        reg(:,:,i) = moving;
        fixed = moving;
    else
        tform = imregtform(moving,fixed,'translation',optimizer,metric);
        reg(:,:,i) =  imregister(moving,fixed,'rigid',optimizer,metric,...
            'initialtransformation',tform);
    end
end

end