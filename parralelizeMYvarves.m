function [outputs,inputs] = parralelizeMYvarves(inputs,summed_bands_core_image)

% disp('Tracking varves throughout core: calculating initial spacing');

lower_bound = 0.2;
upper_bound = 0.8;
number_of_steps = inputs.number_of_transects;
step_size = (upper_bound-lower_bound)/(number_of_steps);


save_varve_ages = NaN(5000,number_of_steps);

save_varve_positions = NaN(5000,number_of_steps);

save_varve_thicknesses = NaN(5000,number_of_steps);
% % 
% % save_varve_minimums = NaN(5000,number_of_steps);
% % 
% % save_varve_maximums = NaN(5000,number_of_steps);

full_varve_list = ones(2,1);



% disp('Tracking varves throughout core: calculating full varve sequence');

if strcmpi(inputs.parralelize,'No')
for position_loop = 1:number_of_steps %parfor
    

working = inputs; 
    
working.correlation_centroid = lower_bound+(position_loop-1)*(step_size);

[full_varve_list,~] = countMYvarves(working,summed_bands_core_image);

for inner_loop = 1:5000
    
    try

save_varve_ages(inner_loop,position_loop)=full_varve_list(inner_loop,1);

save_varve_positions(inner_loop,position_loop)=full_varve_list(inner_loop,2);

save_varve_thicknesses(inner_loop,position_loop)=full_varve_list(inner_loop,3);
% % 
% % save_varve_minimums(inner_loop,position_loop)=full_varve_list(inner_loop,4);
% % 
% % save_varve_maximums(inner_loop,position_loop)=full_varve_list(inner_loop,5);
    catch
       %run out of values to load 
    end

end

disp(position_loop);

end

else
    
    parfor position_loop = 1:number_of_steps %parfor
    

working = inputs; 
    
working.correlation_centroid = lower_bound+(position_loop-1)*(step_size);

[full_varve_list,~] = countMYvarves(working,summed_bands_core_image);

for inner_loop = 1:5000
    
    try

save_varve_ages(inner_loop,position_loop)=full_varve_list(inner_loop,1);

save_varve_positions(inner_loop,position_loop)=full_varve_list(inner_loop,2);

save_varve_thicknesses(inner_loop,position_loop)=full_varve_list(inner_loop,3);
% % 
% % save_varve_minimums(inner_loop,position_loop)=full_varve_list(inner_loop,4);
% % 
% % save_varve_maximums(inner_loop,position_loop)=full_varve_list(inner_loop,5);
    catch
       %run out of values to load 
    end

end

disp(position_loop);

    end
end

outputs.varve_ages.raw = save_varve_ages;
outputs.varve_positions = save_varve_positions;
outputs.varve_thicknesses.raw = save_varve_thicknesses;
% % outputs.varve_minimums.raw = save_varve_minimums;
% % outputs.varve_maximums.raw = save_varve_maximums;


maximum_matrix = zeros(size(outputs.varve_ages.raw,2),1);

for maximum_loop = 1:size(outputs.varve_positions,2)
    
    column = outputs.varve_ages.raw(:,maximum_loop);
    
    column = rmmissing(column);
    
    maximum_matrix(maximum_loop,1) = size(column,1);
end

crop_single = zeros(5000,1);

crop_single(1:max(maximum_matrix),1) = 1;


crop_full = zeros(5000,size(outputs.varve_ages.raw,2));

for iteration_count = 1:size(outputs.varve_ages.raw,2)
    crop_full(:,iteration_count) = crop_single;
end

outputs.varve_positions(isnan(outputs.varve_positions)) = 0;    

outputs.varve_positions(crop_full==0)=NaN;

outputs.varve_positions = rmmissing(outputs.varve_positions);

outputs.varve_positions(outputs.varve_positions==0) = NaN;


outputs.varve_thicknesses.raw(isnan(outputs.varve_thicknesses.raw)) = 0;    

outputs.varve_thicknesses.raw(crop_full==0)=NaN;

outputs.varve_thicknesses.raw = rmmissing(outputs.varve_thicknesses.raw);

outputs.varve_thicknesses.raw(outputs.varve_thicknesses.raw==0) = NaN;


outputs.varve_ages.raw(isnan(outputs.varve_ages.raw)) = 0;    

outputs.varve_ages.raw(crop_full==0)=NaN;

outputs.varve_ages.raw = rmmissing(outputs.varve_ages.raw);

outputs.varve_ages.raw(outputs.varve_ages.raw==0) = NaN;

% Transform to DEPTH

%Set depth resolution as ~0.25 times mean varve thickness to ensure no loss
%of information

interval_bin_size = (nanmean(outputs.varve_thicknesses.raw,'all')/4);

depth_bins = (0:interval_bin_size:nanmax(outputs.varve_positions(:,1)))';

if depth_bins(size(depth_bins,1),1) < nanmax(outputs.varve_positions(:,1))

depth_bins(size(depth_bins,1)+1,1)= nanmax(outputs.varve_positions(:,1));

end

depth_SR = NaN(size(depth_bins,1), size(outputs.varve_ages.raw,2));

counter_SR = ones(1,size(outputs.varve_ages.raw,2));

for db_loop = 1:size(depth_bins,1)
    for raw_loop = 1:size(outputs.varve_ages.raw,2)
        if depth_bins(db_loop,1) <= outputs.varve_positions(counter_SR(1,raw_loop),raw_loop)
           depth_SR(db_loop,raw_loop) = outputs.varve_thicknesses.raw(counter_SR(1,raw_loop),raw_loop);
        else
           if counter_SR(1,raw_loop) < size(outputs.varve_ages.raw,1)
           counter_SR(1,raw_loop) = counter_SR(1,raw_loop)+1;
           end
           
           depth_SR(db_loop,raw_loop) = outputs.varve_thicknesses.raw(counter_SR(1,raw_loop),raw_loop); 
        end
        
    end
end

% Calculate AGES
depth_AGE = NaN(size(depth_bins,1), size(outputs.varve_ages.raw,2));

for db_loop = 1:size(depth_bins,1)
    for raw_loop = 1:size(outputs.varve_ages.raw,2)
        if db_loop == 1 %dS/dz
           depth_AGE( db_loop,raw_loop) = (nanmean(outputs.varve_thicknesses.raw,'all')/4)/depth_SR(db_loop,raw_loop);
        else
           depth_AGE( db_loop,raw_loop) = depth_AGE( db_loop-1,raw_loop)+...
               (nanmean(outputs.varve_thicknesses.raw,'all')/4)/depth_SR(db_loop,raw_loop); 
        end
    end
end

outputs.varve_positions = depth_bins./inputs.resolution; %Convert to mm

outputs.varve_thicknesses.raw = depth_SR./inputs.resolution;
outputs.varve_thicknesses.median = quantile(depth_SR,0.5,2)./inputs.resolution;
outputs.varve_thicknesses.Q1 = quantile(depth_SR,0.25,2)./inputs.resolution;
outputs.varve_thicknesses.Q3 = quantile(depth_SR,0.75,2)./inputs.resolution;

outputs.varve_ages.raw = depth_AGE;
outputs.varve_ages.median = quantile(depth_AGE,0.5,2);
outputs.varve_ages.Q1 = quantile(depth_AGE,0.25,2);
outputs.varve_ages.Q3 = quantile(depth_AGE,0.75,2);












% % [outputs.varve_ages.raw,outputs.varve_ages.mean,outputs.varve_ages.median,outputs.varve_ages.std]...
% %     = calculate_statistics(outputs.varve_ages.raw,'Constant',crop_full,inputs,'Yes');
% % 
% % [outputs.varve_positions.raw,outputs.varve_positions.mean,outputs.varve_positions.median,outputs.varve_positions.std]...
% %     = calculate_statistics(outputs.varve_positions.raw,'Constant',crop_full,inputs,'Yes');
% % 
% % [outputs.varve_thicknesses.raw,outputs.varve_thicknesses.mean,outputs.varve_thicknesses.median,outputs.varve_thicknesses.std]...
% %     = calculate_statistics(outputs.varve_thicknesses.raw,'Constant',crop_full,inputs,'Yes');
% % 
% % [outputs.varve_minimums.raw,outputs.varve_minimums.mean,outputs.varve_minimums.median,outputs.varve_minimums.std]...
% %     = calculate_statistics(outputs.varve_minimums.raw,'Constant',crop_full,inputs,'Yes');
% % 
% % [outputs.varve_maximums.raw,outputs.varve_maximums.mean,outputs.varve_maximums.median,outputs.varve_maximums.std]...
% %     = calculate_statistics(outputs.varve_maximums.raw,'Constant',crop_full,inputs,'Yes');