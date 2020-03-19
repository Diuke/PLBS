function [ phi,lam,h ] = cart2geo( x,y,z )
    a = 6378137;
    b = 6356752.314140347;
    e = 0.0818191910435;
    
    e2b = (a^2 - b^2) / b^2;
    r = sqrt(x^2 + y^2);
    psi = atan(z/(r*sqrt(1-e^2)));
    
    lam = atan(y/x);
    phi = atan((z + e2b^2 * b * sin(psi).^3)/(r - e^2 * a * cos(psi).^3));
    RN = a/(sqrt(1 - e^2 * sin(phi).^2));
    h = r/cos(phi) - RN;
end

