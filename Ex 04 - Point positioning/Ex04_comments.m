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

% storage of iterate results
Xr = X_init;
Xs = xyz_sat;
m = length(xyz_sat);

% Least squares iteration
for i=1:max_iter
    
    % topocentric positions of all satellites
    
    % approximate geodetic coordinates of the receiver
    
    [phi, lam, h, phiC] = cart2geod(Xr(1), Xr(2), Xr(3)); %= [phi, lam, h, phiC]

    % Array init
    tropo = zeros(m,1);
    az = zeros(m,1);
    el = zeros(m,1);
    D = zeros(m,1);
    
    % topocent and tropo error calculations
    for k = 1:m
        [az(k), el(k), D(k)] = topocent(Xr(1:3), Xs(k,(1:3)));
        tropo(k) = tropo_error(h, el(k));
    end

    % iono calcualtion
    iono = iono_error(phi, lam, az, el, time_rx, ionoparams);
    
    % LS known term
    P0 = pr_C1;
    i_vector = ones(m,1);
    bs = D - s_light*dtS + tropo + iono;
    delta_P0 = P0 - bs;
    
    % E calculation
    E = zeros(m,3);
    for j=1:m
        E(j,1) = 1/D(j) * (Xr(1)-Xs(j,1));
        E(j,2) = 1/D(j) * (Xr(2)-Xs(j,2));
        E(j,3) = 1/D(j) * (Xr(3)-Xs(j,3));
    end
    
    % LS A matrix
    A = [E i_vector];
    
    % N Matrix calculation
    y_ = delta_P0;
    N = A'*A;

    % Least square solution for the corrections to the apriori
    delta = N\(A'*y_);
    
    % Estimated coordinates of the receiver:
    % approximate + estimated correction
    Xr = [Xr(1:3) 0] + delta';

    %check convergence of the result and, in case exit
    if norm(delta(1:3)) < th_convergence
        break
    end
    
    % check at the end that convergence did not fail
    if i == max_iter
        disp('Convergence failed');
    end
end
% to get clock offset divided by c
Xr(4)= Xr(4)/s_light;

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
fprintf('%f ', estimates);
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

fprintf('The clock offset of the receiver is: %f \n', Xr(4));
