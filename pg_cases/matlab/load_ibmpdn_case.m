function [Gl Cl pins nins max_node_num] = load_ibmpdn_case(pwd)
    
    fileG = [pwd, 'spG.dat'];
    fileC = [pwd, 'spC.dat'];

    rawG = load(fileG);
    rawC = load(fileC);
    
    Cl = spconvert(rawC);
    Gl = spconvert(rawG);

    pins = [];
    nins = [];

    max_node_num = size(Gl, 1);

    clear rawC;
    clear rawG;
end
