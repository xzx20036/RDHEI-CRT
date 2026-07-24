function [original_img] = dec_bin_img_recover(padded_dec_values, b, rows, cols)  
    %% ===================== 步骤1：十进制序列转回9位二进制，拼接为补零后完整二进制序列 =====================
    padded_split_bin = cell(1, length(padded_dec_values));
    for i = 1:length(padded_dec_values)
        % 十进制转9位二进制（前补零，保证每段严格9位）
        bin_str = dec2bin(padded_dec_values(i), 9);
        if length(bin_str) > 9
                bin_str = bin_str(end-8:end); 
        end
        padded_split_bin{i} = bin_str;
    end
    % 拼接所有9位二进制段，得到补零后的完整二进制序列
    padded_bin_str = strjoin(padded_split_bin, '');
    %% ===================== 步骤2：输入校验 =====================
    % 校验补零个数b的合法性
    if ~isnumeric(b) || b < 0 || b ~= floor(b)
        error('补零个数b必须是非负整数！');
    end
    if b > length(padded_bin_str)
        error(['补零个数b=', num2str(b), ' 超出补零后序列长度（', num2str(length(padded_bin_str)), '），无法还原']);
    end
    % 校验图像尺寸的合法性
    if ~isnumeric(rows) || rows < 1 || rows ~= floor(rows) || ...
       ~isnumeric(cols) || cols < 1 || cols ~= floor(cols)
        error('图像行数rows和列数cols必须是正整数！');
    end
    expected_pixel_num = rows * cols; % 原始图像应有的像素总数

    %% ===================== 步骤3：还原原始二进制序列（去除前补的b个零） =====================
    % 去除前补的b个零，得到原始图像的二进制序列（所有像素的8位二进制拼接）
    raw_bin_str = padded_bin_str(b+1:end);
    len_raw = length(raw_bin_str);

    %% ===================== 步骤4：原始二进制序列转回图像（8位分割→像素值→重塑矩阵） =====================
    % 校验二进制长度是否为8的倍数（每个像素对应8位）
    if mod(len_raw, 8) ~= 0
        warning(['原始二进制序列长度（', num2str(len_raw), '）不是8的倍数，舍弃最后不足8位的部分']);
        len_raw = floor(len_raw / 8) * 8; % 截断到8的倍数
        raw_bin_str = raw_bin_str(1:len_raw);
    end

    % 按8位分割（每个像素对应8位二进制）
    split_num_raw = len_raw / 8; % 像素总数
    pixel_vals = zeros(1, expected_pixel_num); % 存储像素值（0~255）

    for i = 1:split_num_raw
        start_idx = (i-1)*8 + 1;
        end_idx = i*8;
        pixel_bin = raw_bin_str(start_idx:end_idx);
        pixel_val = bin2dec(pixel_bin); % 8位二进制转像素值（0~255）
        pixel_vals(i) = pixel_val;
    end

    % 校验像素数与图像尺寸是否匹配
    if length(pixel_vals) ~= expected_pixel_num
        error(['还原得到的像素数（', num2str(length(pixel_vals)), '）与指定图像尺寸（', num2str(rows), '×', num2str(cols), '）不匹配！']);
    end

    % 将像素值序列重塑为图像矩阵（行优先，与编码时一致）
    original_img = reshape(pixel_vals, rows, cols);
    original_img = uint8(original_img); % 转为8位灰度图像（uint8）
end