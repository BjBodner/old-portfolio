function [TestSummeryPlots_Choices] = Menu_TestSummeryPlots_DefaultParameters_Generator()

%% all the final plots

tripleplot = 1;
I_V_Single_Plot = 1;
Conductance_Plot = 1;
PlotAverageState =0;
Plot_InitialFinal_Difference_State = 0;
ChargesPlot =0;
CurrentPlot = 0;
Double_AverageSateplot = 0;
ExtraChargesPerDot_Plot = 0;
DistributionPlot = 0;
Conductance_Noise_Plot = 1;

field1 = 'tripleplot';
value1 = tripleplot;
field2 = 'I_V_Single_Plot';
value2 = I_V_Single_Plot;
field3 = 'Plot_InitialFinal_Difference_State';
value3 = Plot_InitialFinal_Difference_State;
field4 = 'ChargesPlot';
value4 = ChargesPlot;
field5 = 'CurrentPlot';
value5 = CurrentPlot;
field6 = 'ExtraChargesPerDot_Plot';
value6 = ExtraChargesPerDot_Plot;
field7 = 'PlotAverageState';
value7 = PlotAverageState;
field8 = 'Conductance_Plot';
value8 = Conductance_Plot;
field9 = 'DistributionPlot';
value9 = DistributionPlot;
field10 = 'Conductance_Noise_Plot';
value10 = Conductance_Noise_Plot;

%field9 = 'ChoiceVector';
%value9 = [value1, value2,value3,value4,value5,value6,value7];

TestSummeryPlots_Choices = struct(field1,value1,field2,value2,field3,value3,field4,value4,field5,value5,field6,value6,field7,value7,field8,value8,field9,value9,field10,value10);