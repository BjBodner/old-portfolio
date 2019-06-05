function [Vleft] = OneD_Linear_RaisingaLowering_Of_Voltage(NumberOfVoltageTests,n,Vleft,ThresholdVoltage,VoltageRasingAmount)
    if n <= round(NumberOfVoltageTests/2)
                Vleft = Vleft + VoltageRasingAmount*ThresholdVoltage;
    end
    if n > round(NumberOfVoltageTests/2)+1
                Vleft = Vleft - VoltageRasingAmount*ThresholdVoltage;
    end