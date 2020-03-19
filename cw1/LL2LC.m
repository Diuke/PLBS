function [ LC ] = LL2LC(LL, eta, xi)

Rx = [1 0 0; 0 1 -xi; 0 xi 1];
Ry = [1 0 -eta; 0 1 0; eta 0 1];
Rtemp = 

alpha = atan(LL(1)/LL(2));
Rz = [cos(alpha) sin(alpha) 0; -sin(alpha) cos(alpha) 0; 0 0 1];


end

