function [MainMenu_Choice,Loaded_Preset] = Menu_Main(Loaded_Preset)

SavePreset = 0;

CCg_Averaging_Change = 0;
VoltageSequence_Change = 0;
Size_and_Disorder_Change = 0;
Monitoring_and_Reaults_Change = 0;
CapacitanceMatrix_Change = 0;
ExperimentType_Change = 0;
StepByStepMonitoring_Change = 0;
VoltageByVoltageMonitoring_Change = 0;
TestSummeryPlots_Change =0;



%%Defaultant
CCg_Averaging_defaultans = {'1','0.1','0.1','1','1'};





repeating = 1;
while repeating == 1
    
    %% Loading in the choices from the load
    if Loaded_Preset == 1
        if CCg_Averaging_Change == 0
        CCg_Averaging_Parameters = MainMenu_Choice.CCg_Averaging_Parameters;
        end
        if VoltageSequence_Change ==0
        VoltageSequence_and_Test_Parameters = MainMenu_Choice.VoltageSequence_and_Test_Parameters;
        end
        if Size_and_Disorder_Change == 0
        SizeAndDisorder_parameters = MainMenu_Choice.SizeAndDisorder_parameters;
        end
        if StepByStepMonitoring_Change == 0
        StepByStepMonitoring_Choices = MainMenu_Choice.StepByStepMonitoring_Choices;
        end
        if VoltageByVoltageMonitoring_Change == 0
        VoltageByVoltageMonitoring_Choices = MainMenu_Choice.VoltageByVoltageMonitoring_Choices;
        end
        if TestSummeryPlots_Change == 0
        TestSummeryPlots_Choices = MainMenu_Choice.TestSummeryPlots_Choices;
        end
        if CapacitanceMatrix_Change == 0
        CapacitanceMatrixChoice = MainMenu_Choice.CapacitanceMatrixChoice;
        end
        if ExperimentType_Change == 0
        ExperimentType_Choice = MainMenu_Choice.ExperimentType_Choice;
        end
    end
    
    %%Filling in the defaults
    if Loaded_Preset == 0;
        
        %% Getting Relavent Defaults
        if CCg_Averaging_Change == 0
            CCg_Averaging_Answer = CCg_Averaging_defaultans;
            field1 = 'Cg';
            value1 = str2num(CCg_Averaging_Answer{1});
            field2 = 'Initial_C';
            value2 = str2num(CCg_Averaging_Answer{2});
            field3 = 'Final_C';
            value3 = str2num(CCg_Averaging_Answer{3});
            field4 = 'Number_Of_Logarithmic_Steps';
            value4 = str2num(CCg_Averaging_Answer{4});
            field5 = 'Number_of_Averaging_runs_at_Each_CCg';
            value5 = str2num(CCg_Averaging_Answer{5});
            CCg_Averaging_Parameters = struct(field1,value1,field2,value2,field3,value3,field4,value4,field5,value5);
        end
        
        if VoltageSequence_Change == 0
            [ VoltageSequence_and_Test_Parameters] = Menu_VoltageSequence_DefaultParameters_Generator;
        end
        
        if Size_and_Disorder_Change == 0
            [SizeAndDisorder_parameters] = Menu_Default_SizeAndDisorder_parameters_Generator;
        end
        
        if  Monitoring_and_Reaults_Change == 0
            if StepByStepMonitoring_Change ==0
                [StepByStepMonitoring_Choices] = Menu_StepByStepMonitoring_DefaultParameters_Generator;
            end
            if VoltageByVoltageMonitoring_Change ==0
                [VoltageByVoltageMonitoring_Choices] = Menu_VoltageByVoltageMonitoring_DefaultParameters_Generator;
            end
            if TestSummeryPlots_Change ==0
                [TestSummeryPlots_Choices] = Menu_TestSummeryPlots_DefaultParameters_Generator;
            end
        end
        
        if CapacitanceMatrix_Change == 0
            [CapacitanceMatrixChoice] = Menu_CapacitanceMatrix_DefaultParameters_Generator;
        end
        
        if ExperimentType_Change == 0
            field1 = 'Charging_Experiment';
            value1 = 1;
            field2 = 'Charging_and_Conducting_Experiment';
            value2 = 0;
            field3 = 'ChoiceVector';
            value3 = [value1,value2];
            ExperimentType_Choice = struct(field1,value1,field2,value2,field3,value3);
        end
        

        
    end
    
    
    
    MainMenu = menu('Main Menu',...
        'CCg_Averaging_Settings',...
        'VoltageSequence_Settings',...
        'Size_and_Disorder_Settings',...
        'Monitoring_and_Reaults_Settings',...
        'CapacitanceMatrix_Settings',...
        'ExperimentType_Settings',...
        'LoadPreset',...
        'SavePreset',...
        'Run_The_Experiment');
    
    
    switch MainMenu
        case 0
            break
            
            %% CCg_Averaging_Settings
        case 1
            
            CCg_Averaging_Change = 1;
            
            prompt = {'Cg',...
                'Initial C(For CCg Sweep)',...
                'Final C(For CCg Sweep)',...
                'Number Of Logarithmic Step between Initial and Final C(minimum 1)',...
                'Number of Averaging runs at Each C/Cg(minimum 1)'};
            dlg_title = 'Multiple Runs';
            num_lines = 1;
            CCg_Averaging_Answer = inputdlg(prompt,dlg_title,num_lines,CCg_Averaging_defaultans);
            field1 = 'Cg';
            value1 = str2num(CCg_Averaging_Answer{1});
            field2 = 'Initial_C';
            value2 = str2num(CCg_Averaging_Answer{2});
            field3 = 'Final_C';
            value3 = str2num(CCg_Averaging_Answer{3});
            field4 = 'Number_Of_Logarithmic_Steps';
            value4 = str2num(CCg_Averaging_Answer{4});
            field5 = 'Number_of_Averaging_runs_at_Each_CCg';
            value5 = str2num(CCg_Averaging_Answer{5});
            CCg_Averaging_Parameters = struct(field1,value1,field2,value2,field3,value3,field4,value4,field5,value5);
            
            %% VoltageSequence_Settings
        case 2
            [VoltageSequence_and_Test_Parameters] = Menu_VoltageSequence()
            
            VoltageSequence_Change = 1;
            
            %% Size_and_Disorder_Settings
        case 3
            if Loaded_Preset ~= 1
            [SizeAndDisorder_parameters] = Menu_SizeAndDisorder();
            end
            
            if Loaded_Preset == 1
            [SizeAndDisorder_parameters] = Menu_SizeAndDisorder_ForLoadedParameters(SizeAndDisorder_parameters);
            end
            
            Size_and_Disorder_Change = 1;
            %% Monitoring_and_Reaults_Settings
        case 4
            
            Monitoring_and_Reaults_Change = 1;
            GoBack=0
            while GoBack ~= 1
                monitoring = menu('Select Type Of Monitoring',...
                    'StepByStepMonitoring',...
                    'VoltageByVoltageMonitoring',...
                    'Menu_RunByRunMonitoring',...
                    'Menu_TestSummeryPlots()')
                
                switch monitoring
                    case 0
                        GoBack = 1
                    case 1
                        [StepByStepMonitoring_Choices] = Menu_StepByStepMonitoring; %Monitor system at Each step
                        StepByStepMonitoring_Change = 1;
                    case 2
                        [VoltageByVoltageMonitoring_Choices] = Menu_VoltageByVoltageMonitoring; %Monitor system at Each Change in Voltage
                        VoltageByVoltageMonitoring_Change = 1;
                    case 3
                        %  [] = Menu_RunByRunMonitoring %Monitor System at each run (CCg Change)
                    case 4
                        [TestSummeryPlots_Choices] = Menu_TestSummeryPlots(); %Final Results
                        TestSummeryPlots_Change = 1;
                    case 5
                        GoBack = 1
                end
            end
            
            
            %% CapacitanceMatrix_Settings
        case 5
            [CapacitanceMatrixChoice,GoBack] = Menu_Capacitance_Matrix();
            
            CapacitanceMatrix_Change = 1;
            %% ExperimentType_Settings
        case 6
            
            ExperimentType_Change = 1;
            
            Experiment = menu('Select Experiment',...
                'Charging_Experiment', ...
                'Charging_and_Conducting_Experiment');
            field1 = 'Charging_Experiment';
            value1 = 1;
            field2 = 'Charging_and_Conducting_Experiment';
            value2 = 0;
            field3 = 'ChoiceVector';
            value3 = [value1,value2];
            ExperimentType_Choice = struct(field1,value1,field2,value2,field3,value3);
            switch Experiment
                case 0
                    disp('You Chose to Exit Please run again')
                case 1
                    disp('Charging_Experiment')
                    value1 = 1;
                case 2
                    disp('Charging_and_Conducting_Experiment')
                    value2 = 1;
            end
            value3 = [value1,value2];
            ExperimentType_Choice = struct(field1,value1,field2,value2,field3,value3);
            
            
            
            
            %% LoadPreset
        case 7
            NameOfDataFile = uigetdir
            disp(NameOfDataFile)
            filename = uigetfile;
            disp(filename)
            SeperationSlash = '\';
            FullFileName = strcat(NameOfDataFile,SeperationSlash,filename) ;
            disp(FullFileName)
            load(FullFileName)
            
            Loaded_Preset = 1;
            
            %% Save The Preset
        case 8
            [FullFileName] = Menu_SaveWorkSpace()
            SavePreset = 1;
            %  repeating = 0;
            
            
            
            %% Run_The_Experiment
        case 9
            
            %  [] = Menu_AutoSave()
            repeating = 0;
            
    end
    
end


%% Making the MainMenu_choices structure
field1 = 'CCg_Averaging_Parameters';
value1 = CCg_Averaging_Parameters;
field2  = 'VoltageSequence_and_Test_Parameters';
value2 = VoltageSequence_and_Test_Parameters;
field3 = 'SizeAndDisorder_parameters';
value3 = SizeAndDisorder_parameters;
field4 = 'StepByStepMonitoring_Choices';
value4 = StepByStepMonitoring_Choices;
field5 = 'VoltageByVoltageMonitoring_Choices';
value5 = VoltageByVoltageMonitoring_Choices;
field6 = 'TestSummeryPlots_Choices';
value6 = TestSummeryPlots_Choices;
field7 = 'CapacitanceMatrixChoice';
value7 = CapacitanceMatrixChoice;
field8 = 'ExperimentType_Choice';
value8 = ExperimentType_Choice;
MainMenu_Choice = struct(field1,value1,field2 ,value2,field3 ,value3,field4 ,value4,field5 ,value5,field6 ,value6,field7 ,value7,field8,value8);
Loaded_Preset = 1;




%% Save Preset
if SavePreset == 1
    save(FullFileName,'MainMenu_Choice')
end

%% AutoSave
SumOfAllChanges = CCg_Averaging_Change + VoltageSequence_Change + Size_and_Disorder_Change + CapacitanceMatrix_Change + ExperimentType_Change;
if SumOfAllChanges ~= 0
    Currentdate = date;
   % DirNameForAutoSaves = 'C:\Users\BBB\OneDrive\Documents\Research Quantum Dots\2D\AutoSaves';
    DirNameForAutoSaves = 'C:\Users\benjy\OneDrive\Documents\Research Quantum Dots\2D\AutoSaves';
    RandomNumber = num2str(round(10000*rand(1,1)));
    FullFileName = strcat(DirNameForAutoSaves,'\''AutoSave',RandomNumber,'_',Currentdate,'.mat');
    save(FullFileName,'MainMenu_Choice')
end
