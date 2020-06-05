clc;
clear all;

%getting obs values
run('Ex04_variables.m')

%initialization of parameters

%max number of iterations
max_iter = 100;
%threshold for convergence
th_convergence = 0.1;
%approx coordinates of the receiver and clock offset

X_init = [ 0,0,0,0]; 

xyz_real =    [4407345.9683   700838.7444  4542057.2866];
%with tropo-iono[4407983.9977460429072380065917969, 689466.1070261170389130711555481, 4483441.1963863326236605644226074, 0.020861414756313114565733357608224]
%only tropo     [4407381.4354982804507017135620117, 700841.25238080474082380533218384, 4542077.2566848732531070709228516, 0.0074693469653422479501148067981831]
%               [4407381.4355508321896195411682129, 700841.25249385985080152750015259, 4542077.2566507039591670036315918, 0.0068365843831159614149561853935211]


% storage of iterate results
Xr = X_init;
Xs = xyz_sat;
m = length(xyz_sat);
% Least squares iteration
for i=1:max_iter
    
    % topocentric positions of all satellites
    [az, el, D] = topocent(Xr(1:3), Xs);
    el = rad2deg(el);
    % approximate geodetic coordinates of the receiver
    
    [phi, lam, h, phiC] = cart2geod(Xr(1), Xr(2), Xr(3)); %= [phi, lam, h, phiC]
    %phi = g(1); lam = g(2); h = g(3);
    % tropospheric and ionospheric corrections
    if i > 2 
        tropo = tropo_error(el,h);
    else
        tropo = zeros(length(el),1);
    end    
   
    iono = iono_error(phi, lam, az, el, time_rx, ionoparams);
    % LS known term
    P0 = pr_C1;
    i_vector = ones(m,1);
    bs = D - s_light.*dtS;% + tropo + iono;
    delta_P0 = P0 - bs;
    E = zeros(m,3);
    for j=1:m
        E(j,1) = 1/D(j) * (Xr(1)-Xs(j,1));
        E(j,2) = 1/D(j) * (Xr(2)-Xs(j,2));
        E(j,3) = 1/D(j) * (Xr(3)-Xs(j,3));
    end
    % LS A matrix
    A = [E s_light.*i_vector];
    %x_ = [delta_Xr;dtR];
    y_ = delta_P0;
    N = A'*A;
    % Least square solution for the corrections to the apriori
    delta = inv(N)*A'*y_;   
    %check convergence of the result and, in case exit
    if max(abs(delta(1:3))) < th_convergence
        break
    end
    % Estimated coordinates of the receiver:
    delta_priori = Xr;
    % approximate + estimated correction
    Xr = Xr + delta';
    % check at the end that convergence did not fail
    if i == max_iter
        disp('Convergence failed');
    end
end




% covariance

%Use only the 3x3 matrix of N
newN= N(1:3,1:3);
%Computation of residuals, real positions with respect to estimated ones
residuals = xyz_real-Xr(1:3);
sigma2 = residuals'*residuals/(m-4);
Cxx = sigma2*inv(newN);

% pdop
%Qxx = N^-1
Qxx = inv(newN);
diagQxx = diag(Qxx);
[pdop_phi, pdop_lambda, pdop_h, pdop_phic]= cart2geod(diagQxx(1),diagQxx(2),diagQxx(3));
%Rotation matrix from GC to LC
R_LC = R_GCtoLC(pdop_phi, pdop_lambda);
Qxx_ENU = R_LC*Qxx*R_LC';
pdop = sqrt(sum(diag(Qxx_ENU)));

estimates = vpa(Xr);
% final estimated unknowns
fprintf('Final estimated unknowns: [');
fprintf('%g ', estimates);
fprintf(']\n');
% LS residuals and sigma2
fprintf('LS residuals: [');
fprintf('%g ', residuals);
fprintf(']\n');
fprintf('Sigma2: [');
fprintf('%g ', sigma2);
fprintf(']\n');
% covariance matrix of the estimated coordinates
fprintf('Covariance matrix of the estimated coordinates: [');
fprintf('%g ', Cxx);
fprintf(']\n');
% Rotate and PDOP
fprintf('Rotation matrix to LC: [');
fprintf('%g ', R_LC);
fprintf(']\n');
fprintf('PDOP: [');
fprintf('%g ', pdop);
fprintf(']\n');
% print results
fprintf('The total number of iterations was: %d \n', i);


% coord_print = sprintf('The coordinates of the receiver are: [%d %d %d]', R_pos);
% disp(coord_print);
% offset_print = sprintf('The clock offset of the receiver is: %d', Xr_est(4));
% disp(offset_print);
% PDOP_print = sprintf('PDOP value is %f', PDOP);
% disp(PDOP_print);

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
