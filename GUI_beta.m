function OPENcountMYvarves()            

if ~isdeployed
addpath(genpath(pwd));
end

GUIinputs = {};
merged_inputs = {};


            GUIFigure = uifigure;
            GUIFigure.Position = [100 100 905 704];
            GUIFigure.Name = 'countMYvarves!';

            % Create TabGroup
            TabGroup = uitabgroup(GUIFigure);
            TabGroup.Position = [1 0 905 704];

            % Create RequiredSettingsTab
            RequiredSettingsTab = uitab(TabGroup);
            RequiredSettingsTab.Title = 'Required Settings';
            RequiredSettingsTab.BackgroundColor = [1 1 1];

%             % Create SelectcoreimageButton
%             SelectcoreimageButton = uibutton(RequiredSettingsTab, 'push');
%             SelectcoreimageButton.FontName = 'Lucida Sans';
%             SelectcoreimageButton.Position = [457 526 180 22];
%             SelectcoreimageButton.Text = 'Select core image';
%             SelectcoreimageButton.ButtonPushedFcn = @(btn,event) plotButtonPushed1 (btn);

            % Create CorenameEditFieldLabel
            CorenameEditFieldLabel = uilabel(RequiredSettingsTab);
            CorenameEditFieldLabel.HorizontalAlignment = 'right';
            CorenameEditFieldLabel.FontName = 'Lucida Sans';
            CorenameEditFieldLabel.Position = [405 638 117 22];
            CorenameEditFieldLabel.Text = 'Core name';

            % Create CorenameEditField
            CorenameEditField = uieditfield(RequiredSettingsTab, 'text');
            CorenameEditField.FontName = 'Lucida Sans';
            CorenameEditField.Position = [537 638 100 22];
            CorenameEditField.Value = 'COR_LOC20_1A_1G_1_W';

            % Create ImageresolutionknownSwitchLabel
            ImageresolutionknownSwitchLabel = uilabel(RequiredSettingsTab);
            ImageresolutionknownSwitchLabel.HorizontalAlignment = 'center';
            ImageresolutionknownSwitchLabel.FontName = 'Lucida Sans';
            ImageresolutionknownSwitchLabel.Position = [440 540 215 22];
            ImageresolutionknownSwitchLabel.Text = 'Image resolution known?';

            % Create ImageresolutionknownSwitch
            ImageresolutionknownSwitch = uiswitch(RequiredSettingsTab, 'slider');
            ImageresolutionknownSwitch.Items = {'Yes', 'No'};
            ImageresolutionknownSwitch.FontName = 'Lucida Sans';
            ImageresolutionknownSwitch.Position = [522 513 45 20];
            ImageresolutionknownSwitch.Value = 'Yes';

            % Create ResolutioninpixelspermmifknownEditFieldLabel
            ResolutioninpixelspermmifknownEditFieldLabel = uilabel(RequiredSettingsTab);
            ResolutioninpixelspermmifknownEditFieldLabel.HorizontalAlignment = 'right';
            ResolutioninpixelspermmifknownEditFieldLabel.FontName = 'Lucida Sans';
            ResolutioninpixelspermmifknownEditFieldLabel.Position = [341 471 254 22];
            ResolutioninpixelspermmifknownEditFieldLabel.Text = 'Resolution in pixels per mm (if known)';

            % Create ResolutioninpixelspermmifknownEditField
            ResolutioninpixelspermmifknownEditField = uieditfield(RequiredSettingsTab, 'numeric');
            ResolutioninpixelspermmifknownEditField.FontName = 'Lucida Sans';
            ResolutioninpixelspermmifknownEditField.Position = [608 471 100 22];
            ResolutioninpixelspermmifknownEditField.Value = 19.94;

            % Create BoundingboxlimitsknownSwitchLabel
            BoundingboxlimitsknownSwitchLabel = uilabel(RequiredSettingsTab);
            BoundingboxlimitsknownSwitchLabel.HorizontalAlignment = 'center';
            BoundingboxlimitsknownSwitchLabel.FontName = 'Lucida Sans';
            BoundingboxlimitsknownSwitchLabel.Position = [414 417 254 22];
            BoundingboxlimitsknownSwitchLabel.Text = 'Bounding box limits known?';

            % Create BoundingboxlimitsknownSwitch
            BoundingboxlimitsknownSwitch = uiswitch(RequiredSettingsTab, 'slider');
            BoundingboxlimitsknownSwitch.Items = {'Yes', 'No'};
            BoundingboxlimitsknownSwitch.FontName = 'Lucida Sans';
            BoundingboxlimitsknownSwitch.Position = [524 389 45 20];
            BoundingboxlimitsknownSwitch.Value = 'Yes';

            % Create LeftlimitpixelsEditFieldLabel
            LeftlimitpixelsEditFieldLabel = uilabel(RequiredSettingsTab);
            LeftlimitpixelsEditFieldLabel.HorizontalAlignment = 'right';
            LeftlimitpixelsEditFieldLabel.FontName = 'Lucida Sans';
            LeftlimitpixelsEditFieldLabel.Position = [337 315 135 22];
            LeftlimitpixelsEditFieldLabel.Text = 'Left limit (pixels)';

            % Create LeftlimitpixelsEditField
            LeftlimitpixelsEditField = uieditfield(RequiredSettingsTab, 'numeric');
            LeftlimitpixelsEditField.FontName = 'Lucida Sans';
            LeftlimitpixelsEditField.Position = [372 294 100 22];
            LeftlimitpixelsEditField.Value = 1;
            
            % Create ToplimitpixelsEditFieldLabel
            ToplimitpixelsEditFieldLabel = uilabel(RequiredSettingsTab);
            ToplimitpixelsEditFieldLabel.HorizontalAlignment = 'right';
            ToplimitpixelsEditFieldLabel.FontName = 'Lucida Sans';
            ToplimitpixelsEditFieldLabel.Position = [440 343 150 22];
            ToplimitpixelsEditFieldLabel.Text = 'Top limit (pixels)';

            % Create ToplimitpixelsEditField
            ToplimitpixelsEditField = uieditfield(RequiredSettingsTab, 'numeric');
            ToplimitpixelsEditField.FontName = 'Lucida Sans';
            ToplimitpixelsEditField.Position = [495 322 100 22];
            ToplimitpixelsEditField.Value = 1;

            % Create BottomlimitpixelsEditFieldLabel
            BottomlimitpixelsEditFieldLabel = uilabel(RequiredSettingsTab);
            BottomlimitpixelsEditFieldLabel.HorizontalAlignment = 'right';
            BottomlimitpixelsEditFieldLabel.FontName = 'Lucida Sans';
            BottomlimitpixelsEditFieldLabel.Position = [457 285 138 22];
            BottomlimitpixelsEditFieldLabel.Text = 'Bottom limit (pixels)';

            % Create BottomlimitpixelsEditField
            BottomlimitpixelsEditField = uieditfield(RequiredSettingsTab, 'numeric');
            BottomlimitpixelsEditField.FontName = 'Lucida Sans';
            BottomlimitpixelsEditField.Position = [495 264 100 22];
            BottomlimitpixelsEditField.Value = 2;

            % Create RightlimitpixelsEditFieldLabel
            RightlimitpixelsEditFieldLabel = uilabel(RequiredSettingsTab);
            RightlimitpixelsEditFieldLabel.HorizontalAlignment = 'right';
            RightlimitpixelsEditFieldLabel.FontName = 'Lucida Sans';
            RightlimitpixelsEditFieldLabel.Position = [589 314 131 22];
            RightlimitpixelsEditFieldLabel.Text = 'Right limit (pixels)';

            % Create RightlimitpixelsEditField
            RightlimitpixelsEditField = uieditfield(RequiredSettingsTab, 'numeric');
            RightlimitpixelsEditField.FontName = 'Lucida Sans';
            RightlimitpixelsEditField.Position = [620 293 100 22];
            RightlimitpixelsEditField.Value = 2;

            % Create ExcludedintervalfileSwitchLabel
            ExcludedintervalfileSwitchLabel = uilabel(RequiredSettingsTab);
            ExcludedintervalfileSwitchLabel.HorizontalAlignment = 'center';
            ExcludedintervalfileSwitchLabel.FontName = 'Lucida Sans';
            ExcludedintervalfileSwitchLabel.Position = [487 225 122 22];
            ExcludedintervalfileSwitchLabel.Text = 'Excluded interval file?';

            % Create ExcludedintervalfileSwitch
            ExcludedintervalfileSwitch = uiswitch(RequiredSettingsTab, 'slider');
            ExcludedintervalfileSwitch.Items = {'Yes', 'No'};
            ExcludedintervalfileSwitch.FontName = 'Lucida Sans';
            ExcludedintervalfileSwitch.Position = [524 197 45 20];
            ExcludedintervalfileSwitch.Value = 'Yes';

%             % Create SelectexcludedintervalfileButton
%             SelectexcludedintervalfileButton = uibutton(RequiredSettingsTab, 'push');
%             SelectexcludedintervalfileButton.FontName = 'Lucida Sans';
%             SelectexcludedintervalfileButton.Position = [457 88 180 22];
%             SelectexcludedintervalfileButton.Text = 'Select excluded interval file';
%             SelectexcludedintervalfileButton.ButtonPushedFcn = @(btn,event) plotButtonPushed2 (btn);

            % Create Image
            Image = uiimage(RequiredSettingsTab);
            Image.Position = [1 450 355 300];
            Image.ImageSource = 'cmv_logo_colour.png';

            % Create InitialestimateofsedimentationratemmyrEditFieldLabel
            InitialestimateofsedimentationratemmyrEditFieldLabel = uilabel(RequiredSettingsTab);
            InitialestimateofsedimentationratemmyrEditFieldLabel.HorizontalAlignment = 'right';
            InitialestimateofsedimentationratemmyrEditFieldLabel.FontName = 'Lucida Sans';
            InitialestimateofsedimentationratemmyrEditFieldLabel.Position = [246 96 358 22];
            InitialestimateofsedimentationratemmyrEditFieldLabel.Text = 'Initial estimate of sedimentation rate (mm/yr)';

            % Create InitialestimateofsedimentationratemmyrEditField
            InitialestimateofsedimentationratemmyrEditField = uieditfield(RequiredSettingsTab, 'numeric');
            InitialestimateofsedimentationratemmyrEditField.FontName = 'Lucida Sans';
            InitialestimateofsedimentationratemmyrEditField.Position = [619 96 100 22];
            InitialestimateofsedimentationratemmyrEditField.Value = 2;

            % Create LeftlimitpixelsEditFieldLabel_2
            LeftlimitpixelsEditFieldLabel_2 = uilabel(RequiredSettingsTab);
            LeftlimitpixelsEditFieldLabel_2.HorizontalAlignment = 'right';
            LeftlimitpixelsEditFieldLabel_2.FontName = 'Lucida Sans';
            LeftlimitpixelsEditFieldLabel_2.Position = [101 482 157 22];
            LeftlimitpixelsEditFieldLabel_2.Text = 'Welcome to countMYvarves!';

            % Create LeftlimitpixelsEditFieldLabel_3
            LeftlimitpixelsEditFieldLabel_3 = uilabel(RequiredSettingsTab);
            LeftlimitpixelsEditFieldLabel_3.FontName = 'Lucida Sans';
            LeftlimitpixelsEditFieldLabel_3.Position = [9 -5 350 599];
            LeftlimitpixelsEditFieldLabel_3.Text = {'Please select your digital core scan image, and enter'; 'the following parameters:'; '-Core name'; '-Resolution (if known)'; '-Bounding box limits (if known)'; '-Excluded intervals file (if needed)'; '-Estimated sedimentation rate'; ''; 'Select ''No'' if you not know the image resolution, or if '; 'you wish to draw a new bounding box rectangle. You'; 'will be presented with an interface to draw onto the '; 'core scan directly.'; ''; 'Excluded interval files should follow the attached MS'; 'excel template, and list regions to skip or extrapolate'; 'over. This is not a required input.'; ''; 'See the ''Advanced Settings'' tab for additional options.'; ''; 'Please check the user manual for further details on the'; 'input options. '; ''; 'Once you are ready, simply press the ''count varves'''; 'button below. Thanks and happy counting!'; ''};

            % Create Image_2
            Image_2 = uiimage(RequiredSettingsTab);
            Image_2.Position = [6 438 355 300];
            Image_2.ImageSource = 'cmv_logo_colour.png';

            % Create countvarvesButton
            countvarvesButton = uibutton(RequiredSettingsTab, 'push');
            countvarvesButton.BackgroundColor = [0.949 0.851 0.5216];
            countvarvesButton.FontName = 'Lucida Sans';
            countvarvesButton.FontSize = 15;
            countvarvesButton.FontWeight = 'bold';
            countvarvesButton.Position = [20 7 283 64];
            countvarvesButton.Text = 'count varves!';
            countvarvesButton.ButtonPushedFcn = @(btn,event) plotButtonPushed3 (btn);

            % Create AdvancedSettingsTab
            AdvancedSettingsTab = uitab(TabGroup);
            AdvancedSettingsTab.Title = 'Advanced Settings';
            AdvancedSettingsTab.BackgroundColor = [1 1 1];

            % Create NumberoftransectsEditFieldLabel
            NumberoftransectsEditFieldLabel = uilabel(AdvancedSettingsTab);
            NumberoftransectsEditFieldLabel.HorizontalAlignment = 'right';
            NumberoftransectsEditFieldLabel.FontName = 'Lucida Sans';
            NumberoftransectsEditFieldLabel.Position = [479 617 189 22];
            NumberoftransectsEditFieldLabel.Text = 'Number of transects';

            % Create NumberoftransectsEditField
            NumberoftransectsEditField = uieditfield(AdvancedSettingsTab, 'numeric');
            NumberoftransectsEditField.Position = [683 617 100 22];
            NumberoftransectsEditField.Value = 12;

            % Create ScalingfactorEditFieldLabel
            ScalingfactorEditFieldLabel = uilabel(AdvancedSettingsTab);
            ScalingfactorEditFieldLabel.HorizontalAlignment = 'right';
            ScalingfactorEditFieldLabel.FontName = 'Lucida Sans';
            ScalingfactorEditFieldLabel.Position = [481 572 187 22];
            ScalingfactorEditFieldLabel.Text = 'Scaling factor';

            % Create ScalingfactorEditField
            ScalingfactorEditField = uieditfield(AdvancedSettingsTab, 'numeric');
            ScalingfactorEditField.Position = [683 572 100 22];
            ScalingfactorEditField.Value = 1;

            % Create RundifferenttransectsinparralelLabel
            RundifferenttransectsinparralelLabel = uilabel(AdvancedSettingsTab);
            RundifferenttransectsinparralelLabel.HorizontalAlignment = 'center';
            RundifferenttransectsinparralelLabel.FontName = 'Lucida Sans';
            RundifferenttransectsinparralelLabel.Position = [524 526 295 22];
            RundifferenttransectsinparralelLabel.Text = 'Run different transects in parralel?';

            % Create RundifferenttransectsinparralelSwitch
            RundifferenttransectsinparralelSwitch = uiswitch(AdvancedSettingsTab, 'slider');
            RundifferenttransectsinparralelSwitch.Items = {'Yes', 'No'};
            RundifferenttransectsinparralelSwitch.FontName = 'Lucida Sans';
            RundifferenttransectsinparralelSwitch.Position = [663 498 45 20];
            RundifferenttransectsinparralelSwitch.Value = 'Yes';

            % Create ExternalerrorEditFieldLabel
            ExternalerrorEditFieldLabel = uilabel(AdvancedSettingsTab);
            ExternalerrorEditFieldLabel.HorizontalAlignment = 'right';
            ExternalerrorEditFieldLabel.FontName = 'Lucida Sans';
            ExternalerrorEditFieldLabel.Position = [511 445 156 22];
            ExternalerrorEditFieldLabel.Text = 'External error';

            % Create ExternalerrorEditField
            ExternalerrorEditField = uieditfield(AdvancedSettingsTab, 'numeric');
            ExternalerrorEditField.Position = [682 445 100 22];
            ExternalerrorEditField.Value = 0.02;

            % Create SmoothingsizepixelsEditFieldLabel
            SmoothingsizepixelsEditFieldLabel = uilabel(AdvancedSettingsTab);
            SmoothingsizepixelsEditFieldLabel.HorizontalAlignment = 'right';
            SmoothingsizepixelsEditFieldLabel.FontName = 'Lucida Sans';
            SmoothingsizepixelsEditFieldLabel.Position = [433 397 233 22];
            SmoothingsizepixelsEditFieldLabel.Text = 'Smoothing size (pixels)';

            % Create SmoothingsizepixelsEditField
            SmoothingsizepixelsEditField = uieditfield(AdvancedSettingsTab, 'numeric');
            SmoothingsizepixelsEditField.Position= [681 397 101 22];
            SmoothingsizepixelsEditField.Value = 10;

            % Create PercentofimageheightusedintransectsEditFieldLabel
            PercentofimageheightusedintransectsEditFieldLabel = uilabel(AdvancedSettingsTab);
            PercentofimageheightusedintransectsEditFieldLabel.HorizontalAlignment = 'right';
            PercentofimageheightusedintransectsEditFieldLabel.FontName = 'Lucida Sans';
            PercentofimageheightusedintransectsEditFieldLabel.Position = [337 352 330 22];
            PercentofimageheightusedintransectsEditFieldLabel.Text = 'Percent of image height used in transects';

            % Create PercentofimageheightusedintransectsEditField
            PercentofimageheightusedintransectsEditField = uieditfield(AdvancedSettingsTab, 'numeric');
            PercentofimageheightusedintransectsEditField.Position = [682 352 100 22];
            PercentofimageheightusedintransectsEditField.Value = 20;

            % Create PercentofimageheightusedintransectsEditField_2Label
            NumberofvarvesLabel = uilabel(AdvancedSettingsTab);
            NumberofvarvesLabel.HorizontalAlignment = 'right';
            NumberofvarvesLabel.FontName = 'Lucida Sans';
            NumberofvarvesLabel.Position = [302 306 366 22];
            NumberofvarvesLabel.Text = 'Number of varves counted either side';

            % Create PercentofimageheightusedintransectsEditField_2
            NumberofvarvesEditField = uieditfield(AdvancedSettingsTab, 'numeric');
            NumberofvarvesEditField.Position = [683 306 100 22];
            NumberofvarvesEditField.Value = 15;

            % Create CorrelationfiltersizeEditFieldLabel
            CorrelationfiltersizeEditFieldLabel = uilabel(AdvancedSettingsTab);
            CorrelationfiltersizeEditFieldLabel.HorizontalAlignment = 'right';
            CorrelationfiltersizeEditFieldLabel.FontName = 'Lucida Sans';
            CorrelationfiltersizeEditFieldLabel.Position = [355 263 313 22];
            CorrelationfiltersizeEditFieldLabel.Text = 'Correlation filter size';

            % Create CorrelationfiltersizeEditField
            CorrelationfiltersizeEditField = uieditfield(AdvancedSettingsTab, 'numeric');
            CorrelationfiltersizeEditField.Position = [683 263 100 22];
            CorrelationfiltersizeEditField.Value = 0.1;

            % Create NumberofautocorrelationiterationsEditFieldLabel
            NumberofautocorrelationiterationsEditFieldLabel = uilabel(AdvancedSettingsTab);
            NumberofautocorrelationiterationsEditFieldLabel.HorizontalAlignment = 'right';
            NumberofautocorrelationiterationsEditFieldLabel.FontName = 'Lucida Sans';
            NumberofautocorrelationiterationsEditFieldLabel.Position = [317 220 351 22];
            NumberofautocorrelationiterationsEditFieldLabel.Text = 'Number of autocorrelation iterations';

            % Create NumberofautocorrelationiterationsEditField
            NumberofautocorrelationiterationsEditField = uieditfield(AdvancedSettingsTab, 'numeric');
            NumberofautocorrelationiterationsEditField.Position = [683 220 100 22];
            NumberofautocorrelationiterationsEditField.Value = 2;

            % Create SedimentationratesmoothlyvaryingSwitchLabel
            SedimentationratesmoothlyvaryingSwitchLabel = uilabel(AdvancedSettingsTab);
            SedimentationratesmoothlyvaryingSwitchLabel.HorizontalAlignment = 'center';
            SedimentationratesmoothlyvaryingSwitchLabel.FontName = 'Lucida Sans';
            SedimentationratesmoothlyvaryingSwitchLabel.Position = [6 150 268 22];
            SedimentationratesmoothlyvaryingSwitchLabel.Text = 'Sedimentation rate smoothly varying?';

            % Create SedimentationratesmoothlyvaryingSwitch
            SedimentationratesmoothlyvaryingSwitch = uiswitch(AdvancedSettingsTab, 'slider');
            SedimentationratesmoothlyvaryingSwitch.Items = {'Yes', 'No'};
            SedimentationratesmoothlyvaryingSwitch.FontName = 'Lucida Sans';
            SedimentationratesmoothlyvaryingSwitch.Position = [119 122 45 20];
            SedimentationratesmoothlyvaryingSwitch.Value = 'Yes';

            % Create SplitdoublesizevarvesLabel
            SplitdoublesizevarvesLabel = uilabel(AdvancedSettingsTab);
            SplitdoublesizevarvesLabel.HorizontalAlignment = 'center';
            SplitdoublesizevarvesLabel.FontName = 'Lucida Sans';
            SplitdoublesizevarvesLabel.Position = [246 150 234 22];
            SplitdoublesizevarvesLabel.Text = 'Split ''double size'' varves?';

            % Create SplitdoublesizevarvesSwitch
            SplitdoublesizevarvesSwitch = uiswitch(AdvancedSettingsTab, 'slider');
            SplitdoublesizevarvesSwitch.Items = {'Yes', 'No'};
            SplitdoublesizevarvesSwitch.FontName = 'Lucida Sans';
            SplitdoublesizevarvesSwitch.Position = [337 122 45 20];
            SplitdoublesizevarvesSwitch.Value = 'Yes';

            % Create SplittriplesizevarvesLabel
            SplittriplesizevarvesLabel = uilabel(AdvancedSettingsTab);
            SplittriplesizevarvesLabel.HorizontalAlignment = 'center';
            SplittriplesizevarvesLabel.FontName = 'Lucida Sans';
            SplittriplesizevarvesLabel.Position = [405 150 259 22];
            SplittriplesizevarvesLabel.Text = 'Split ''triple size'' varves?';

            % Create SplittriplesizevarvesSwitch
            SplittriplesizevarvesSwitch = uiswitch(AdvancedSettingsTab, 'slider');
            SplittriplesizevarvesSwitch.Items = {'Yes', 'No'};
            SplittriplesizevarvesSwitch.FontName = 'Lucida Sans';
            SplittriplesizevarvesSwitch.Position= [520 122 45 20];
            SplittriplesizevarvesSwitch.Value = 'Yes';

            % Create MergehalfsizevarvesSwitchLabel
            MergehalfsizevarvesSwitchLabel = uilabel(AdvancedSettingsTab);
            MergehalfsizevarvesSwitchLabel.HorizontalAlignment = 'center';
            MergehalfsizevarvesSwitchLabel.FontName = 'Lucida Sans';
            MergehalfsizevarvesSwitchLabel.Position  = [589 150 273 22];
            MergehalfsizevarvesSwitchLabel.Text = 'Merge ''half size'' varves?';

            % Create MergehalfsizevarvesSwitch
            MergehalfsizevarvesSwitch = uiswitch(AdvancedSettingsTab, 'slider');
            MergehalfsizevarvesSwitch.Items = {'Yes', 'No'};
            MergehalfsizevarvesSwitch.FontName = 'Lucida Sans';
            MergehalfsizevarvesSwitch.Position = [697 122 45 20];
            MergehalfsizevarvesSwitch.Value = 'Yes';

            % Create LeftlimitpixelsEditFieldLabel_4
            LeftlimitpixelsEditFieldLabel_4 = uilabel(AdvancedSettingsTab);
            LeftlimitpixelsEditFieldLabel_4.HorizontalAlignment = 'center';
            LeftlimitpixelsEditFieldLabel_4.FontName = 'Lucida Sans';
            LeftlimitpixelsEditFieldLabel_4.Position = [20 392 389 54];
            LeftlimitpixelsEditFieldLabel_4.Text = {'Welcome to countMYvarves!'; ''; 'Please see the user manual for parameter descriptions'; 'and additional information.'};

            % Create Image_3
            Image_3 = uiimage(AdvancedSettingsTab);
            Image_3.Position = [6 438 355 300];
            Image_3.ImageSource = 'cmv_logo_colour.png';

            % Create MergesectionsTab
            MergesectionsTab = uitab(TabGroup);
            MergesectionsTab.Title = 'Merge sections';
            MergesectionsTab.BackgroundColor = [1 1 1];

            % Create NameofcompositeEditFieldLabel
            NameofcompositeEditFieldLabel = uilabel(MergesectionsTab);
            NameofcompositeEditFieldLabel.HorizontalAlignment = 'right';
            NameofcompositeEditFieldLabel.Position = [372 603 248 22];
            NameofcompositeEditFieldLabel.Text = 'Name of composite';

            % Create NameofcompositeEditField
            NameofcompositeEditField = uieditfield(MergesectionsTab, 'text');
            NameofcompositeEditField.Position  = [635 603 100 22];
            NameofcompositeEditField.Value = 'LOC20_1A_full_core';

            % Create LeftlimitpixelsEditFieldLabel_5
            LeftlimitpixelsEditFieldLabel_5 = uilabel(MergesectionsTab);
            LeftlimitpixelsEditFieldLabel_5.HorizontalAlignment = 'center';
            LeftlimitpixelsEditFieldLabel_5.FontName = 'Lucida Sans';
            LeftlimitpixelsEditFieldLabel_5.Position= [20 351 601 95];
            LeftlimitpixelsEditFieldLabel_5.Text = {'Welcome to countMYvarves!'; ''; 'Note: please move the core results you wish to move into'; 'one folder containing only these files.'; ''; 'Please see the user manual for parameter descriptions'; 'and additional information.'};

            % Create Image_4
            Image_4 = uiimage(MergesectionsTab);
            Image_4.Position  = [6 438 355 300];
            Image_4.ImageSource = 'cmv_logo_colour.png';

            % Create mergesectionsButton
            mergesectionsButton = uibutton(MergesectionsTab, 'push');
            mergesectionsButton.BackgroundColor = [0.949 0.851 0.5216];
            mergesectionsButton.FontName = 'Lucida Sans';
            mergesectionsButton.FontSize = 15;
            mergesectionsButton.FontWeight = 'bold';
            mergesectionsButton.Position = [481 496 283 64];
            mergesectionsButton.Text = 'merge sections!';
            mergesectionsButton.ButtonPushedFcn = @(btn,event) plotButtonPushed4 (btn);
            
            
             %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
             %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
             %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
             %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
             %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
             %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
             %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
             %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
             %% FUNCTIONS
             
%              %% 1) Get core image (gui open)
%              function [btn,event,GUIinputs]= plotButtonPushed1(btn,GUIinputs)
%              [name,path] = uigetfile('','Select a digital core scan image file.','*.jpg') ;
%              GUIinputs.core_image_path = path;
%              GUIinputs.core_image_name = name;
%              end
%              
%              
%              %% 2) Get excluded interval file (gui open)
%              function [btn,event,GUIinputs]= plotButtonPushed2(btn,GUIinputs)
%              [name,path] = uigetfile('','Select an excluded interval file (please follow the excel template).','*.xls') ;
%              GUIinputs.exluded_intervals_file_path = path;
%              GUIinputs.exluded_intervals_file_name = name;
%              end
             
             %% 3) Main button (run varve counting)
             function [btn,event,GUIinputs]= plotButtonPushed3(btn,GUIinputs)
              
                 logo = imread('cmv_logo_colour.png');
                 
                 uiwait(msgbox({'Please select your core image (e.g. jpg scan). Results will be saved to a new results folder in this location.'},...
             'Step 1: Select core image','custom',logo));
             
             
             files = uipickfiles('num',1,'out','ch','type',{'*.jpg'},'prompt','PLEASE SELECT YOUR CORE IMAGE')   ;
             [path,name,ext] = fileparts(files);
             GUIinputs.core_image_path = strcat(path,'/');
             GUIinputs.core_image_name = strcat(name,ext);    
             
             if strcmpi(ExcludedintervalfileSwitch.Value,'Yes')
                 uiwait(msgbox({'Please select your excluded interval file for this core. This should follow the provided excel template.'},...
             'Step 1b: Select excluded intervals file','custom',logo));
            
         
            files = uipickfiles('num',1,'out','ch','type',{'*.xlsx'},'prompt','PLEASE SELECT YOUR EXCLUDED INTERVALS FILE')  ;
            
            [path,name,ext] = fileparts(files); ;
             GUIinputs.exluded_intervals_file_path = strcat(path,'/');
             GUIinputs.exluded_intervals_file_name = strcat(name,ext); 
             end
                 
             %Import all values into struct array    
             GUIinputs.core_name = CorenameEditField.Value;
             GUIinputs.estimated_varve_thickness = InitialestimateofsedimentationratemmyrEditField.Value;
             GUIinputs.first_pixel = LeftlimitpixelsEditField.Value;                        
             GUIinputs.top_pixel = ToplimitpixelsEditField.Value;
             GUIinputs.last_pixel = RightlimitpixelsEditField.Value;
             GUIinputs.bottom_pixel = BottomlimitpixelsEditField.Value;
             GUIinputs.resolution = ResolutioninpixelspermmifknownEditField.Value;
             GUIinputs.parralelize = RundifferenttransectsinparralelSwitch.Value;
             GUIinputs.smoothing_size_preprocessing = SmoothingsizepixelsEditField.Value;
             GUIinputs.percent_cropped_middle = PercentofimageheightusedintransectsEditField.Value;
             GUIinputs.search_zone = NumberofvarvesEditField.Value;                                               
             GUIinputs.filter_proportion = CorrelationfiltersizeEditField.Value;
             GUIinputs.are_areas_excluded = ExcludedintervalfileSwitch.Value;
             GUIinputs.number_of_size_iterations = NumberofautocorrelationiterationsEditField.Value;
             GUIinputs.smoothly_varying_sedimentation_rate = SedimentationratesmoothlyvaryingSwitch.Value;
             GUIinputs.Filter_double_thickness = SplitdoublesizevarvesSwitch.Value;
             GUIinputs.Filter_triple_thickness = SplittriplesizevarvesSwitch.Value;
             GUIinputs.Filter_low_thickness = MergehalfsizevarvesSwitch.Value;
             GUIinputs.number_of_transects = NumberoftransectsEditField.Value;
             GUIinputs.scaling_factor = ScalingfactorEditField.Value; 
             GUIinputs.ext_error = ExternalerrorEditField.Value;
             
             
             
             if strcmpi(ImageresolutionknownSwitch.Value,'No')
                 
                 uiwait(msgbox({'In order to find the resolution of your image, you will be prompted to draw a rectangle of a given size';...
                     'Try and draw as large a box as possible for accuracy.'},...
             'Step 1c: Determine image resolution','custom',logo));
                
                                
                prompt = {'Enter length (left-right) extent of the box you wish to draw (in mm):'};
                dlgtitle = 'Choose box size (mm)';
                dims = [1 200];
                definput = {'20','hsv'};
                box_length = inputdlg(prompt,dlgtitle,dims,definput);
                
                core_image = imread(strcat(GUIinputs.core_image_path, GUIinputs.core_image_name));
                
                dessert = 'No';
                
                while strcmpi(dessert,'No')
                
                scale_image = figure;
                imshow(core_image);
                scale = drawrectangle;
                scalebar = scale.Position ;
                
                
                GUIinputs.resolution = ((scalebar(1,3)))/str2double(box_length);
                
                close(scale_image)
                
                answer = questdlg('Are you happy with your scalebar?', ...
	'Repeat?', ...
	'Yes, continue','No, re-draw it','No, re-draw it');
            % Handle response
            switch answer
    case 'Yes, continue'
          dessert = 'Yes';
         case 'No, re-draw it'
         dessert = 'No';
            end
                end
                
                
             end
             
             
             
             if strcmpi(BoundingboxlimitsknownSwitch.Value,'No')
                 
                 
                 uiwait(msgbox({'You will now be prompted to draw a rectangle onto your core image selected earlier.';...
                     ' Only regions inside this box will be considered for varve counting.';...
                     'Typically this would be the whole core, excluding any scalebar, colorchart or missing top.'},...
             'Step 1d: Region of interest','custom',logo));
                
                                

                
                core_image = imread(strcat(GUIinputs.core_image_path, GUIinputs.core_image_name));
                
                dessert = 'No';
                
                while strcmpi(dessert,'No')
                
                scale_image = figure;
                imshow(core_image);
                scale = drawrectangle;
                scalebar = scale.Position ;
                
                GUIinputs.first_pixel = (scalebar(1,1));                        
             GUIinputs.top_pixel = (scalebar(1,2));
             GUIinputs.last_pixel = (scalebar(1,3))+(scalebar(1,1));
             GUIinputs.bottom_pixel = (scalebar(1,2))+(scalebar(1,4));
                
                
                close(scale_image)
                
                answer = questdlg('Are you happy with your bounding box?', ...
	'Repeat?', ...
	'Yes, continue','No, re-draw it','No, re-draw it');
            % Handle response
            switch answer
    case 'Yes, continue'
          dessert = 'Yes';
         case 'No, re-draw it'
         dessert = 'No';
            end
                end
                
                
             end
             
             
                         
             inputs = GUIinputs;
             
             msgbox({'countMYvarves is now measuring the number of varves in your image. Please be patient, this may take a few minutes!'},...
             'Step 2: Counting varves, please be patient','custom',logo);
             
             inputMYvarves(inputs);
             
             msgbox({'Complete. See the results folder in the same folder as your image for the results. Thanks for using countMYvarves!'},...
             'Step 3: COMPLETE!','custom',logo);
             
             end 
             
             %% 4) Merge sections
             function [btn,event,merged_inputs]= plotButtonPushed4(btn,merged_inputs)
             a = uigetdir() ;
             PathtoimagesfolderEditField.Value = a;
             merged_inputs.merged_file = a;
             merged_inputs.merged_name = NameofcompositeEditField.Value;
             
             mergeMYvarves(merged_inputs);
             
             logo = imread('cmv_logo_colour.png');

             msgbox({'Sections are currently being merged. This should be done in seconds. Check the folder you selected for the results.'},...
             'Merging!','custom',logo);
             
             end 
            
         
         
         
         
         
end