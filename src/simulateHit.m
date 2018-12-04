function simulateHit(pen1, pen2, table, deltaT)

    doPensIntersect = 0;
    pen2Ends = [pen2.center(1) + pen2.length * cos(pen2.angle) / 2, ...
                              pen2.center(2) + pen2.length * sin(pen2.angle) / 2, ...
                              pen2.center(1) - pen2.length * cos(pen2.angle) / 2, ...
                              pen2.center(2) - pen2.length * sin(pen2.angle) / 2];
    intersection = [];
    
    figure;
    plot([pen2Ends(1), pen2Ends(3)], [pen2Ends(2), pen2Ends(4)], 'r');
    hold on;
    
    % Propagate pen1 till it reaches pen2
    while(~doesPenFallOff(pen1, table) && ~doPensIntersect) 
        
        pen1.center = pen1.center + deltaT * pen1.linearVelocity;
        pen1.angle = pen1.angle + deltaT * pen1.angularVelocity;
        
        pen1Ends = [pen1.center(1) + pen1.length * cos(pen1.angle) / 2, ...
                                  pen1.center(2) + pen1.length * sin(pen1.angle) / 2, ...
                                  pen1.center(1) - pen1.length * cos(pen1.angle) / 2, ...
                                  pen1.center(2) - pen1.length * sin(pen1.angle) / 2];
                              
        plot([pen1Ends(1), pen1Ends(3)], [pen1Ends(2), pen1Ends(4)], 'g');

        
        intersection = lineSegmentIntersect(pen1Ends, pen2Ends);
        doPensIntersect = intersection.intAdjacencyMatrix;
                           
    end

    pointOfIntersection = [intersection.intMatrixX; intersection.intMatrixY];
    r = pen1.center - pointOfIntersection - pen1.center;
    instantVelocity = pen1.linearVelocity + pen1.angularVelocity;
    
end