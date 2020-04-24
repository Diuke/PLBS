clc
clear all

%getting obs values
run('Ex04_variables.m')

%initialization of parameters

%max number of iterations
%threshold for convergence
X_init = [0 0 0 0]; %approx coordinates of the receiver and clock offset
% storage of iterate results
% Least squares iteration
for i=1:max_iter
    % topocentric positions of all satellites
    % approximate geodetic coordinates of the receiver
    % tropospheric and ionospheric corrections
    % LS known term
    % LS A matrix
    % Least square solution for the corrections to the apriori
    % Estimated coordinates of the receiver: 
    % approximate + estimated correction

    %check convergence of the result and, in case exit
    if max(abs(delta(1:3))) < th_convergence
        break
    end
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