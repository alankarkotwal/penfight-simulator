nSamples = 10;
nParams = 9;

penWeight = 100;
penLength = 15;
penRadius = 1;
frictionCoeff = 0.1;

table = [50, 50];

impulseLimit = 1000;

deltaT = 0.01;

parameters = zeros(nSamples, nParams);
winners = zeros(nSamples, 1);

parfor i = 1:nSamples
    
    disp(['Sample ' num2str(i) ' / ' num2str(nSamples)]);
    
    pen1Center = [rand*table(1); rand*table(2)]; %#ok<PFBNS>
    pen2Center = [rand*table(1); rand*table(2)];
    
    pen1Angle = rand*2*pi;
    pen2Angle = rand*2*pi;
    
    impulseRadius = rand*penLength - penLength/2;
    impulsePoint = pen1Center + [impulseRadius*cos(pen1Angle); ...
                                 impulseRadius*sin(pen1Angle)];
	impulse = rand*impulseLimit;
	impulseAngle = rand*2*pi;
                             
    pen1 = Pen(penWeight, penLength, penRadius, ...
               frictionCoeff, pen1Center, pen1Angle, impulse, impulsePoint, impulseAngle);
    pen2 = Pen(penWeight, penLength, penRadius, ...
               frictionCoeff, pen2Center, pen2Angle);
    
    winners(i) = simulateHit(pen1, pen2, table, deltaT); 
    parameters(i, :) = [pen1Center; pen2Center; pen1Angle; pen2Angle; impulseRadius; impulse; impulseAngle]';
    
end