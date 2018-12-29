function winner = simulateHit(pen1, pen2, table, deltaT)
   
%     figure; hold on;
%     xlim([-2, 16]);
%     ylim([-4, 12]);
    
%     count = 1;
    
    pen1Ends = [pen1.center(1) + pen1.length * cos(pen1.angle) / 2, ...
                                  pen1.center(2) + pen1.length * sin(pen1.angle) / 2, ...
                                  pen1.center(1) - pen1.length * cos(pen1.angle) / 2, ...
                                  pen1.center(2) - pen1.length * sin(pen1.angle) / 2];
                              
    pen2Ends = [pen2.center(1) + pen2.length * cos(pen2.angle) / 2, ...
                                  pen2.center(2) + pen2.length * sin(pen2.angle) / 2, ...
                                  pen2.center(1) - pen2.length * cos(pen2.angle) / 2, ...
                                  pen2.center(2) - pen2.length * sin(pen2.angle) / 2];
                              
    intersection = lineSegmentIntersect(pen1Ends, pen2Ends);
    doPensIntersect = intersection.intAdjacencyMatrix;
    if(doPensIntersect) 
        winner = 0;
        return;
    end
    
    % Propagate pen1 till it reaches pen2
    while(~doesPenFallOff(pen1, table) && ~doesPenFallOff(pen2, table)) %&& ~doPensIntersect) 
        
        pen1.center = pen1.center + deltaT * pen1.linearVelocity;
        pen1.angle = pen1.angle + deltaT * pen1.angularVelocity;
        
        pen2.center = pen2.center + deltaT * pen2.linearVelocity;
        pen2.angle = pen2.angle + deltaT * pen2.angularVelocity;
        
        pen1Ends = [pen1.center(1) + pen1.length * cos(pen1.angle) / 2, ...
                                  pen1.center(2) + pen1.length * sin(pen1.angle) / 2, ...
                                  pen1.center(1) - pen1.length * cos(pen1.angle) / 2, ...
                                  pen1.center(2) - pen1.length * sin(pen1.angle) / 2];
                              
        pen2Ends = [pen2.center(1) + pen2.length * cos(pen2.angle) / 2, ...
                                  pen2.center(2) + pen2.length * sin(pen2.angle) / 2, ...
                                  pen2.center(1) - pen2.length * cos(pen2.angle) / 2, ...
                                  pen2.center(2) - pen2.length * sin(pen2.angle) / 2];
                    
%         plot(pen1Ends([1, 3]), pen1Ends([2, 4]), 'r');
%         plot(pen2Ends([1, 3]), pen2Ends([2, 4]), 'g');
%         drawnow;
        
        intersection = lineSegmentIntersect(pen1Ends, pen2Ends);
        doPensIntersect = intersection.intAdjacencyMatrix;
        
        if(doPensIntersect)
           
            intersectionPoint = [intersection.intMatrixX; intersection.intMatrixY];
            r1 = intersectionPoint - pen1.center;
            r2 = intersectionPoint - pen2.center;
            
            omega1 = [0;0;pen1.angularVelocity];
            omega2 = [0;0;pen2.angularVelocity];
            
            pt1AngVel = cross(omega1, [r1;0]);
            pt2AngVel = cross(omega2, [r2;0]);
            
            pen1PtVel = pen1.linearVelocity + pt1AngVel(1:2);
            pen2PtVel = pen2.linearVelocity + pt2AngVel(1:2);
            
            dirImpulse = normc(pen1PtVel - pen2PtVel);
            
            a1 = cross([r1; 0], [dirImpulse; 0]); a1 = a1(end);
            a2 = cross([r2; 0], [dirImpulse; 0]); a2 = a2(end);
            
            t = -2 * (norm(pen1.linearVelocity) - norm(pen2.linearVelocity) + ...
                      a1 * pen1.angularVelocity - a2 * pen2.angularVelocity) / ...
                  (1/pen1.weight + 1/pen2.weight + a1^2/pen1.momentOfInertia^2 + ...
                   a2^2/pen2.momentOfInertia^2);
               
            pen1.linearVelocity = pen1.linearVelocity + t*dirImpulse/pen1.weight;
            pen2.linearVelocity = pen2.linearVelocity - t*dirImpulse/pen2.weight;
            pen1.angularVelocity = pen1.angularVelocity + t*a1/pen1.momentOfInertia;
            pen2.angularVelocity = pen2.angularVelocity - t*a2/pen2.momentOfInertia;
                      
        end
           
%         export_fig(['simulatedHit' num2str(count) '.png']);
%         count = count + 1;
       
        
    end
    
    if(doesPenFallOff(pen1, table)) 
        winner = 2;
    else
        winner = 1;
    end
    
end