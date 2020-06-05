function [corr] = iono_error_correction(lat, lon, az, el, time_rx, ionoparams)

% SYNTAX:
%   [corr] = iono_error_correction(lat, lon, az, el, time_rx, ionoparams, sbas);
%
% INPUT:
%   lat = receiver latitude    [degrees]
%   lon = receiver longitude   [degrees]
%   az  = satellite azimuth    [degrees]
%   el  = satellite elevation  [degrees]
%   time_rx    = receiver reception time
%   ionoparams = ionospheric correction parameters
%   sbas = SBAS corrections
%
% OUTPUT:
%   corr = ionospheric error correction
%
% DESCRIPTION:
%   Computation of the pseudorange correction due to ionospheric delay.
%   Klobuchar model or SBAS ionosphere interpolation.

    s_light = 299792458;

    F1 = 1575.420;  % GPS [MHz]
        
    [week, sow] = time2weektow(time_rx);
    if (nargin >= 6 & any(ionoparams))
        corr = klobuchar_model(lat, lon, az, el, sow, ionoparams);
    else
        corr = zeros(size(el));
    end

% -------------------------------------------------------------------------
% End of function - start nested function declaration
% -------------------------------------------------------------------------

    function [delay] = klobuchar_model(lat, lon, az, el, sow, ionoparams)
        
        %initialization
        delay = zeros(size(el));
        
        %-------------------------------------------------------------------------------
        % KLOBUCHAR MODEL
        %
        % Algorithm from Leick, A. (2004) "GPS Satellite Surveying - 2nd Edition"
        % John Wiley & Sons, Inc., New York, pp. 301-303)
        %-------------------------------------------------------------------------------
        
        %ionospheric parameters
        a0 = ionoparams(1);
        a1 = ionoparams(2);
        a2 = ionoparams(3);
        a3 = ionoparams(4);
        b0 = ionoparams(5);
        b1 = ionoparams(6);
        b2 = ionoparams(7);
        b3 = ionoparams(8);
        
        %elevation from 0 to 90 degrees
        el = abs(el);
        
        %conversion to semicircles
        lat = lat / 180;
        lon = lon / 180;
        az = az / 180;
        el = el / 180;
        
        f = 1 + 16*(0.53-el).^3;
        
        psi = (0.0137 ./ (el+0.11)) - 0.022;
        
        phi = lat + psi .* cos(az*pi);
        phi(phi > 0.416)  =  0.416;
        phi(phi < -0.416) = -0.416;
        
        lambda = lon + ((psi.*sin(az*pi)) ./ cos(phi*pi));
        
        ro = phi + 0.064*cos((lambda-1.617)*pi);
        
        t = lambda*43200 + sow;
        t = mod(t,86400);
        
        % for i = 1 : length(time_rx)
        %    while (t(i) >= 86400)
        %        t(i) = t(i)-86400;
        %    end
        %    while (t(i) < 0)
        %        t(i) = t(i)+86400;
        %    end
        %end
        
        % index = find(t >= 86400);
        % while ~isempty(index)
        %     t(index) = t(index)-86400;
        %     index = find(t >= 86400);
        % end
        
        % index = find(t < 0);
        % while ~isempty(index)
        %     t(index) = t(index)+86400;
        %     index = find(t < 0);
        % end
        
        a = a0 + a1*ro + a2*ro.^2 + a3*ro.^3;
        a(a < 0) = 0;
        
        p = b0 + b1*ro + b2*ro.^2 + b3*ro.^3;
        p(p < 72000) = 72000;
        
        x = (2*pi*(t-50400)) ./ p;
        
        %ionospheric delay
        index = find(abs(x) < 1.57);
        delay(index,1) = s_light * f(index) .* (5e-9 + a(index) .* (1 - (x(index).^2)/2 + (x(index).^4)/24));
        
        index = find(abs(x) >= 1.57);
        delay(index,1) = s_light * f(index) .* 5e-9;
    end
end
  