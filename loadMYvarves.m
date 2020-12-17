function [summed_bands_core_image,inputs] = loadMYvarves()
%
% This function loads the inputs

%Load image file
% open('C:\Users\gmaxv\Documents\=PhD\project\Core analysis lab\Varve_counting\cropped_4A_3K_COARSE.jpg')
core_image = imread('C:\Users\gmaxv\Documents\=PhD\project\Core analysis lab\GCO_images\GCO-LARG19-4A-1K-3-W.jpg');

inputs.core_name = 'GCO-LARG19-4A-1K-3-W';

inputs.first_pixel = 65;

inputs.last_pixel = 29084;

inputs.top_pixel = 150;

inputs.bottom_pixel = 1151;

inputs.resolution = 19.94 ; %pixels per mm

inputs.smoothing_size_preprocessing = 10; 

inputs.estimated_varve_thickness = 1.5; % mm

inputs.percent_cropped_middle = 20; %Percent

inputs.search_zone = 15; %either side

inputs.correlation_centroid = 0.5; %Centre of correlation region. Between 0 and 1.

inputs.filter_size = round(inputs.estimated_varve_thickness*inputs.resolution/3);


%Sum bands
summed_bands_core_image= double(core_image(:,:,1))+double(core_image(:,:,2))+double(core_image(:,:,3));

%TODO: crop out central part only here
summed_bands_core_image(inputs.bottom_pixel:end,:)=[];   %Crop out scale bar from GCO images, and some edge. Clean 1000 for GCO images
summed_bands_core_image(1:inputs.top_pixel,:)=[];   %Crop out top core edge

summed_bands_core_image(:,inputs.last_pixel:end)=[];   %Crop out scale bar from GCO images, and some edge
summed_bands_core_image(:,1:inputs.first_pixel)=[];   %Crop out top core edge

[summed_bands_core_image] = core_pre_filter(summed_bands_core_image,inputs);