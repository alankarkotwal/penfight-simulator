function visualizeTrajectory(pen, trajectory)

    figure; hold on;
    %xlim([min(trajectory(:, 1))-pen.length, min(trajectory(:, 1))+pen.length]);
    %ylim([min(trajectory(:, 2))-pen.length, min(trajectory(:, 2))+pen.length]);

    for i = 1:size(trajectory, 2)
        
        com = trajectory(1:2, i);
        angle = trajectory(3, i);
        endpoints = [com + pen.length * [cos(angle), sin(angle)] / 2;
                     com - pen.length * [cos(angle), sin(angle)] / 2];
        
        plot(endpoints(:, 1), endpoints(:, 2), 'LineWidth', 4); drawnow;
                 
    end

end