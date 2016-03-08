function [ pred_index ] = measurement_function( meas , coef)

pred_index=coef(1)*meas+coef(2);

end

