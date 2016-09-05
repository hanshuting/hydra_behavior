function [T] = imtranslateHST(im,vec)

dims = size(im);
vec = round(vec);

T = zeros(dims);

if vec(2)<0 && vec(1)<0
    T(1:dims(1)+vec(2),1:dims(2)+vec(1)) = im(-vec(2)+1:dims(1),-vec(1)+1:dims(2));
elseif vec(2)>=0 && vec(1)<0
    T(vec(2)+1:dims(1),1:dims(2)+vec(1)) = im(1:dims(1)-vec(2),-vec(1)+1:dims(2));
elseif vec(2)<0 && vec(1)>=0
    T(1:dims(1)+vec(2),vec(1)+1:dims(2)) = im(-vec(2)+1:dims(1),1:dims(2)-vec(1));
else
    T(vec(2)+1:dims(1),vec(1)+1:dims(2)) = im(1:dims(1)-vec(2),1:dims(2)-vec(1));
end


end