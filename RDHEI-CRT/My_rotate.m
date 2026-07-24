function out = My_rotate(in, bits)
    % 对8位整数in左移bits位（bits范围1-8）
    in_bin = dec2bin(in,8);  % 转为8位二进制字符串
    rotated_bin = [in_bin(bits+1:end), in_bin(1:bits)];  % 左移拼接
    out = bin2dec(rotated_bin);  % 转回十进制
end