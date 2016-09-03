function [smxx,smyy] = smoothTraj(xx,yy)

% this function smoothes the given trajectory

nt = length(xx);
smxx = xx;
smyy = yy;

for i = 2:nt-1
    smxx(i) = (xx(i-1)+xx(i)+xx(i)+xx(i+1))/4;
    smyy(i) = (yy(i-1)+yy(i)+yy(i)+yy(i+1))/4;
end

end