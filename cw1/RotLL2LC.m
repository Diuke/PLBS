function [ R ] = RotLL2LC( x_lc1, xi, eta )
    Rx = [1 0 0;0 cos(xi) -sin(xi);0 sin(xi) cos(xi)];
    Ry = [cos(eta) 0 -sin(eta);0 1 0;sin(eta) 0 cos(eta)];
    
    xtemp = Ry * Rx * x_lc1;
    alpha = atan(xtemp(2)/xtemp(1));
    
    Rz = [cos(alpha) sin(alpha) 0;-sin(alpha) cos(alpha) 0; 0 0 1];
    R = Rz * Ry * Rx;
end

