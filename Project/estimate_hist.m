function [ estimate ] = estimate_hist(particle_vector)

particle_number=length(particle_vector);

bin_numb = particle_number/20;
[particle_hist, centers] = hist(particle_vector, bin_numb);

% estimate = find(max(particle_hist));

estimate_bin_index = find(particle_hist==max(particle_hist),1);
estimate = centers(estimate_bin_index);

% particle_hist=[0, particle_hist,0];
% centers=[0,centers,0];
% 
% [estimate_max, estimate_bin_index] = findpeaks([0, particle_hist,0]);
% estimate_bin_index2 = find(estimate_max == max(estimate_max));
% estimate = centers(estimate_bin_index(estimate_bin_index2));


% part_mean = mean(particle_vector)
% diff_percentage = (estimate-part_mean)/estimate*100


end

