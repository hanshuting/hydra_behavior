function [annoAll] = mergeAnno(annoRaw,mergetype)
% mergeAnno(annoRaw,mergetype)

annoAll = zeros(size(annoRaw));
switch mergetype
    case 0
        return;
    % annotation version 1
    case 1
        annoAll(annoRaw==10|annoRaw==11|annoRaw==12|annoRaw==13|annoRaw==14) = 1; % silent
        annoAll(annoRaw==21|annoRaw==22|annoRaw==23|annoRaw==25|annoRaw==24) = 2; % elongation
        annoAll(annoRaw==31|annoRaw==32|annoRaw==53|annoRaw==55) = 3; % tentacle sway
        annoAll(annoRaw==51|annoRaw==54|annoRaw==52|annoRaw==56) = 4; % body sway and stand up
        annoAll(annoRaw==41|annoRaw==42) = 5; % bending
        annoAll(annoRaw==61|annoRaw==65|annoRaw==66|annoRaw==63|annoRaw==64) = 6; % contraction
        annoAll(annoRaw==62) = 7; % single tentacle contraction side view
        annoAll(annoRaw==71|annoRaw==72|annoRaw==73|annoRaw==74) = 8; % somersaulting
        annoAll(annoRaw==91|annoRaw==92|annoRaw==93) = 9; % feeding
    % annotation version 2
    case 2
        annoAll(annoRaw==10|annoRaw==11|annoRaw==12|annoRaw==13|annoRaw==14) = 1; % silent
        annoAll(annoRaw==21|annoRaw==22|annoRaw==23|annoRaw==24|annoRaw==25) = 2; % elongation
        annoAll(annoRaw==31|annoRaw==32|annoRaw==53|annoRaw==55) = 3; % tentacle sway
        annoAll(annoRaw==51|annoRaw==52|annoRaw==56) = 4; % body sway
        annoAll(annoRaw==41|annoRaw==42) = 5; % bending
        annoAll(annoRaw==63|annoRaw==64|annoRaw==65|...
            annoRaw==66|annoRaw==54) = 6; % contraction
        annoAll(annoRaw==61|annoRaw==62) = 7; % single tentacle contraction
        annoAll(annoRaw==71|annoRaw==72|annoRaw==73|annoRaw==74) = 8; % somersaulting
        annoAll(annoRaw==91|annoRaw==92|annoRaw==93) = 9; % feeding
    % annotation version 3
    case 3
        annoAll(annoRaw==10|annoRaw==11|annoRaw==12|annoRaw==13|annoRaw==14) = 1; % silent
        annoAll(annoRaw==21|annoRaw==22|annoRaw==23|annoRaw==24|annoRaw==25) = 2; % elongation
        annoAll(annoRaw==31|annoRaw==32|annoRaw==53|annoRaw==55|annoRaw==61|...
            annoRaw==62) = 3; % tentacle sway
        annoAll(annoRaw==51|annoRaw==52|annoRaw==56) = 4; % body sway
        annoAll(annoRaw==41|annoRaw==42) = 5; % bending
        annoAll(annoRaw==63|annoRaw==64|annoRaw==65|...
            annoRaw==66|annoRaw==54) = 6; % contraction
        annoAll(annoRaw==71|annoRaw==72|annoRaw==73|annoRaw==74) = 7; % somersaulting
        annoAll(annoRaw==91|annoRaw==92|annoRaw==93) = 8; % feeding
    % annotation version 4
    case 4
        annoAll(annoRaw==10|annoRaw==11|annoRaw==12|annoRaw==13|annoRaw==14) = 1; % silent
        annoAll(annoRaw==21|annoRaw==22|annoRaw==23|annoRaw==24|annoRaw==25) = 2; % elongation
        annoAll(annoRaw==31|annoRaw==32|annoRaw==53|annoRaw==55|annoRaw==61|...
            annoRaw==62) = 3; % tentacle sway
        annoAll(annoRaw==51|annoRaw==52|annoRaw==56) = 4; % body sway
        annoAll(annoRaw==41|annoRaw==42) = 5; % bending
        annoAll(annoRaw==63|annoRaw==64|annoRaw==65|...
            annoRaw==66|annoRaw==54) = 6; % contraction
        annoAll(annoRaw==71|annoRaw==72) = 7; % somersaulting stage 1,5
        annoAll(annoRaw==73) = 8; % somersaulting stage 3
        annoAll(annoRaw==74) = 9; % somersaulting stage 2,4
        annoAll(annoRaw==91) = 10; % feeding stage 1
        annoAll(annoRaw==92) = 11; % feeding stage 2
        annoAll(annoRaw==93) = 12; % feeding stage 3
    % annotation version 5: low level behavior only
    case 5
        annoAll(annoRaw==10|annoRaw==11|annoRaw==12|annoRaw==13|annoRaw==14) = 1; % silent
        annoAll(annoRaw==21|annoRaw==22|annoRaw==23|annoRaw==24|annoRaw==25) = 2; % elongation
        annoAll(annoRaw==31|annoRaw==32|annoRaw==53|annoRaw==55|annoRaw==61|...
            annoRaw==62) = 3; % tentacle sway
        annoAll(annoRaw==51|annoRaw==52|annoRaw==56) = 4; % body sway
        annoAll(annoRaw==41|annoRaw==42) = 5; % bending
        annoAll(annoRaw==63|annoRaw==64|annoRaw==65|...
            annoRaw==66|annoRaw==54) = 6; % contraction
        annoAll(annoRaw==91|annoRaw==92|annoRaw==93) = 7; % feeding
    % low level with detailed feeding and ss stage 24 only
    case 6
        annoAll(annoRaw==10|annoRaw==11|annoRaw==12|annoRaw==13|annoRaw==14) = 1; % silent
        annoAll(annoRaw==21|annoRaw==22|annoRaw==23|annoRaw==24|annoRaw==25) = 2; % elongation
        annoAll(annoRaw==31|annoRaw==32|annoRaw==53|annoRaw==55|annoRaw==61|...
            annoRaw==62) = 3; % tentacle sway
        annoAll(annoRaw==51|annoRaw==52|annoRaw==56) = 4; % body sway
        annoAll(annoRaw==41|annoRaw==42) = 5; % bending
        annoAll(annoRaw==63|annoRaw==64|annoRaw==65|...
            annoRaw==66|annoRaw==54) = 6; % contraction
        annoAll(annoRaw==74) = 7; % somersaulting stage 2,4
        annoAll(annoRaw==91) = 8; % feeding stage 1
        annoAll(annoRaw==92) = 9; % feeding stage 2
        annoAll(annoRaw==93) = 10; % feeding stage 3
    case 7
        annoAll(annoRaw==10|annoRaw==11|annoRaw==12|annoRaw==13|annoRaw==14) = 1; % silent
        annoAll(annoRaw==21|annoRaw==22|annoRaw==23|annoRaw==24|annoRaw==25|...
            annoRaw==71) = 2; % elongation
        annoAll(annoRaw==31|annoRaw==32|annoRaw==53|annoRaw==55|annoRaw==61|...
            annoRaw==62) = 3; % tentacle sway
        annoAll(annoRaw==51|annoRaw==52|annoRaw==56) = 4; % body sway
        annoAll(annoRaw==41|annoRaw==42) = 5; % bending
        annoAll(annoRaw==63|annoRaw==64|annoRaw==65|...
            annoRaw==66|annoRaw==54|annoRaw==72|annoRaw==73) = 6; % contraction
        annoAll(annoRaw==74) = 7; % somersaulting stage 2,4
        annoAll(annoRaw==91|annoRaw==92|annoRaw==93) = 8; % feeding
    case 8
        annoAll(annoRaw==10|annoRaw==11|annoRaw==12|annoRaw==13|annoRaw==14) = 1; % silent
        annoAll(annoRaw==21|annoRaw==22|annoRaw==23|annoRaw==24|annoRaw==25|...
            annoRaw==71) = 2; % elongation
        annoAll(annoRaw==31|annoRaw==32|annoRaw==53|annoRaw==55|annoRaw==61|...
            annoRaw==62) = 3; % tentacle sway
        annoAll(annoRaw==51|annoRaw==52|annoRaw==56) = 4; % body sway
        annoAll(annoRaw==41|annoRaw==42) = 5; % bending
        annoAll(annoRaw==63|annoRaw==64|annoRaw==65|...
            annoRaw==66|annoRaw==54|annoRaw==72|annoRaw==73) = 6; % contraction
        annoAll(annoRaw==74) = 7; % somersaulting stage 2,4
        annoAll(annoRaw==91) = 8; % feeding stage 1
        annoAll(annoRaw==92) = 9; % feeding stage 2
        annoAll(annoRaw==93) = 10; % feeding stage 3
    case 9
        annoAll(annoRaw==10|annoRaw==11|annoRaw==12|annoRaw==13|annoRaw==14) = 1; % silent
        annoAll(annoRaw==21|annoRaw==22|annoRaw==23|annoRaw==24|annoRaw==25|...
            annoRaw==71) = 2; % elongation
        annoAll(annoRaw==31|annoRaw==32|annoRaw==53|annoRaw==55|annoRaw==61|...
            annoRaw==62) = 3; % tentacle sway
        annoAll(annoRaw==51|annoRaw==52|annoRaw==56) = 4; % body sway
        annoAll(annoRaw==41|annoRaw==42|annoRaw==74) = 5; % bending
        annoAll(annoRaw==63|annoRaw==64|annoRaw==65|annoRaw==66|annoRaw==54|...
            annoRaw==72|annoRaw==73) = 6; % contraction
        annoAll(annoRaw==91|annoRaw==92|annoRaw==93) = 7; % feeding
    case 10
        annoAll(annoRaw==10|annoRaw==11|annoRaw==12|annoRaw==13|annoRaw==14) = 1; % silent
        annoAll(annoRaw==21|annoRaw==22|annoRaw==23|annoRaw==24|annoRaw==25|...
            annoRaw==71) = 2; % elongation
        annoAll(annoRaw==31|annoRaw==32|annoRaw==53|annoRaw==55|annoRaw==61|...
            annoRaw==62|annoRaw==91) = 3; % tentacle sway
        annoAll(annoRaw==51|annoRaw==52|annoRaw==56) = 4; % body sway
        annoAll(annoRaw==41|annoRaw==42|annoRaw==74) = 5; % bending
        annoAll(annoRaw==63|annoRaw==64|annoRaw==65|annoRaw==66|annoRaw==54|...
            annoRaw==72|annoRaw==73) = 6; % contraction
        annoAll(annoRaw==92|annoRaw==93) = 7; % feeding
    case 11
        annoAll(annoRaw==10|annoRaw==11|annoRaw==12|annoRaw==13|annoRaw==14) = 1; % silent
        annoAll(annoRaw==21|annoRaw==22|annoRaw==23|annoRaw==24|annoRaw==25) = 2; % elongation
        annoAll(annoRaw==31|annoRaw==32|annoRaw==53|annoRaw==55|annoRaw==61|...
            annoRaw==62) = 3; % tentacle sway
        annoAll(annoRaw==51|annoRaw==52|annoRaw==56) = 4; % body sway
        annoAll(annoRaw==41|annoRaw==42) = 5; % bending
        annoAll(annoRaw==63|annoRaw==64|annoRaw==65|...
            annoRaw==66|annoRaw==54) = 6; % contraction
        annoAll(annoRaw==91) = 7; % feeding 1
        annoAll(annoRaw==92) = 8; % feeding 2
        annoAll(annoRaw==93) = 9; % feeding 3
    case 12
        annoAll(annoRaw==10|annoRaw==11|annoRaw==12|annoRaw==13|annoRaw==14) = 1; % silent
        annoAll(annoRaw==21|annoRaw==22|annoRaw==23|annoRaw==24|annoRaw==25) = 2; % elongation
        annoAll(annoRaw==31|annoRaw==32|annoRaw==53|annoRaw==55|annoRaw==61|...
            annoRaw==62) = 3; % tentacle sway
        annoAll(annoRaw==51|annoRaw==52|annoRaw==56) = 4; % body sway
        annoAll(annoRaw==41|annoRaw==42) = 5; % bending
        annoAll(annoRaw==63|annoRaw==64|annoRaw==65|...
            annoRaw==66|annoRaw==54) = 6; % contraction
    otherwise
        error('invalid annotation merging scheme');
end

end