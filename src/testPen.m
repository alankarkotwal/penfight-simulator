consts;

pen1 = Pen(100, 15, 1, 0.1, [7.5, 7.5]', 0, 100, [15; 7.5], -3*pi/4);
%pen2 = Pen(100, 15, 1, 0.1, [8, 2]', pi);
pen2 = Pen(100, 15, 1, 0.1, [7.5, 6.5]', pi);

table = [50, 50];
simulateHit(pen1, pen2, table, 0.01)


% pen = Pen(100, 15, 1, 0.1, [7.5, 7.5]', 0, 100, [15; 7.5], -3*pi/4);
% timePoints = 0:0.5:20;
% trajectory = zeros([3, numel(timePoints)]);
% for i = 1:numel(timePoints) 
%    trajectory(1:2, i) = pen.center + pen.linearVelocity * timePoints(i);
%    trajectory(3, i) = pen.angle + pen.angularVelocity * timePoints(i);
% end
% visualizeTrajectory(pen, trajectory);