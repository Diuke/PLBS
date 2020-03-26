function [geo] = cart2geo(x0)
    x = x0(1); y = x0(2); z = x0(3);
    f = 1/298.257222101;
    a = 6378137;
    e = 0.081819191042815788368535232003625;
    b = a*(1-f);
    e2b = (a^2 - b^2) / b^2;
    r = sqrt(x^2 + y^2);
    psi = atan(z/(r*sqrt(1-e^2)));
    
    lam = atand(y/x);
    phi = atand((z + e2b * b * sin(psi).^3)/(r - e^2 * a * cos(psi).^3));
    RN = a/(sqrt(1 - e^2 * sin(deg2rad(phi)).^2));
    h = r/cos(deg2rad(phi)) - RN;
    geo = [phi;lam;h];
end

