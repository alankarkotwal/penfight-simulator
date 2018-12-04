consts;

pen1 = Pen(100, 15, 1, 0.1, [7.5, 7.5]', 0, 100, [15; 7.5], -3*pi/4);
pen2 = Pen(100, 15, 1, 0.1, [8, 2]', pi/4);
table = [50, 50];
simulateHit(pen1, pen2, table, 0.01);
%visualizeTrajectory(pen, trajectory);