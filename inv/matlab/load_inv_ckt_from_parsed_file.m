function [Gl Cl pins nins max_node_num] = load_inv_ckt_from_parsed_file

    dir = '../ngspice3/';
    %D G S B Level(unused) W L VT0(unused) lambda(unused) KP(unused)
    [nins pins] = LoadMosFile([dir, 'mos.dat']);
    
    spG = load([dir, 'spG.dat']);
    spC = load([dir, 'spC.dat']);
    Gl = spconvert(spG);
    Cl = spconvert(spC);

    max_node_num = size(Gl, 1);
end
