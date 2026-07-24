function [dec1, dec2, dec3] = num_to_3byte_dec(num)
    %% 步骤1：输入校验（确保数值范围合法）
    if num < 0 || num > 16777215
        error('输入数值超出范围！必须满足 0 ≤ num ≤ 16777215');
    end

    %% 步骤2：将数值转为二进制字符串（无前置0）
    bin_str = dec2bin(num);  
    
    %% 步骤3：补零至24位（3×8位），不足则在前端补零
    pad_bits = 24 - length(bin_str);  % 计算需要前补的零位数
    bin_str_24 = [repmat('0', 1, pad_bits), bin_str];  % 前补零，总长度24位

    %% 步骤4：对24位二进制字符串进行逆序操作

    bin_str_24_rev = bin_str_24(end:-1:1);  % 核心逆序操作，从最后一位到第一位反向取数

    %% 步骤5：基于逆序后的24位字符串，拆分为3个8位二进制段（按24位均分）
    bin_segments = cell(1, 3);
    bin_segments{1} = bin_str_24_rev(1:8);
    bin_segments{2} = bin_str_24_rev(9:16);
    bin_segments{3} = bin_str_24_rev(17:24);


    %% 步骤6：将每个8位二进制段转为十进制
    dec1 = bin2dec(bin_segments{1});
    dec2 = bin2dec(bin_segments{2});
    dec3 = bin2dec(bin_segments{3});
end



