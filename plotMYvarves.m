function plotMYvarves(inputs, outputs)
%This function creates plots and saves the input and output files for future reference.

results_folder = strcat(inputs.core_image_path, '/Results');

if ~exist(results_folder)
    mkdir(results_folder);
end

file_name = [inputs.core_name ' ' 'data files and plots'];

results_folder = strcat(inputs.core_image_path, 'Results\');

if ~exist(strcat(results_folder,file_name))
    mkdir(strcat(results_folder,file_name));
end  



%Save raw matlab input file and data
save(strcat(results_folder,file_name,'/Run Inputs'),'inputs');
save(strcat(results_folder,file_name,'/Raw matlab data file'),'outputs');


%Save .CSV of parameters

csv_save_file = (zeros(size(outputs.varve_ages.median,1)+1,7));

csv_save_file(2:end,1) = outputs.varve_positions;

csv_save_file(2:end,2) = outputs.varve_thicknesses.median;

csv_save_file(2:end,3) = outputs.varve_thicknesses.Q1;

csv_save_file(2:end,4) = outputs.varve_thicknesses.Q3;

csv_save_file(2:end,5) = outputs.varve_ages.median;

csv_save_file(2:end,6) = outputs.varve_ages.Q1-(inputs.ext_error*outputs.varve_ages.median);

csv_save_file(2:end,7) = outputs.varve_ages.Q3+(inputs.ext_error*outputs.varve_ages.median);

csv_save_file = num2cell(csv_save_file);

csv_save_file{1,1} = 'Depth in core (mm)';

csv_save_file{1,2} = 'Median sedimentation rate (mm)';

csv_save_file{1,3} = 'First quartile sedimentation rate (mm)';

csv_save_file{1,4} = 'Third quartile sedimentation rate (mm)';

csv_save_file{1,5} = 'Median age (years)';

csv_save_file{1,6} = 'Minimum age (years)';

csv_save_file{1,7} = 'Maximum age (years)';

% Create CSV file of main outputs
csv_name_path = [results_folder file_name '\' inputs.core_name ' ' 'csv file results.csv'];

writecell(csv_save_file,csv_name_path)

% Create CSV file of inputs
csv_name_path = [results_folder file_name '\' inputs.core_name ' ' 'inputs.csv'];

a = [fieldnames(inputs) struct2cell(inputs)];

writecell(a,csv_name_path)


%PLOT VARVE THICKNESS = SEDIMENTATION RATE
  
    
varve_thickness = figure('visible','off');


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
y_minimum = nanmin(outputs.varve_thicknesses.median,[],'all') - 3;
if y_minimum < 0
    y_minimum = 0;
end
y_maximum = nanmedian(outputs.varve_thicknesses.raw,'all') + 3;
ylim([y_minimum y_maximum]);
xlim([1 outputs.varve_positions(size(outputs.varve_positions,1),1)]);
ylabel_text = ['Sedimentation rate' ' ' '(mm/yr)'];
ylabel(ylabel_text)
xlabel_text = ['Depth in core' ' ' '(mm)'];
xlabel(xlabel_text)
title_varve_thickness = ['Sedimentation rate for' ' ' inputs.core_name];
title(title_varve_thickness)

set(gca,'fontname','times')

print(varve_thickness,'-dpng','-r500',strcat(results_folder,file_name,'/Sedimentation rate.png'));    
    
 

%PLOT AGE DEPTH PLOT
age_depth = figure('visible','off');

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


print(age_depth,'-dpng','-r500',strcat(results_folder,file_name,'/Age - Depth plot.png'));


%%% Word doc

docdoc_path = [results_folder file_name];

options.codeToEvaluate = 'publishMYreport(inputs,outputs)';
options.format = 'pdf';
options.outputDir = docdoc_path;
options.showCode = false;
options.figureSnapMethod = 'print';
publish('publishMYreport.m', options);
movefile(strcat(docdoc_path,'\publishMYreport.pdf'),strcat(docdoc_path,'\Results and assumptions report.pdf'));
options.codeToEvaluate = 'publishMYreport(inputs,outputs)';
options.format = 'doc';
options.outputDir = docdoc_path;
options.showCode = false;
options.figureSnapMethod = 'print';
publish('publishMYreport.m', options);
movefile(strcat(docdoc_path,'\publishMYreport.doc'),strcat(docdoc_path,'\Results and assumptions report.doc'));
close('all')





% %Create MS WORD file of outputs
% generateMYreport(inputs,outputs,results_folder);
