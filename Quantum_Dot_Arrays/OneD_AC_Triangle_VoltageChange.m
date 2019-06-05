function [Vleft] = OneD_AC_Triangle_VoltageChange(NumberOfVoltageTests,n,Vleft,ThresholdVoltage,VoltageRasingAmount,NumberOfCycles)
    if mod(n-1,NumberOfVoltageTests/(NumberOfCycles)) < round(NumberOfVoltageTests/(2*NumberOfCycles))
                Vleft = Vleft + VoltageRasingAmount*ThresholdVoltage;
    end
    if mod(n-1,NumberOfVoltageTests/(NumberOfCycles)) >= round(NumberOfVoltageTests/(2*NumberOfCycles))
                Vleft = Vleft - VoltageRasingAmount*ThresholdVoltage;
    end