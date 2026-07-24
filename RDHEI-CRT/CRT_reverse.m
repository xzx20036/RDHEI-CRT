function [x,y,z] = CRT_reverse(e1)
    x=mod(e1,257);
    y=mod(e1,259);
    z=mod(e1,251);
end

