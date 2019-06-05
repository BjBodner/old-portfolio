				

%% Finding the requied voltage to add a charge into each one of the first dots


function [Current_Theshold_Voltage] = OneD_Theshold_VoltageCalculator(Q,invCM,C)
                        
                        
						CapacitanceEnergyBefore = 0.5*Q.'*invCM*Q;
                        Vext_Coefficients_Before = 1 + Q(1,1)*invCM(1,1)*C;
                        
						Q(1,1) = Q(1,1) + 1;

						CapacitanceEnergyAfter = 0.5*Q.'*invCM*Q;
                        Vext_Coefficients_After = Q(1,1)*invCM(1,1)*C;
                        
						Q(1,1) = Q(1,1) - 1;

						Current_Theshold_Voltage = (CapacitanceEnergyAfter - CapacitanceEnergyBefore)/(Vext_Coefficients_Before - Vext_Coefficients_After);



				%%Finding next voltage

