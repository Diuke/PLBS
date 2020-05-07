    % Compute the coordinates of a GPS receiver using one epoch of pseudorange
% observations and the given position of the satellites in view
%
% Meaning of the variables 
%  - time_rx        epoch of observation
%  - pr_C1          array pseudo range observations 
%  - sat_ids        array with the list of the satellites IDs
% 
%  - xyz_sat        estimated positions of the satellites
%  - dtS            estimated clock error of the satellites
%  - ionoparams     8 iono parameters
%
%  - xyz_real       "real" position of the receiver, to check the quality
%                   of your computation
%
% Useful functions:
%  - [az, el, dist] = topocent(xyz_approx, xyz_sat);
%  - [phiR, lamR, hR] = cart2geod(xyz_approx(1), xyz_approx(2), xyz_approx(3));
%  - err_tropo = tropo_error_correction(time_rx, phiR, lamR, hR, el);
%  - err_iono = iono_error_correction(phiR, lamR, az, el, time_rx, ionoparams, []);
%
% Use 5 iterations of linearized LS
% Hint: to compute the satellite ionospheric and troposferic errors
% you need at least a rough estimation of the receiver position.
% Start your iterations using the center of the Earth as approximate
% positions for the receiver.
%
% Compute PDOP, the coordinates of the receiver, the error of the
% estimation, and the covariance matrix of the error
%
% Bonus, try to ignore the satellite below 5 degree of elevation
%

s_light = 299792458; % speed of light

% Observation block as extracted from the rinex file
obs_head = '16  7 22  2  0  0.0010000  0 11G28G05G13G07G20G09G08G02G21G30G15';
obs_block = [
'  22578312.093   -13203438.42828      2191.9622         48.0002'
'  20984179.054   -20727820.82827        78.7872         47.0002'
'  22340643.025   -16367083.16328      2092.2242         49.0002'
'  21815745.186   -12544784.50127     -2709.6602         47.0002'
'  23719962.313    -9392713.37427      2643.6122         45.0002'
'  24558115.868     4617804.87825     -3524.9392         35.0002'
'  25751171.706     -823641.26426      1233.4482         38.0002'
'  24359848.780    -2100338.14827     -3325.5292         44.0002'
'  26560055.854     -481626.76626      1250.1762         40.0002'
'  20547846.341   -20792798.64228     -1329.0502         50.0002'
'  25187331.212    -3058072.84025      2811.4132         32.0002'];

% Read time of observation
data   = sscanf(obs_head(1:26),'%f');
year   = 2016;
month  = data(2);
day    = data(3);
hour   = data(4);
minute = data(5);
second = data(6);

% Convert it in GPS double format
[week, tow] = date2gps([year, month, day, hour, minute, second]);
[time_rx] = weektow2time(week, tow, 'G');

% get the number of satellites
n_sat = str2num(obs_head(30:31));

% satellite list
sat_list = obs_head(32:end);

% ids of the satellites in view
sat_ids = zeros(n_sat,1);

% store observed pseudorange of code 
pr_C1 = zeros(n_sat,1);
for s = 1 : n_sat
    sat_ids(s) = str2double(sat_list((s-1)*3 + (2:3)));
    pr_C1(s) = str2double(obs_block(s,3:14));
end

% satellite positions and clock error at the observation epoch:
% from the function [xyz_sat dtS] = get_sat_pos(obs_head(1:25));
xyz_sat =    1.0e+07 * [
   2.266904303720417   1.376019580610336   0.242665876089085;
   1.793483097238855  -0.684611592059353   1.836848309959032;
   1.237349240389060  -1.488069273671674   1.810628493493055;
   0.682633532041234   1.366381869196001   2.184884029980142;
   0.141020153293916  -1.610493243878792   2.092127478822572;
   0.710758426920100   2.494566375976196   0.565262210580487;
  -0.670387964847087   2.192133222131345   1.342746581584370;
   2.183170669948725  -1.415437238094089  -0.371984191760939;
  -1.019768755765267  -1.243833666228832   2.189467478141541;
   1.528675973015969   0.745824912302640   2.042145267368744;
   0.467596411393501  -2.316970109165663   1.162832980243857];

dtS = [
      0.000538885950029137
     -0.000103714172891042
     -3.26664571204891e-05
      0.000440397108129438
      0.000425625330509237
      0.000171981683578018
     -4.36651382082638e-05
      0.000573964626877986
     -0.000528855944540131
      0.000141099019219313
     -0.000320324134333714];
    
 line1 = 'GPSA   0.7451D-08  0.1490D-07 -0.5960D-07 -0.1192D-06       IONOSPHERIC CORR';
 line2 = 'GPSB   0.9216D+05  0.1311D+06 -0.6554D+05 -0.5243D+06       IONOSPHERIC CORR';
 ionoparams = [cell2mat(textscan(line1, '%*s %f %f %f %f %*s')) ...
     cell2mat(textscan(line2, '%*s %f %f %f %f %*s'))]; 

% "real" coordinates of the rover point (to check the final precision of the computation)
% xyz_real = [4407345.9683   700838.7444  4542057.2866];

% END OF TEXT -------------------------------------------------------------
