% function H = jacobian_observation_model(mu_bar,M,j,z,i)
% This function is the implementation of the H function
% Inputs:
%           mu_bar(t)   3X1
%           M           2XN
%           j           1X1 which M column
%           z_hat       2Xn
%           i           1X1  which z column
% Outputs:  
%           H           2X3
function H = jacobian_observation_model(mu_bar,M,j,z_hat,i)
    H1=(mu_bar(1)-M(1,j))/z_hat(1,i);
    H2=(mu_bar(2)-M(2,j))/z_hat(1,i);
    H3=0;
    H4=-(mu_bar(2)-M(2,j))/(z_hat(1,i).^2);
    H5=(mu_bar(1)-M(1,j))/(z_hat(1,i).^2);
    H6=-1;
    H=[H1,H2,H3;H4,H5,H6];
end
