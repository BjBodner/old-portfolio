		
function [Q,CurrentRow,CurrentCol,ChargingTime] = TwoD_Probabilistic_AddingChargeToFirstDot(Q,Cg,Vleft,NumberOfDots,invCM,C)
%% Finding Which Step will give th minimum energy, Applying SLides to see 
%%EnergyBefore = 0.5*(Q).'*invCM*(Q) + C*Vleft*invCM(:,1).'*Q;
%%EnergyMatrix = zeros(9,1);

				%%Finding Easiest dot to charge with minimal voltage
                    ChargingVoltageDifference = ones(NumberOfDots,1);
                        for j = 1:NumberOfDots
						ChargingVoltageDifference(j,1) = Vleft - Q(1,j)/Cg;
                        end
                [~,MaximumVoltageDifference] = max(ChargingVoltageDifference(:));

                ChosenDot = MaximumVoltageDifference;
                
                
                


            
                
                %% Creating Positive VoltageDifference elements
                n = 1;
                for j = 1:NumberOfDots
                        if ChargingVoltageDifference(j,1) > 0
                              PositiveVoltageDifference(j,n) = ChargingVoltageDifference(j,1);
                              n = n+1;
                        end
                end
                [Jmax,Nmax] = size(PositiveVoltageDifference);
                
                %% Normalizing Energy Difference
                Nomalization = sum(sum(PositiveVoltageDifference));
                Normalized_VoltageDifference = PositiveVoltageDifference/Nomalization;
                
                %% Creating Ordered Domains for Probabalistic dice roll
                NextStep_Domain(:,1) = zeros(Jmax,1);
                for n = 2:Nmax+1
                   [~,IndexOfStep] = max(Normalized_VoltageDifference(:,n-1));
                   NextStep_Domain(:,n) =  Normalized_VoltageDifference(:,n-1);
                   NextStep_Domain(IndexOfStep,n) = NextStep_Domain(IndexOfStep,n) + max(NextStep_Domain(:,n-1));
                end
                
                %% Dice Roll
                RandomNumber = rand(1,1);
                
                %% Checking Where the random Number falls
                for n = 1:Nmax
                    if RandomNumber > max(NextStep_Domain(:,n))
                        if RandomNumber < max(NextStep_Domain(:,n+1))
                            [~,ChosenDot] = max(Normalized_VoltageDifference(:,n));
                            break
                        end
                    end
                end
            
                
                    [ChargingTime] = TwoD_ChargingTimeCalculator(Q,NumberOfDots,invCM,C,Vleft,ChosenDot);
        
         			%%Charging Up Dot          
                    Q(1,ChosenDot) = Q(1,ChosenDot) + 1;

                    
				%% Finding, and Setting The new Location of Current dot
                    CurrentCol = ChosenDot;
                    CurrentRow = 1;
                    if ChosenDot == 10
                        CurrentRow
                    end
                    
                    