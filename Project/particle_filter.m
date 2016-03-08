function [estimate, particle_vector] = particle_filter(initial_state, measurement_data, particle_number, coef, process_noise_variance, measurement_noise_variance,mean_manipulator, verbose)

% process_noise_variance = 0.1;
% measurement_noise_variance = 0.1; 
% initial_estimate_variance = 1;


%initial particle vector is gaussian around initial_state
particle_vector = zeros(length(measurement_data),particle_number); 
particle_vector_update = zeros(particle_number,1); 
% measurement_vector_update = zeros(particle_number,1);
weight_vector = zeros(particle_number,1);
measurement_variable = zeros(length(measurement_data),1);
estimate = zeros(length(measurement_data),1);

for i = 1:particle_number
    particle_vector(1,i) = initial_state + sqrt(process_noise_variance) * randn;
end


%initialize variables
% measurement_variable_out = measurement_function(initial_state);
% state_variable_out = initial_state;  
% state_variable = initial_state; 
if verbose>=1
    figure; hold on;
end


for t = 1:length(measurement_data)


    measurement_variable(t) = measurement_function(measurement_data(t), coef);% + 100*randn;

    %update particles
    for i = 1:particle_number
        
        %apply state update to particles (sample step)
        if t==1
            particle_vector_update(i) = process_function2_optimist(particle_vector(t,i), process_noise_variance, mean_manipulator);
            %particle_vector_update(i) = process_function3 (particle_vector(t,i), estimate, t, process_noise_variance);
        else
            particle_vector_update(i) = process_function2_optimist(particle_vector(t-1,i), process_noise_variance, mean_manipulator);
            %particle_vector_update(i) = process_function3( particle_vector(t-1,i), estimate, t, process_noise_variance);
        end
        %update measurement for new particles
%         measurement_vector_update(i) = measurement_function(measurement_data(t), coef);
        
        %calculate weights 
        weight_vector(i) = (1/sqrt(2*pi*measurement_noise_variance)) * exp(-(measurement_variable(t) - particle_vector_update(i))^2/(2*measurement_noise_variance));
    end
    

    

    %Resampling
%     for i = 1 : particle_number
%         particle_vector(t,i) = particle_vector_update(find(rand <= cumsum(weight_vector),1));
%     end

    %Normalisation
    weight_vector = weight_vector./sum(weight_vector);
    particle_vector(t,:)=sys_resample(particle_vector_update,weight_vector);
    %mean or other function?
    
%     estimate(t) = mean(particle_vector(t,:));
    estimate(t) = estimate_hist(particle_vector(t,:));
    
    if verbose>=1
        scatter(t*ones(size(particle_vector,2),1),particle_vector(t,:),[],1-weight_vector); %It makes no sense to put the weights here as they have already been used for resampling, should be another weight according to concentration of particles
        plot(t,estimate(t),'rx');
        drawnow;
    end


    
end

end




