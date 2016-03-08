function process_output = process_function2_moody( state_variable, process_noise_variance, mean_manipulator)



process_output = state_variable  + mean_manipulator* state_variable + sqrt(process_noise_variance)*randn;


end

    