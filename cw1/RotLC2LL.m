function [ R ] = RotLC2LL( x_lc1, xi, eta )
    xiRad = deg2rad(xi);
    etaRad = deg2rad(eta);
    Rx = [1 0 0; 0 1 -xiRad; 0 xiRad 1];
    Ry = [1 0 -etaRad; 0 1 0; etaRad 0 1];
    
    xtemp = Ry * Rx * x_lc1
    alpha = atan(xtemp(2)/xtemp(1))
    
    Rz = [cos(alpha) sin(alpha) 0;-sin(alpha) cos(alpha) 0; 0 0 1];
    R = Rz * Ry * Rx;
end

