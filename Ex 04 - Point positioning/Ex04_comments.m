clc
clear all

%getting obs values
run('Ex04_variables.m')

%initialization of parameters

%max number of iterations
max_iter = 10;
%threshold for convergence
th_convergence = 0.1;
%approx coordinates of the receiver and clock offset
X_init = [0 0 0 0]; 
% storage of iterate results
Xs = xyz_sat;
m = length(xyz_sat);
% Least squares iteration
for i=1:max_iter
    Xr = X_init(1:3);
    % topocentric positions of all satellites
    [az, el, D] = topocent(Xr, Xs);
    el = rad2deg(el);
    % approximate geodetic coordinates of the receiver
    
    [phi, lam, h, phiC]  = cart2geod(Xr(1), Xr(2), Xr(3)); %= [phi, lam, h, phiC]
    % tropospheric and ionospheric corrections
    tropo = tropo_error_correction(0, 0, 0, Xs(:,3), el)
    iono = iono_error_correction(phi, lam, az, el, time_rx, ionoparams, [])
    % LS known term
    i_vector = ones(m,1);
    delta_p = D + s_light*dtS + tropo + iono;
    E = zeros(m,3);
    for j=1:m
        E(j,1) = 1/D(j) * (Xr(1)-Xs(j,1));
        E(j,2) = 1/D(j) * (Xr(2)-Xs(j,2));
        E(j,3) = 1/D(j) * (Xr(3)-Xs(j,3));
    end
    
    A = [E s_light.*i_vector]
    %x_ = [delta_Xr;dtR];
    y_ = delta_p;
    N = A'*A;
    delta = inv(N)*A'*y_
    
    % LS A matrix
    % Least square solution for the corrections to the apriori
    % Estimated coordinates of the receiver: 
    % approximate + estimated correction

    %check convergence of the result and, in case exit
    if max(abs(delta(1:3))) < th_convergence
        break
    end
    X_init = X_init+delta'
    % check at the end that convergence did not fail
    if i == max_iter
        disp('Convergence failed');
    end
end

% final estimated unknowns
% LS residuals and sigma2
% covariance matrix of the estimated coordinates
% Rotate and PDOP
% print results
i_print = sprintf('The total number of iterations is: %d', i);
disp(i_print);
coord_print = sprintf('The coordinates of the receiver are: [%d %d %d]', R_pos);
disp(coord_print);
offset_print = sprintf('The clock offset of the receiver is: %d', Xr_est(4));
disp(offset_print);
PDOP_print = sprintf('PDOP value is %f', PDOP);
disp(PDOP_print);

%%

%% repeat with CutOfAngle

CutOfAngle = 5;

% extract satellites above cut off
for j=1:n_sat
    if El_co(j) > CutOfAngle
        % store coordinates, otherwise exclude
    end
end

% repeat same computations
% print
disp('-------------------------------------------------------------');
COA_print = sprintf('Cut off Angle: %d',CutOfAngle);
disp(COA_print);
i_print = sprintf('The total number of iterations (COA) is: %d', i);
disp(i_print);
coord_print = sprintf('The coordinates of the receiver (COA) are: [%d %d %d]', X_co(i+1,1:3));
disp(coord_print);
offset_print = sprintf('The clock offset of the receiver (COA) is: %d', X_co(i+1,4));
disp(offset_print);
PDOP_print = sprintf('PDOP (COA) value is %f', PDOP_co);
disp(PDOP_print);