function [raw,calculated_mean,calculated_median,calculated_std] = calculate_statistics(raw,stable,crop_full,inputs,average_end)
%Filters and averages raw data.
%
%Stable = 'Constant' or 'Zero'


if strcmpi(stable,'Constant')
    
raw(isnan(raw)) = 0;    

raw(crop_full==0)=NaN;

raw = rmmissing(raw);

raw(raw==0) = NaN;

if strcmpi(average_end,'Yes')
for iteration_loop = 1:size(raw,2)
    for time_loop = 2:size(raw,1)
        if isnan(raw(time_loop,iteration_loop))
            if ~isnan(raw(time_loop-1,iteration_loop))
             raw(time_loop,iteration_loop) = raw(time_loop-1,iteration_loop);
            else
             raw(time_loop,iteration_loop) = 0;
            end
        end
    end
end
end
calculated_mean = nanmean(raw,2);
calculated_median = nanmedian(raw,2);
calculated_std = nanstd(raw,[],2);


elseif strcmpi(stable,'Zero')
    
raw(isnan(raw)) = 0;       
    
    raw(crop_full==0)=NaN;

raw = rmmissing(raw);

raw(raw==0) = NaN;

if strcmpi(average_end,'Yes')

for iteration_loop = 1:size(raw,2)
    for time_loop = 2:size(raw,1)
        if isnan(raw(time_loop,iteration_loop))
            
             raw(time_loop,iteration_loop) = 0;
            
        end
    end
end
end

calculated_mean = nanmean(raw,2);
calculated_median = nanmedian(raw,2);
calculated_std = nanstd(raw,[],2);

end







