function[posInert] = CalcTrajectory(acc, omegaz, epoch)

    vel = zeros(size(acc));
    vel(1, : ) = [0 0];

    for i=2:length(epoch)
        %vel(i, :) = vel(i-1, :) + (epoch(i)-epoch(i-1)) * (acc(i, :)+acc(i-1, :))/2;
        vel(i, :) = vel(i-1, :) +  acc(i, :) * (epoch(i)-epoch(i-1));
    end

    pos = zeros(size(vel));
    pos(1, : ) = [0 0];

    for i=2:length(epoch)
        pos(i, :) = pos(i-1, :) + vel(i, :) * (epoch(i)-epoch(i-1)) +((epoch(i)-epoch(i-1))^2 * (acc(i, :)))/2;
    end

    %set direction for inertial system, no movement on z axis
    pos2 = zeros(size(pos));
    pos2(:, 1) = pos(:,2);
    pos2(:, 2) = pos(:,1);

    alpha = zeros(length(omegaz));
    alpha(1) = [0];

    posInert = zeros(size(pos2));
    posInert(1, :) = [100 100]; 

    for i=2:length(epoch)
       alpha(i) = alpha(i-1) +  omegaz(i) * (epoch(i)-epoch(i-1));
       R = [cos(alpha(i)) sin(alpha(i)); -sin(alpha(i)) cos(alpha(i))];
       posInert(i, :) = posInert(i-1, :) + (R * (pos2(i, :) - pos2(i-1, :))')';
    end
end