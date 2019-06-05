function [ VoltageSequence_and_Test_Parameters] = Menu_VoltageSequence_DefaultParameters_Generator



            Answer = {'1.02','0.02','10^7','20','2'}
            
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
            
            
            
                field1 = 'TotalTimeOfRun';
    value1 = TotalTimeOfRun;
    field2 = 'NumberOfVoltageTests';
    value2 = NumberOfVoltageTests;
    field3 = 'NumberOf_Runs_at_each_Voltage';
    value3 = NumberOf_Runs_at_each_Voltage;
    field4 = 'VoltageSequence';
    value4 = VoltageSequence;

    VoltageSequence_and_Test_Parameters = struct(field1,value1,field2,value2,field3,value3,field4,value4);