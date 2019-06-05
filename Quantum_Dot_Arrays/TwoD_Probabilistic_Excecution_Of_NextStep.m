		
function [Q,CurrentRow,CurrentCol,ChosenStep,EnergyDifference] = TwoD_Probabilistic_Excecution_Of_NextStep(Q,NextStepArray,invCM,C,Vleft,NumberOfDots)
%% Finding Which Step will give th minimum energy, Applying SLides to see 
%%EnergyBefore = 0.5*(Q).'*invCM*(Q) + C*Vleft*invCM(:,1).'*Q;
%%EnergyMatrix = zeros(9,1);
                EnergyDifference = 0;
				EnergyBefore = 0.5*reshape(Q,1,NumberOfDots*NumberOfDots)*invCM*reshape(Q,NumberOfDots*NumberOfDots,1) + C*Vleft*invCM(:,1).'*reshape(Q,NumberOfDots*NumberOfDots,1);
                EnergyMatrix = zeros(17,1);
                EnergyMatrix(17) = EnergyBefore;
                
                
            for l = 1:16
                [~,Index] = min(reshape(NextStepArray(:,:,l),1,NumberOfDots*NumberOfDots));
                [I_row, I_col] = ind2sub(size(NextStepArray(:,:,2)),Index);
                if Q(I_row, I_col) >=1
                	EnergyMatrix(l) = 0.5*reshape(Q + NextStepArray(:,:,l),1,NumberOfDots*NumberOfDots)*invCM*reshape(Q + NextStepArray(:,:,l),NumberOfDots*NumberOfDots,1) + C*Vleft*invCM(:,1).'*reshape(Q + NextStepArray(:,:,l),NumberOfDots*NumberOfDots,1);
                end
                if Q(I_row, I_col) <=1
                    EnergyMatrix(l) = 100*EnergyBefore;
                end
            end
            
      
     			[~,MinimalEnergy] = min(EnergyMatrix);
            ChosenStep = MinimalEnergy;

            if MinimalEnergy < 17
                
                %% Creating energy difference elements
                %%EnergyDifference = zeros (8,8);
                n = 1;
                for l = 1:16
                        if EnergyMatrix(l) < EnergyMatrix(17)
                              EnergyDifference(l,n) = EnergyMatrix(17) - EnergyMatrix(l);
                              n = n+1;
                        end
                end
                [Lmax,Nmax] = size(EnergyDifference);
                
                %% Normalizing Energy Difference
                Nomalization = sum(sum(EnergyDifference));
                Normalized_EnergyDifference = EnergyDifference/Nomalization;
                
                %% Creating Ordered Domains for Probabalistic dice roll
                NextStep_Domain(:,1) = zeros(Lmax,1);
                for n = 2:Nmax+1
                   [~,IndexOfStep] = max(Normalized_EnergyDifference(:,n-1));
                   NextStep_Domain(:,n) =  Normalized_EnergyDifference(:,n-1);
                   NextStep_Domain(IndexOfStep,n) = NextStep_Domain(IndexOfStep,n) + max(NextStep_Domain(:,n-1));
                end
                
                %% Dice Roll
                RandomNumber = rand(1,1);
                
                %% Checking Where the random Number falls
                for n = 1:Nmax
                    if RandomNumber > max(NextStep_Domain(:,n))
                        if RandomNumber < max(NextStep_Domain(:,n+1))
                            [~,ChosenStep] = max(Normalized_EnergyDifference(:,n));
                            break
                        end
                    end
                end
            end


            		%Executing Next Step
		Q = Q + NextStepArray(:,:,ChosenStep);
        
        %%Calculating Chosen Energy Difference
        EnergyDifference = EnergyMatrix(17) - EnergyMatrix(ChosenStep); 
        
				%% Finding, and Setting The new Location of Current dot

		[~,Index] = max(reshape(NextStepArray(:,:,ChosenStep),1,NumberOfDots*NumberOfDots));
		[I_row, I_col] = ind2sub(size(NextStepArray(:,:,2)),Index);
		CurrentRow = I_row;
		CurrentCol = I_col;
