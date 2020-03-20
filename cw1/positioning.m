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
Como_GC = [COMOx;COMOy;COMOz];
como1 = vpa(cart2geo(Como_GC'));

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
Brun_GC = deltaComoBrun_GC + Como_GC;

%% SECTION2

%-----WF3------
P0001_LC = GC2LC(deltaBrunP0001_GC,Brun_GC);

%-----WF4,5------
Rot = RotLC2LL(P0001_LC, Xi, Eta);

%-----WF6------
P0002_LC = LL2LC(p0002LL, Rot);
P0003_LC = LL2LC(p0003LL, Rot);

%-----WF7------
P0001_GC = deltaBrunP0001_GC + Brun_GC; 
P0002_GC = LC2GC(Brun_GC, P0002_LC);
P0003_GC = LC2GC(Brun_GC, P0003_LC);
vpa(P0001_GC)
vpa(P0002_GC)
vpa(P0003_GC)
vpa(Brun_GC)

%-----WF8------
% Transformation made in website 
% http://www.epncb.oma.be/_productsservices/coord_trans/index.php
% From ITRF2014 2019.33 to ETRF2014 2019.33
P0001_GC_ETRF = [4397215.21430  704153.33680 4551824.58020];
P0002_GC_ETRF = [4397183.09380  704084.32430 4551867.37610];
P0003_GC_ETRF = [4397272.15960  704050.76910 4551780.10460];
BRUN_GC_ETRF = [4397266.34430  704076.58780 4551785.89920];

%-----WF9------
P0001_GEO = vpa(cart2geo(P0001_GC_ETRF')',10)
P0002_GEO = vpa(cart2geo(P0002_GC_ETRF')',10)
P0003_GEO = vpa(cart2geo(P0003_GC_ETRF')',10)
BRUN_GEO = vpa(cart2geo(BRUN_GC_ETRF')',10)
