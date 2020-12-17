function mergeMYvarves(merged_inputs)

%% mergeMYvarves!
% Use this to combine several sections of one core into a single composite.
%


%% Required inputs

% %Enter core name for composite to be saved as
% 
% whole_core_name = 'GCO_LARG19-36A-1G';
% 
% % Add sections to list as required
% 
% combine_list={...
%     'GCO-LARG19-36A-1G-1-W';...
%     };

whole_core_name = merged_inputs.merged_name;

dinfo = dir(merged_inputs.merged_file);

combine_list = {dinfo.name}';
    
combine_list(1:2,:)=[];

%% Start the combination process, read data from files

%Calculate number of sections to combine

num_sections = size(combine_list,1);

% %Check if a 'combined sections' folder exists, create it if not
% if ~exist(strcat(inputs.merged_file, '/Results/Whole_core_composites'))
%     mkdir(strcat(inputs.merged_file,'./Results/Whole_core_composites'));
% end  

%Make a specific directory for this composite
mkdir(strcat(merged_inputs.merged_file, '/', whole_core_name));

save_folder = strcat(merged_inputs.merged_file, '/',whole_core_name);

% Loop through the sections

section_addition_parameter = 1;

temp_core_statistics = NaN(100000,7);

save_depth = 0;

% save_SR_Q1 = 0;
% 
% save_SR_Q2 = 0;
% 
% save_SR_Q3 = 0;

save_age_Q1 = 0;

save_age_Q2 = 0;

save_age_Q3 = 0;

for section_loop = 1:num_sections
    
    %Load one section
    folder_name = [merged_inputs.merged_file '\' combine_list{section_loop,1} '\Raw matlab data file.mat'];
    
    load(folder_name);
    
    %Find the length of the input
    length_cells = size(outputs.varve_positions,1);
    
    %Find the depth
    temp_core_statistics(section_addition_parameter:length_cells+section_addition_parameter-1,1) = ...
        outputs.varve_positions+save_depth;

    %Find the Q1 sed rate
    temp_core_statistics(section_addition_parameter:length_cells+section_addition_parameter-1,2) = ...
        outputs.varve_thicknesses.Q1;
    
    %Find the median sed rate
    temp_core_statistics(section_addition_parameter:length_cells+section_addition_parameter-1,3) = ...
        outputs.varve_thicknesses.median;
    
    %Find the Q3 sed rate
    temp_core_statistics(section_addition_parameter:length_cells+section_addition_parameter-1,4) = ...
        outputs.varve_thicknesses.Q3;
    
    %Find the Q1 age
    temp_core_statistics(section_addition_parameter:length_cells+section_addition_parameter-1,5) = ...
        outputs.varve_ages.Q1+save_age_Q1;
    
    %Find the median age
    temp_core_statistics(section_addition_parameter:length_cells+section_addition_parameter-1,6) = ...
        outputs.varve_ages.median+save_age_Q2;
    
    %Find the Q3 age
    temp_core_statistics(section_addition_parameter:length_cells+section_addition_parameter-1,7) = ...
        outputs.varve_ages.Q3+save_age_Q3;
   
    
    %Save stats
    save_depth = temp_core_statistics(length_cells+section_addition_parameter-1,1);
%     save_SR_Q1 = temp_core_statistics(length_cells+section_addition_parameter-1,2);
%     save_SR_Q2 = temp_core_statistics(length_cells+section_addition_parameter-1,3);
%     save_SR_Q3 = temp_core_statistics(length_cells+section_addition_parameter-1,4);
    save_age_Q1 = temp_core_statistics(length_cells+section_addition_parameter-1,5);
    save_age_Q2 = temp_core_statistics(length_cells+section_addition_parameter-1,6);
    save_age_Q3 = temp_core_statistics(length_cells+section_addition_parameter-1,7);
    
    
    %Stacks cumulative sections
    section_addition_parameter = section_addition_parameter + length_cells;
    
end

temp_core_statistics = rmmissing(temp_core_statistics);

%Load one inputs file for resolution data, etc
    folder_name = [merged_inputs.merged_file '\' combine_list{1,1} '\'];
    
    load(strcat(folder_name,'Run inputs.mat'));
    
temp_core_statistics(:,5) = temp_core_statistics(:,5)-(inputs.ext_error*temp_core_statistics(:,6));

temp_core_statistics(:,7) = temp_core_statistics(:,7)+(inputs.ext_error*temp_core_statistics(:,6));
    

final_core_statistics = NaN(size(temp_core_statistics,1)+1,size(temp_core_statistics,2));

final_core_statistics(2:size(temp_core_statistics,1)+1,1:size(temp_core_statistics,2)) = temp_core_statistics;

final_core_statistics = num2cell(final_core_statistics);

final_core_statistics{1,1} = 'Depth (mm)';

final_core_statistics{1,2} = 'Median sedimentation rate (mm/yr)';

final_core_statistics{1,3} = 'Median sedimentation rate (mm/yr)';

final_core_statistics{1,4} = 'Median sedimentation rate (mm/yr)';

final_core_statistics{1,5} = 'Minimum age (years)';

final_core_statistics{1,6} = 'Median age (years)';

final_core_statistics{1,7} = 'Maximum age (years)';



%% Make Plots

    


%PLOT VARVE THICKNESS = SEDIMENTATION RATE over DEPTH


varve_thickness = figure('visible','off');



movmean_thick = movmean([final_core_statistics{2:end,3}],10*4);

plot([final_core_statistics{2:end,1}],movmean_thick,'r');

hold on
plot([final_core_statistics{2:end,1}],[final_core_statistics{2:end,3}],'k','LineStyle',':');


%Calculate axis limits
y_minimum = min([final_core_statistics{2:end,3}]') - 3;
if y_minimum < 0
    y_minimum = 0;
end
y_maximum = median([final_core_statistics{2:end,3}]') + 3;
ylim([y_minimum y_maximum]);
xlim([1 [final_core_statistics{end,1}]]);
ylabel_text = ['Sedimentation rate' ' ' '(mm/yr)'];
ylabel(ylabel_text)
xlabel_text = ['Depth in core' ' ' '(mm)'];
xlabel(xlabel_text)
title_varve_thickness = ['Sedimentation rate for' ' ' whole_core_name];
title(title_varve_thickness)

set(gca,'fontname','times')

plot_name_path = [save_folder '/Sedimentation rate with depth.png'];

print(varve_thickness,'-dpng','-r500',plot_name_path);



%PLOT VARVE THICKNESS = SEDIMENTATION RATE over TIME

%first, remove outlier values

rm_tephras = final_core_statistics;

rm_tephras(1,:)=[];

rm_tephras = [zeros(1,7); cell2mat(rm_tephras)];

rm_tephras = rmoutliers(rm_tephras);

rm_tephras = num2cell(rm_tephras);

varve_thickness_time = figure('visible','off');

movmean_thick = movmean([rm_tephras{2:end,3}],10*4);

plot([rm_tephras{2:end,6}],movmean_thick,'r');

hold on
plot([rm_tephras{2:end,6}],[rm_tephras{2:end,3}],'k','LineStyle',':');


%Calculate axis limits
y_minimum = min([rm_tephras{2:end,3}]') - 3;
if y_minimum < 0
    y_minimum = 0;
end
y_maximum = median([rm_tephras{2:end,3}]') + 3;
ylim([y_minimum y_maximum]);
xlim([1 [rm_tephras{end,6}]]);
ylabel_text = ['Sedimentation rate' ' ' '(mm/yr)'];
ylabel(ylabel_text)
xlabel_text = ['Age' ' ' '(years)'];
xlabel(xlabel_text)
title_varve_thickness = ['Sedimentation rate per year for' ' ' whole_core_name];
title(title_varve_thickness)

set(gca,'fontname','times')

plot_name_path = [save_folder '/Sedimentation rate over time.png'];

print(varve_thickness_time,'-dpng','-r500',plot_name_path);


%PLOT VARVE THICKNESS = SEDIMENTATION RATE over TIME MOVING MEAN


varve_thickness_mean = figure('visible','off');

movmean_thick = movmean([rm_tephras{2:end,3}],10*4);

plot([rm_tephras{2:end,6}],movmean_thick,'r');

hold on

movmean_thick = movmean([rm_tephras{2:end,3}],50*4);

plot([rm_tephras{2:end,6}],movmean_thick,'b');

hold on

movmean_thick = movmean([rm_tephras{2:end,3}],500*4);

plot([rm_tephras{2:end,6}],movmean_thick,'k');

legend('10 point average','50 point average','500 point average')

%Calculate axis limits
y_minimum = min([rm_tephras{2:end,3}]') - 3;
if y_minimum < 0
    y_minimum = 0;
end
y_maximum = median([rm_tephras{2:end,3}]') + 3;
ylim([y_minimum y_maximum]);
xlim([1 [rm_tephras{end,6}]]);
ylabel_text = ['Sedimentation rate' ' ' '(mm/yr)'];
ylabel(ylabel_text)
xlabel_text = ['Age' ' ' '(years)'];
xlabel(xlabel_text)
title_varve_thickness = ['Sedimentation rate per year for' ' ' whole_core_name];
title(title_varve_thickness)

set(gca,'fontname','times')

plot_name_path = [save_folder '/Smoothed sedimentation rate over time.png'];

print(varve_thickness_mean,'-dpng','-r500',plot_name_path);


%PLOT AGE DEPTH PLOT
age_depth = figure('visible','off');


plot([final_core_statistics{2:end,6}],[final_core_statistics{2:end,1}],'k');

hold on
transparent_std=plot([final_core_statistics{2:end,5}],[final_core_statistics{2:end,1}],'r');
transparent_std.Color(4) = 0.6;
hold on
transparent_std=plot([final_core_statistics{2:end,7}],[final_core_statistics{2:end,1}],'r');
transparent_std.Color(4) = 0.6;


ylabel('Depth in core (mm)')
xlabel('Age (years)')
title_age_depth = ['Age Depth Plot for' ' ' inputs.core_name];
title(title_age_depth)

set(gca,'fontname','times')
set(gca, 'YDir','reverse')


plot_name_path = [save_folder '/Age Depth plot.png'];

print(age_depth,'-dpng','-r500',plot_name_path);







%% Create CSV file of main outputs
csv_name_path = [save_folder '/' whole_core_name ' ' 'data table.csv'];

writecell(final_core_statistics,csv_name_path)


