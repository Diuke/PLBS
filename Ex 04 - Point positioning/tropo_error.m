function [tropo] = tropo_error(h, el)

%   Saastamoinen model computation.

    if h > 5000
        tropo = 0;
    else
        %if heigth is less than -200, h = -200
        h = max(-200,h);
        
        %conversion to radians
        el = abs(el) * pi/180;

        % Standard values
        PRES = 1013.25;                           % pressure 
        TEMP = 291.15;                            % temperature 
        HUMI = 50.0;                              % humidity 


        %temperature
        T = TEMP;
        Tr = T - 0.0065*h;

        %humidity
        H = HUMI;
        Hr = H * exp(-0.0006396*h);
       
        %pressure
        P = PRES;
        Pr = P*(1-0.0000226*h)^5.225;

        er = 0.01*Hr*exp(-37.2465 + 0.213166*Tr - 0.000256908*Tr^2);
     
        %tropo delay
        tropo = (0.002277/sin(el))*(Pr + (1255/Tr + 0.05)*er - tan(el)^-2);

end
