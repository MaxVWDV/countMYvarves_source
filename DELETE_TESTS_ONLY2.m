function publishMYreport(inputs,outputs)
%REPORT FOR CORE RUN
%% Varve counting results report
%Thanks for using countMYvarves. This report sums up your results and key
%assumptions.


% % % %options.codeToEvaluate = 'DELETE_TESTS_ONLY2(in,in2)';
% % % % options.format = 'doc';
% % % % options.showCode = false;
% % % % publish('DELETE_TESTS_ONLY2.m', options);




% Automatically generate a word document with a status report for this core
% run.
%
% Acknowledgements to Andreas Karlsson for some of the functions included here.
%
% % -------------------------------------------------------------------
%     file_name = [inputs.core_name ' ' 'data files and plots'];
%     file_name_docx = [inputs.core_name ' ' 'varve count report' '.doc'];
%     present_directory = pwd;
% 	WordFileName= file_name_docx;
% 	CurDir= strcat(results_folder,file_name);
% 	FileSpec = fullfile(CurDir,WordFileName);
% 	[ActXWord,WordHandle]=StartWord(FileSpec);
    
%     fprintf('Document will be saved in %s\n',FileSpec);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
%Section 1
%     %%create header in word        
%     Style='Heading 1'; %NOTE! if you are NOT using an English version of MSWord you get
%     % an error here. For Swedish installations use 'Rubrik 1'. 
    TextString=[inputs.core_name ' ' 'full varve count report'];
    disp(TextString)
    disp('  ');disp('  ');
%     WordText(ActXWord,TextString,Style,[0,2]);%two enters after text
    cmv_logo = imread('cmv_logo_colour.png');
    
        
%     Style='Normal';
    today_date_run = date;
    TextString=['Age-depth model created on' ' ' today_date_run ' ' 'using countMYvarves!'];  
    disp(TextString)
    disp('  ');disp('  ');
%     WordText(ActXWord,TextString,Style,[1,1]);%enter after text
     
    
    
    TextString='This report provides an account of the model run, assumptions and results.';
    disp(TextString)
    disp('The automated "write to word" function failed, so this bare-bones report is generated as a backup. Note this will be common on macOS, linux and older Windows computers.')
    disp('This report is not elegant, but the necessary information is here. Feel free to re-format to your own template.')
    disp('  ');disp('  ');
    
    
%% Summary Statistics


%     disp('Summary Statistics')
    Number_of_columns = size(outputs.varve_ages.raw,1);
    
    Q1_age = round(outputs.varve_ages.Q1(Number_of_columns,1)-(inputs.ext_error*outputs.varve_ages.median(Number_of_columns,1)),1);
    
    Median_age = round(outputs.varve_ages.median(Number_of_columns,1),1);
    
    Q3_age = round(outputs.varve_ages.Q3(Number_of_columns,1)+(inputs.ext_error*outputs.varve_ages.median(Number_of_columns,1)),1);
    
    Q1_thickness = round(median(outputs.varve_thicknesses.Q1,'all'),2);
    
    Median_thickness = round(median(outputs.varve_thicknesses.raw,'all'),2);
    
    Q3_thickness = round(median(outputs.varve_thicknesses.Q3),2);
    
    Minimum_thickness = round(min(mean(outputs.varve_thicknesses.raw)),2);

    Maximum_thickness = round(max(mean(outputs.varve_thicknesses.raw)),2);
    
    
    TextString=['This image contains a median of' ' ' num2str(Median_age) ' ' 'varves or years, with a minimum of' ' ' num2str(Q1_age) ' '...
        'and a maximum of' ' ' num2str(Q3_age) ' ' 'years.' ' ' 'This accounts for both internal counting uncertainty and' ' ' num2str(inputs.ext_error*100)...
        '% additional external error.'];
    disp(TextString)
    disp('  ');disp('  ');
    
    TextString=['This core has an overall median sedimentation rate (varve thickness) of' ' ' num2str(Median_thickness) ' ' 'mm per year, with the 25th percentile sedimentation rate being' ' ' num2str(Q1_thickness) ' '...
        'mm per year and the 75th percentile sedimentation rate being' ' ' num2str(Q3_thickness) ' ' 'mm.'];
    disp(TextString)
    disp('  ');disp('  '); disp('  ');disp('  ');disp('  ');disp('  ');disp('  ');disp('  ');disp('  ');disp('  ');disp('  ');disp('  ');disp('  ');disp('  ');

    


%% Key assumptions

    TextString='Key assumptions made:';
    disp(TextString)
    disp('  ');disp('  ');
    label_number = 1;
    TextString=[num2str(label_number) ')' ' ' 'The core contains a repeating, self-similar pattern that represents an annual cycle (i.e. a varve, although it need not be a dark and light alternation.'];
    disp(TextString)
    disp('  ');disp('  ');
    label_number = label_number+1;
    TextString=[num2str(label_number) ')' ' '  'Unless explicitly excluded, varves are clear enough to be detected throughout the core length.'];
    disp(TextString)
    disp('  ');disp('  ');
    
    if strcmpi(inputs.are_areas_excluded, 'Yes')
        label_number = label_number+1;
    TextString=[num2str(label_number) ')' ' ' 'Certain areas are either excluded from the count (i.e. essentially instantaneous) or assumed to be disrupted and extrapolated over with the mean sedimentation rate. See table on next page for full details.'];
    disp(TextString)
    disp('  ');disp('  ');
    end
    if strcmpi(inputs.smoothly_varying_sedimentation_rate, 'Yes')
        label_number = label_number+1;
    TextString=[num2str(label_number) ')' ' ' 'The sedimentation rate is (mostly) smoothly varying.'];
    disp(TextString)
    disp('  ');disp('  ');
    end
        if strcmpi(inputs.Filter_double_thickness, 'Yes')
            label_number = label_number+1;
    TextString=[num2str(label_number) ')' ' ' 'Where a varve is close to double the thickness of the local (10 point) mean, it is assumed to be two varves.'];
    disp(TextString)
    disp('  ');disp('  ');
        end
        if strcmpi(inputs.Filter_triple_thickness, 'Yes')
            label_number = label_number+1;
    TextString=[num2str(label_number) ')' ' ' 'Where a varve is close to triple the thickness of the local (10 point) mean, it is assumed to be three varves.'];
    disp(TextString)
    disp('  ');disp('  ');
        end
    if strcmpi(inputs.Filter_low_thickness, 'Yes')
        label_number = label_number+1;
    TextString=[num2str(label_number) ')' ' ' 'Where two consecutive varves are more than 25% below the regional mean, and their sum is close to the regional mean, they are counted as one varve.'];
    disp(TextString)
    disp('  ');disp('  ');
    end
    
    
    if inputs.scaling_factor == 1
    TextString= ['The core was also pre-processed using a' ' ' num2str(round(inputs.estimated_varve_thickness*inputs.resolution*0.25),1) ' ' 'pixel ('...
        num2str(round(inputs.estimated_varve_thickness*0.25),2) ' ' 'mm) median filter. Outlier pixels were excluded and interpolated over, and the image was smoothed'...
        ' ' 'using a' ' ' num2str(round(inputs.estimated_varve_thickness*inputs.resolution*0.333),1) ' ' 'pixel ('...
        num2str(round(inputs.estimated_varve_thickness*0.333),2) ' ' 'mm) smoothing mask.'];
    disp(TextString)
    disp('  ');disp('  ');
    else
    TextString= ['The core was also pre-processed using a' ' ' num2str(round(inputs.estimated_varve_thickness*inputs.resolution*0.25),1) ' ' 'pixel ('...
        num2str(round(inputs.estimated_varve_thickness*0.25),2) ' ' 'mm) median filter. Outlier pixels were excluded and interpolated over, and the image was smoothed'...
        ' ' 'using a' ' ' num2str(round(inputs.estimated_varve_thickness*inputs.resolution*0.333),1) ' ' 'pixel ('...
        num2str(round(inputs.estimated_varve_thickness*0.333),2) ' ' 'mm) smoothing mask. The resolution of the input image was coarsened by a factor of' ' '...
        num2str(inputs.scaling_factor) ' ' 'using a linear interpolation in order to reduce computational time. The image analysed had a resolution of' ' ' ...
        num2str(inputs.resolution/inputs.scaling_factor) ' ' 'pixels per mm.'];
    disp(TextString)
    disp('  ');disp('  ');   
        
    end
    
    difference_in_varve_thickness = inputs.estimated_varve_thickness/Median_thickness;
    
    if difference_in_varve_thickness < 1.5 && difference_in_varve_thickness > 0.5
    
    TextString= ['The initial estimated varve thickness is within 50% of the final calculated thickess.' ' '...
        'It is unlikely that the results were biased by over or under-smoothing.'];
    disp(TextString)
    disp('  ');disp('  ');  
    
    elseif difference_in_varve_thickness > 1.50
TextString= ['The initial estimated varve thickness more than 50% higher than the final calculated thickess (' ...
    num2str(round(difference_in_varve_thickness*100-100),2) ' ' '% higher).'...
        'This could in some cases lead to over-smoothing and underestimation of the number of varves.' ' ' ...
        'If there is a problem with the results, perhaps re-run this core with an estimated initial varve thickness of' ' ' ...
        num2str(round(Median_thickness),2) ' ' 'mm).'];
    disp(TextString)
    disp('  ');disp('  ');  
    
    elseif difference_in_varve_thickness < 0.50
        
       TextString= ['The initial estimated varve thickness more than 50% lower than the final calculated thickess (' ...
    num2str(round(difference_in_varve_thickness*100-100),2) ' ' '% lower).'...
        'This could in some cases lead to image noise remaining and overestimation of the number of varves.' ' ' ...
        'If there is a problem with the results, perhaps re-run this core with an estimated initial varve thickness of' ' ' ...
        num2str(round(Median_thickness),2) ' ' 'mm).'];
    disp(TextString)
    disp('  ');disp('  ');   
        
    end

    disp('  ');disp('  ');   disp('  ');disp('  ');   disp('  ');disp('  ');   disp('  ');disp('  ');   disp('  ');disp('  ');   disp('  ');disp('  ');   disp('  ');disp('  ');

   
%% Input data for this run.
    disp('  ');disp('  '); 

C = struct2cell(inputs);
numIndex = find(not(cellfun('isclass', C, 'char')));
for i = reshape(numIndex, 1, [])
C{i} = num2str(C{i});
end
    
input_table = [fieldnames(inputs) C];

    [NoRows,NoCols]=size(input_table);          
    input_table

    
    
% % % %% Plots: Sedimentation rate and Age-Depth
% % % varve_thickness = figure;
% % % 
% % % 
% % % for plot_iterations = 1:size(outputs.varve_ages.raw,2)
% % %     hold on
% % %     transparent_plot = plot(outputs.varve_positions,outputs.varve_thicknesses.raw(:,plot_iterations),'Color','k','LineWidth',0.3,'HandleVisibility','off','LineStyle',':');
% % %     transparent_plot.Color(4) = 0.33;
% % % end
% % % hold on
% % % plot(outputs.varve_positions,outputs.varve_thicknesses.median,'k');
% % % 
% % % hold on
% % % transparent_std = plot(outputs.varve_positions,outputs.varve_thicknesses.Q1,'r');
% % % transparent_std.Color(4) = 0.6;
% % % hold on
% % % transparent_std=plot(outputs.varve_positions,outputs.varve_thicknesses.Q3,'r');
% % % transparent_std.Color(4) = 0.6;
% % % %Calculate axis limits
% % % y_minimum = min(outputs.varve_thicknesses.median,[],'all') - 3;
% % % if y_minimum < 0
% % %     y_minimum = 0;
% % % end
% % % y_maximum = median(outputs.varve_thicknesses.raw,'all') + 3;
% % % ylim([y_minimum y_maximum]);
% % % xlim([1 outputs.varve_positions(size(outputs.varve_positions,1),1)]);
% % % ylabel_text = ['Sedimentation rate' ' ' '(mm/yr)'];
% % % ylabel(ylabel_text)
% % % xlabel_text = ['Depth in core' ' ' '(mm)'];
% % % xlabel(xlabel_text)
% % % title_varve_thickness = ['Sedimentation rate for' ' ' inputs.core_name];
% % % title(title_varve_thickness)
% % % 
% % % set(gca,'fontname','times')
% % % 
% % %     
% % %  
% % % 
% % % %PLOT AGE DEPTH PLOT
% % % age_depth = figure;
% % % 
% % % for plot_iterations = 1:size(outputs.varve_ages.raw,2)
% % %     hold on
% % %     transparent_plot = plot(outputs.varve_ages.raw(:,plot_iterations),outputs.varve_positions,'Color','k','LineWidth',0.3,'HandleVisibility','off','LineStyle',':');
% % %     transparent_plot.Color(4) = 0.33;
% % % end
% % % hold on
% % % plot(outputs.varve_ages.median,outputs.varve_positions,'k');
% % % 
% % % 
% % % hold on
% % % transparent_std=plot(outputs.varve_ages.Q1-(inputs.ext_error*outputs.varve_ages.median),(outputs.varve_positions),'r');
% % % transparent_std.Color(4) = 0.25;
% % % hold on
% % % transparent_std=plot(outputs.varve_ages.Q3+(inputs.ext_error*outputs.varve_ages.median),(outputs.varve_positions),'r');
% % % transparent_std.Color(4) = 0.25;
% % % 
% % % 
% % % ylabel('Depth in core (mm)')
% % % xlabel('Age (years)')
% % % title_age_depth = ['Age Depth Plot for' ' ' inputs.core_name];
% % % title(title_age_depth)
% % % 
% % % set(gca,'fontname','times')
% % % set(gca, 'YDir','reverse')
% % % 
% % % 
% % %     
% % % 
% % % 
% % % figure;
% % %     imshow(cmv_logo);
% % %     disp('  ');disp('  ');disp('  ');disp('  ');
% % %     
% % %     
if strcmpi(inputs.are_areas_excluded, 'Yes')
        
%         %%
%         c = 5;
%         d=99+1;
%         %%
%         test = 55;
%         b = sqrt(test);
    %% Excluded areas (in pixels)



    text='Excluded and extrapolated intervals defined (Pixels):';
    disp(text)
    disp('  ');disp('  ');
    

    TextString='See "excluded interval" excel files to edit these assumptions.';
    disp(TextString)
    disp('  ');disp('  '); 

excluded_areas = readtable(inputs.exluded_intervals_file,'Range','A3:D105','PreserveVariableNames',true); %Read the excel exclusion file


excluded_areas = table2cell(rmmissing(excluded_areas));                             %crop it and turn into matrix
%     [NoRows,NoCols]=size(excluded_areas);          
    %create table with data from DataCell
     disp(excluded_areas)
    
    
%% Excluded areas (in mm)

    
    %Section 3
    style='Heading 2';
    text='Excluded and extrapolated intervals defined (mm):';
    disp(text)
    disp('  ');disp('  ');
    

    TextString='See "excluded interval" excel files to edit these assumptions. Note depths are in mm rather than pixels.';
    disp(TextString)
    disp('  ');disp('  '); 
% %     %the obvious data
%     DataCell={'Test 12', num2str(0.3) ,'Pass';
%               'Test 2', num2str(1.8) ,'Fail'};

excluded_areas = readtable(inputs.exluded_intervals_file,'Range','A3:D105','PreserveVariableNames',true); %Read the excel exclusion file


excluded_areas = table2cell(rmmissing(excluded_areas));                             %crop it and turn into matrix

for loop = 2:size(excluded_areas,1)

    excluded_areas{loop,1} = num2str(round(str2double(excluded_areas{loop,1})/inputs.resolution,2));
    excluded_areas{loop,2} = num2str(round(str2double(excluded_areas{loop,2})/inputs.resolution,2));
%     excluded_areas{loop,3} = temp3;
end
%     [NoRows,NoCols]=size(excluded_areas);          
    disp(excluded_areas)
    
end

    
    Style='Normal';
    TextString='Note: raw age-depth data for this core is available in associated .csv file in this folder. This may be loaded into other programs (e.g. Corelyser) if useful.';
    disp(TextString)
    disp('  ');disp('  '); 


        
    %% Plots: Sedimentation rate and Age-Depth
varve_thickness = figure;


for plot_iterations = 1:size(outputs.varve_ages.raw,2)
    hold on
    transparent_plot = plot(outputs.varve_positions,outputs.varve_thicknesses.raw(:,plot_iterations),'Color','k','LineWidth',0.3,'HandleVisibility','off','LineStyle',':');
    transparent_plot.Color(4) = 0.33;
end
hold on
plot(outputs.varve_positions,outputs.varve_thicknesses.median,'k');

hold on
transparent_std = plot(outputs.varve_positions,outputs.varve_thicknesses.Q1,'r');
transparent_std.Color(4) = 0.6;
hold on
transparent_std=plot(outputs.varve_positions,outputs.varve_thicknesses.Q3,'r');
transparent_std.Color(4) = 0.6;
%Calculate axis limits
y_minimum = min(outputs.varve_thicknesses.median,[],'all') - 3;
if y_minimum < 0
    y_minimum = 0;
end
y_maximum = median(outputs.varve_thicknesses.raw,'all') + 3;
ylim([y_minimum y_maximum]);
xlim([1 outputs.varve_positions(size(outputs.varve_positions,1),1)]);
ylabel_text = ['Sedimentation rate' ' ' '(mm/yr)'];
ylabel(ylabel_text)
xlabel_text = ['Depth in core' ' ' '(mm)'];
xlabel(xlabel_text)
title_varve_thickness = ['Sedimentation rate for' ' ' inputs.core_name];
title(title_varve_thickness)

set(gca,'fontname','times')

    
 

%PLOT AGE DEPTH PLOT
age_depth = figure;

for plot_iterations = 1:size(outputs.varve_ages.raw,2)
    hold on
    transparent_plot = plot(outputs.varve_ages.raw(:,plot_iterations),outputs.varve_positions,'Color','k','LineWidth',0.3,'HandleVisibility','off','LineStyle',':');
    transparent_plot.Color(4) = 0.33;
end
hold on
plot(outputs.varve_ages.median,outputs.varve_positions,'k');


hold on
transparent_std=plot(outputs.varve_ages.Q1-(inputs.ext_error*outputs.varve_ages.median),(outputs.varve_positions),'r');
transparent_std.Color(4) = 0.25;
hold on
transparent_std=plot(outputs.varve_ages.Q3+(inputs.ext_error*outputs.varve_ages.median),(outputs.varve_positions),'r');
transparent_std.Color(4) = 0.25;


ylabel('Depth in core (mm)')
xlabel('Age (years)')
title_age_depth = ['Age Depth Plot for' ' ' inputs.core_name];
title(title_age_depth)

set(gca,'fontname','times')
set(gca, 'YDir','reverse')


    


figure;
    imshow(cmv_logo);
    disp('  ');disp('  ');disp('  ');disp('  ');
    
