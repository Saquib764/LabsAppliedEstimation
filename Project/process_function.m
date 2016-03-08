function process_output = process_function( state_variable, process_noise_variance )

%probably something else, just to write something:
process_output = state_variable + sqrt(process_noise_variance)*randn-sqrt(process_noise_variance)*randn;
end

