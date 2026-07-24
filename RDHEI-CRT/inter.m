function [imge_inter] = inter(input_matrix)
B = 2;
N = 3;

[H,W] = size(input_matrix);

assert(mod(H,B)==0 && mod(W,B)==0,...
       'Image size must be divisible by 2');

num_blocks_h = H/B;
num_blocks_w = W/B;

%% 提取2×2块

blocks_linear = im2col(input_matrix,[B B],'distinct');

a = uint8(blocks_linear(1,:));
b = uint8(blocks_linear(2,:));
c = uint8(blocks_linear(3,:));
d = uint8(blocks_linear(4,:));

%% GF(256)-MDS 插值

A = gf([...
    2 3 1 1;
    1 2 3 1;
    1 1 2 3;
    3 1 1 2;
    1 3 2 1],8);

X = gf([a;
        b;
        c;
        d],8);

E = A * X;

E_uint8 = uint8(E.x);

e1 = E_uint8(1,:);
e2 = E_uint8(2,:);
e3 = E_uint8(3,:);
e4 = E_uint8(4,:);
e5 = E_uint8(5,:);

% e1 = a;
% e2 = c;
% e3 = a;
% e4 = b;
% e5 = d;

%% 构造3×3块

new_blocks = zeros(9,num_blocks_h*num_blocks_w);

new_blocks(1,:) = a;
new_blocks(2,:) = e1;
new_blocks(3,:) = b;

new_blocks(4,:) = e2;
new_blocks(5,:) = e3;
new_blocks(6,:) = e4;

new_blocks(7,:) = c;
new_blocks(8,:) = e5;
new_blocks(9,:) = d;

%% 重构图像

output_matrix = col2im(new_blocks,...
                       [N N],...
                       [num_blocks_h*N,num_blocks_w*N],...
                       'distinct');

imge_inter = output_matrix;

end

