function [ bias] = calculate_BIAS( data, estimate)

bias = mean(abs(data(:)-estimate(:)));


end

