function [ gc ] = LC2GC(x0, enu)
    geodetic = cart2geo(x0);
    phi = geodetic(1);lam = geodetic(2);h = geodetic(3);
    R = [-sin(lam) cos(lam) 0;-sin(phi)*cos(lam) -sin(phi)*sin(lam) cos(phi);cos(phi)*cos(lam) cos(phi)*sin(lam) sin(phi)]
    
    gc = R' * enu + x0;
end

