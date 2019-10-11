%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [Ids Q gds ggs CGS CGD CGB CBS CBD] ...
    = Pmos1entries(Mosfets1,x)
%
% see N-MOS for details
% Vds -> -Vds
% Vgs -> -Vgs
% -Vbs -> Vbs
% Ids -> -Ids
% Vto -> -Vto
%%

nd = Mosfets1(1);
ng = Mosfets1(2);
ns = Mosfets1(3);
nb = Mosfets1(4);

if nd==0, xnd=0;        else xnd = x(nd); end
if ng ==0, xng = 0;     else xng = x(ng); end
if ns ==0, xns = 0;     else xns = x(ns); end
if nb ==0, xnb = 0;     else xnb = x(nb); end


%------------- default values ---------------------
VT0 = 0.0;
KP = 2e-5;              gamma = 0;
mu0 = 600;          phif = .1/2;            lambda = 0.0;
Nb = 0;             tox = 1e-7;
Nss = 0;            Is = 1e-14;             Js = 1e-14;
Rs = 0;             Rd = 0;                 rhos = inf;
CBS = 0;            CBD = 0;                Cjo = 0.32e-3;
mj = 0.5;           phibi = 0.8;
Cjswo = 0.11e-9;          mjsw = 0.5;
Cgso = 0;           Cgdo = 0;               Cgbo = 0;
KF = 0;             AF = 1;                 TPG = 1;
L = 1e-4;           W = 1e-4;
As = 0;             Ad = 0;
Ps = 0;             Pd = 0;
NRS = 1;            NRD = 1;
%---------------

%Mosfets1(1,:) = [vt0, kp, w, L, LD, lambda];
%Mosfets1(1,:) = [.2, 2e-5, 20e-6, 1e-6, 0, 0];

eps0 = 8.8542e-12;  % may have wrong units here (BNB 5/14/8)
%eps0 = 8.8542e-11;  % may have wrong units here (BNB 5/14/8)
epsox = 3.9;  % unsure about this one (BNB 5/14/8)
%---------------------------------------------
if size(Mosfets1,2) > 5
    W = Mosfets1(6);         L = Mosfets1(7);    
    if size(Mosfets1,2) > 7
        VT0 = Mosfets1(8);       lambda = Mosfets1(9);    
        KP = Mosfets1(10);
    end
end

%AS & PS, AD & PD parameter
D = 1e-6;
As = W * 5 * D;
Ad = W * 5 * D;
Ps = 2*W + 10 * D;
Pd = 2*W + 10 * D;

Cox = eps0*epsox/tox;
%Cox = 0;

VSB = xns-xnb;
VDS = xnd-xns;
VGS = xng-xns;
VGD = xng-xnd;

% PMOS Corrections
VDS = -VDS;
VGS = -VGS;
VSB = -VSB;
VT0 = -VT0;


VTH = VT0 + gamma*( sqrt(2*phif + VSB) - sqrt(2*phif) );
VGT = VGS-VTH;

Bayta0 = KP*(W/L);
Coxt = W*L*Cox;

Q = 0;  % FIGURE THIS OUT... (BNB 5/13/8)

if VGT < 0
    if VGT < -2*phif
        Ids = 0;
        Cgs = 0;
        Cgd = 0;
        Cgb = Coxt;
        gds = 0;
        ggs = 0;
     %   disp('a');
    else
        Ids = 0;
        gds = 0;
        ggs = 0;
%         Cgs = 2/3*Coxt*( (VGS-VTH)/phif + 1 );
        Cgs = Coxt;
        Cgd = 0;
        %Cgb = Coxt*( 1 + 4/gamma^2*(Vgb-Vfb) )^(-1/2);
        Cgb = 0;  % figure this out later, what is Vgb, Vfb?
       % disp('b');
    end
elseif VDS > VGT
    Ids = 0.5*Bayta0*(VGT)^2*(1+lambda*VDS);
    gds = 0.5*Bayta0*(VGT)^2*lambda;
    ggs = 0.5*Bayta0*2*VGT*(1+lambda*VDS);
    Cgs = 2/3*Coxt;
    Cgd = 0;
    Cgb = 0;
 %   disp('c');
elseif VDS <= VGT
    Ids = Bayta0 * ((VGT - .5*VDS)*VDS)*(1+lambda*VDS);
    gds = Bayta0 * (VGT-VDS)*(1+lambda*VDS) + Bayta0*lambda*((VGT-.5*VDS)*VDS);
    ggs = Bayta0 * VDS*(1+lambda*VDS);
%     Cgs = 2/3*Coxt*( 1 - (VGT)^2 / (VGD + VGS - 2*VTH)^2 );
%     Cgd = 2/3*Coxt*( 1 - (VGT)^2 / (VGD + VGS - 2*VTH)^2 );
    Cgs = 1/2*Coxt;
    Cgd = 1/2*Coxt;    
    Cgb = 0;
 %   disp('d');
else
    error('Check for NaN or Inf or something...')
end

Ids = -Ids;  % PMOS CORRECTION


%%%%%%%%%%
% extrinsive overlap capacitances
CGSO = Cgso*W;
CGDO = Cgdo*W;
CGBO = Cgbo*L;

%CBS = ( Cjo*As / (1-V/phibi)^mj ) + ( Cjswo*Ps / (1-V/phibi)^mjsw );
CBS = As*Cjo + Ps*Cjswo;
CBD = Ad*Cjo + Pd*Cjswo;

% total capacitances
CGS = Cgs + CGSO;
CGD = Cgd + CGDO;
CGB = Cgb + CGBO;

%%%%%%%%%%%%
