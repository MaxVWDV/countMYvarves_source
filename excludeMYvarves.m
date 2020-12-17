function [working, full_varve_list] = excludeMYvarves(working, full_varve_list)

excluded_areas = readtable(working.exluded_intervals_file,'Range','A4:C105'); %Read the excel exclusion file


excluded_areas = rmmissing(excluded_areas{:,:});                             %crop it and turn into matrix

if any(excluded_areas==-1,'all')
    excluded_areas(excluded_areas==-1) = working.first_pixel/working.resolution;
end

if any(excluded_areas==-2,'all')
    excluded_areas(excluded_areas==-2) = working.last_pixel/working.resolution;
end

excluded_areas(:,1:2) = excluded_areas(:,1:2).*working.resolution;

varve_positions = full_varve_list(:,2);
    
varve_thicknesses = full_varve_list(:,3);

markervt = 0;


for exclusion_loop = 1:size(excluded_areas,1)
    
    start_current_excluded = excluded_areas(exclusion_loop,1) - working.first_pixel; %Start of this interval
    
    end_current_excluded = excluded_areas(exclusion_loop,2) - working.first_pixel;
    
    if end_current_excluded > 1 && start_current_excluded < (working.last_pixel-working.first_pixel)
    
    if start_current_excluded < 1   %if out of bounds, move to in bounds
        start_current_excluded = 1;
    end
    
    if end_current_excluded > working.last_pixel   %if out of bounds, move to in bounds
        end_current_excluded = working.last_pixel ;
    end
    
    
    if excluded_areas(exclusion_loop,3) == 1 %EXTRAPOLATE
        
    %Find mean varve thickness of remainder of core, cut out relevant
    %portion, extrapolate and recombine!
    
    if start_current_excluded < full_varve_list(1,2) %Excluded interval right at the start
        
       
        %Find mean varve thickness of remainder of core
        mean_value_remainder = mean(varve_thicknesses(varve_positions>end_current_excluded));
        
        
        %Split off portion after interval
        
        portion_after_interval = varve_positions(varve_positions>end_current_excluded);
        
        %'Create' varves in excluded area
        
        size_excluded = end_current_excluded - start_current_excluded;
        
        number_of_varves_interpolated = round(size_excluded/mean_value_remainder);
        
        size_of_varves_interpolated = size_excluded/number_of_varves_interpolated;
        
        if number_of_varves_interpolated >= 1
        
        portion_interpolated = ones(number_of_varves_interpolated,1);
        
        for interpolation_loop = 1:number_of_varves_interpolated
            
           portion_interpolated(interpolation_loop,1) = round(size_of_varves_interpolated*interpolation_loop);
           
        end
        
        output_varve_locations = ones((size(portion_interpolated,1) + size(portion_after_interval,1)),1);
        
        output_varve_locations(1:size(portion_interpolated,1),1) = portion_interpolated;
        
        output_varve_locations(size(portion_interpolated,1)+1:end,1) = portion_after_interval;
                
        else
            
        output_varve_locations = portion_after_interval;
            
            
        end
        
        
        
    elseif end_current_excluded > full_varve_list(size(full_varve_list,1),2) %Excluded interval right at the end
       
        %Find mean varve thickness of remainder of core
       mean_value_remainder = mean(varve_thicknesses(varve_positions<start_current_excluded)); 
       
       
       
       %Split off portion before interval
        
        portion_before_interval = varve_positions(varve_positions<start_current_excluded);
        
        %'Create' varves in excluded area
        
        size_excluded = end_current_excluded - start_current_excluded;
        
        number_of_varves_interpolated = round(size_excluded/mean_value_remainder);
        
        size_of_varves_interpolated = size_excluded/number_of_varves_interpolated;
        
        if number_of_varves_interpolated >= 1
        
        portion_interpolated = ones(number_of_varves_interpolated,1);
        
        for interpolation_loop = 1:number_of_varves_interpolated
            
           portion_interpolated(interpolation_loop,1) = round(size_of_varves_interpolated*interpolation_loop)+start_current_excluded;
           
        end
        
        output_varve_locations = ones((size(portion_interpolated,1) + size(portion_before_interval,1)),1);
        
        output_varve_locations(1:size(portion_before_interval,1),1) = portion_before_interval;
        
        output_varve_locations(size(portion_before_interval,1)+1:end,1) = portion_interpolated;
                
        else
            
        output_varve_locations = portion_before_interval;
            
            
        end
       
       
       
    else
        
        if ~isnan(nanmedian(varve_thicknesses(varve_positions>end_current_excluded))) &&...
                ~isnan(nanmedian(varve_thicknesses(varve_positions<start_current_excluded)))
        %Find mean varve thickness of remainder of core
        mean_value_remainder = 0.5* (nanmedian(varve_thicknesses(varve_positions>end_current_excluded))+...
            nanmedian(varve_thicknesses(varve_positions<start_current_excluded)));
        elseif ~isnan(nanmedian(varve_thicknesses(varve_positions>end_current_excluded))) &&...
                isnan(nanmedian(varve_thicknesses(varve_positions<start_current_excluded)))
            mean_value_remainder =  (nanmedian(varve_thicknesses(varve_positions>end_current_excluded)));
            elseif isnan(nanmedian(varve_thicknesses(varve_positions>end_current_excluded))) &&...
                ~isnan(nanmedian(varve_thicknesses(varve_positions<start_current_excluded)))
            mean_value_remainder =  nanmedian(varve_thicknesses(varve_positions<start_current_excluded));
        end
        
        
        
        %Split off portion before and after interval
        
        portion_before_interval = varve_positions(varve_positions<start_current_excluded);
        
        portion_after_interval = varve_positions(varve_positions>end_current_excluded);
        
        %'Create' varves in excluded area
        
        size_excluded = end_current_excluded - start_current_excluded;
        
        number_of_varves_interpolated = round(size_excluded/mean_value_remainder);
        
        size_of_varves_interpolated = size_excluded/number_of_varves_interpolated;
        
        if number_of_varves_interpolated >= 1
        
        portion_interpolated = ones(number_of_varves_interpolated,1);
        
        for interpolation_loop = 1:number_of_varves_interpolated
            
           portion_interpolated(interpolation_loop,1) = round(size_of_varves_interpolated*interpolation_loop)+start_current_excluded;
           
        end
        
        output_varve_locations = ones((size(portion_interpolated,1) + size(portion_before_interval,1)+ size(portion_after_interval,1)),1);
        
        output_varve_locations(1:size(portion_before_interval,1),1) = portion_before_interval;
        
        output_varve_locations(size(portion_before_interval,1)+1:size(portion_before_interval,1)+size(portion_interpolated,1),1) = portion_interpolated;
        
        output_varve_locations(size(portion_before_interval,1)+size(portion_interpolated,1)+1:end,1) = portion_after_interval;

                
        else
            
            
        output_varve_locations = ones((size(portion_before_interval,1) + size(portion_after_interval,1)),1);
        
        output_varve_locations(1:size(portion_before_interval,1),1) = portion_before_interval;
        
        output_varve_locations(size(portion_before_interval,1)+1:end,1) = portion_after_interval;    
            

        end
        
                
           
    end
    
    
        
        
        
        
    elseif excluded_areas(exclusion_loop,3) == 2 %EXCLUDE
        
        
    if start_current_excluded < full_varve_list(1,2) %Excluded interval right at the start
        

        
        %Split off portion after interval
        
        
        
        portion_after_interval = varve_positions(varve_positions>end_current_excluded);
       
            
        output_varve_locations(2:size(portion_after_interval,1)+1,1) = portion_after_interval(:,1);
        
        output_varve_locations(1,1) = max(1,end_current_excluded);
            

        
        
        
    elseif end_current_excluded > full_varve_list(size(full_varve_list,1),2) %Excluded interval right at the end
       
        
       %Split off portion before interval
        
        portion_before_interval = varve_positions(varve_positions<start_current_excluded);
        
                    
        output_varve_locations(1:size(portion_before_interval,1),1) = portion_before_interval(:,1);
        
        output_varve_locations(size(portion_before_interval,1)+1,1) = min(working.last_pixel-working.first_pixel,start_current_excluded);
            
            
      
       
       
    else
        
       
        %Split off portion before and after interval
        
        portion_before_interval = varve_positions(varve_positions<start_current_excluded);
        
        portion_after_interval = varve_positions(varve_positions>end_current_excluded);           
            
        output_varve_locations = ones((size(portion_before_interval,1) + size(portion_after_interval,1)),1);
        
        output_varve_locations(1:size(portion_before_interval,1),1) = portion_before_interval;
        
        output_varve_locations(size(portion_before_interval,1)+1:end,1) = portion_after_interval;    
            

        end
        
                
           
    end    
    
    varve_positions = output_varve_locations;
    
    output_varve_locations = [];
    
    varve_thicknesses = ones(size(varve_positions,1),1);
    
    %Calculate layer thicknesses

        for loop = 1:size(varve_positions,1)
        if loop == 1
        varve_thicknesses(loop,1) = varve_positions(loop,1);
        else
        varve_thicknesses(loop,1) = varve_positions(loop,1)-varve_positions(loop-1,1);
        end
        end
        
        markervt = 1;
    end
end

% Force first and last varve thickness reading to absurdly high value, else can be too fine
% and break it

if markervt == 1

varve_thicknesses(1,1) = 9999;

varve_thicknesses(size(varve_thicknesses,1),1) = 9999;

end
    
full_varve_list = [];

full_varve_list(:,2) = varve_positions;

full_varve_list(:,3) = varve_thicknesses;
        
for year_loop = 1:size(full_varve_list,1)
    
    full_varve_list(year_loop,1) = year_loop;
    
end
    
    
