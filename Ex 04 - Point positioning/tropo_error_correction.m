function [corr] = tropo_error_correction(time_rx, lat, lon, h, el)

% SYNTAX:
%   [corr] = tropo_error_correction(time_rx, lat, lon, h, el);
%
% INPUT:
%   time_rx = receiver reception time
%   lat = receiver latitude          [degrees]
%   lon = receiver longitude         [degrees]
%   h  = receiver ellipsoidal height [meters]
%   el = satellite elevation         [degrees]
%
% OUTPUT:
%   corr = tropospheric error correction
%
% DESCRIPTION:
%   Computation of the pseudorange correction due to tropospheric refraction.
%   Saastamoinen algorithm.

%----------------------------------------------------------------------------------------------
%                           goGPS v0.4.3
%
% Copyright (C) 2009-2014 Mirko Reguzzoni, Eugenio Realini
%
% Portions of code contributed by Laboratorio di Geomatica, Polo Regionale di Como,
%    Politecnico di Milano, Italy
%----------------------------------------------------------------------------------------------

tropo_model = 1;

switch tropo_model
    case 0 %no model
        corr = zeros(size(el));
    case 1 %Saastamoinen model (with standard atmosphere parameters)
        corr = saastamoinen_model(lat, lon, h, el);
    case 2 %Saastamoinen model (with Global Pressure Temperature model)
        corr = saastamoinen_model_GPT(time_rx, lat, lon, h, el);
end

% -------------------------------------------------------------------------
% End of function - start nested function declaration
% -------------------------------------------------------------------------

    function [delay] = saastamoinen_model(lat, lon, h, el)        
        if (h < 5000)
            
            %conversion to radians
            el = abs(el) * pi/180;
            
            %Standard atmosphere - Berg, 1948 (Bernese)
            %pressure [mbar]
            STD_PRES = 1013.25;                           % pressure [mbar]
            STD_TEMP = 291.15;                            % temperature [K]
            STD_HUMI = 50.0;                              % humidity [%]

            Pr = STD_PRES;
            %temperature [K]
            Tr = STD_TEMP;
            %humidity [%]
            Hr = STD_HUMI;
            
            P = Pr * (1-0.0000226*h).^5.225;
            T = Tr - 0.0065*h;
            H = Hr * exp(-0.0006396*h);
            
            %----------------------------------------------------------------------
            
            %linear interpolation
            h_a = [0; 500; 1000; 1500; 2000; 2500; 3000; 4000; 5000];
            B_a = [1.156; 1.079; 1.006; 0.938; 0.874; 0.813; 0.757; 0.654; 0.563];
            
            t = zeros(length(T),1);
            B = zeros(length(T),1);
            
            for i = 1 : length(T)
                
                d = h_a - h(i);
                [~, j] = min(abs(d));
                if (d(j) > 0)
                    index = [j-1; j];
                else
                    index = [j; j+1];
                end
                
                t(i) = (h(i) - h_a(index(1))) ./ (h_a(index(2)) - h_a(index(1)));
                B(i) = (1-t(i))*B_a(index(1)) + t(i)*B_a(index(2));
            end
            
            %----------------------------------------------------------------------
            
            e = 0.01 * H .* exp(-37.2465 + 0.213166*T - 0.000256908*T.^2);
            %tropospheric delay
            delay = ((0.002277 ./ sin(el)) .* (P - (B ./ (tan(el)).^2)) + (0.002277 ./ sin(el)) .* (1255./T + 0.05) .* e);
        else
            delay = zeros(size(el));
        end
    end

    function [delay] = saastamoinen_model_GPT(time_rx, lat, lon, h, el)        
        delay = zeros(size(el));
        
        [week, sow] = time2weektow(time_rx);
        date = gps2date(week, sow);
        [~, mjd] = date2jd(date);
        
        [pres, temp, undu] = gpt(mjd, lat*pi/180, lon*pi/180, h);
        ZHD_R = saast_dry(pres, h - undu, lat);
        ZWD_R = saast_wet(temp, goGNSS.STD_HUMI, h - undu);

        for s = 1 : length(el)
            [gmfh_R, gmfw_R] = gmf_f_hu(mjd, lat*pi/180, lon*pi/180, h, (90-el(s,1))*pi/180);
            delay(s,1) = gmfh_R*ZHD_R + gmfw_R*ZWD_R;
        end
    end
end
