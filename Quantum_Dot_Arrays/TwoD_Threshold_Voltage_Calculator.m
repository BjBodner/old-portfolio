				

%% Finding the requied voltage to add a charge into each one of the first dots


function [Current_Theshold_Voltage] = TwoD_Threshold_Voltage_Calculator(Q,NumberOfDots,invCM,C,Vleft)
                        
                        

NextVoltageEnergyMatrix = zeros(NumberOfDots(2),1);
                        
                        %% Creating Partial_Coefficients
                        %%Partial_Coefficients = zeros(NumberOfDots*NumberOfDots,1);
                        %%for n = 0:NumberOfDots-1
                          %%  Partial_Coefficients =  Partial_Coefficients + invCM(:,1 + n*NumberOfDots);
                        %%end
                        
                        EnergyBefore = 0.5*reshape(Q,1,NumberOfDots(1)*NumberOfDots(2))*invCM*reshape(Q,NumberOfDots(1)*NumberOfDots(2),1);
                        
                        
                        NextVoltageMatrix = EnergyBefore*ones(NumberOfDots(2),1);
                      
                        
                    %%  Full_Coefficients_Before = 1 + reshape(Q,1,NumberOfDots*NumberOfDots)*Partial_Coefficients*C; 
                    %%  invCM(1,1:NumberOfDots:NumberOfDots*NumberOfDots - NumberOfDots + 1)
                       
                        
					for j = 1:NumberOfDots(2)
	
                        %% Quasi 1D Calculation
                        %%QuasiOneDCoeficients_Before =  1 + Q(1,j)*invCM(1,1 + (j-1)*NumberOfDots)*C;
                        
                        %% Propper Calculation
                        Propper_Coeficients_Before = 1 + Q(1,:)*invCM(1,1:NumberOfDots(1):NumberOfDots(1)*NumberOfDots(2) - NumberOfDots(1) + 1).';
                        
                        
						Q(1,j) = Q(1,j) + 1;

						EnergyAfter = 0.5*reshape(Q,1,NumberOfDots(1)*NumberOfDots(2))*invCM*reshape(Q,NumberOfDots(1)*NumberOfDots(2),1);
                        %% Quasi 1D Calculation
                        %%QuasiOneDCoeficients_After =  Q(1,j)*invCM(1,1 + (j-1)*NumberOfDots)*C;
                        
                        %% Propper Calculation
                        Propper_Coeficients_After = Q(1,:)*invCM(1,1:NumberOfDots(1):NumberOfDots(1)*NumberOfDots(2) - NumberOfDots(1) + 1).';

                        Q(1,j) = Q(1,j) - 1;
                        
                      %%  Full_Coefficients_After = reshape(Q,1,NumberOfDots*NumberOfDots)*Partial_Coefficients*C; 
                      %%  Minimized_Coeficients = Partial_Coefficients(1 + (j-1)*NumberOfDots);
                   
                      %% Quasi 1D Calculation
						%%NextVoltageMatrix(j,1) = (EnergyAfter - EnergyBefore)/(QuasiOneDCoeficients_Before - QuasiOneDCoeficients_After);
                     %% Propper Calculation
                        NextVoltageMatrix(j,1) = (EnergyAfter - EnergyBefore)/(Propper_Coeficients_Before - Propper_Coeficients_After);
                        NextVoltageEnergyMatrix(j,1) = (EnergyAfter - EnergyBefore);
					end



				%%Finding minimal next voltage

						[M,~] = min(NextVoltageMatrix);
						Current_Theshold_Voltage = M;
                        
                       %[~,indexOfMinimalVoltage] = min(NextVoltageMatrix)
                       %[~,indexOfMinimalEnergy] = min(NextVoltageEnergyMatrix)
                       %Vleft
