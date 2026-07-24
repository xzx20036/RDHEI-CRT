function [final_dec_values] = text_bin_assemble(n,raw_bin_str)
    len_raw = n;  
    % 前补零到36的倍数，计算补零数b
    b = mod(36 - mod(len_raw, 36), 36);  % 补零个数（0~35）
    padded_bin_str = [repmat('0', 1, b), raw_bin_str];  % 补零后完整二进制串
    len_padded = length(padded_bin_str);
    % 9位分割
    split_num = len_padded / 9;
    split_bin_seqs = cell(1, split_num);
    for i = 1:split_num
        start_idx = (i-1)*9 + 1;
        end_idx = i*9;
        split_bin_seqs{i} = padded_bin_str(start_idx:end_idx);
    end  
    %% ===================== 步骤2：计算分段数a（n/36）并编码为14位 =====================
    a = len_padded/36; 
    a_bin = dec2bin(a, 18); 
    
    %% ===================== 步骤3：编码补零数b为7位二进制 =====================
    b_bin = dec2bin(b, 18);  % b编码为18位二进制（前补零）
   
    %% ===================== 步骤4：拼接所有序列 =====================
    final_bin = [a_bin, b_bin, padded_bin_str];
    %% ===================== 步骤5：转成10进制序列 =====================
    len_final_padded=length(final_bin);
    final_split_num = len_final_padded / 9;
    final_split_bin = cell(1, final_split_num);
    final_dec_values = zeros(1, final_split_num);
    
    for i = 1:final_split_num
        start_idx = (i-1)*9 + 1;
        end_idx = i*9;
        % 提取9位二进制段
        final_split_bin{i} = final_bin(start_idx:end_idx);
        % 清洗并转十进制（兼容异常，保证9位）
        bin_str = final_split_bin{i}(final_split_bin{i} == '0' | final_split_bin{i} == '1');
        if length(bin_str) < 9
            bin_str = [repmat('0', 1, 9-length(bin_str)), bin_str];
        elseif length(bin_str) > 9
            bin_str = bin_str(1:9);
        end
        final_dec_values(i) = bin2dec(bin_str);
    end
end



