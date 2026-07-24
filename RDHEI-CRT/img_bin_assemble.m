function [final_dec_values] = img_bin_assemble(img)
    %% ===================== 步骤1：图像转8位二进制序列（替换原文本转二进制） =====================
    % 1. 校验输入：确保是灰度图像（二维矩阵）
    if ndims(img) == 3
        img = rgb2gray(img); % 彩色图转灰度图
    end
    img = im2uint8(img); % 确保为8位灰度图（像素值0~255）
    
    % 2. 图像像素展平为一维序列（按行优先）
    pixel_vals = img(:)'; % 转置为行向量，方便遍历
    raw_bin_str = '';     % 存储所有像素的8位二进制串
    % 3. 每个像素值转8位二进制
    for i = 1:length(pixel_vals)
        pixel_bin = dec2bin(pixel_vals(i), 8); % 像素值(0-255)转8位二进制
        raw_bin_str = [raw_bin_str, pixel_bin]; % 拼接所有二进制串
    end
    % 4. 清洗二进制串（仅保留0/1，避免异常字符）
    raw_bin_str = raw_bin_str(raw_bin_str == '0' | raw_bin_str == '1');
    len_raw = length(raw_bin_str); % 有效二进制串长度（图像像素总数×8）
    
    % 前补零到36的倍数，计算补零数b
    b = mod(36 - mod(len_raw, 36), 36);  % 补零个数（0~35）
    padded_bin_str = [repmat('0', 1, b), raw_bin_str];  % 补零后完整二进制串
    len_padded = length(padded_bin_str);
    % 9位分割（保留原逻辑）
    split_num = len_padded / 9;
    split_bin_seqs = cell(1, split_num);
    for i = 1:split_num
        start_idx = (i-1)*9 + 1;
        end_idx = i*9;
        split_bin_seqs{i} = padded_bin_str(start_idx:end_idx);
    end
    % 9位二进制段转十进制（保留原逻辑）
    dec_values = zeros(1, split_num);
    for i = 1:split_num
        bin_9bit = split_bin_seqs{i};
        bin_str = bin_9bit(bin_9bit == '0' | bin_9bit == '1');
        if length(bin_str) < 9
            bin_str = [repmat('0', 1, 9-length(bin_str)), bin_str];
        elseif length(bin_str) > 9
            bin_str = bin_str(1:9);
        end
        dec_values(i) = bin2dec(bin_str);
    end
    
    %% ===================== 步骤2：计算分段数a（n/36）并编码为14位 =====================
    a = len_padded/36;  % 补零后长度n除以36
    a_bin = dec2bin(a, 18);    % a编码为18位二进制（前补零）
    
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
        % 清洗并转十进制（兼容异常，保证7位）
        bin_str = final_split_bin{i}(final_split_bin{i} == '0' | final_split_bin{i} == '1');
        if length(bin_str) < 9
            bin_str = [repmat('0', 1, 9-length(bin_str)), bin_str];
        elseif length(bin_str) > 9
            bin_str = bin_str(1:9);
        end
        final_dec_values(i) = bin2dec(bin_str);
    end

end