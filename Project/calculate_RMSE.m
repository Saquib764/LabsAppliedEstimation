function [ rmse] = calculate_RMSE( data, estimate)

rmse = sqrt(sum((data(:)-estimate(:)).^2)/numel(data));
% estimate_variance = var(estimate);
% estimate_bias = mean((data(:)-estimate(:)));

end

