classdef Pen
    
    properties
        
        density % g / cm^3
        weight % g
        length % cm
        radius % cm
        center % cm
        angle % radians
        frictionCoeff
        momentOfInertia
        
    end

    methods

       function obj = Pen(density, length, radius, frictionCoeff, center, angle)
           
           obj.density = density;
           obj.length = length;
           obj.radius = radius;
           obj.frictionCoeff = frictionCoeff;
           
           if nargin == 4
               obj.center = [0, 0];
               obj.angle = 0;
           else
               obj.center = center;
               obj.angle = angle;
           end
           
           % Calculate weight and moment of inertia about the center.
           obj.weight = 2 * pi * obj.radius * obj.length * obj.density;
           obj.momentOfInertia = obj.weight * (3 * obj.radius^2 + obj.length^2) / 12;
           
       end
       
       function trajectory = singleHitFrictionless(obj, impulse, point, direction, timePoints)
           
           % Calculate the trajectory for a single hit of a single 
           % pen, without any collisions. We assume that the impulse
           % transferred is always large enough to set the pen in
           % motion. Further, we assume the pen is much thinner than
           % its length.
           
           penEnds = obj.center + [obj.length * [cos(obj.angle), sin(obj.angle)] / 2;
                                  -obj.length * [cos(obj.angle), sin(obj.angle)] / 2];
           
           if norm(point - penEnds(1, :)) + norm(point - penEnds(2, :)) ~= obj.length
               error('You cannot hit the pen here! This point doesn''t lie on the pen.');
           end

           direction = normr(direction);
           
           comLinearVelocity = impulse / obj.weight * direction;
           comAngularVelocity = norm(point - obj.center) * ...
                                dot(direction, [-sin(obj.angle), cos(obj.angle)] * ...
                                impulse / obj.momentOfInertia);
                            
           trajectory = [bsxfun(@times, comLinearVelocity, timePoints'), ...
                         comAngularVelocity * timePoints'];
                                      
       end
       
       function trajectory = singleHitFrictionful(obj, impulse, point, direction, timePoints)
           
           % TODO
           % Calculate the trajectory for a single hit of a single 
           % pen, without any collisions. We assume that the impulse
           % transferred is always large enough to set the pen in
           % motion. Further, we assume the pen is much thinner than
           % its length.
           
           penEnds = obj.center + [obj.length * [cos(obj.angle), sin(obj.angle)] / 2;
                                  -obj.length * [cos(obj.angle), sin(obj.angle)] / 2];
           
           if norm(point - penEnds(1, :)) + norm(point - penEnds(2, :)) ~= obj.length
               error('You cannot hit the pen here! This point doesn''t lie on the pen.');
           end

           direction = normr(direction);
           
           comLinearVelocity = impulse / obj.weight * direction;
           comAngularVelocity = norm(point - obj.center) * ...
                                dot(direction, [-sin(obj.angle), cos(obj.angle)] * ...
                                impulse / obj.momentOfInertia);
                            
           for i = 1:numel(timePoints)
               % Attenuate angular and linear velocities here!
           end
                                      
       end
    
    end
    
end