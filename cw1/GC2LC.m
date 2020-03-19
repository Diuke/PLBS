function [ENU] = GC2LC(deltaX, x0)
     geodetic = cart2geo(x0);
     phi = geodetic(1);lam = geodetic(2);
     R0 = [-sin(lam) cos(lam) 0;
          -sin(phi)*cos(lam) -sin(phi)*sin(lam) cos(phi);
           cos(phi)*cos(lam) cos(phi)*sin(lam) sin(phi)];
     
    ENU = R0*deltaX;
end

