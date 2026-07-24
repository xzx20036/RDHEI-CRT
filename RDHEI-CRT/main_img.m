clc;
clear;
close all;
load MyRDH.mat;
image_file = 'image512\elaine.tiff';   
new_image = imread(image_file);
img=imread('binary_RDH_128.png');
if size(new_image, 3) == 3
    new_image = rgb2gray(new_image);
end
imge_original = double(new_image);
imge_encrypted = Encrypt(imge_original);
[imge_encrypted_inter, imge_embedded] = Embed1(imge_encrypted,img);
[imge_extract, secret_img] = Extract1(imge_embedded);
imge_extract_decrypt = Decrypt(imge_extract);

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
subplot(2,3,4:6)
    imshow(secret_img,[0 255]);
    title('recovery secret_img')


