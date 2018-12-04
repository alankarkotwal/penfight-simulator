function out = doesPenFallOff(pen, tableEnd) 

    % Table specified with its diagonal points
    com = pen.center;
    if(com(1) > tableEnd(1) || com(1) < 0 || com(2) > tableEnd(2) || com(2) < 0)
        out = 1;
    else
        out = 0;
    end

end