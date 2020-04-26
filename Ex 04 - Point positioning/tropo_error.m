function [error] = tropo_error(eta,ellipsoidal_height)
    if ellipsoidal_height < 0
        ellipsoidal_height = 0;
    end
    Hr = 0.0; %/* [m] */
    Pr = 1013.25; %/* [mb] */
    Tr =18; %/* [°C] */
    hr= 0.5; % /* [%-->50%] */                     
    P = (Pr) * (1 - 0.0000226*mpower(ellipsoidal_height - Hr,5.225));
    T = (Tr) - 0.0065*(ellipsoidal_height-(Hr)); %  /* [C] */
    h = (hr) * exp(-0.0006396*(ellipsoidal_height-(Hr)));
    Trp_delay = (0.002277/sin(eta)) * (P + (1255/(T+273.15) + 0.05)*h - 1./(tan(eta).^2));
    
    error = Trp_delay;
end

