%load parameters
line1 = 'GPSA 7.4506D-09 1.4901D-08 -5.9605D-08 -1.1921D-07 IONOSPHERIC CORR';
line2 = 'GPSB 9.2160D+04 1.3107D+05 -6.5536D+04 -5.2429D+05 IONOSPHERIC CORR';
ionoparams = [cell2mat(textscan(line1, '%*s %f %f %f %f %*s')) ...
cell2mat(textscan(line2, '%*s %f %f %f %f %*s'))];
% zenithal maps of Iono corrections

%initialize values for the zenital cycle
elevation = 90; %degrees
latitude = (-80:0.5:80); %degrees
longitude = (-180:0.5:180); %degrees
azimuth = 0;
time = [0 6 12 18]*3600;

%initialize matrix
Iono_map1 = zeros(length(longitude), length(latitude),length(time));

%time, phi and lambda cycle
for t = 1 : length(time)
    for p = 1 : length(latitude)
        for l = 1 : length(longitude)
            %compute iono zenithal
            Iono_map1(l,p,t) = iono_error_correction(latitude(p), longitude(l), azimuth, elevation, time(t), ionoparams,[]);
        end
    end
end

% plots
[phi_grid,lambda_grid] = meshgrid(latitude,longitude);
figure(1)
title('Ionospheric Error Maps')
for i = 1:length(time)
    subplot(2,2,i);
    geoshow(phi_grid, lambda_grid, Iono_map1(:,:,i), 'DisplayType','texturemap','facealpha',.5)
    hold on
    geoshow('landareas.shp', 'FaceColor', 'none');
    title(['time = ', num2str(time(i)/3600),':00']);
    xlabel('longitude [deg]')
    ylabel('latitude [deg]')
    xlim([-180 180]);
    ylim([-80 80]);
    colormap(jet);
end
hp4 = get(subplot(2,2,4),'Position');
colorbar('Position', [hp4(1)+hp4(3)+0.028  hp4(2)  0.03  hp4(2)+hp4(3)*2.1]);


%% polar maps of ionospheric error corrections

%%polar map in Milano
% Milano position in degrees
phi2 = 45 + 28 / 60 + 38.28 / 60^2; %degrees
lambda2 = 9 + 10 / 60 + 53.40 / 60^2; %degrees

%inizialize values for the cycle
elevation2 = 0:0.5:90; %degrees
azimuth2 = -180:0.5:180; %degrees
time2 = [0 12]*3600;
% matrix inizialization

Iono_map2 = zeros(length(elevation2),length(azimuth2),length(time2));

%time, elevation and azimuth cycle 
for t = 1 : length(time2)
    for el = 1 : length(elevation2)
        for a = 1 : length(azimuth2)
            % compute iono corrections for az and el
            Iono_map2(el,a,t) = iono_error_correction(phi2, lambda2, azimuth2(a), elevation2(el), time2(t), ionoparams,[]);
        end
    end
end

%plots
[Az, El] = meshgrid(azimuth2, elevation2);
for i = 1 : length(time2)
    figure(i + 1)
    title(['Ionospheric Error Polar Map for Milan Observer time = ', num2str(time2(i)/3600),':00'])
    axesm('eqaazim', 'MapLatLimit', [0 90]);
    axis off
    framem on
    gridm on

    mlabel on
    plabel on;
    setm(gca,'MLabelParallel',0)
    geoshow(El, Az, Iono_map2(:,:,i), 'DisplayType','texturemap', 'facealpha',.6)
    colormap(jet)

    hcb = colorbar('eastoutside');
    set(get(hcb,'Xlabel'),'String','Legend')
end

