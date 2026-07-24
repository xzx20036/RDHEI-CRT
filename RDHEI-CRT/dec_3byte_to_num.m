function [original_num] = dec_3byte_to_num(dec1, dec2, dec3)

    %% 步骤1：输入校验（确保dec1/dec2/dec3为8位二进制对应的合法值）
    if ~isnumeric([dec1, dec2, dec3]) || any([dec1, dec2, dec3] < 0) || any([dec1, dec2, dec3] > 255)
        error('dec1/dec2/dec3必须是0~255之间的整数！');
    end
    dec1 = uint8(dec1); dec2 = uint8(dec2); dec3 = uint8(dec3);
    
    %% 步骤2：每个十进制值转8位二进制字符串（前补零）
    bin_segments = cell(1, 3);
    bin_segments{1} = dec2bin(dec1, 8);  % dec1→8位二进制（最高位段）
    bin_segments{2} = dec2bin(dec2, 8);  % dec2→8位二进制
    bin_segments{3} = dec2bin(dec3, 8);  % dec3→8位二进制（最低位段）
    
    %% 步骤3：拼接3个8位二进制段，得到编码时逆序后的24位字符串
    % 此字符串 = 编码函数中的 bin_str_24_rev
    bin_str_24_rev = [bin_segments{1}, bin_segments{2}, bin_segments{3}];

    
    %% 步骤4：逆序还原，恢复为编码函数中原始的24位二进制字符串

    bin_str_24 = bin_str_24_rev(end:-1:1);  

    %% 步骤4：24位二进制转十进制（还原原始数值）
    original_num = bin2dec(bin_str_24);
    

    %% 步骤5：验证数值范围（与原函数匹配）
    if original_num > 16777215
        warning('还原的数值超出16777215（2^24-1）范围，原函数不支持该数值输入');
    end
    
end

