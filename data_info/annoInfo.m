function [annostr,numClass] = annoInfo(annoType,num)

switch annoType
    % annotation version 1
    case 1
        numClass = 9;
        if num==1
            annostr = 'silent';
        elseif num==2
            annostr = 'elongation';
        elseif num==3
            annostr = 'tentacle sway';
        elseif num==4
            annostr = 'body sway';
        elseif num==5
            annostr = 'bending';
        elseif num==6
            annostr = 'contraction';
        elseif num==7
            annostr = 'single tentacle contraction';
        elseif num==8
            annostr = 'somersaulting';
        elseif num==9
            annostr = 'feeding';
        else
            warning('unrecognized annotation label!');
        end
    % annotation version 2
    case 2
        numClass = 9;
        if num==1
            annostr = 'silent';
        elseif num==2
            annostr = 'elongation';
        elseif num==3
            annostr = 'tentacle sway';
        elseif num==4
            annostr = 'body sway';
        elseif num==5
            annostr = 'bending';
        elseif num==6
            annostr = 'contraction';
        elseif num==7
            annostr = 'single tentacle contraction';
        elseif num==8
            annostr = 'somersaulting';
        elseif num==9
            annostr = 'feeding';
        else
            warning('unrecognized annotation label!');
        end
    % annotation version 3
    case 3
        numClass = 8;
        if num==1
            annostr = 'silent';
        elseif num==2
            annostr = 'elongation';
        elseif num==3
            annostr = 'tentacle sway';
        elseif num==4
            annostr = 'body sway';
        elseif num==5
            annostr = 'bending';
        elseif num==6
            annostr = 'contraction';
        elseif num==7
            annostr = 'somersaulting';
        elseif num==8
            annostr = 'feeding';
        else
            warning('unrecognized annotation label!');
        end
    % annotation version 4
    case 4
        numClass = 12;
        if num==1
            annostr = 'silent';
        elseif num==2
            annostr = 'elongation';
        elseif num==3
            annostr = 'tentacle sway';
        elseif num==4
            annostr = 'body sway';
        elseif num==5
            annostr = 'bending';
        elseif num==6
            annostr = 'contraction';
        elseif num==7
            annostr = 'somersaulting 15';
        elseif num==8
            annostr = 'somersaulting 3';
        elseif num==9
            annostr = 'somersaulting 24';
        elseif num==10
            annostr = 'feeding 1';
        elseif num==11
            annostr = 'feeding 2';
        elseif num==12
            annostr = 'feeding 3';
        else
            warning('unrecognized annotation label!');
        end
    % annotation version 5: low level behavior only
    case 5
        numClass = 7;
        if num==1
            annostr = 'silent';
        elseif num==2
            annostr = 'elongation';
        elseif num==3
            annostr = 'tentacle sway';
        elseif num==4
            annostr = 'body sway';
        elseif num==5
            annostr = 'bending';
        elseif num==6
            annostr = 'contraction';
        elseif num==7
            annostr = 'feeding';
        else
            warning('unrecognized annotation label!');
        end
    % low level with detailed feeding and ss stage 24 only
    case 6
        numClass = 10;
        if num==1
            annostr = 'silent';
        elseif num==2
            annostr = 'elongation';
        elseif num==3
            annostr = 'tentacle sway';
        elseif num==4
            annostr = 'body sway';
        elseif num==5
            annostr = 'bending';
        elseif num==6
            annostr = 'contraction';
        elseif num==7
            annostr = 'somersaulting 24';
        elseif num==8
            annostr = 'feeding 1';
        elseif num==9
            annostr = 'feeding 2';
        elseif num==10
            annostr = 'feeding 3';
        else
            warning('unrecognized annotation label!');
        end
    case 11
        numClass = 9;
        if num==1
            annostr = 'silent';
        elseif num==2
            annostr = 'elongation';
        elseif num==3
            annostr = 'tentacle sway';
        elseif num==4
            annostr = 'body sway';
        elseif num==5
            annostr = 'bending';
        elseif num==6
            annostr = 'contraction';
        elseif num==7
            annostr = 'feeding 1';
        elseif num==8
            annostr = 'feeding 2';
        elseif num==9
            annostr = 'feeding 3';
        else
            warning('unrecognized annotation label!');
        end
    case 12
        numClass = 6;
        if num==1
            annostr = 'silent';
        elseif num==2
            annostr = 'elongation';
        elseif num==3
            annostr = 'tentacle sway';
        elseif num==4
            annostr = 'body sway';
        elseif num==5
            annostr = 'bending';
        elseif num==6
            annostr = 'contraction';
        else
            warning('unrecognized annotation label!');
        end
    otherwise
        error('unrecognized annotation type');
end

end