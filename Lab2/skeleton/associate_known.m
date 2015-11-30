% function [outlier,Psi] = associate_known(S_bar,z,W,Lambda_psi,Q,known_associations)
%           S_bar(t)            4XM
%           z(t)                2Xn
%           W                   2XN
%           Lambda_psi          1X1
%           Q                   2X2
%           known_associations  1Xn
% Outputs: 
%           outlier             1Xn
%           Psi(t)              1XnXM
function [outlier,Psi] = associate_known(S_bar,z,W,Lambda_psi,Q,known_associations)
    M=size(S_bar,2);%particles
    N=size(W,2);%landmarks
    n=size(z,2);%observations
    
    z_hat=zeros(2,M,N);
    nu=zeros(size(z_hat));
    Psi=zeros(n,M);
    c=zeros(n,M);
    psi=zeros(n,M,N);
    outlier=zeros(1,n);
    
    for j=1:N
        z_hat(:,:,j)=observation_model(S_bar,W,j);
    end
    for i=1:n
        for m=1:M
            for j=1:N
                nu(:,m,j)=z(:,i)-z_hat(:,m,j);
                nu(2,m,j)=mod(nu(2,m,j)+pi,2*pi)-pi;
                D=(nu(:,m,j)'/Q)*nu(:,m,j);
                psi(i,m,j)=det(2*pi*Q).^(-1/2)*exp(-1/2*D);
            end
            k=find(psi(i,m,:)==max(psi(i,m,:)));
            c(i,m)=k(1);
            Psi(i,m)=psi(i,m,known_associations(i));
            
        end
        Psi_bar=mean(Psi(i,:));
        outlier(i)=Psi_bar<=Lambda_psi;
    end
    Psi=reshape(Psi,[1 n M]);
end
