%GC -> ITRF2014
clc;clear all;
%SECTION1

p0001LL = [99.9994;0.0;1.0174];
p0002LL = [80.0;85.0;2.0];
p0003LL = [-25.0;10.0;-3.0];

COMOx = 4398306.209 + (-0.0145)*(2019.09041096 - 2010.0);
COMOy = 704149.948 + 0.0181*(2019.09041096 - 2010.0);
COMOz = 4550154.733 + 0.0113*(2019.09041096 - 2010.0);
%-----WF1------
%Compute Geocentric Cartesian coordinates of COMO at 2019/02/02.
Como_GC = [COMOx;COMOy;COMOz];

std_XLL = 0.1;
std_YLL = 0.1;
std_ZLL = 0.15;

BRUN_LL = [0;0;0];

Xi = sex2deg(0, 0, 10.23);
Eta = sex2deg(0, 0, 9.5);

deltaComoBrun_GC = [-1040.168;-72.970;1631.398];
covDeltaComoBrun_GC = [2e-6 0.5e-6 0.5e-6;0.5e-6 1e-6 0.5e-6;0.5e-6 0.5e-6 2e-6];
deltaBrunP0001_GC = [-51.130;76.749;38.681];
covDeltaBrunP0001_GC = [1.5e-6 0.3e-6 0.3e-6;0.3e-6 1e-6 0.2e-6;0.3e-6 0.2e-6 2e-6];

%-----WF2------
%Compute BRUN coordinates in ITRF
Brun_GC = deltaComoBrun_GC + Como_GC;

%% SECTION2

%-----WF3------
%Compute Local Cartesian coordinates of 0001 with respect to BRUN
P0001_LC = GC2LC(deltaBrunP0001_GC,Brun_GC);

%-----WF4,5------
%Convert LC of 0001 to pseudo Local Level with respect to BRUN
%Compute alpha rotation between LC and LL in BRUN
Rot = RotLC2LL(P0001_LC, Xi, Eta);

%-----WF6------
%Compute LC of 0002 and 0003
P0002_LC = LL2LC(p0002LL, Rot);
P0003_LC = LL2LC(p0003LL, Rot);

%-----WF7------
%Compute GC of 0002 and 0003
P0001_GC = deltaBrunP0001_GC + Brun_GC; 
P0002_GC = LC2GC(Brun_GC, P0002_LC);
P0003_GC = LC2GC(Brun_GC, P0003_LC);
%remove ";" to show coordinates to convert to ETRF in website
vpa(P0001_GC);
vpa(P0002_GC);
vpa(P0003_GC);
vpa(Brun_GC);

%-----WF8------
% Transformation made in website 
% http://www.epncb.oma.be/_productsservices/coord_trans/index.php
% From ITRF2014 2019.33 to ETRF2014 2019.33
P0001_GC_ETRF = [4397215.21430  704153.33680 4551824.58020];
P0002_GC_ETRF = [4397183.09380  704084.32430 4551867.37610];
P0003_GC_ETRF = [4397272.15960  704050.76910 4551780.10460];
BRUN_GC_ETRF = [4397266.34430  704076.58780 4551785.89920];

%-----WF9------
%Compute ETRF geodetic coordinates of all the stations
P0001_GEO = double(vpa(cart2geo(P0001_GC_ETRF')',10))
P0002_GEO = double(vpa(cart2geo(P0002_GC_ETRF')',10))
P0003_GEO = double(vpa(cart2geo(P0003_GC_ETRF')',10))
BRUN_GEO = double(vpa(cart2geo(BRUN_GC_ETRF')',10))

%-----WF10------
%Propagate accuracies from LL to LC in BRUN
covComoInd = 0.001^2 + 0.0001^2*(2019.09041096 - 2010.0)^2;
covComo = [covComoInd 0 0;0 covComoInd 0;0 0 covComoInd]

covBrun = covComo + covDeltaComoBrun_GC

cov_11_ITRF = covBrun + covDeltaBrunP0001_GC

cov_22_LL = [std_XLL^2 0 0;0 std_YLL^2 0;0 0 std_ZLL^2];
cov_33_LL = cov_22_LL;

cov_22_LC = Rot*cov_22_LL*Rot';
cov_33_LC = Rot*cov_33_LL*Rot';


%-----WF11------
%Propagate accuracies from LC to ETRF geodetic coord in BRUN
RotLC2GC = RotLC2GC(Brun_GC);

deltaBrun_22 = RotLC2GC'*cov_22_LC*RotLC2GC;
cov_22_ITRF = covBrun + deltaBrun_22;

deltaBrun_33 = RotLC2GC'*cov_33_LC*RotLC2GC;
cov_33_ITRF = covBrun + deltaBrun_33;

cov_11 =  RotLC2GC*cov_11_ITRF*RotLC2GC';
cov_22 =  RotLC2GC*cov_22_ITRF*RotLC2GC';
cov_33 =  RotLC2GC*cov_33_ITRF*RotLC2GC';

cov_Brun_ENU = RotLC2GC*covBrun*RotLC2GC'

SIGMA_E_11 = sqrt(cov_11(1,1))
SIGMA_N_11 = sqrt(cov_11(2,2))
SIGMA_U_11 = sqrt(cov_11(3,3))

SIGMA_E_22 = sqrt(cov_22(1,1))
SIGMA_N_22 = sqrt(cov_22(2,2))
SIGMA_U_22 = sqrt(cov_22(3,3))

SIGMA_E_33 = sqrt(cov_33(1,1))
SIGMA_N_33 = sqrt(cov_33(2,2))
SIGMA_U_33 = sqrt(cov_33(3,3))

%% SECTION3
name = 'openstreetmap';
url = 'a.tile.openstreetmap.org';
copyright = char(uint8(169));
attribution = copyright + "OpenStreetMap contributors";
addCustomBasemap(name,url,'Attribution',attribution)
latitudes = [P0001_GEO(1) P0002_GEO(1) P0003_GEO(1) BRUN_GEO(1)];
longitudes = [P0001_GEO(2) P0002_GEO(2) P0003_GEO(2) BRUN_GEO(2)];
colordata = categorical(["P0001" "P0002" "P0003" "BRUN"], ["P0001" "P0002" "P0003" "BRUN"])

gb = geobubble(latitudes, longitudes, null(1), colordata, 'Basemap', 'openstreetmap');
gb.BubbleWidthRange = 10;
gb.MapLayout = 'maximized';
gb.ZoomLevel = 18;

