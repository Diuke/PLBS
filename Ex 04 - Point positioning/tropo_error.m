function [error] = tropo_error(eta,ellipsoidal_height)
    error = zeros(length(eta),1);
    if ellipsoidal_height < -200 || ellipsoidal_height > 10000
        return
    end
    Hr = 0.0; % relative humidity in the receiver site
    Pr = 1013.25; % [mb] mean standard pressure at mean sea level
    Tr =18; % [°C] mean standard temperature at mean sea level
    hr= 0.5; %  [%-->50%] mean standard humidity percentage at mean sea level                     
    P = (Pr) * mpower(1 - 0.0000226*(ellipsoidal_height - Hr),5.225);
    T = (Tr) - 0.0065*(ellipsoidal_height-(Hr)); % [C]
    h = (hr) * exp(-0.0006396*(ellipsoidal_height-(Hr)));
    error = (0.002277./sin(eta)) .* (P + (1255./(T+273.15) + 0.05).*h - 1./(tan(eta).^2));
    
    
end

