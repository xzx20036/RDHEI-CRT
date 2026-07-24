function [imge_extract,secret_img] = Extract1(imge_embedded)
em_img=imge_embedded;
[input_rows, input_cols] = size(em_img);
img=em_img;
num_blocks_3x3_rows = input_rows / 3;  % 128
num_blocks_3x3_cols = input_cols / 3;  % 128
first_blocks= em_img(1:3,1:3);
data=[];
str=dec2bin(bitxor(first_blocks(2,2),first_blocks(1,1)),8);
s1=str(1:2);
s2=str(3:4);
s3=str(5:6);
s4=str(7:8);
[x,y,z] = CRT_reverse(dec_3byte_to_num(first_blocks(3,1), first_blocks(2,1), first_blocks(1,1)));
first_blocks(3,1)=x;
first_blocks(1,1)=y;
c1=dec2bin(z,7);
[x,y,z] = CRT_reverse(dec_3byte_to_num(first_blocks(3,3), first_blocks(3,2), first_blocks(3,1)));
first_blocks(3,3)=x;
first_blocks(3,1)=y;
c2=dec2bin(z,7);
[x,y,z] = CRT_reverse(dec_3byte_to_num(first_blocks(1,3), first_blocks(2,3), first_blocks(3,3)));
first_blocks(1,3)=x;
first_blocks(3,3)=y;
c3=dec2bin(z,7);
[x,y,z] = CRT_reverse(dec_3byte_to_num(first_blocks(1,1), first_blocks(1,2), first_blocks(1,3)));
first_blocks(1,1)=x;
first_blocks(1,3)=y;
c4=dec2bin(z,7);
n=bin2dec([s1,c4,s2,c3]);
b=bin2dec([s3,c2,s4,c1]);
img(1:3,1:3)=first_blocks;
i=1;
for row_block = 1:num_blocks_3x3_rows
    row_start = (row_block-1) * 3 + 1;
    row_end = row_block * 3;
    for col_block = 1:num_blocks_3x3_cols
        if row_block==1 && col_block==1
            continue
        end
        if i>n
            break
        end
        col_start = (col_block-1) * 3 + 1;
        col_end = col_block * 3;
        last_blocks = em_img(row_start:row_end, col_start:col_end);
        str=dec2bin(bitxor(last_blocks(2,2),last_blocks(1,1)),8);
        [x,y,z1] = CRT_reverse(dec_3byte_to_num(last_blocks(3,1), last_blocks(2,1), last_blocks(1,1)));
        last_blocks(3,1)=x;
        last_blocks(1,1)=y;
        [x,y,z2] = CRT_reverse(dec_3byte_to_num(last_blocks(3,3), last_blocks(3,2), last_blocks(3,1)));
        last_blocks(3,3)=x;
        last_blocks(3,1)=y;
        [x,y,z3] = CRT_reverse(dec_3byte_to_num(last_blocks(1,3), last_blocks(2,3), last_blocks(3,3)));
        last_blocks(1,3)=x;
        last_blocks(3,3)=y;
        [x,y,z4] = CRT_reverse(dec_3byte_to_num(last_blocks(1,1), last_blocks(1,2), last_blocks(1,3)));
        last_blocks(1,1)=x;
        last_blocks(1,3)=y;
        s1=str(1:2);
        s2=str(3:4);
        s3=str(5:6);
        s4=str(7:8);
        z1=dec2bin(z1,7);
        z2=dec2bin(z2,7);
        z3=dec2bin(z3,7);
        z4=dec2bin(z4,7);
        data=[data,bin2dec([s1,z4]),bin2dec([s2,z3]),bin2dec([s3,z2]),bin2dec([s4,z1])];
        i=i+1;
        img(row_start:row_end, col_start:col_end)=last_blocks;
    end
end

secret_img=dec_bin_img_recover(data,b,128,128);
new_blocks = im2col(img, [3, 3], 'distinct');
a = new_blocks(1, :);  % 还原原2×2块左上角
b = new_blocks(3, :);  % 还原原2×2块右上角
c = new_blocks(7, :);  % 还原原2×2块左下角
d = new_blocks(9, :);  % 还原原2×2块右下角
total_blocks = num_blocks_3x3_rows * num_blocks_3x3_cols;
original_blocks = zeros(4, total_blocks);
original_blocks(1, :) = a;  % 原2×2块(0,0)
original_blocks(2, :) = b;  % 原2×2块(0,1)
original_blocks(3, :) = c;  % 原2×2块(1,0)
original_blocks(4, :) = d;  % 原2×2块(1,1)
imge_extract = col2im(original_blocks, [2, 2], [num_blocks_3x3_rows*2,num_blocks_3x3_cols*2], 'distinct');
end

