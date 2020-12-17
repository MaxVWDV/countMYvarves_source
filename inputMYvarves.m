function inputMYvarves(inputs)
%
% This function loads the inputs


%% Necessary inputs
% inputs.core_name = 'GCO-LARG19-1A-1K-1-W';

% inputs.estimated_varve_thickness = 3.2; % mm
% 
% inputs.first_pixel = 1;
% 
% inputs.last_pixel = 14739;


%% May be kept constant

%Load image file
core_image = imread(strcat(inputs.core_image_path, inputs.core_image_name));

% inputs.top_pixel = 150;
% 
% inputs.bottom_pixel = 1151;
% 
% inputs.resolution = 19.94 ; %pixels per mm
% 
% inputs.parralelize = 'Yes';
% 
% inputs.smoothing_size_preprocessing = 10; 
% 
% inputs.percent_cropped_middle = 20; %Percent
% 
% inputs.search_zone = 15; %either side
% 
inputs.correlation_centroid = 0.5; %Centre of correlation region. Between 0 and 1.
% 
% inputs.filter_proportion = 0.1;

inputs.filter_size = round(inputs.estimated_varve_thickness*inputs.resolution*inputs.filter_proportion);

% inputs.are_areas_excluded = 'Yes';
% 
% inputs.number_of_size_iterations = 2;


if strcmpi(inputs.are_areas_excluded,'Yes')
inputs.exluded_intervals_file = ...
    strcat(inputs.exluded_intervals_file_path, inputs.exluded_intervals_file_name);
end



% inputs.smoothly_varying_sedimentation_rate = 'Yes';
% 
% inputs.Filter_double_thickness = 'Yes';
% 
% inputs.Filter_triple_thickness = 'Yes';
% 
% inputs.Filter_low_thickness = 'Yes';
% 
% inputs.number_of_transects = 12;
% 
% inputs.scaling_factor = 1;
% 
% inputs.ext_error = 0.05;

%Sum bands
summed_bands_core_image= double(core_image(:,:,1))+double(core_image(:,:,2))+double(core_image(:,:,3));

%TODO: crop out central part only here
summed_bands_core_image(inputs.bottom_pixel:end,:)=[];   %Crop out scale bar from GCO images, and some edge. Clean 1000 for GCO images
summed_bands_core_image(1:inputs.top_pixel,:)=[];   %Crop out top core edge

summed_bands_core_image(:,inputs.last_pixel:end)=[];   %Crop out scale bar from GCO images, and some edge
summed_bands_core_image(:,1:inputs.first_pixel)=[];   %Crop out top core edge

[summed_bands_core_image] = core_pre_filter(summed_bands_core_image,inputs);

%% Enbed all in one file

[outputs,inputs] = parralelizeMYvarves(inputs,summed_bands_core_image);

plotMYvarves(inputs, outputs);