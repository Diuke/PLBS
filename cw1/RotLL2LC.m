function [ R ] = RotLL2LC( x_lc1, xi, eta )
xi
eta
    Rx = [1 0 0; 0 1 -xi; 0 xi 1];
    Ry = [1 0 -eta; 0 1 0; eta 0 1];
    
    xtemp = Ry * Rx * x_lc1;
    alpha = atan(xtemp(2)/xtemp(1));
    
    Rz = [cos(alpha) sin(alpha) 0;-sin(alpha) cos(alpha) 0; 0 0 1];
    R = Rz * Ry * Rx;
end

