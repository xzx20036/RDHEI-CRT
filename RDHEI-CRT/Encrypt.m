function [imge_encrypted] = Encrypt(imge_original)
load ('MyRDH.mat','g')
I0=[];

imge=double(imge_original); 
imaj=imge;
[a,b]=size(imge);
bits=8;
k=0;
I0=reshape(imge,1,a*b);

L=length(I0);
R=2;
d=floor(log10(L))+11;
d=14;

Ib=ones(R,L);
r=1; F=L-2;Ib(1,:)=I0;
alfa=10^d;



while(r<=R)
   
    i=2;
    S=L-1;
    X=g(1,r);  
    Z=g(2,r); 
    lambda1=g(3,r);
    lambda2=g(4,r);
    Tr=g(5,r);
    lambda3=g(6,r);
    Y=g(7,r); 

        for h=1:Tr   
            X=lambda1*X*(1-X);
            Z=lambda2*Z*(1-Z);
            Y=lambda3*Y*(1-Y);
        end
    Z1_prev=0;
    while (i<L-2)
        
        
       X=lambda1*X*(1-X);
       Z=lambda2*Z*(1-Z); 
       Y=lambda3*Y*(1-Y);
         Z_norm=mod(floor(alfa*Z),256);
        
       if(Ib(r,i)>Ib(r,i-1))
            j=1+mod(floor(alfa*X),i-1);
            jf=i+2+mod(floor(alfa*Y),L-i-1);
       else
            j=1+mod(floor(alfa*Y),i-1);
            jf=i+2+mod(floor(alfa*X),L-i-1);           
       end
       
       
       Z1=Ib(r,i+1);
       Z2=Ib(r,j);
       
       Z4=Ib(r,jf);
       
            if(i>0)
               Z1_prev=Ib(r,i); 
            end

      Z3=bitxor(bitxor(bitxor(bitxor(Z1,Z2),Z4),Z_norm),Z1_prev);

       Z3=My_rotate(Z3,1+mod(Z_norm,8));    
     
       
       Ib(r,i+1)=(Z3);
      
       i=i+1;
       S=S-1;
    end
    
   r=r+1;
   Ib(r,:)=Ib(r-1,:);
    
end

IR=Ib(R,:);

[a,b]=size(imge);
bits=8;
imge_encrypted=[];
k=0;
for i=1:a
  for j=1:b
        k=k+1;
        imge_encrypted(i,j)=IR(k);

  end
    
end
end

