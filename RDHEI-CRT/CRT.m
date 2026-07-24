function e1 = CRT(x, y, z)  
    mlist=[257,259,251];
    m1=mlist(1);
    m2=mlist(2);
    m3=mlist(3);
    m=m1*m2*m3;
    M1=m/m1; M2=m/m2; M3=m/m3;
    
    M1_inv = inverse(M1, m1);  
    M2_inv = inverse(M2, m2);
    M3_inv = inverse(M3, m3);
    
    e1 = mod(x*M1*M1_inv + y*M2*M2_inv + z*M3*M3_inv, m);
end


function [gcd, x, y] = extended_gcd(a, m)
    if m == 0
        gcd = a; x=1; y=0;
    else
        [gcd, x1, y1] = extended_gcd(m, mod(a,m));
        x = y1; y = x1 - floor(a/m)*y1;
    end
end


function inv_val = inverse_mod(a, m)
    [gcd, x, ~] = extended_gcd(a, m);
    if gcd ~= 1
        inv_val = -1;
    else
        inv_val = mod(x, m);
    end
end


function is_valid = check_inverse(a, m)
    inv_val = inverse_mod(a, m);
    is_valid = inv_val~=-1 && mod(a*inv_val, m)==1;
end


function inv_val = inverse(a, m)
    if check_inverse(a, m)
        inv_val = inverse_mod(a, m);
    else
        disp('false'); inv_val=-1;
    end
end