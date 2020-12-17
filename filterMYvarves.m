function [filtered_varves] = filterMYvarves(inputs,raw_data,raw_data_smoothed)
%
%
%
%
%

filtered_varves = NaN(size(raw_data,1)*3,3);

add_row_counter = 0;

skip_next_position_condition = 0;


    for varve_location_loop = 1:size(raw_data)
        
        if skip_next_position_condition == 0
            
        
        if raw_data(varve_location_loop,1) > (raw_data_smoothed(varve_location_loop,1)*1.25)...
                ||  raw_data(varve_location_loop,1) < raw_data_smoothed(varve_location_loop,1)*0.75 %IF the value is more than 25% off of the 10 pt mean
            
            if raw_data(varve_location_loop,1)/2 < (raw_data_smoothed(varve_location_loop,1)*1.25)...
                &&  raw_data(varve_location_loop,1)/2 > raw_data_smoothed(varve_location_loop,1)*0.75 && ...
                strcmpi(inputs.Filter_double_thickness,'Yes') %IF HALF the value is within 25% of mean
            
            filtered_varves(varve_location_loop+add_row_counter,1) = varve_location_loop+add_row_counter;
            
            if varve_location_loop+add_row_counter == 1
            
            filtered_varves(varve_location_loop+add_row_counter,2) = round(0.5*raw_data(varve_location_loop,1));
                       
            else
                
            filtered_varves(varve_location_loop+add_row_counter,2) = round(0.5*raw_data(varve_location_loop,1)...
                + filtered_varves(varve_location_loop-1+add_row_counter,2));
            
            end
            
            add_row_counter = add_row_counter + 1;
            
            filtered_varves(varve_location_loop+add_row_counter,1) = varve_location_loop+add_row_counter;
            
            filtered_varves(varve_location_loop+add_row_counter,2) = (raw_data(varve_location_loop,1)-(round(0.5*raw_data(varve_location_loop,1))))...
                + filtered_varves(varve_location_loop-1+add_row_counter,2);
            
            filtered_varves(varve_location_loop+add_row_counter,4) = 1;

            
            elseif raw_data(varve_location_loop,1)/3 < (raw_data_smoothed(varve_location_loop,1)*1.25)...
                &&  raw_data(varve_location_loop,1)/3 > raw_data_smoothed(varve_location_loop,1)*0.75 && ...
                strcmpi(inputs.Filter_triple_thickness,'Yes') %IF ONE THIRD of the value is within 25% of mean
            
           filtered_varves(varve_location_loop+add_row_counter,1) = varve_location_loop+add_row_counter;
           
           
            
            if varve_location_loop+add_row_counter == 1
            
            filtered_varves(varve_location_loop+add_row_counter,2) = round(0.333*raw_data(varve_location_loop,1));
            
           
            else
                
            filtered_varves(varve_location_loop+add_row_counter,2) = round(0.333*raw_data(varve_location_loop,1))...
                + filtered_varves(varve_location_loop-1+add_row_counter,2);    
            
           
            end
            
            add_row_counter = add_row_counter + 1;
            
            filtered_varves(varve_location_loop+add_row_counter,1) = varve_location_loop+add_row_counter;
            
            filtered_varves(varve_location_loop+add_row_counter,2) = (raw_data(varve_location_loop,1)-round((0.666*raw_data(varve_location_loop,1))))...
                + filtered_varves(varve_location_loop-1+add_row_counter,2);
            
            add_row_counter = add_row_counter + 1;
            
            filtered_varves(varve_location_loop+add_row_counter,1) = varve_location_loop+add_row_counter;
            
            filtered_varves(varve_location_loop+add_row_counter,2) = round(0.333*raw_data(varve_location_loop,1)...
                + filtered_varves(varve_location_loop-1+add_row_counter,2));
            
            filtered_varves(varve_location_loop+add_row_counter,4) = 2;
            
            %%%%%%%%Add two troughs
            
            
            elseif raw_data(varve_location_loop,1) < raw_data_smoothed(varve_location_loop,1)*0.75 && ...
                strcmpi(inputs.Filter_low_thickness,'Yes')%if the value is too low
            
            if varve_location_loop+add_row_counter == 1 %if it is the first trough
                
                
            if raw_data(varve_location_loop,1)+raw_data(varve_location_loop+1,1)...
                    < raw_data_smoothed(varve_location_loop,1)*1.25...
                &&  raw_data(varve_location_loop,1)...
                +raw_data(varve_location_loop+1,1) > raw_data_smoothed(varve_location_loop,1)*0.75 %IF the sum of this and next is within 25% of mean
            
            filtered_varves(varve_location_loop+add_row_counter,1) = varve_location_loop+add_row_counter;

                
            filtered_varves(varve_location_loop+add_row_counter,2) = raw_data(varve_location_loop,1) + raw_data(varve_location_loop+1,1);
            
            filtered_varves(varve_location_loop+add_row_counter,5) = 1;

            
                
            skip_next_position_condition = 1;
            
            add_row_counter = add_row_counter - 1;
            
           
            elseif raw_data(varve_location_loop,1) < raw_data_smoothed(varve_location_loop,1)*0.5 %if the value is less than half local mean
                
                  
                raw_data(varve_location_loop+1,1) = raw_data(varve_location_loop,1)...
                + raw_data(varve_location_loop+1,1);    %Add to next peak
            
            filtered_varves(varve_location_loop+add_row_counter,5) = 1;
                    
            add_row_counter = add_row_counter - 1; 
            
            else
                
            filtered_varves(varve_location_loop+add_row_counter,1) = varve_location_loop+add_row_counter;

                
            filtered_varves(varve_location_loop+add_row_counter,2) = raw_data(varve_location_loop,1);
            
            filtered_varves(varve_location_loop+add_row_counter,5) = 1;
    
                
            end
            
            elseif varve_location_loop == size(raw_data,1) %if it is the LAST trough
                
            
            if raw_data(varve_location_loop,1)+raw_data(varve_location_loop-1,1)...
                    < raw_data_smoothed(varve_location_loop,1)*1.25...
                &&  raw_data(varve_location_loop,1)...
                +raw_data(varve_location_loop-1,1) > raw_data_smoothed(varve_location_loop,1)*0.75 %IF the sum of this and previous is within 25% of mean
            
                
            filtered_varves(varve_location_loop+add_row_counter-1,2) = raw_data(varve_location_loop,1)...
                + filtered_varves(varve_location_loop+add_row_counter-1,2);
            
            filtered_varves(varve_location_loop+add_row_counter-1,5) = 1;
            
                
            skip_next_position_condition = 1;
            
            add_row_counter = add_row_counter - 1;
            
            elseif raw_data(varve_location_loop,1) < raw_data_smoothed(varve_location_loop,1)*0.5 %if the value is less than half local mean
                
                  
            filtered_varves(varve_location_loop+add_row_counter-1,2) = raw_data(varve_location_loop,1)...
                + filtered_varves(varve_location_loop+add_row_counter-1,2);
            
            filtered_varves(varve_location_loop+add_row_counter-1,5) = 1;
            
            else
                
            filtered_varves(varve_location_loop+add_row_counter,1) = varve_location_loop+add_row_counter;

                
            filtered_varves(varve_location_loop+add_row_counter,2) = raw_data(varve_location_loop,1)+ filtered_varves(varve_location_loop+add_row_counter-1,2);
            
            filtered_varves(varve_location_loop+add_row_counter,5) = 1;
    
                
            end
            
            else % if it is not the first or last trough
                
            if raw_data(varve_location_loop,1)+raw_data(varve_location_loop+1,1)...
                    < raw_data_smoothed(varve_location_loop,1)*1.25...
                &&  raw_data(varve_location_loop,1)...
                +raw_data(varve_location_loop+1,1) > raw_data_smoothed(varve_location_loop,1)*0.75 %IF the sum of this and NEXT is within 25% of mean
            
            raw_data(varve_location_loop+1,1) = raw_data(varve_location_loop,1)...
                + raw_data(varve_location_loop+1,1);    %Add to next peak
            
            filtered_varves(varve_location_loop+add_row_counter,5) = 1;
                    
            
                add_row_counter = add_row_counter - 1; 
            
            
            elseif raw_data(varve_location_loop,1)+raw_data(varve_location_loop+1,1)...
                    < raw_data_smoothed(varve_location_loop,1)*1.25...
                &&  raw_data(varve_location_loop,1)...
                +raw_data(varve_location_loop+1,1) > raw_data_smoothed(varve_location_loop,1)*0.75 %IF the sum of this and PREVIOUS is within 25% of mean
            
            filtered_varves(varve_location_loop+add_row_counter,1) = varve_location_loop+add_row_counter;

                
            filtered_varves(varve_location_loop+add_row_counter,2) = raw_data(varve_location_loop,1)...
                +filtered_varves(varve_location_loop+add_row_counter-1,2);
            
            filtered_varves(varve_location_loop+add_row_counter,5) = 1;
            
            
            add_row_counter = add_row_counter - 1;
            
            
            elseif raw_data(varve_location_loop,1) < raw_data_smoothed(varve_location_loop,1)*0.5 %if the value is less than half local mean
                
                if raw_data(varve_location_loop-1,1) <= raw_data(varve_location_loop+1,1) %prior value is smaller or EQUAL
                    
                 filtered_varves(varve_location_loop+add_row_counter-1,2) = raw_data(varve_location_loop,1)...
                +filtered_varves(varve_location_loop+add_row_counter-1,2); 
            
                filtered_varves(varve_location_loop+add_row_counter-1,5) = 1;
                    
            
                 add_row_counter = add_row_counter - 1;   
                    
                 
                elseif raw_data(varve_location_loop-1,1) > raw_data(varve_location_loop+1,1) %following value is smaller
                
                 raw_data(varve_location_loop+1,1) = raw_data(varve_location_loop,1)...
                + raw_data(varve_location_loop+1,1);    %Add to next peak
            
                filtered_varves(varve_location_loop+add_row_counter,5) = 1;
                    
            
                add_row_counter = add_row_counter - 1;    
                end
                
            else
                
            filtered_varves(varve_location_loop+add_row_counter,1) = varve_location_loop+add_row_counter;

                
            filtered_varves(varve_location_loop+add_row_counter,2) = raw_data(varve_location_loop,1)+ filtered_varves(varve_location_loop-1+add_row_counter,2);
            
            filtered_varves(varve_location_loop+add_row_counter,5) = 1;
              
                
            end    
                
                
                
            end
            
            else %value not double, triple or too low (or those categories excluded from filter)
                
            if varve_location_loop+add_row_counter == 1 %if it is the first trough
            
            
            
             filtered_varves(varve_location_loop+add_row_counter,1) = varve_location_loop+add_row_counter;

                
             filtered_varves(varve_location_loop+add_row_counter,2) = raw_data(varve_location_loop,1);
             %Normal trough: just load into array as is     
            
            
            
            else
            
                filtered_varves(varve_location_loop+add_row_counter,1) = varve_location_loop+add_row_counter;

                
             filtered_varves(varve_location_loop+add_row_counter,2) = raw_data(varve_location_loop,1) + filtered_varves(varve_location_loop-1+add_row_counter,2);
             %Normal trough: just load into array as is    
        
           end
            
            end
            
        else
            
        if varve_location_loop+add_row_counter == 1 %if it is the first trough
            
            
            
         filtered_varves(varve_location_loop+add_row_counter,1) = varve_location_loop+add_row_counter;

                
        filtered_varves(varve_location_loop+add_row_counter,2) = raw_data(varve_location_loop,1);
        %Normal trough: just load into array as is     
            
            
            
        else
            
        filtered_varves(varve_location_loop+add_row_counter,1) = varve_location_loop+add_row_counter;

                
        filtered_varves(varve_location_loop+add_row_counter,2) = raw_data(varve_location_loop,1) + filtered_varves(varve_location_loop-1+add_row_counter,2);
        %Normal trough: just load into array as is    
        
        end
            
        end
        
        
        else
            
            skip_next_position_condition = 0;
            
        end
        
%     if varve_location_loop+add_row_counter>=1 && isnan(filtered_varves(varve_location_loop+add_row_counter,1))
%         a = 1;
%         
%     end
        
    end    
    
    
first_column = [];

second_column = [];

first_column(:,1) = filtered_varves(:,1);

second_column(:,1) = filtered_varves(:,2);

third_column(:,1) = filtered_varves(:,3);

% % fourth_column(:,1) = filtered_varves(:,4);
% % 
% % fifth_column(:,1) = filtered_varves(:,5);

third_column(isnan(first_column)) = [];

% % fourth_column(isnan(first_column)) = [];
% % 
% % fifth_column(isnan(first_column)) = [];

first_column(isnan(first_column)) = [];

second_column(isnan(second_column)) = [];

filtered_varves = [];

filtered_varves(:,1) = first_column(:,1);

filtered_varves(:,2) = second_column(:,1);

filtered_varves(:,3) = third_column(:,1);

% % filtered_varves(:,4) = fourth_column(:,1);
% % 
% % filtered_varves(:,5) = fifth_column(:,1);
                        
            


%Calculate layer thicknesses

for loop = 1:size(filtered_varves,1)
if loop == 1
filtered_varves(loop,3) = filtered_varves(loop,2);
else
filtered_varves(loop,3) = filtered_varves(loop,2)-filtered_varves(loop-1,2);
end
end


% % % % % %Calculate minimum age depth
% % % % % minimum_age = [];
% % % % % minimum_add = filtered_varves(:,4);
% % % % % minimum_add(isnan(minimum_add)) = 0;
% % % % % 
% % % % % for loop = 1:size(filtered_varves,1)
% % % % % if loop == 1
% % % % % minimum_age(loop,1) = 1-minimum_add(loop,1);
% % % % % if minimum_age(loop,1) < 0
% % % % %     minimum_age(loop,1) = 0;
% % % % % end
% % % % % else
% % % % % minimum_age(loop,1) = minimum_age(loop-1,1)-minimum_add(loop,1)+1;
% % % % % if minimum_add(loop,1) == 2
% % % % %   minimum_age(loop-1,1) = minimum_age(loop-1,1)-1;
% % % % % end
% % % % % end
% % % % % end
% % % % % 
% % % % % filtered_varves(:,4) = minimum_age(:,1);
% % % % % 
% % % % % %Calculate minimum age depth
% % % % % maximum_age = [];
% % % % % maximum_add = filtered_varves(:,5);
% % % % % maximum_add(isnan(maximum_add)) = 0;
% % % % % 
% % % % % for loop = 1:size(maximum_add,1)
% % % % % if loop == 1
% % % % % maximum_age(loop,1) = 1+maximum_add(loop,1);
% % % % % else
% % % % % maximum_age(loop,1) = maximum_age(loop-1,1)+maximum_add(loop,1)+1;
% % % % % end
% % % % % end
% % % % % 
% % % % % filtered_varves(:,5) = maximum_age(:,1);
