function visualizeTrajectory(pen, trajectory)

    figure; hold on;
    %xlim([min(trajectory(:, 1))-pen.length, min(trajectory(:, 1))+pen.length]);
    %ylim([min(trajectory(:, 2))-pen.length, min(trajectory(:, 2))+pen.length]);

    for i = 1:size(trajectory, 1)
        
        com = trajectory(i, 1:2);
        angle = trajectory(i, 3);
        endpoints = [com + pen.length * [cos(angle), sin(angle)] / 2;
                     com - pen.length * [cos(angle), sin(angle)] / 2];
        
        plot(endpoints(:, 1), endpoints(:, 2), 'LineWidth', 4); drawnow;
                 
    end

end