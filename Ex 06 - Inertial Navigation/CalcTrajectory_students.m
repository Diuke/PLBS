function[posInert] = CalcTrajectory(acc, omegaz, epoch)
    %initialize velocities
    vx = zeros(length(acc),1);
    vy = zeros(length(acc),1);
    vx(1) = 0;
    vy(1) = 0;
    %cycle for: compute velocities
    for i=2:length(epoch)
       vx(i) =vx(i-1)+acc(i,1)*(epoch(i)-epoch(i-1));
       vy(i) =vy(i-1)+acc(i,2)*(epoch(i)-epoch(i-1));
    end
    %initialize delta positions
    posx = zeros(length(acc),1);
    posy = zeros(length(acc),1);
    posx(1) = 0;
    posy(1) = 0;
    %cycle for: compute delta positions in body frame
    for i=2:length(epoch)
       posx(i) = posx(i-1) + vx(i)*(epoch(i)-epoch(i-1)) + 0.5*(acc(i,1)*(epoch(i)-epoch(i-1))^2);
       posy(i) = posy(i-1) + vy(i)*(epoch(i)-epoch(i-1)) + 0.5*(acc(i,2)*(epoch(i)-epoch(i-1))^2);
    %It should be V0 -> vx(i-1) and vy(i-1) according to formulas
    end
    
    %    initialize alpha angle and positions in inertial
    alpha = zeros(length(omegaz),1);
    alpha(1) = 0;
    
    pos = zeros(size(acc));
    pos(:,1) = posy;
    pos(:,2) = posx;
    
    posInert = zeros(size(acc));
    posInert(1, :) = [100 100]; 
    % cycle for: for each epoch compute alpha, R(alpha), rotate Dx from body to
    % inertial and update intertial coordinates
    for i=2:length(epoch)
       alpha(i) = alpha(i-1) +  omegaz(i) * (epoch(i)-epoch(i-1));
       R = [cos(alpha(i)) sin(alpha(i)); -sin(alpha(i)) cos(alpha(i))];
       posInert(i, :) = posInert(i-1, :) + (R * (pos(i, :) - pos(i-1, :))')';
    end
    %finish!
end