function [ corr_matrix ] = corrcoef_matrix( stocks )

[a b]       = size(stocks);
corr_matrix = zeros(b);
temp_matrix = zeros(2);


for i=1:1:b
    for j=1:1:b
       temp_matrix      = corrcoef(stocks(:,i),stocks(:,j)) ;
       corr_matrix(i,j) = temp_matrix(1,2);
    end
    
end




end

