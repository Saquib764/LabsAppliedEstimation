% function h = observation_model(S,W,j)
% This function is the implementation of the observation model
% The bearing should lie in the interval [-pi,pi)
% Inputs:
%           S           4XM
%           W           2XN
%           j           1X1
% Outputs:  
%           h           2XM
function h = observation_model(S,W,j)

    M=size(S,2);
    WM=repmat(W(:,j),1,M);
    SW=WM-S(1:2,:);
    
    h=zeros(2,M);
    angle=zeros(1,M);
    for i=1:size(SW,2)
        h(1,i)=norm(SW(:,i));
        angle(i)=atan2(WM(2,i)-S(2,i),WM(1,i)-S(1,i));
    end
    
    h(2,:)=angle-S(3,:);
    h(2,:)=mod(h(2,:)+pi,2*pi)-pi;
    
end