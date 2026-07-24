function [original_text] = dec_bin_text_recover(padded_dec_values,b)

    %% ===================== 步骤1：十进制序列转回9位二进制，拼接为补零后完整二进制序列 =====================
    padded_split_bin = cell(1, length(padded_dec_values));
    for i = 1:length(padded_dec_values)
        % 十进制转9位二进制（前补零，保证每段严格9位）
        bin_str = dec2bin(padded_dec_values(i), 9);
        padded_split_bin{i} = bin_str;
    end

    padded_bin_str = strjoin(padded_split_bin, '');
    
    %% ===================== 步骤2：输入校验 =====================
    % 校验补零个数b的合法性
    if ~isnumeric(b) || b < 0 || b ~= floor(b)
        error('补零个数b必须是非负整数！');
    end
    if b > length(padded_bin_str)
        error(['补零个数b=', num2str(b), ' 超出补零后序列长度（', num2str(length(padded_bin_str)), '），无法还原']);
    end
    
    %% ===================== 步骤3：还原原始二进制序列（去除前补的b个零） =====================
    % 去除前补的b个零，得到原始二进制序列
    raw_bin_str = padded_bin_str(b+1:end);
    original_text =raw_bin_str;
end
