function [full_varve_list,working] = countMYvarves(working,summed_bands_core_image)

% Check that the crop condition will not overlap with the edge of the
% image.

if working.correlation_centroid*size(summed_bands_core_image,1) < size(summed_bands_core_image,1)/(2*(1/(working.percent_cropped_middle*0.01)))
    
    working.correlation_centroid = (size(summed_bands_core_image,1)/(2*(1/(working.percent_cropped_middle*0.01)))+1)/(size(summed_bands_core_image,1));
    
elseif working.correlation_centroid*size(summed_bands_core_image,1) >...
        size(summed_bands_core_image,1)-(size(summed_bands_core_image,1)/(2*(1/(working.percent_cropped_middle*0.01))))
    
    working.correlation_centroid =...
        (size(summed_bands_core_image,1)-(size(summed_bands_core_image,1)/(2*(1/(working.percent_cropped_middle*0.01))))-1)/(size(summed_bands_core_image,1));
    
end

working.save_varve_thickness = working.estimated_varve_thickness;


%% Middle portion

% % % %%%%%%%%%%% Calculate a linear transect of mean color. Use this to
% % % %%%%%%%%%%% initialize the peak correlation
% % % 
% % % mean_value = mean(summed_bands_core_image(ceil(working.correlation_centroid*size(summed_bands_core_image,1) ...
% % % - size(summed_bands_core_image,1)/(2*(1/(working.percent_cropped_middle*0.01)))):...
% % % floor(working.correlation_centroid*size(summed_bands_core_image,1) + size(summed_bands_core_image,1)/(2*(1/(working.percent_cropped_middle*0.01)))),:));
% % % 
% % % %%%%%%%%%%% Findpeaks
% % % [~,max_peak_locations] = findpeaks(mean_value'); %peaks
% % % 
% % % [~,min_peak_locations] = findpeaks(-mean_value'); %troughs
% % % 
% % % varves_at_once = 1 ; %initial number of 'peaks' used for correlation 

% correlation_resolution = 1 ; %calculate correlation every x pixels

correlation_columns = NaN(size(summed_bands_core_image,2),working.search_zone*2+2);

column_counter = 1;


%%%%%%%%%%%%%%%%%%%%%%%% Initialize with the estimated max peaks
    
     
%     maxbound_working.search_zone = floor((1+varves_at_once*0.5)+working.search_zone);
    
    minbound_location = 1;

    maxbound_location = round(working.estimated_varve_thickness*working.resolution*working.search_zone);
    
    if maxbound_location > working.last_pixel - working.first_pixel - 1
        maxbound_location = working.last_pixel - working.first_pixel - 1;
    end

    current_working.search_zone = summed_bands_core_image(ceil(working.correlation_centroid*size(summed_bands_core_image,1) ...
    - size(summed_bands_core_image,1)/(2*(1/(working.percent_cropped_middle*0.01)))):floor(working.correlation_centroid*size(summed_bands_core_image,1) + size(summed_bands_core_image,1)/(2*(1/(working.percent_cropped_middle*0.01)))),...
    minbound_location:maxbound_location);

    exit_loop_marker = 0;
    
    correlation_chip_min = 1;
    
    correlation_chip_max = round(working.estimated_varve_thickness*working.resolution);
    
    
    current_correlation_chip = summed_bands_core_image(ceil(working.correlation_centroid*size(summed_bands_core_image,1) ...
    - size(summed_bands_core_image,1)/(2*(1/(working.percent_cropped_middle*0.01)))):floor(working.correlation_centroid*...
    size(summed_bands_core_image,1) + size(summed_bands_core_image,1)/(2*(1/(working.percent_cropped_middle*0.01)))),...
    correlation_chip_min:correlation_chip_max);
    
    notfirstloop = 0;
    
    %Continue by selecting the next 'correlation chip' as the next peak
    %identified by the correlation calcualtion.
    
    
            %Install bounds on difference with previous value
        previous_correlation_chip_min = -1;
        
        previous_correlation_chip_max = -1;
        
        previous_minbound_location = -1;
        
        previous_maxbound_location = -1;
        
        previous_separation = -1;
        

while exit_loop_marker < 1
    
        if previous_correlation_chip_min ~= -1
            
            %IF next is more than THREE TIMES previous or estimated
         if  previous_correlation_chip_max - correlation_chip_max >  (previous_correlation_chip_max - previous_correlation_chip_min) * 3 ||...
                 previous_correlation_chip_max - correlation_chip_max >  (working.estimated_varve_thickness*working.resolution) * 3
            
             correlation_chip_max = previous_correlation_chip_max+round(working.estimated_varve_thickness*working.resolution)+1;
         end
         
            %IF next is less than ONE THIRD TIMES previous or estimated
         if  previous_correlation_chip_max - correlation_chip_max <  (previous_correlation_chip_max - previous_correlation_chip_min) * (1/3) ||...
                 previous_correlation_chip_max - correlation_chip_max <  (working.estimated_varve_thickness*working.resolution) * (1/3)
            
             correlation_chip_max = previous_correlation_chip_max+round(working.estimated_varve_thickness*working.resolution)+1;
             
         end
            
            
        end
    
        %Install bounds on difference with previous value
        previous_correlation_chip_min = correlation_chip_min;
        
        previous_correlation_chip_max = correlation_chip_max;
        
        previous_minbound_location = minbound_location;
        
        previous_maxbound_location = maxbound_location;
        
        previous_separation = previous_correlation_chip_max-previous_correlation_chip_min;
        
        
        
        
        % For lower bound portion - don't match itself
        
        if minbound_location  < correlation_chip_min - size(current_correlation_chip,2) - 1
        for correlation_loop = 1:correlation_chip_min - size(current_correlation_chip,2) - minbound_location
            
        match_chip = current_working.search_zone(:,...
        correlation_loop : correlation_loop + size(current_correlation_chip,2)-1);    
    
        correlation_columns(correlation_loop+minbound_location-1,column_counter) = corr2(current_correlation_chip,match_chip);
         
        end
        end
        
        %For upper bound portion
        
        if maxbound_location  > correlation_chip_max + size(current_correlation_chip,2) + 1
        for correlation_loop = correlation_chip_max+1- minbound_location:maxbound_location - size(current_correlation_chip,2) -1 - minbound_location
            
        match_chip = current_working.search_zone(:,...
        correlation_loop : correlation_loop + size(current_correlation_chip,2)-1);   
    
        correlation_columns(correlation_loop+minbound_location-1,column_counter) = corr2(current_correlation_chip,match_chip);
         
        end
        end
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%% ITERATIVELY CALCULATE THICKNESS %%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
working.estimated_varve_thickness = working.save_varve_thickness;        

iteration_counter_initial_size = 0;

splay_reduction_factor = 0;

while iteration_counter_initial_size < working.number_of_size_iterations

working.initial_varve_thickness = working.estimated_varve_thickness;

record_varve_sizes_window = zeros(4,1);

record_varve_sizes_calculated = zeros(4,1);


for varve_size_loop = 1:4 %parfor
        
    size_splay = 1/4^(iteration_counter_initial_size - splay_reduction_factor);
    
    working.estimated_varve_thickness = working.initial_varve_thickness*((1-size_splay/2)+size_splay*(varve_size_loop-1)/3);
    
    working.filter_size = ceil(working.estimated_varve_thickness*working.resolution*working.filter_proportion);
    
    
    record_varve_sizes_window(varve_size_loop,1) = working.estimated_varve_thickness;
    
    
    %--- Find peaks with varying filters
    if minbound_location~=correlation_chip_min
            correlation_columns(minbound_location:correlation_chip_min,column_counter) = ...
            movmean(correlation_columns(minbound_location:correlation_chip_min,column_counter),working.filter_size);
    end
    
        if correlation_chip_max ~= maxbound_location
        correlation_columns(correlation_chip_max:maxbound_location,column_counter) = ...
            movmean(correlation_columns(correlation_chip_max:maxbound_location,column_counter),working.filter_size); 
        end

        
        
        [~, lcs] = findpeaks(correlation_columns(minbound_location:maxbound_location,column_counter));
        
        lcs(lcs<correlation_chip_max) = []; %deleet the lesser ones
        
        [~, lcs_neg] = findpeaks(-correlation_columns(minbound_location:maxbound_location,column_counter));
        
        lcs_neg(lcs_neg<correlation_chip_max) = []; %deleet the lesser ones
        
        
        
        %---
    


    record_varve_sizes_calculated(varve_size_loop,1) = ((correlation_chip_min-minbound_location)+(maxbound_location-correlation_chip_max))...
        /((0.5*(size(lcs,1)+(size(lcs_neg,1))))*working.resolution);

end

if record_varve_sizes_calculated(1,1) < record_varve_sizes_window(1,1)
    
   working.estimated_varve_thickness = record_varve_sizes_window(1,1);
    
    splay_reduction_factor = splay_reduction_factor + 1;
    
elseif record_varve_sizes_calculated(4,1) > record_varve_sizes_window(4,1)
    
    working.estimated_varve_thickness = record_varve_sizes_window(4,1);
    
    splay_reduction_factor = splay_reduction_factor + 1;
    
else

for find_turning_point_loop = 2:4
    
    if (record_varve_sizes_calculated(find_turning_point_loop-1,1) > record_varve_sizes_window(find_turning_point_loop-1,1)) &&...
         (record_varve_sizes_calculated(find_turning_point_loop,1) < record_varve_sizes_window(find_turning_point_loop,1))   
        
     working.estimated_varve_thickness = 0.5*(record_varve_sizes_calculated(find_turning_point_loop-1,1)...
         +record_varve_sizes_calculated(find_turning_point_loop,1));
    
    end

end

end

iteration_counter_initial_size = iteration_counter_initial_size + 1;

end
        
        
 working.filter_size = working.estimated_varve_thickness;
 
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%% END %%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%        
        
        if minbound_location~=correlation_chip_min
            correlation_columns(minbound_location:correlation_chip_min,column_counter) = ...
            movmean(correlation_columns(minbound_location:correlation_chip_min,column_counter),working.filter_size);
    end
    
        if correlation_chip_max ~= maxbound_location
        correlation_columns(correlation_chip_max:maxbound_location,column_counter) = ...
            movmean(correlation_columns(correlation_chip_max:maxbound_location,column_counter),working.filter_size); 
        end

        
        
        [~, lcs] = findpeaks(correlation_columns(minbound_location:maxbound_location,column_counter));
        
        lcs(lcs<correlation_chip_max) = []; %deleet the lesser ones
        
        [~, lcs_neg] = findpeaks(-correlation_columns(minbound_location:maxbound_location,column_counter));
        
        lcs_neg(lcs_neg<correlation_chip_max) = []; %deleet the lesser ones
        
        current_separation = correlation_chip_max - correlation_chip_min;
        
        if size(lcs_neg,1) > 0
        try
        
%         correlation_chip_max = lcs(2,1);  %The next peak found in the data becomes the next search chip     
%         correlation_chip_min = lcs(1,1);
        
        
        correlation_chip_min = correlation_chip_max+1;

        correlation_chip_max = lcs_neg(1,1);  %The next trough found in the data becomes the next search chip     
        
        
            
        current_correlation_chip = summed_bands_core_image(ceil(working.correlation_centroid*size(summed_bands_core_image,1) ...
        - size(summed_bands_core_image,1)/(2*(1/(working.percent_cropped_middle*0.01)))):...
        floor(working.correlation_centroid*size(summed_bands_core_image,1) + size(summed_bands_core_image,1)/(2*(1/(working.percent_cropped_middle*0.01)))),...
        correlation_chip_min:correlation_chip_max);
                  
            
        catch
                   
        correlation_chip_max = correlation_chip_max + current_separation;
        
        if correlation_chip_min > size(summed_bands_core_image,2) || correlation_chip_max > size(summed_bands_core_image,2) || ((previous_correlation_chip_max - correlation_chip_max <  (previous_correlation_chip_max - previous_correlation_chip_min) * (1/3) ||...
                 previous_correlation_chip_max - correlation_chip_max <  (working.save_varve_thickness*working.resolution) * (1/3)) && ...
                 previous_correlation_chip_max+round(working.save_varve_thickness*working.resolution)+1 > size(summed_bands_core_image,2))
            
        exit_loop_marker = 1;  %none larger than current one = THE END      
        
        else
        
        correlation_chip_min = correlation_chip_min + previous_separation;
        
        current_correlation_chip = summed_bands_core_image(ceil(working.correlation_centroid*size(summed_bands_core_image,1) ...
        - size(summed_bands_core_image,1)/(2*(1/(working.percent_cropped_middle*0.01)))):floor(working.correlation_centroid*size(summed_bands_core_image,1) + size(summed_bands_core_image,1)/(2*(1/(working.percent_cropped_middle*0.01)))),...
        correlation_chip_min:correlation_chip_max);
               
        end
        end
        else
        
        correlation_chip_max = correlation_chip_max + current_separation;
        
        if correlation_chip_min > size(summed_bands_core_image,2) || correlation_chip_max > size(summed_bands_core_image,2) || ((previous_correlation_chip_max - correlation_chip_max <  (previous_correlation_chip_max - previous_correlation_chip_min) * (1/3) ||...
                 previous_correlation_chip_max - correlation_chip_max <  (working.save_varve_thickness*working.resolution) * (1/3)) && ...
                 previous_correlation_chip_max+round(working.save_varve_thickness*working.resolution)+1 > size(summed_bands_core_image,2))
            
        exit_loop_marker = 1;  %none larger than current one = THE END     
        
        else
        
        correlation_chip_min = correlation_chip_min + previous_separation;
        
        current_correlation_chip = summed_bands_core_image(ceil(working.correlation_centroid*size(summed_bands_core_image,1) ...
        - size(summed_bands_core_image,1)/(2*(1/(working.percent_cropped_middle*0.01)))):floor(working.correlation_centroid*size(summed_bands_core_image,1) + size(summed_bands_core_image,1)/(2*(1/(working.percent_cropped_middle*0.01)))),...
        correlation_chip_min:correlation_chip_max);
        
        end
        end
        
        search_distance = ceil(max((working.search_zone*(correlation_chip_max-correlation_chip_min)),(working.search_zone*working.resolution*working.estimated_varve_thickness)));
        %Search distance is the larger of searchzone * size of chip or
        %*estimated varve thickness. Should prevent runaway smaller chips.
        
        minbound_location = correlation_chip_min+(correlation_chip_max-correlation_chip_min) - search_distance;
        
        maxbound_location = correlation_chip_min+(correlation_chip_max-correlation_chip_min) + search_distance;
        
        if minbound_location < 1
            minbound_location = 1;
        end
        
        if maxbound_location > size(summed_bands_core_image,2)
         maxbound_location = size(summed_bands_core_image,2);
        end
        
        current_working.search_zone = summed_bands_core_image(ceil(working.correlation_centroid*size(summed_bands_core_image,1) ...
          - size(summed_bands_core_image,1)/(2*(1/(working.percent_cropped_middle*0.01)))):floor(working.correlation_centroid*size(summed_bands_core_image,1) + size(summed_bands_core_image,1)/(2*(1/(working.percent_cropped_middle*0.01)))),...
          minbound_location:maxbound_location);
        
        
        
        notfirstloop = 1;
        
        column_counter = column_counter+1;
        
        if column_counter > working.search_zone*5+1
            column_counter = 1;
        end
 
        

end
    
        
% end


%%%Calculate mean

mean_correlation = nanmean(correlation_columns,2);

%%%

% Smooth

mean_correlation_smoothed = ...
    movmean(mean_correlation,working.filter_size);
       
% Make layer database;

[~, mean_peak_locations] = findpeaks(mean_correlation_smoothed);

[~, mean_trough_locations] = findpeaks(-mean_correlation_smoothed);

%Calculate layer thicknesses

for loop = 1:size(mean_peak_locations,1)
if loop == 1
mean_peak_locations_gradient(loop,1) = mean_peak_locations(loop,1);
else
mean_peak_locations_gradient(loop,1) = mean_peak_locations(loop,1)-mean_peak_locations(loop-1,1);
end
end

mean_peak_locations_gradient_smoothed = ...
movmean(mean_peak_locations_gradient,working.filter_size);

for loop = 1:size(mean_trough_locations,1)
if loop == 1
mean_trough_locations_gradient(loop,1) = mean_trough_locations(loop,1);
else
mean_trough_locations_gradient(loop,1) = mean_trough_locations(loop,1)-mean_trough_locations(loop-1,1);
end
end

mean_trough_locations_gradient_smoothed = ...
    movmean(mean_trough_locations_gradient,working.filter_size);


if strcmpi(working.smoothly_varying_sedimentation_rate,'Yes')
if min(mean_peak_locations) < min ( mean_trough_locations) % first is a PEAK
 
    
    [full_varve_list] = filterMYvarves(working,mean_peak_locations_gradient,mean_peak_locations_gradient_smoothed);

else % first is a TROUGH
    
    [full_varve_list] = filterMYvarves(working,mean_trough_locations_gradient,mean_trough_locations_gradient_smoothed);
end
else
    
    full_varve_list = zeros(size(mean_trough_locations_gradient,1),3);
    
    full_varve_list(:,1) = 1:size(mean_trough_locations_gradient,1);
    
    full_varve_list(:,2) = mean_trough_locations;
    
    full_varve_list(:,3) = mean_trough_locations_gradient;
    
end
    

% Exclude or extrapolate relevant portions
if strcmpi(working.are_areas_excluded, 'Yes')
    
[working, full_varve_list] = excludeMYvarves(working, full_varve_list);    
    
end

