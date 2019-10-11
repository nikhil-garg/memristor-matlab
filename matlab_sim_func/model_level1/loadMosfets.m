%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [F J C dbg] = loadMosfets(Mosfets,x,maxnode,branches,NorP)

%--------------------------------------------------------
%          Vd           Vg           Vs           Vb
%      [ CGD+CBD       -CGD          0           -CBD     ]  d
%  C = [  -CGD      CGD+CGB+CGS     -CGS         -CGB     ]  g
%      [   0           -CGS        CGS+CBS       -CBS     ]  s
%      [  -CBD         -CGB         -CBS      CBD+CGB+CBS ]  b
%
%
%
%         Vd            Vg           Vs           Vb
%      [ gds+gbd+gdb   ggs     -gmbs-ggs-gds   gmbs-gbd-gdb ]  d
%  G = [    0           0           0               0       ]  g
%      [  -gds        -ggs   gbs+gds+ggs+gmbs   -gbs-gmbs   ]  s
%      [ -gdb-gbd       0         -gbs         gbs+gbd+gdb  ]  b
%
%
%--------------------------------------------------------

%%

numMs = size(Mosfets,1);
dbg=[];
if numMs>0
    F = zeros(maxnode+branches,1);
    Q = zeros(maxnode+branches,1);
    J = spalloc(maxnode+branches,maxnode+branches,16*numMs);
    C = spalloc(maxnode+branches,maxnode+branches,16*numMs);
else
    F=0; Q=0; J=0; C=0;    
end

for im = 1:numMs
    nd = Mosfets(im,1);
    ng = Mosfets(im,2);
    ns = Mosfets(im,3);
    nb = Mosfets(im,4);

    if nd==0,  xnd = 0;     else xnd = x(nd); end
    if ng ==0, xng = 0;     else xng = x(ng); end
    if ns ==0, xns = 0;     else xns = x(ns); end
    if nb ==0, xnb = 0;     else xnb = x(nb); end

    moslevel = Mosfets(im,5);


%% Compute the entries

    % matrix entries (conductances, capacitances)
    gds = 0;        ggs = 0;         gmbs = 0;
    gbs = 0;        gbd = 0;        gdb = 0;


    CGS = 0;        CGD = 0;        CGB = 0;
    CBD = 0;        CBS = 0;

    % function entries (currents, charges)
    Ids = 0;        Q = 0;

    if strcmp(NorP,'N')
        if moslevel == 1
            [Ids Q gds ggs CGS CGD CGB CBS CBD] = Nmos1entries(Mosfets(im,:),x);
        elseif moslevel == 2

        elseif moslevel == 3

        elseif moslevel == 4
            [Ids Q gds ggs CGS CGD CGB CBS CBD] = Nmos4entries(Mosfets(im,:),x);
        else
            error('Do not know this MOSFET model...')
        end
    elseif strcmp(NorP,'P')
        if moslevel == 1
            [Ids Q gds ggs CGS CGD CGB CBS CBD] = Pmos1entries(Mosfets(im,:),x);
        elseif moslevel == 2

        elseif moslevel == 3

        elseif moslevel == 4

        else
            error('Do not know this MOSFET model...')
        end
    else
        error('Quelle Mosfet type?')
    end
    1;
%%    Fill in the matrices



    %% diagonal entries
    if nd>0,
        F(nd,1) = F(nd) + Ids;
        J(nd,nd) = J(nd,nd) + gds + gbd + gdb;
        C(nd,nd) = C(nd,nd) + CGD + CBD;
    end

    if ng > 0,
        F(ng,1) = F(ng) + 0;
        J(ng,ng) = J(ng,ng) + 0;
        C(ng,ng) = C(ng,ng) + CGD + CGS + CGB;
    end

    if ns > 0
        F(ns,1) = F(ns) - Ids;
        J(ns,ns) = J(ns,ns) + gds + ggs + gbs + gmbs;
        C(ns,ns) = C(ns,ns) + CGS + CBS;
    end

    if nb > 0
        F(nb,1) = F(nb) + 0;
        J(nb,nb) = J(nb,nb) + gbs + gbd + gdb;
        C(nb,nb) = C(nb,nb) + CBS + CGB + CBD;
    end

    %% Off-diagonals
    if nd>0 && ng > 0
        J(nd,ng) = J(nd,ng) + ggs;
        J(ng,nd) = J(ng,nd) - 0;
        C(nd,ng) = C(nd,ng) - CGD;
        C(ng,nd) = C(ng,nd) - CGD;
    end

    if nd>0 && ns > 0
        J(nd,ns) = J(nd,ns) - gds - ggs - gmbs;
        J(ns,nd) = J(ns,nd) - gds;
        C(nd,ns) = C(nd,ns) + 0;
        C(ns,nd) = C(ns,nd) + 0;
    end

    if ns>0 && ng > 0
        J(ng,ns) = J(ng,ns) - 0;
        J(ns,ng) = J(ns,ng) - ggs;
        C(ng,ns) = C(ng,ns) - CGS;
        C(ns,ng) = C(ns,ng) - CGS;
    end

    if ns>0 && nb > 0
        J(nb,ns) = J(nb,ns) - gbs;
        J(ns,nb) = J(ns,nb) - gbs-gmbs;
        C(nb,ns) = C(nb,ns) - CBS;
        C(ns,nb) = C(ns,nb) - CBS;
    end

    if ng>0 && nb > 0
        J(nb,ng) = J(nb,ng) - 0;
        J(ng,nb) = J(ng,nb) - 0;
        C(nb,ng) = C(nb,ng) - CGB;
        C(ng,nb) = C(ng,nb) - CGB;
    end

    if nd>0 && nb > 0
        J(nb,nd) = J(nb,nd) - gdb-gbd;
        J(nd,nb) = J(nd,nb) + gmbs-gbd-gdb;
        C(nb,nd) = C(nb,nd) - CBD;
        C(nd,nb) = C(nd,nb) - CBD;
    end
end
1;
