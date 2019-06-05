function [ChargingTime] = TwoD_ChargingTimeCalculator(Q,NumberOfDots,invCM,C,Vleft,ChosenDot);

                        EnergyBefore = 0.5*reshape(Q,1,NumberOfDots*NumberOfDots)*invCM*reshape(Q,NumberOfDots*NumberOfDots,1) ;              
                        Propper_Coeficients_Before = 1 + Q(1,:)*invCM(1,1:NumberOfDots:NumberOfDots*NumberOfDots - NumberOfDots + 1).';
                        
						Q(1,ChosenDot) = Q(1,ChosenDot) + 1;
                        
						EnergyAfter = 0.5*reshape(Q,1,NumberOfDots*NumberOfDots)*invCM*reshape(Q,NumberOfDots*NumberOfDots,1);
                        Propper_Coeficients_After = Q(1,:)*invCM(1,1:NumberOfDots:NumberOfDots*NumberOfDots - NumberOfDots + 1).';

                        Q(1,ChosenDot) = Q(1,ChosenDot) - 1;
                        
                        EnergyDifference = (EnergyAfter + Vleft*Propper_Coeficients_After) - (EnergyBefore - Vleft*Propper_Coeficients_Before);
                        
                        ChargingTime = 1/EnergyDifference;