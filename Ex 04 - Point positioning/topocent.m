function [az, el, d] = topocent(Xr, Xs)

[phi, lam] = cart2geod(Xr(1), Xr(2), Xr(3));

phi = phi*pi()/180;
lam = lam*pi()/180;

cp = cos(phi);  sp = sin(phi);
cl = cos(lam);  sl = sin(lam);

R = [-sl, cl, 0;
    -sp*cl, -sl*sp, cp;
    cp*cl, cp*sl, sp];

local_vector = (Xs - Xr)*R';

E = local_vector(1);
N = local_vector(2);
U = local_vector(3);

%azimuth
az = atan2(E,N)/pi*180;
az(az<0) = az(az<0) + 360;

%elevation
dist = sqrt(E^2 + N^2);
el = atan2(U, dist)/pi*180;

%receiver to satellite distance
d = norm(Xs - Xr);


