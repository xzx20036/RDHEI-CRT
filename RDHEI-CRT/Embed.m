function [imge_encrypted_inter,imge_embedded] = Embed(imge_encrypted,n,raw_bin_str)
input_matrix=imge_encrypted;
output_matrix = inter(input_matrix);
imge_encrypted_inter=output_matrix;
matrix_crt=output_matrix;
[t] = text_bin_assemble(n,raw_bin_str);
l=length(t);
[output_rows, output_cols] = size(output_matrix);
num_blocks_3x3_rows = output_rows / 3;  % 128
num_blocks_3x3_cols = output_cols / 3;  % 128
i=1;

for row_block = 1:num_blocks_3x3_rows
    row_start = (row_block-1) * 3 + 1;
    row_end = row_block * 3;
    for col_block = 1:num_blocks_3x3_cols
        if i>l
            break
        end
        col_start = (col_block-1) * 3 + 1;
        col_end = col_block * 3;
        current_block = output_matrix(row_start:row_end, col_start:col_end);
        current_block_coy=current_block;
        binary_str1=dec2bin(t(i),9);
        a1=binary_str1(1:2);
        binary_str2=dec2bin(t(i+1),9);
        a2=binary_str2(1:2);
        binary_str3=dec2bin(t(i+2),9);
        a3=binary_str3(1:2);
        binary_str4=dec2bin(t(i+3),9);
        a4=binary_str4(1:2);
     
        [dec1, dec2, dec3] = num_to_3byte_dec(CRT(current_block_coy(1,1),current_block_coy(1,3), bin2dec(binary_str1(3:9))));
        current_block_coy(1,1)=dec1;
        current_block_coy(1,2)=dec2;
        current_block_coy(1,3)=dec3;
        

        [dec1, dec2, dec3] = num_to_3byte_dec(CRT(current_block_coy(1,3),current_block_coy(3,3), bin2dec(binary_str2(3:9))));
        current_block_coy(1,3)=dec1;
        current_block_coy(2,3)=dec2;
        current_block_coy(3,3)=dec3;

        
        [dec1, dec2, dec3] = num_to_3byte_dec(CRT(current_block_coy(3,3),current_block_coy(3,1), bin2dec(binary_str3(3:9))));
        current_block_coy(3,3)=dec1;
        current_block_coy(3,2)=dec2;
        current_block_coy(3,1)=dec3;
        
        
        [dec1, dec2, dec3] = num_to_3byte_dec(CRT(current_block_coy(3,1),current_block_coy(1,1), bin2dec(binary_str4(3:9))));
        current_block_coy(3,1)=dec1;
        current_block_coy(2,1)=dec2;
        current_block_coy(1,1)=dec3;
        
        current_block_coy(2,2) = bitxor(bin2dec([a1,a2,a3,a4]),current_block_coy(1,1));

        
        matrix_crt(row_start:row_end, col_start:col_end)=current_block_coy;
        i=i+4;
    end
end
imge_embedded=matrix_crt;

end

