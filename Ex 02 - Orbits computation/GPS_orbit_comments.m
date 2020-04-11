%GPSorbit_est.m
% http://www.navipedia.net/index.php/Clock_Modelling
% http://www.ajgeomatics.com/SatelliteOrbitsRev0828-2010.pdf
% http://www.navipedia.net/index.php/GPS_and_Galileo_Satellite_Coordinates_Computation

%clear all
close all
set(0,'DefaultFigureWindowStyle','docked');

% Load Almanac of satellite SVN 63, PRN 01 (Block IIR) for 2016
dt0 = -7.661711424589D-05;
dt1 = -3.183231456205D-12;
dt2 =  0.000000000000D+00;
sqrt_a = 5.153650835037D+03;
e = 3.841053112410D-03;
M0 = 1.295004883409D+00;
Omega0 = -2.241692424630D-01;
Omegadot = -8.386063598924D-09;
i0 = 9.634782624741D-01;
idot = -7.286017777600D-11;
w0 = 9.419793734505D-01;
wdot = 0.0;

GMe = 3.986005D+14;
OmegaEdot = 7.2921151467D-05;
 


%initialize vector of epochs

epoch = (0:30:86400);

%1) Compute clock offsets and plot it
syms t;

offset = subs(dt0 + dt1*t + dt2*t^2, t, epoch);

plot(epoch, offset, '*g');


% Initialize vector of positions

% Compute positions in ITRF, X, Y, Z
% Compute mean velocity

for Dt = 0 : t_step : (t_end - t0)
    % compute psi
    % compute r 
    % radius with respect to the center of the ellipse 
    % rotations of the orbital plane with the equatorial plane
    % orbital plane with the equatorial plante towards the greenwich meridian
    % rotate from OCRS to ITRF
end
%Convert X(t), Y(t), Z(t) to phi(t), la(t), r(t)

figure(1);

% H = subplot(m,n,p), or subplot(mnp), breaks the Figure window
% into an m-by-n matrix of small axes

% Plot groundtracks
subplot(3,1,1:2);
% axesm Define map axes and set map properties
ax = axesm ('eqdcylin', 'Frame', 'on', 'Grid', 'on', 'LabelUnits', 'degrees', 'MeridianLabel', 'on', 'ParallelLabel', 'on', 'MLabelParallel', 'south');
% geoshow Display map latitude and longitude data 
%  DISPLAYTYPE can be 'point', 'line', or 'polygon' and defaults to 'line'
geoshow('landareas.shp', 'FaceColor', 'black');
hold on
geoshow(##YourVariables, 'DisplayType', 'point', 'MarkerEdgeColor', 'green');
% axis EQUAL  sets the aspect ratio so that equal tick mark
% increments on the x-,y- and z-axis are equal in size.
% axis TIGHT  sets the axis limits to the range of the data.
axis equal; axis tight;

% Plot height of the satellite 
subplot(3,1,3);
plot(t(1:10:end), (##YourVariables, '.g');
title(['ellipsoidic height variations [km] around mean height = ' num2str(mean(##YourVariables) ' km']);
xlabel('seconds in one day (00:00 - 23:59 = 86400 sec)');
ylabel('[km]');
xlim([1 t(end)]);

% Print results on a file
fid = fopen('GPS_KeplerianOrbit_6parameters.txt','w');

fprintf(fid,'EXPORT FROM MATLAB: GPS_orbit_est.m \n\n');
fprintf(fid,' * Coordinates ORS (xF, yF) || Coordinates ITRF (x, y, z) || Coordinates phi, lambda, h ell\n\n');
for i = 1 : length(##YourVariables)
    fprintf(fid, ' %15.6f  %15.6f %15.6f || %15.6f  %15.6f  %15.6f || %15.6f  %15.6f  %15.6f \n', ##YourVariables);
end
fprintf(fid, '\n');


fclose(fid);        %or fclose('all');

save solution2.mat
