% function S = systematic_resample(S_bar)
% This function performs systematic re-sampling
% Inputs:   
%           S_bar(t):       M
% Outputs:
%           S(t):           M
function [S,weight] = sys_resample(S_bar,weight_bar)
    S=zeros(size(S_bar));
    weight=zeros(size(weight_bar));
    M=length(S_bar);
    CDF=zeros(1,M);
    for m=1:M
        CDF(m)=sum(weight_bar(1:m)); 
    end
    r=rand()/M;
    for m=1:M
        i=find(CDF>=r+(m-1)/M, 1 );
        S(m)=S_bar(i);
        weight(m)=1/M;
    end
end