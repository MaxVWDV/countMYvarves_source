function generateMYreport(inputs,outputs,results_folder)
%
% Automatically generate a word document with a status report for this core
% run.
%
% Acknowledgements to Andreas Karlsson for some of the functions included here.
%
% -------------------------------------------------------------------
    file_name = [inputs.core_name ' ' 'data files and plots'];
    file_name_docx = [inputs.core_name ' ' 'varve count report' '.doc'];
    present_directory = pwd;
	WordFileName= file_name_docx;
	CurDir= strcat(results_folder,file_name);
	FileSpec = fullfile(CurDir,WordFileName);
	[ActXWord,WordHandle]=StartWord(FileSpec);
    
%     fprintf('Document will be saved in %s\n',FileSpec);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
%Section 1
    %%create header in word        
    Style='Heading 1'; %NOTE! if you are NOT using an English version of MSWord you get
    % an error here. For Swedish installations use 'Rubrik 1'. 
    TextString=[inputs.core_name ' ' 'full varve count report'];
    WordText(ActXWord,TextString,Style,[0,2]);%two enters after text
% % %     cmv_logo = imread('cmv_logo_colour.png');
% % %     
% % %     figure('visible','off');
% % %     imshow(cmv_logo);
% % %     FigureIntoWord(ActXWord);
    
    Style='Normal';
    today_date_run = date;
    TextString=['Age-depth model created on' ' ' today_date_run ' ' 'using countMYvarves!'];    
    WordText(ActXWord,TextString,Style,[1,1]);%enter after text
     
    
    
    TextString='This report provides an account of the model run, assumptions and results.';
    WordText(ActXWord,TextString,Style,[0,2]);%no enter
    
    TextString='Summary Statistics:';
    WordText(ActXWord,TextString,Style,[0,1]);%no enter
    
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
    WordText(ActXWord,TextString,Style,[0,1]);%no enter
    
    TextString=['This core has an overall median sedimentation rate (varve thickness) of' ' ' num2str(Median_thickness) ' ' 'mm per year, with the 25th percentile sedimentation rate being' ' ' num2str(Q1_thickness) ' '...
        'mm per year and the 75th percentile sedimentation rate being' ' ' num2str(Q3_thickness) ' ' 'mm.'];
    WordText(ActXWord,TextString,Style,[0,2]);%no enter
    

    TextString='Key assumptions made:';
    WordText(ActXWord,TextString,Style,[0,1]);%no enter
    label_number = 1;
    TextString=[num2str(label_number) ')' ' ' 'The core contains a repeating, self-similar pattern that represents an annual cycle (i.e. a varve, although it need not be a dark and light alternation.'];
    WordText(ActXWord,TextString,Style,[0,1]);%enter after text
    label_number = label_number+1;
    TextString=[num2str(label_number) ')' ' '  'Unless explicitly excluded, varves are clear enough to be detected throughout the core length.'];
    WordText(ActXWord,TextString,Style,[0,1]);%no enter
    
    if strcmpi(inputs.are_areas_excluded, 'Yes')
        label_number = label_number+1;
    TextString=[num2str(label_number) ')' ' ' 'Certain areas are either excluded from the count (i.e. essentially instantaneous) or assumed to be disrupted and extrapolated over with the mean sedimentation rate. See table on next page for full details.'];
    WordText(ActXWord,TextString,Style,[0,1]);%no enter
    end
    if strcmpi(inputs.smoothly_varying_sedimentation_rate, 'Yes')
        label_number = label_number+1;
    TextString=[num2str(label_number) ')' ' ' 'The sedimentation rate is (mostly) smoothly varying.'];
    WordText(ActXWord,TextString,Style,[0,1]);%no enter
    end
        if strcmpi(inputs.Filter_double_thickness, 'Yes')
            label_number = label_number+1;
    TextString=[num2str(label_number) ')' ' ' 'Where a varve is close to double the thickness of the local (10 point) mean, it is assumed to be two varves.'];
    WordText(ActXWord,TextString,Style,[0,1]);%no enter
        end
        if strcmpi(inputs.Filter_triple_thickness, 'Yes')
            label_number = label_number+1;
    TextString=[num2str(label_number) ')' ' ' 'Where a varve is close to triple the thickness of the local (10 point) mean, it is assumed to be three varves.'];
    WordText(ActXWord,TextString,Style,[0,1]);%no enter
        end
    if strcmpi(inputs.Filter_low_thickness, 'Yes')
        label_number = label_number+1;
    TextString=[num2str(label_number) ')' ' ' 'Where two consecutive varves are more than 25% below the regional mean, and their sum is close to the regional mean, they are counted as one varve.'];
    WordText(ActXWord,TextString,Style,[0,3]);%no enter
    end
    
    
    if inputs.scaling_factor == 1
    TextString= ['The core was also pre-processed using a' ' ' num2str(round(inputs.estimated_varve_thickness*inputs.resolution*0.25),1) ' ' 'pixel ('...
        num2str(round(inputs.estimated_varve_thickness*0.25),2) ' ' 'mm) median filter. Outlier pixels were excluded and interpolated over, and the image was smoothed'...
        ' ' 'using a' ' ' num2str(round(inputs.estimated_varve_thickness*inputs.resolution*0.333),1) ' ' 'pixel ('...
        num2str(round(inputs.estimated_varve_thickness*0.333),2) ' ' 'mm) smoothing mask.'];
    WordText(ActXWord,TextString,Style,[0,2]);%no enter
    else
    TextString= ['The core was also pre-processed using a' ' ' num2str(round(inputs.estimated_varve_thickness*inputs.resolution*0.25),1) ' ' 'pixel ('...
        num2str(round(inputs.estimated_varve_thickness*0.25),2) ' ' 'mm) median filter. Outlier pixels were excluded and interpolated over, and the image was smoothed'...
        ' ' 'using a' ' ' num2str(round(inputs.estimated_varve_thickness*inputs.resolution*0.333),1) ' ' 'pixel ('...
        num2str(round(inputs.estimated_varve_thickness*0.333),2) ' ' 'mm) smoothing mask. The resolution of the input image was coarsened by a factor of' ' '...
        num2str(inputs.scaling_factor) ' ' 'using a linear interpolation in order to reduce computational time. The image analysed had a resolution of' ' ' ...
        num2str(inputs.resolution/inputs.scaling_factor) ' ' 'pixels per mm.'];
    WordText(ActXWord,TextString,Style,[0,2]);%no enter    
        
    end
    
    difference_in_varve_thickness = inputs.estimated_varve_thickness/Median_thickness;
    
    if difference_in_varve_thickness < 1.5 && difference_in_varve_thickness > 0.5
    
    TextString= ['The initial estimated varve thickness is within 50% of the final calculated thickess.' ' '...
        'It is unlikely that the results were biased by over or under-smoothing.'];
    WordText(ActXWord,TextString,Style,[0,2]);%no enter    
    
    elseif difference_in_varve_thickness > 1.50
TextString= ['The initial estimated varve thickness more than 50% higher than the final calculated thickess (' ...
    num2str(round(difference_in_varve_thickness*100-100),2) ' ' '% higher).'...
        'This could in some cases lead to over-smoothing and underestimation of the number of varves.' ' ' ...
        'If there is a problem with the results, perhaps re-run this core with an estimated initial varve thickness of' ' ' ...
        num2str(round(Median_thickness),2) ' ' 'mm).'];
    WordText(ActXWord,TextString,Style,[0,2]);%no enter   
    
    elseif difference_in_varve_thickness < 0.50
        
       TextString= ['The initial estimated varve thickness more than 50% lower than the final calculated thickess (' ...
    num2str(round(difference_in_varve_thickness*100-100),2) ' ' '% lower).'...
        'This could in some cases lead to image noise remaining and overestimation of the number of varves.' ' ' ...
        'If there is a problem with the results, perhaps re-run this core with an estimated initial varve thickness of' ' ' ...
        num2str(round(Median_thickness),2) ' ' 'mm).'];
    WordText(ActXWord,TextString,Style,[0,2]);%no enter   
        
    end

    ActXWord.Selection.InsertBreak; %pagebreak
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
% %Section 3
%     style='Heading 1';
%     text='Table of Contents';
%     WordText(ActXWord,text,style,[1,1]);%enter before and after text 
%     WordCreateTOC(ActXWord,1,3);
%     ActXWord.Selection.InsertBreak; %pagebreak
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    

if strcmpi(inputs.are_areas_excluded, 'Yes')

%Section 3
    style='Heading 2';
    text='Excluded and extrapolated intervals defined (Pixels):';
    WordText(ActXWord,text,style,[0,1]);%enter before and after text 
    

    TextString='See "excluded interval" excel files to edit these assumptions.';
    WordText(ActXWord,TextString,Style,[2,2]);%enter after text
% %     %the obvious data
%     DataCell={'Test 12', num2str(0.3) ,'Pass';
%               'Test 2', num2str(1.8) ,'Fail'};

excluded_areas = readtable(inputs.exluded_intervals_file,'Range','A3:D105'); %Read the excel exclusion file


excluded_areas = table2cell(rmmissing(excluded_areas));                             %crop it and turn into matrix
    [NoRows,NoCols]=size(excluded_areas);          
    %create table with data from DataCell
    WordCreateTable(ActXWord,NoRows,NoCols,excluded_areas,1);%enter before table
    ActXWord.Selection.InsertBreak; %pagebreak
    
    
    
    
    %Section 3
    style='Heading 2';
    text='Excluded and extrapolated intervals defined (mm):';
    WordText(ActXWord,text,style,[0,1]);%enter before and after text 
    

    TextString='See "excluded interval" excel files to edit these assumptions. Note depths are in mm rather than pixels.';
    WordText(ActXWord,TextString,Style,[2,2]);%enter after text
% %     %the obvious data
%     DataCell={'Test 12', num2str(0.3) ,'Pass';
%               'Test 2', num2str(1.8) ,'Fail'};

excluded_areas = readtable(inputs.exluded_intervals_file,'Range','A3:D105'); %Read the excel exclusion file


excluded_areas = table2cell(rmmissing(excluded_areas));                             %crop it and turn into matrix

for loop = 2:size(excluded_areas,1)

    excluded_areas{loop,1} = num2str(round(str2double(excluded_areas{loop,1})/inputs.resolution,2));
    excluded_areas{loop,2} = num2str(round(str2double(excluded_areas{loop,2})/inputs.resolution,2));
%     excluded_areas{loop,3} = temp3;
end
    [NoRows,NoCols]=size(excluded_areas);          
    %create table with data from DataCell
    WordCreateTable(ActXWord,NoRows,NoCols,excluded_areas,1);%enter before table
    ActXWord.Selection.InsertBreak; %pagebreak
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Section 4

%%%



% % % %PLOT VARVE THICKNESS = SEDIMENTATION RATE
% % % 
% % % varve_thickness = figure('visible','off');
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
% % % xlim([1 outputs.varve_positions(end,1)]);
% % % ylabel_text = ['Sedimentation rate' ' ' '(mm/yr)'];
% % % ylabel(ylabel_text)
% % % xlabel_text = ['Depth in core' ' ' '(mm)'];
% % % xlabel(xlabel_text)
% % % title_varve_thickness = ['Sedimentation rate for' ' ' inputs.core_name];
% % % title(title_varve_thickness)
% % % 
% % % set(gca,'fontname','times')
% % % 
% % % %%%
% % %     %insert the figure
% % %     Style='Heading 2';
% % %     TextString='Sedimentation rate throughout core:';
% % %     WordText(ActXWord,TextString,Style,[0,2]);%enter after text
% % %     FigureIntoWord(ActXWord); 
% % %     
% % %     ActXWord.Selection.InsertBreak; %pagebreak
% % %     
% % %     Style='Heading 2';
% % %     TextString='Age Depth model for this core.';
% % %     WordText(ActXWord,TextString,Style,[2,2]);%enter after text  
% % % %     figure;plot([1:19],[1:10,9:-1:1]);title('Figure 2');xlabel('Time [s]');ylabel('Amplitude [A]');
% % % 
% % % 
% % % %%%%
% % % 
% % % 
% % % %PLOT AGE DEPTH PLOT
% % % age_depth = figure('visible','off');
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
% % % %%%%
% % % 
% % % 
% % %     FigureIntoWord(ActXWord); 
    
    Style='Normal';
    TextString='Note: raw age-depth data for this core is available in associated .csv file in this folder. This may be loaded into other programs (e.g. Corelyser) if useful.';
    WordText(ActXWord,TextString,Style,[2,2]);%enter after text 
%     ActXWord.Selection.InsertBreak; %pagebreak


ActXWord.Selection.InsertBreak; %pagebreak

    Style='Heading 2';
    TextString='Input parameter table for this run.';
    WordText(ActXWord,TextString,Style,[2,2]);%enter after text 

C = struct2cell(inputs);
numIndex = find(not(cellfun('isclass', C, 'char')));
for i = reshape(numIndex, 1, [])
C{i} = num2str(C{i});
end
    
input_table = [fieldnames(inputs) C];

    [NoRows,NoCols]=size(input_table);          
    %create table with data from DataCell
    WordCreateTable(ActXWord,NoRows,NoCols,input_table,1);%enter before table

    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
%Section 5
% % %     Style='Heading 1';
% % %     TextString='Flying Start';
% % %     WordText(ActXWord,TextString,Style,[0,1]);%enter after text
% % %     Style='Normal';
% % %     TextString='Find out how to do new things in MS-Word by using the "Record Macro"-function ';
% % %     WordText(ActXWord,TextString,Style,[0,0]);%no enter
% % %     TextString='and look at the Visual Basic commands used.';
% % %     WordText(ActXWord,TextString,Style,[0,1]);%enter after text
% % %     
% % %     TextString='In Matlab you find the available properties by using get(ActXWord), for top interface,';
% % %     WordText(ActXWord,TextString,Style,[0,0]);%no enter
% % %     TextString=' and further on with for example get(ActXWord.Selection).';     
% % %     WordText(ActXWord,TextString,Style,[0,1]);%enter after text
% % %     
% % %     TextString='Then find the methods usable from Matlab by using the invoke-function in Matlab '; 
% % %     WordText(ActXWord,TextString,Style,[0,0]);%no enter
% % %     TextString='e.g. invoke(ActXWord.Selection). See the output of that call below. ';     
% % %     WordText(ActXWord,TextString,Style,[0,1]);%enter after text
% % % 
% % %     TextString='Set a breakpoint here and play around with these commands...'; 
% % %     WordText(ActXWord,TextString,Style,[0,1],'wdRed');%red text and enter after text
% % % 
% % %     %Make a long list of some of the methods available in MS-Word
% % %     Category='Selection'; % Category='ActiveDocument';
% % %     PrintMethods(ActXWord,Category)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%        
%add pagenumbers (0=not on first page)
    WordPageNumbers(ActXWord,'wdAlignPageNumberRight');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%        
% % %     %Last thing is to replace the Table of Contents so all headings are
% % %     %included.
% % %     %Selection.GoTo What:=wdGoToField, Which:=wdGoToPrevious, Count:=1, Name:= "TOC"
% % %     WordGoTo(ActXWord,7,3,1,'TOC',1);%%last 1 to delete the object
% % %     WordCreateTOC(ActXWord,1,3);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%        
    CloseWord(ActXWord,WordHandle,FileSpec);    
    close all;
return

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SUB-FUNCTIONS
% Creator Andreas Karlsson; andreas_k_se@yahoo.com
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [actx_word,word_handle]=StartWord(word_file_p)
    % Start an ActiveX session with Word:
    actx_word = actxserver('Word.Application');
    actx_word.Visible = true;
    trace(actx_word.Visible);  
    if ~exist(word_file_p,'file');
        % Create new document:
        word_handle = invoke(actx_word.Documents,'Add');
    else
        % Open existing document:
        word_handle = invoke(actx_word.Documents,'Open',word_file_p);
    end           
return
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function WordGoTo(actx_word_p,what_p,which_p,count_p,name_p,delete_p)
    %Selection.GoTo(What,Which,Count,Name)
    actx_word_p.Selection.GoTo(what_p,which_p,count_p,name_p);
    if(delete_p)
        actx_word_p.Selection.Delete;
    end

return

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function WordCreateTOC(actx_word_p,upper_heading_p,lower_heading_p)
%      With ActiveDocument
%         .TablesOfContents.Add Range:=Selection.Range, RightAlignPageNumbers:= _
%             True, UseHeadingStyles:=True, UpperHeadingLevel:=1, _
%             LowerHeadingLevel:=3, IncludePageNumbers:=True, AddedStyles:="", _
%             UseHyperlinks:=True, HidePageNumbersInWeb:=True, UseOutlineLevels:= _
%             True
%         .TablesOfContents(1).TabLeader = wdTabLeaderDots
%         .TablesOfContents.Format = wdIndexIndent
%     End With
    actx_word_p.ActiveDocument.TablesOfContents.Add(actx_word_p.Selection.Range,1,...
        upper_heading_p,lower_heading_p);
    
    actx_word_p.Selection.TypeParagraph; %enter  
return
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function WordText(actx_word_p,text_p,style_p,enters_p,color_p)
	%VB Macro
	%Selection.TypeText Text:="Test!"
	%in Matlab
	%set(word.Selection,'Text','test');
	%this also works
	%word.Selection.TypeText('This is a test');    
    if(enters_p(1))
        actx_word_p.Selection.TypeParagraph; %enter
    end
	actx_word_p.Selection.Style = style_p;
    if(nargin == 5)%check to see if color_p is defined
        actx_word_p.Selection.Font.ColorIndex=color_p;     
    end
    
	actx_word_p.Selection.TypeText(text_p);
    actx_word_p.Selection.Font.ColorIndex='wdAuto';%set back to default color
    for k=1:enters_p(2)    
        actx_word_p.Selection.TypeParagraph; %enter
    end
return
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function WordSymbol(actx_word_p,symbol_int_p)
    % symbol_int_p holds an integer representing a symbol, 
    % the integer can be found in MSWord's insert->symbol window    
    % 176 = degree symbol
    actx_word_p.Selection.InsertSymbol(symbol_int_p);
return
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function WordCreateTable(actx_word_p,nr_rows_p,nr_cols_p,data_cell_p,enter_p) 
    %Add a table which auto fits cell's size to contents
    if(enter_p(1))
        actx_word_p.Selection.TypeParagraph; %enter
    end
    %create the table
    %Add = handle Add(handle, handle, int32, int32, Variant(Optional))
    actx_word_p.ActiveDocument.Tables.Add(actx_word_p.Selection.Range,nr_rows_p,nr_cols_p,1,1);
    %Hard-coded optionals                     
    %first 1 same as DefaultTableBehavior:=wdWord9TableBehavior
    %last  1 same as AutoFitBehavior:= wdAutoFitContent
     
    %write the data into the table
    for r=1:nr_rows_p
        for c=1:nr_cols_p
            %write data into current cell
            WordText(actx_word_p,data_cell_p{r,c},'Normal',[0,0]);
            
            if(r*c==nr_rows_p*nr_cols_p)
                %we are done, leave the table
                actx_word_p.Selection.MoveDown;
            else%move on to next cell 
                actx_word_p.Selection.MoveRight;
            end            
        end
    end
return
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function WordPageNumbers(actx_word_p,align_p)
    %make sure the window isn't split
    if (~strcmp(actx_word_p.ActiveWindow.View.SplitSpecial,'wdPaneNone')) 
        actx_word_p.Panes(2).Close;
    end
    %make sure we are in printview
    if (strcmp(actx_word_p.ActiveWindow.ActivePane.View.Type,'wdNormalView') | ...
        strcmp(actx_word_p.ActiveWindow.ActivePane.View.Type,'wdOutlineView'))
        actx_word_p.ActiveWindow.ActivePane.View.Type ='wdPrintView';
    end
    %view the headers-footers
    actx_word_p.ActiveWindow.ActivePane.View.SeekView='wdSeekCurrentPageHeader';
    if actx_word_p.Selection.HeaderFooter.IsHeader
        actx_word_p.ActiveWindow.ActivePane.View.SeekView='wdSeekCurrentPageFooter';
    else
        actx_word_p.ActiveWindow.ActivePane.View.SeekView='wdSeekCurrentPageHeader';
    end
    %now add the pagenumbers 0->don't display any pagenumber on first page
     actx_word_p.Selection.HeaderFooter.PageNumbers.Add(align_p,0);
     actx_word_p.ActiveWindow.ActivePane.View.SeekView='wdSeekMainDocument';
return

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function PrintMethods(actx_word_p,category_p)
    style='Heading 3';
    text=strcat(category_p,'-methods');
    WordText(actx_word_p,text,style,[1,1]);           
    
    style='Normal';    
    text=strcat('Methods called from Matlab as: ActXWord.',category_p,'.MethodName(xxx)');
    WordText(actx_word_p,text,style,[0,0]);           
    text='Ignore the first parameter "handle". ';
    WordText(actx_word_p,text,style,[1,3]);           
    
    MethodsStruct=eval(['invoke(actx_word_p.' category_p ')']);
    MethodsCell=struct2cell(MethodsStruct);
    NrOfFcns=length(MethodsCell);
    for i=1:NrOfFcns
        MethodString=MethodsCell{i};
        WordText(actx_word_p,MethodString,style,[0,1]);           
    end
return
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function FigureIntoWord(actx_word_p)
	% Capture current figure/model into clipboard:
	print -dmeta
	% Find end of document and make it the insertion point:
	end_of_doc = get(actx_word_p.activedocument.content,'end');
	set(actx_word_p.application.selection,'Start',end_of_doc);
	set(actx_word_p.application.selection,'End',end_of_doc);
	% Paste the contents of the Clipboard:
    %also works Paste(ActXWord.Selection)
	invoke(actx_word_p.Selection,'Paste');
    actx_word_p.Selection.TypeParagraph; %enter    
return
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function CloseWord(actx_word_p,word_handle_p,word_file_p)
    if ~exist(word_file_p,'file')
        % Save file as new:
        invoke(word_handle_p,'SaveAs',word_file_p,1);
    else
        % Save existing file:
        invoke(word_handle_p,'Save');
    end
    % Close the word window:
    invoke(word_handle_p,'Close');            
    % Quit MS Word
    invoke(actx_word_p,'Quit');            
    % Close Word and terminate ActiveX:
    delete(actx_word_p);            
return
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%