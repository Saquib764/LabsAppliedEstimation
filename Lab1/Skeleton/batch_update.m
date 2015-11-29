% function [mu_bar,sigma_bar] = update(mu_bar,sigma_bar,H_bar,S_bar,nu_bar)
% This function should perform the update process(single update).
% You need to make sure that the output sigma_bar is symmetric.
% The last line makes sure that ouput sigma_bar is always symmetric.
% Inputs:
%           mu_bar(t)       3X1
%           sigma_bar(t)    3X3
%           H_bar(t)        2nX3
%           Q_bar(t)		2nX2n
%           nu_bar(t)       2nX1
% Outputs:
%           mu(t)           3X1
%           sigma(t)        3X3
function [mu,sigma] = batch_update(mu_bar,sigma_bar,H_bar,Q_bar,nu_bar)
% nu_bar=nu_bar(:,outlier~=1);
% H_bar=H_bar(:,:,outlier~=1);
% nu_bar=reshape(nu_bar,[2*size(nu_bar,2),1]);
% H_bar=reshape(H_bar,[2*size(H_bar,3),3]);
% Q_bar=kron(eye(size(H_bar,3)),Q);
K=sigma_bar*H_bar'/(H_bar*sigma_bar*H_bar'+Q_bar);
mu=mu_bar+K*nu_bar;
KH=K*H_bar;
I=eye(size(KH));
sigma=(I-KH)*sigma_bar;
sigma = (sigma + sigma')/2;
end