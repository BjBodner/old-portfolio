function [StepByStepMonitoring_Choices] = Menu_StepByStepMonitoring_DefaultParameters_Generator

%% display energetic influance
% display charge system
% dispalay plotsystem

PlotSystem = 0; StartingVoltageTest_forPlotSystem = 2; EndingVoltageTest_forPlotSystem = 3;
PlotCharging =0;
Plot_EnergyLanscape_plot = 0;

field1 = 'PlotSystem';
value1 = [PlotSystem StartingVoltageTest_forPlotSystem EndingVoltageTest_forPlotSystem];
field2 = 'PlotCharging';
value2 = PlotCharging;
field3 = 'Plot_EnergyLanscape_plot';
value3 = Plot_EnergyLanscape_plot;

field4 = 'ChoiceVector';
value4 = [value1, value2,value3];

StepByStepMonitoring_Choices = struct(field1,value1,field2,value2,field3,value3,field4,value4);
