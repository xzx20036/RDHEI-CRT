function [imge_extract_decrypt] = Decrypt(imge_extract)
load ('MyRDH.mat','g')
new_image = imge_extract;
if size(new_image, 3) == 3
    new_image = rgb2gray(new_image); 
end
img = double(new_image); 

[a,b]=size(img);
IR = reshape(img', 1, a*b);
I0_decrypted=[];
%%
L=length(IR);
R=2;
d=14;
Ib=ones(R,L);
r=R; F=L-2;Ib(R,:)=IR;
alfa=10^d;
V=zeros(1,L);


while(r>0)
    r;
   i=2; S=L-1; 
   
    X=g(1,r);
    Z=g(2,r); 
    lambda1=g(3,r);
    lambda2=g(4,r);
    Tr=g(5,r);
    lambda3=g(6,r);
    Y=g(7,r);     
    
     %discarding first 300 iteration results
      for h=1:Tr
        X=lambda1*X*(1-X);
        Z=lambda2*Z*(1-Z);  
        Y=lambda3*Y*(1-Y);
      end
    
   while (i<L-2)
       X=lambda1*X*(1-X);
       Z=lambda2*Z*(1-Z); 
       Y=lambda3*Y*(1-Y);
         Z_norm=mod(floor(alfa*Z),256);
         Z_norm_seq(i+1)=Z_norm;
         
        if(Ib(r,i)>Ib(r,i-1)) 
            j=1+mod(floor(alfa*X),i-1);
            jf=i+2+mod(floor(alfa*Y),L-i-1); 
            
        else
            j=1+mod(floor(alfa*Y),i-1);
            jf=i+2+mod(floor(alfa*X),L-i-1);             
        end
        
       Z1=Ib(r,i+1);
       Z2=Ib(r,j);        

       V(i+1)=j;
       VV(i+1)=jf;
       i=i+1;
       S=S-1;
   end
   j=L-3;
   
   while(j>=2)
       
       i=V(j+1);
       ii=VV(j+1);
       Z1=Ib(r,j+1);
       Z2=Ib(r,i);
       Z4=Ib(r,ii);
       
          if(j>0)
               Z1_prev=Ib(r,j); 
          else
              Z1_prev=0;
          end

         Z_norm=Z_norm_seq(j+1);
        
        Z1=My_rotate(Z1,8-1-mod(Z_norm,8));

       Z1=uint8(Z1);
       Z2=uint8(Z2);
       Z4=uint8(Z4);
       Z_norm=uint8(Z_norm);
       Z1_prev=uint8(Z1_prev);
       
       Z3=bitxor(bitxor(bitxor(bitxor(Z1,Z2),Z4),Z_norm),Z1_prev);

       Ib(r,j+1)=Z3;
       j=j-1;
       
   end
   r=r-1; 
  if(r>0)
      Ib(r,:)=Ib(r+1,:);
  end
end
I0_decrypted=Ib(1,:);
[a,b]=size(img);
bits=8;
imge_decrypted=[];
k=0;
imge_decrypted=reshape(I0_decrypted,a,b);
imge_extract_decrypt=imge_decrypted;

end

