function [RunByRunMonitoring_Choices] = Menu_RunByRunMonitoring

% all the dynamic plots
StateEvolution_Plots =0;
Plot_Dynamic_State = 1; az = 310; el =30;
Plot_FlowChart = 0;
Plot_Flow_NonAverage_Chart = 0;

field1 = 'Plot_Dynamic_State';
value1 = Plot_Dynamic_State;
field2 = 'StateEvolution_Plots';
value2 = StateEvolution_Plots;
field3 = 'Plot_FlowChart';
value3 = Plot_FlowChart;
field4 = 'Plot_Flow_NonAverage_Chart';
value4 = Plot_Flow_NonAverage_Chart;

field5 = 'ChoiceVector';
value5 = [value1, value2,value3,value4];

RunByRunMonitoring_Choices = struct(field1,value1,field2,value2,field3,value3,field4,value4,field5,value5);