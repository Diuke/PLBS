function [phi, lam, h, phiC] = cart2geod(X, Y, Z)

% SYNTAX:
%   [phi, lam, h, phiC] = cart2geod(X, Y, Z);
%
% INPUT:
%   X = X axis cartesian coordinate
%   Y = Y axis cartesian coordinate
%   Z = Z axis cartesian coordinate
%
% OUTPUT:
%   phi = latitude
%   lam = longitude
%   h = ellipsoidal height
%   phiC = geocentric latitude
%
% DESCRIPTION:
%   Conversion from cartesian coordinates to geodetic coordinates.

%global a_GPS e_GPS

a = 6378137;
e = 0.0818191908426215;

%radius computation
r = sqrt(X.^2 + Y.^2 + Z.^2);

%longitude
lam = atan2(Y,X);

%geocentric latitude
phiC = atan2(Z,sqrt(X.^2 + Y.^2));

%coordinate transformation
psi = atan2(tan(phiC),sqrt(1-e^2));

phi = atan2((r.*sin(phiC) + e^2*a/sqrt(1-e^2) * (sin(psi)).^3) , ...
    			(r.*cos(phiC) - e^2*a * (cos(psi)).^3));

N = a ./ sqrt(1 - e^2 * sin(phi).^2);

%height
h = r .* cos(phiC)./cos(phi) - N;
lam = rad2deg(lam);
phi = rad2deg(phi);
phiC = rad2deg(phiC);
