function [phi, lam, h, phiC] = cart2geod(x, y, z)
    
    % WGS84 parameters:
    a = 6378137;            
    f = 1/298.257223563;    
    e = sqrt(2*f - f^2); 

    % Latitude and grand-normal:
    if z == 0
        phi = 0;
        N = a;
    else
        phi = atan2(z, sqrt(x^2 + y^2));
        eps = 1;
        k = 0;
        
        threshold = 1e-9;
        while eps>threshold && k<20
            N = a / sqrt(1 - e^2 * sin(phi)^2);
            phi_i = atan(z/sqrt(x^2 + y^2)*(1+ e^2 * N * sin(phi)/z));
            eps = abs(phi_i - phi);
            phi = phi_i;
        end
    end


    % Longitude:
    lam = atan2(y, x);

    % Ellipsoidal height:
    h = sqrt(x^2 + y^2) / cos(phi) - N;

    % Conversion
    phi = phi*180/pi();
    lam = lam*180/pi();
    %phiC for compatibility
    phiC = 0;
end

