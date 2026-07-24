clc;
load MyRDH.mat;
image_file = 'image512\airplane.tiff';
new_image = imread(image_file);
if size(new_image, 3) == 3
    new_image = rgb2gray(new_image);  % 转为灰度
end
rng(123);
n=floor(589815*4);%调节嵌入率
rand_bin_int = randi([0, 1], 1, n);  % 生成整数型0/1序列
raw_bin_str = char(rand_bin_int + 48);  % 转换为字符型'0'/'1'
imge_original = double(new_image);  
[imge_encrypted] = Encrypt(imge_original);%加密图像
[imge_encrypted_inter,imge_embedded] = Embed(imge_encrypted,n,raw_bin_str);%将密码信息嵌入到加密图像中
[imge_extract,text] = Extract(imge_embedded);%提取信息并恢复图像
[imge_extract_decrypt] = Decrypt(imge_extract);%解密恢复的图像

figure%各个图像的直方图
subplot(2,3,1)
    imshow(imge_original,[0 255]);
    title('original image')
subplot(2,3,2:3)    
    imhist(uint8(imge_original));
subplot(2,3,4)
    imshow(imge_encrypted,[0 255]);
    title('encrypted image')
subplot(2,3,5:6)
    imhist(uint8(imge_encrypted))
figure
subplot(2,3,1)
    imshow(imge_encrypted_inter,[0 255]);
    title('encrypted-inter image')
subplot(2,3,2:3)    
    imhist(uint8(imge_encrypted_inter))
subplot(2,3,4)
    imshow(imge_embedded,[0 255]);
    title('embedded image')
subplot(2,3,5:6)
    imhist(uint8(imge_embedded))
figure
subplot(2,3,1)
    imshow(imge_extract_decrypt,[0 255]);
    title('extract-decrypt image')
subplot(2,3,2:3)    
    imhist(uint8(imge_extract_decrypt))
     title('histogram of the extract-decrypt image')

%     current_img = uint8(imge_embedded);
% 
%     figure('Position', [100, 100, 600, 300]);
% 
%     [counts, grayLevels] = imhist(current_img);
%     bar(grayLevels, counts);
% 
%     xlim([0 255]);
%     ylim([0 max(counts) * 1.1]);   % 给最高峰留10%空间
% 
%     xlabel('Pixel value');
%     ylabel('Frequency');
% 
%     set(gca, 'FontName', 'Times New Roman', 'FontSize', 12);
%     set(gcf, 'Color', 'w');








