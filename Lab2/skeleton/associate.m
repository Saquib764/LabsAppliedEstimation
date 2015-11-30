% function [outlier,Psi] = associate(S_bar,z,W,Lambda_psi,Q)
%           S_bar(t)            4XM
%           z(t)                2Xn
%           W                   2XN
%           Lambda_psi          1X1
%           Q                   2X2
% Outputs: 
%           outlier             1Xn
%           Psi(t)              1XnXM
function [outlier,Psi] = associate(S_bar,z,W,Lambda_psi,Q)
    M=size(S_bar,2);%particles
    N=size(W,2);%landmarks
    n=size(z,2);%observations
    
    z_hat=zeros(2,M,N);
    nu=zeros(size(z_hat));
    Psi=zeros(n,M);
    c=zeros(n,M);
    psi=zeros(M,N);
    outlier=zeros(1,n); %keep uncommented for slow mode
    
    for j=1:N
        z_hat(:,:,j)=observation_model(S_bar,W,j);
    end
    
    %Take only values in diagonal for Q, if its not diagonal better use the
    %slow mode...
    Q=diag(Q);
    QMN=repmat(Q,[1 M N]);
    
    for i=1:n
        nu(:,:,:)=repmat(z(:,i),1,M,N)-z_hat;
        nu(2,:,:)=mod(nu(2,:,:)+pi,2*pi)-pi;
        D=sum(nu.^2./QMN,1);
        psi(:,:)=prod(2*pi*Q).^(-1/2)*exp(-1/2*D);
        Psi(i,:)=max(psi,[],2);        
    end
    
    Psi=reshape(Psi,[1 n M]);
    outlier=mean(Psi,3)<=Lambda_psi;
    
    
% THIS WAS PAINFULLY SLOW!!!    
%     for i=1:n
%         for m=1:M
%             for j=1:N
%                 nu(:,m,j)=z(:,i)-z_hat(:,m,j);
%                 nu(2,m,j)=mod(nu(2,m,j)+pi,2*pi)-pi;
%                 D=(nu(:,m,j)'/Q)*nu(:,m,j);
%                 psi(i,m,j)=det(2*pi*Q).^(-1/2)*exp(-1/2*D);
%             end
%             k=find(psi(i,m,:)==max(psi(i,m,:)));
%             c(i,m)=k(1);
%             Psi(i,m)=psi(i,m,c(i,m));
%             
%         end
%         Psi_bar=mean(Psi(i,:));
%         outlier(i)=Psi_bar<=Lambda_psi;
%     end
%     Psi=reshape(Psi,[1 n M]);
end
