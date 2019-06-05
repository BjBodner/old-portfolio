				

%% Finding the requied voltage to add a charge into each one of the first dots


function [Vleft,Index_Of_Minimal_Calculated_Voltage] = NextVoltageCalculator(Q,NumberOfDots,invCM,C,Cg,Vleft,Vg)
                        
                        

%NextVoltageEnergyMatrix = zeros(NumberOfDots,1);
NextVoltageEnergyMatrix = zeros(NumberOfDots(1),1);
                        

                          %%  Partial_Coefficients =  Partial_Coefficients + invCM(:,1 + n*NumberOfDots);

                        
                        %EnergyBefore = 0.5*reshape(Q,1,NumberOfDots*NumberOfDots)*invCM*reshape(Q,NumberOfDots*NumberOfDots,1);
                        EnergyBefore = 0.5*reshape(Q,1,NumberOfDots(1)*NumberOfDots(2))*invCM*reshape(Q,NumberOfDots(1)*NumberOfDots(2),1);
                                          
                        
                        %NextVoltageMatrix = EnergyBefore*ones(NumberOfDots,1);
                         NextVoltageMatrix = EnergyBefore*ones(NumberOfDots(2),1);                     
                        
                    %%  Full_Coefficients_Before = 1 + reshape(Q,1,NumberOfDots*NumberOfDots)*Partial_Coefficients*C; 
                    %%  invCM(1,1:NumberOfDots:NumberOfDots*NumberOfDots - NumberOfDots + 1)
                       
                        
			%		for j = 1:NumberOfDots
					for j = 1:NumberOfDots(2)	


                      %  NewCoefficients = 1 - C*sum(invCM(1+(j-1)*NumberOfDots,1:NumberOfDots:NumberOfDots*NumberOfDots - NumberOfDots + 1));
                         NewCoefficients = 1 - C*sum(invCM(1+(j-1)*NumberOfDots(1),1:NumberOfDots(1):NumberOfDots(1)*NumberOfDots(2) - NumberOfDots(1) + 1));
                                               
						Q(1,j) = Q(1,j) + 1;

			%			EnergyAfter = 0.5*reshape(Q,1,NumberOfDots*NumberOfDots)*invCM*reshape(Q,NumberOfDots*NumberOfDots,1);

                      %  EnergyAfter = 0.5*reshape(Q,1,NumberOfDots(1)*NumberOfDots(2))*invCM*reshape(Q,NumberOfDots(1)*NumberOfDots(2),1);
                        
                        EnergyAfter = 0.5*reshape(Q,1,NumberOfDots(1)*NumberOfDots(2))*invCM*reshape(Q,NumberOfDots(1)*NumberOfDots(2),1) + Cg*Vg*sum(invCM(j,:));                        

                        Q(1,j) = Q(1,j) - 1;
                        

                        NextVoltageMatrix(j,1) = (EnergyAfter - EnergyBefore)/NewCoefficients ;
                        
					end



				%%Finding minimal next voltage

						[M,Index_Of_Minimal_Calculated_Voltage] = min(NextVoltageMatrix);
						Vleft = max(Vleft,M)
                        
                       %[~,indexOfMinimalVoltage] = min(NextVoltageMatrix)
                       %[~,indexOfMinimalEnergy] = min(NextVoltageEnergyMatrix)
                       Vleft
