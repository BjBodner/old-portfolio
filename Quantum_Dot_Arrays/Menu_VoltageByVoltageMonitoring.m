function [VoltageByVoltageMonitoring_Choices] = Menu_VoltageByVoltageMonitoring

% all the dynamic plots
Plot_Dynamic_State = 1; az = 310; el =30;
Plot_FlowChart = 0;
Plot_Flow_NonAverage_Chart = 0;

field1 = 'Plot_Dynamic_State';
value1 = Plot_Dynamic_State;
field2 = 'Plot_FlowChart';
value2 = Plot_FlowChart;
field3 = 'Plot_Flow_NonAverage_Chart';
value3 = Plot_Flow_NonAverage_Chart;

field4 = 'ChoiceVector';
value4 = [value1, value2,value3];

VoltageByVoltageMonitoring_Choices = struct(field1,value1,field2,value2,field3,value3,field4,value4);