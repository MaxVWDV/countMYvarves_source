function [out] = core_pre_filter(in,inputs)
%
%
%This function performs the filtering of the image prior to running it
%through the image correlation software.

median_mask = medfilt2(in,[round(inputs.estimated_varve_thickness*inputs.resolution*0.333)...
    round(inputs.estimated_varve_thickness*inputs.resolution*0.333)]);


outlier_mask = abs(in-median_mask)./median_mask;


outlier_mask(outlier_mask < 0.20) = 0; %identify if more than 20% different from median

outlier_mask(outlier_mask~=0) = 1;

in(outlier_mask == 1) = NaN;

in = inpaint_nans(in);

%%%%%%%%% Smooth it

smoothing_mask = ones(round(0.333*(inputs.estimated_varve_thickness*inputs.resolution)),round(0.333*(inputs.estimated_varve_thickness*inputs.resolution)));

out = imfilter(in,smoothing_mask,'replicate');

if inputs.scaling_factor ~= 1 %Resample

out = (interp2(out, linspace(1,size(out,2),size(out,2)/inputs.scaling_factor).', linspace(1,size(out,1),size(out,1)/inputs.scaling_factor)));

end