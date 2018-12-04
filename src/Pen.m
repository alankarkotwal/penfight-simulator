classdef Pen
    
    properties
        
        weight % g
        length % cm
        radius % cm
        center % cm
        angle % radians
        density % g / cm^3
        frictionCoeff
        momentOfInertia
        linearVelocity = [0; 0];
        angularVelocity = 0;
        
    end

    methods

       function obj = Pen(weight, length, radius, frictionCoeff, center, angle, impulse, point, thetaF)
           
           obj.weight = weight;
           obj.length = length;
           obj.radius = radius;
           obj.frictionCoeff = frictionCoeff;
           obj.center = center;
           obj.angle = angle;
           
           % Calculate moment of inertia about the center.
           obj.momentOfInertia = obj.weight * (3 * obj.radius^2 + obj.length^2) / 12;
           %obj.density = obj.weight / (2*pi*obj.radius*obj.length);
           
           if(nargin == 6)
               obj.linearVelocity = [0, 0];
               obj.angularVelocity = 0;
           else
               penEnds = obj.center + [obj.length * [cos(obj.angle), -cos(obj.angle)] / 2;
                                      -obj.length * [-sin(obj.angle), sin(obj.angle)] / 2];

               if norm(point - penEnds(:, 1)) + norm(point - penEnds(:, 2)) ~= obj.length
                   error('You cannot hit the pen here! This point doesn''t lie on the pen.');
               end

               obj.linearVelocity = obj.linearVelocity + impulse / obj.weight * [cos(thetaF); sin(thetaF)];

               r = [point - obj.center; 0];
               I = impulse * [cos(thetaF); sin(thetaF); 0];
               rCrossI = cross(r, I);
               obj.angularVelocity = obj.angularVelocity + rCrossI(3) / obj.momentOfInertia;
           end
           
       end
       
       function trajectory = singleHitFrictionless(obj, impulse, point, thetaF, timePoints)
           
           % Calculate the trajectory for a single hit of a single 
           % pen, without any collisions. We assume that the impulse
           % transferred is always large enough to set the pen in
           % motion. Further, we assume the pen is much thinner than
           % its length.
           
%            if(~exist('antialias', 'var'))
%                antialias = pi/10;
%            end
           
           if nargin == 5
               
           end
           
           penEnds = obj.center + [obj.length * [cos(obj.angle), -cos(obj.angle)] / 2;
                                  -obj.length * [-sin(obj.angle), sin(obj.angle)] / 2];
           
           if norm(point - penEnds(:, 1)) + norm(point - penEnds(:, 2)) ~= obj.length
               error('You cannot hit the pen here! This point doesn''t lie on the pen.');
           end
           
           obj.linearVelocity = obj.linearVelocity + impulse / obj.weight * [cos(thetaF); sin(thetaF)];
           
           r = [point - obj.center; 0];
           I = impulse * [cos(thetaF); sin(thetaF); 0];
           rCrossI = cross(r, I);
           obj.angularVelocity = obj.angularVelocity + rCrossI(3) / obj.momentOfInertia;
           
           %timeRes = abs(comAngularVelocity / antialias);
           %timePoints = 0:timeRes:time;
                            
           trajectory = zeros([3, numel(timePoints)]);
           for i = 1:numel(timePoints) 
               trajectory(1:2, i) = obj.center + obj.linearVelocity * timePoints(i);
               trajectory(3, i) = obj.angle + obj.angularVelocity * timePoints(i);
           end
           
           %obj.center = trajectory(1:2, numel(timePoints));
           %obj.angle = trajectory(3, numel(timePoints));

       end
       
       function trajectory = singleHitFrictionful(obj, impulse, point, thetaF, timePoints)
           

           % Calculate the trajectory for a single hit of a single 
           % pen, without any collisions. We assume that the impulse
           % transferred is always large enough to set the pen in
           % motion. Further, we assume the pen is much thinner than
           % its length.
           
%            if(~exist('antialias', 'var'))
%                antialias = pi/10;
%            end
           
           penEnds = obj.center + [obj.length * [cos(obj.angle), -cos(obj.angle)] / 2;
                                  -obj.length * [-sin(obj.angle), sin(obj.angle)] / 2];
           
           if norm(point - penEnds(:, 1)) + norm(point - penEnds(:, 2)) ~= obj.length
               error('You cannot hit the pen here! This point doesn''t lie on the pen.');
           end
           
           comLinearVelocity = impulse / obj.weight * [cos(thetaF); sin(thetaF)];
           
           r = [point - obj.center; 0];
           I = impulse * [cos(thetaF); sin(thetaF); 0];
           rCrossI = cross(r, I);
           comAngularVelocity = rCrossI(3) / obj.momentOfInertia;
                            
           if ~exist('gravity', 'var')
               consts;
           end

%            timeRes = comAngularVelocity / antialias;
%            timePoints = 0:timeRes:time;
           
           trajectory = zeros(3, numel(timePoints));
           trajectory(:, 1) = [obj.center; obj.angle];
           
           for i = 2:numel(timePoints)
               
               disp(i);
               
               thisTheta = trajectory(3, i-1);
               trajectory(1:2, i) = trajectory(1:2, i-1) + (timePoints(i)-timePoints(i-1))*comLinearVelocity;
               trajectory(3, i) = trajectory(3, i-1) + (timePoints(i)-timePoints(i-1))*comAngularVelocity;
               
               A = 2*pi*obj.radius*obj.density*obj.frictionCoeff*gravity;
               D = norm(comLinearVelocity)^2;
               E = 2*comAngularVelocity*(cos(thisTheta)*comLinearVelocity(2) - ...
                                         sin(thisTheta)*comLinearVelocity(1));
               F = comAngularVelocity^2;
               
               syms x;
               comLinearDeceleration = zeros(2, 1);
               
               % comLinearDecelerationX
               B = comLinearVelocity(1);
               C = -comAngularVelocity*sin(thisTheta);
               %intFn = linFrictionFn(x, A, B, C, D, E, F);
               %comLinearDeceleration(1) = int(intFn, -obj.length/2, obj.length/2);
               comLinearDeceleration(1) = linFrictionIntegral(obj.length/2, A, B, C, D, E, F) - ...
                                          linFrictionIntegral(-obj.length/2, A, B, C, D, E, F);
               
               % comLinearDecelerationY
               B = comLinearVelocity(2);
               C = comAngularVelocity*cos(thisTheta);
               %intFn = linFrictionFn(x, A, B, C, D, E, F);
               %comLinearDeceleration(2) = int(intFn, -obj.length/2, obj.length/2);
               comLinearDeceleration(2) = linFrictionIntegral(obj.length/2, A, B, C, D, E, F) - ...
                                          linFrictionIntegral(-obj.length/2, A, B, C, D, E, F);
               
               % comAngularDeceleration
               B = comLinearVelocity(2)-comLinearVelocity(1);
               C = comAngularVelocity;
               intFn = angFrictionFn(x, A, B, C, D, E, F);
               comAngularDeceleration = 0;%int(intFn, -obj.length/2, obj.length/2);
               
               comLinearVelocity = comLinearVelocity - (timePoints(i)-timePoints(i-1))*comLinearDeceleration;
               comAngularVelocity = comAngularVelocity - (timePoints(i)-timePoints(i-1))*comAngularDeceleration;
               
           end
                                      
       end
    
    end
    
end