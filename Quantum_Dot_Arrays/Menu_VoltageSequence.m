function [VoltageSequence_and_Test_Parameters] = Menu_VoltageSequence()

GoBack = 0;
while GoBack~=1
    
    VoltageMenu = menu('Choose The Voltage Sequence you would like to execute',...
        'ConstantVoltage',...
        'LinearRaising',...
        'LinearRaising_and_Lowering',...
        'LogarithmicRaising',...
        'StepFunction',...
        'AC_Voltage',...
        'AC_Triangle_Voltage',...
        'GoBack');
    
    
    switch VoltageMenu
        case 0
            GoBack = 1;
            
            
            %% ConstantVoltage
        case 1
            
            
            prompt = {'Constant voltage Value (V/Vt)','Total Time Of Experiment (time)',...
                'NumberOfVoltageSteps','NumberOf_Runs_at_each_Voltage'};
            dlg_title = 'Select the constant voltage as the fraction of the threshold voltage (V/Vt):';
            num_lines = 1;
            defaultans = {'1.2','10^6','40','2'};
            Answer = inputdlg(prompt,dlg_title,num_lines,defaultans);
            ConstantVoltage_VoltageSequence = 1;
            ConstantVoltage  = str2num(Answer{1});
            
            %RegularParameters
            TotalTimeOfRun = str2num(Answer{2});
            NumberOfVoltageTests = str2num(Answer{3});
            NumberOf_Runs_at_each_Voltage = str2num(Answer{4});

            %GeneratingVoltageSequence
            VoltageSequence = ConstantVoltage*ones(NumberOfVoltageTests,1);
            
            %% LinearRaising
        case 2
            
            prompt = {'BeginingVoltage (V/Vt)','LinearRaising amount (V/Vt)',...
                'Total Time Of Experiment (time)','NumberOfVoltageSteps','NumberOf_Runs_at_each_Voltage'};
            dlg_title = 'LinearRaising_Sequence:';
            num_lines = 1;
            defaultans = {'1.02','0.02','10^6','40','2'};
            Answer = inputdlg(prompt,dlg_title,num_lines,defaultans)
            
            LinearRaising_VoltageSequence = 1;
            BeginingVoltage = str2num(Answer{1});
            VoltageRasingAmount = str2num(Answer{2});

            
            
            %RegularParameters
            TotalTimeOfRun = str2num(Answer{3});
            NumberOfVoltageTests = str2num(Answer{4});
            NumberOf_Runs_at_each_Voltage = str2num(Answer{5});
            
            
            %GeneratingVoltageSequence
            VoltageSequence = zeros(NumberOfVoltageTests,1);
            for n = 1:NumberOfVoltageTests
                VoltageSequence(n) = BeginingVoltage + (n-1)*VoltageRasingAmount;
            end
            
            
            
            %% LinearRaising_and_Lowering
        case 3
            
            prompt = {'BeginingVoltage (V/Vt)','LinearRaising amount (V/Vt)',...
                'Total Time Of Experiment (time)','NumberOfVoltageSteps','NumberOf_Runs_at_each_Voltage'};
            dlg_title = 'LinearRaising__and_Lowering_Sequence:';
            num_lines = 1;
            defaultans = {'1.02','0.02','10^6','40','2'};
            Answer = inputdlg(prompt,dlg_title,num_lines,defaultans)
            
            LinearRaising_and_Lowering_VoltageSequence = 1;
            BeginingVoltage = str2num(Answer{1});
            VoltageRasingAmount = str2num(Answer{2});
            
            
            %Regular Parameters
            TotalTimeOfRun = str2num(Answer{3});
            NumberOfVoltageTests = str2num(Answer{4});
            NumberOf_Runs_at_each_Voltage = str2num(Answer{5});
            
            
            %Generating Voltage Sequence
            VoltageSequence = zeros(NumberOfVoltageTests,1);
            for n = 1:NumberOfVoltageTests
                if n <= round(NumberOfVoltageTests/2)
                    VoltageSequence(n) = BeginingVoltage + (n-1)*VoltageRasingAmount;
                end
                if n > round(NumberOfVoltageTests/2)
                    VoltageSequence(n) = BeginingVoltage +(NumberOfVoltageTests - n)*VoltageRasingAmount;
                end
            end
            
            
            %% LogarithmicRaising
        case 4
            
            
            prompt = {'Initial Power Of Ten (dV/Vt)','Final Power Of Ten (dV/Vt)',...
                'Total Time Of Experiment (time)','NumberOfVoltageSteps','NumberOf_Runs_at_each_Voltage'};
            dlg_title = 'LogarithmicRaising_Sequence:';
            num_lines = 1;
            defaultans = {'1.02','0.02','10^6','40','2'};
            Answer = inputdlg(prompt,dlg_title,num_lines,defaultans)
            
            LogarithmicRaising__VoltageSequence = 1;
            InitialPowerOfTen = str2num(Answer{1});
            FinalPowerOfTen = str2num(Answer{2});
            
            %Regular Parameters
            TotalTimeOfRun = str2num(Answer{3});
            NumberOfVoltageTests = str2num(Answer{4});
            NumberOf_Runs_at_each_Voltage = str2num(Answer{5});
            


            %Generating Voltage Sequence
            VoltageSequence = zeros(NumberOfVoltageTests,1);
            for n = 1:NumberOfVoltageTests
                    VoltageSequence(n) = 1 + sqrt(10)^((n-1/(NumberOfVoltageTests-1))*(FinalPowerOfTen-InitialPowerOfTen) + InitialPowerOfTen);
            end
            
            %% StepFunction
        case 5
            
            prompt = {'BeginingVoltage (V/Vt)','FinalVoltage (V/Vt)',...
                'Total Time Of Experiment (time)','NumberOfVoltageSteps','NumberOf_Runs_at_each_Voltage',...
                'Activation_TestNumber','Deactivation_TestNumber'};
            dlg_title = 'LogarithmicRaising_Sequence:';
            num_lines = 1;
            defaultans = {'1.02','3','10^6','10','2','2','3'};
            Answer = inputdlg(prompt,dlg_title,num_lines,defaultans)
            
            StepFunction_Sequence = 1;
            BeginingVoltage = str2num(Answer{1});
            FinalVoltage = str2num(Answer{2});
            Activation_TestNumber = str2num(Answer{6});
            Deactivation_TestNumber = str2num(Answer{7});
            
            %Regular Parameters
            TotalTimeOfRun = str2num(Answer{3});
            NumberOfVoltageTests = str2num(Answer{4});
            NumberOf_Runs_at_each_Voltage = str2num(Answer{5});

            %Generating Voltage Sequence
            VoltageSequence = zeros(NumberOfVoltageTests);
            for n = 1:NumberOfVoltageTests
                VoltageSequence(n) = BeginingVoltage;
                if n >= Activation_TestNumber
                    if n <= Deactivation_TestNumber
                        VoltageSequence(n) = FinalVoltage;
                    end
                end
            end

            
            
            %% AC_Voltage
        case 6
            
            prompt = {'BaseVoltage (V/Vt)','Amplitude Of Wave (V/Vt)',...
                'Frequency w (10^6/time)','Sampling Rate(10^6/time)','Total Time Of Experiment (time)',...
                'NumberOf_Runs_at_each_Voltage(Recomended 1)'};
            dlg_title = 'AC_Voltage_Sequence:';
            num_lines = 1;
            defaultans = {'1.2','0.1','100','1000','10^6','1'};
            Answer = inputdlg(prompt,dlg_title,num_lines,defaultans)
            
            Real_AC_VoltageSequence =1;
            BaseVoltage = str2num(Answer{1});
            AC_Amplitude = str2num(Answer{2});
            VoltageFrequency = str2num(Answer{3});
            SamplingRate = str2num(Answer{4});
            
            %Regular Parameters - NumberOfVoltageTests
            TotalTimeOfRun = str2num(Answer{5});
            NumberOf_Runs_at_each_Voltage = str2num(Answer{6})

    

            %Generating Voltage Sequence + NumberOfVoltageTests
            
            TotalTimeAtEachVoltage = 10^6/SamplingRate;
            NumberOfVoltageTests = round(TotalTimeOfRun/TotalTimeAtEachVoltage);
            t = 0:TotalTimeAtEachVoltage:TotalTimeOfRun;
            VoltageSequence = zeros(NumberOfVoltageTests); 
            VoltageSequence = BaseVoltage + AC_Amplitude*sin(2*pi*VoltageFrequency*t);

            
            %%AC_Triangle_Voltage
        case 7
            
            
            
            %% GoBack
        case 8
            GoBack = 1;
    end
    
    
    field1 = 'TotalTimeOfRun';
    value1 = TotalTimeOfRun;
    field2 = 'NumberOfVoltageTests';
    value2 = NumberOfVoltageTests;
    field3 = 'NumberOf_Runs_at_each_Voltage';
    value3 = NumberOf_Runs_at_each_Voltage;
    field4 = 'VoltageSequence';
    value4 = VoltageSequence;

    VoltageSequence_and_Test_Parameters = struct(field1,value1,field2,value2,field3,value3,field4,value4);

end
