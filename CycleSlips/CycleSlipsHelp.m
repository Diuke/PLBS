% Ex06: DD analysis and cycle slip identification and repairing
% -------------------------------------------------------------------------
% Guidelines
% 
% Input data = 'CycleSlipsData.txt' text file with
%              col1 = epoch [s]
%              col2 = observed DD [m]
%              col3 = approx DD [m]
%
% 1) Import data in Matlab and graph observed DDs
% 2) For each epoch, compute differences between observed DDs and
%    approximated DDs (residual DDs) and graph them
% 3) For all the couples of consecutive epochs, compute differences between residual DDs 
%    and graph them
% 4) Identify cycle slips and repair them
% 5) Graph the repaired DDs
%
%
% Hints 
%  In step 1) use function 'importdata': 
%  In step 3) try to use function 'diff' instead of a for cycle
%
% * In step 4) use the algorithm explained in the lectures. In
% computation, use 19 cm for wavelenght and 0.20 cycle (3.8 cm) as
% threshold for cycle slips identification and repairing.

clear
close all

% Import data in Matlab and graph observed DDs
[newdata] = importdata('CycleSlipsData.txt', '	', 1);
idata = newdata.data;

threshold = 3.8*1e-2; % [m]
lam = 19*1e-2; % [m]

%% section 1
% For each epoch compute differences between observed DDs and approximated
% DDs (residual DDs) and graph them}
epochs = idata(:,1)';
observations = idata(:,2)';
baseline_approx = idata(:,3)';
differences = observations - baseline_approx;
figure;
plot(epochs, differences);

%% section 2
% Compute differences between consecutive epochs of residual DDs (hint: diff or for cycle) and graph them
diff_epochs = 1:(length(epochs)-1);
residuals = diff(differences);
figure;
plot(diff_epochs, residuals);

%% section 3
% Identify cycle slips and repair them (hint: just one for cycle with both the actions

for i = 1:length(diff_epochs)
    if abs(residuals(i)) > threshold
        x = residuals(i) / lam;
        n = round(x);
        if lam*abs(n - x) <= threshold
            for j = (i+1):length(observations)
                observations(j) = observations(j) - lam*n;
            end
            differences = observations - baseline_approx;
            residuals = diff(differences);
        end   
    end
end

%% section 4
% Graph the corrected DDs, the corrected residuals DDs and their differences in time
figure;
plot(diff_epochs, residuals); hold on;
plot(diff_epochs, residuals, '.g');
plot(diff_epochs, residuals, '-g');