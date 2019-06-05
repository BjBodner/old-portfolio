%% Simulation Of Korotkov Paper
clear

% Units: e = 1, Voltage = 1/Cg
disorder = rand(1);
disorder = 0;
VL = 0.1;
C = 1;
Cg = 1;

T = 10^-10;
R_L = 1;
R_R = 1;
k = 1;

NumberOf_VgSweep_Tests = 80;
VgJump = 0.1;
InitialVg = -2;
Vg = InitialVg;
n = 1;
SumPropabilities = 1;

for k = 1:NumberOf_VgSweep_Tests %% this is the Vg Loop For Vg Sweep
    
    if k <= NumberOf_VgSweep_Tests/2
        Vg = Vg + VgJump;
    end
    if k > NumberOf_VgSweep_Tests/2+1
        Vg = Vg - VgJump;
    end
    
    while SumPropabilities > 0.1 %% this is the relaxation Loop For No Current
    
    
        
        Vg_1 = Vg - VL*(C/2*C);
        Qn = (n + disorder + Cg*Vg_1)*(2*C)/(2*C+Cg);
        U = (VL*C + Qn)/(2*C);
        
        
        %% here Left is index 1, and Right is index 1(compared to the paper
        
        %% Plus means this is for increasing the charge on the dot
        %% Minus means this is for Decreasing the charge on the dot
        
        %% if the is an energy gain - positive W,
        %and the rate is non-zero this means that this is a legal and likely move
        
        W_L_Plus = (1/(2*C))*(-(-1)*((VL*C^2)/C) - 0.5 - Qn);
        W_R_Plus = (1/(2*C))*(-(-1)^2*((VL*C^2)/C) - 0.5 - Qn);
        W_L_Minus = (1/(2*C))*(+(-1)*((VL*C^2)/C) - 0.5 + Qn);
        W_R_Minus = (1/(2*C))*(+(-1)^2*((VL*C^2)/C) - 0.5 + Qn);
        
        
        Gamma_L_Plus = (1/R_L)*W_L_Plus*((1-exp(-W_L_Plus/T)).^-1);
        Gamma_R_Plus = (1/R_R)*W_R_Plus*((1-exp(-W_R_Plus/T)).^-1);
        Gamma_L_Minus = (1/R_L)*W_L_Minus*((1-exp(-W_L_Minus/T)).^-1);
        Gamma_R_Minus = (1/R_R)*W_R_Minus*((1-exp(-W_R_Minus/T)).^-1);
        
        SumPropabilities = Gamma_R_Plus + Gamma_L_Plus + Gamma_R_Minus + Gamma_L_Minus;
        if SumPropabilities > 0
            NormalizedPropability = zeros(5,1);
            NormalizedPropability(2) = Gamma_R_Plus/SumPropabilities;
            NormalizedPropability(3) = Gamma_L_Plus/SumPropabilities + NormalizedPropability(2);
            NormalizedPropability(4) = Gamma_R_Minus/SumPropabilities + NormalizedPropability(3);
            NormalizedPropability(5) = Gamma_L_Minus/SumPropabilities + NormalizedPropability(4);
            
            
            % ChoosingMove
            Dice = rand(1);
            for i = 1:4
                if Dice >=NormalizedPropability(i)
                    if Dice <= NormalizedPropability(i+1)
                        ChosenMove = i;
                    end
                end
            end
            
            if ChosenMove<=2
                n = n+1;
                Current(k) = Current(k) + (Gamma_R_Plus - Gamma_R_Minus) - (Gamma_R_Plus - Gamma_R_Minus);
            end
            if ChosenMove>=3
                n = n-1;
                Current(k) = Current(k) + (Gamma_R_Plus - Gamma_R_Minus) - (Gamma_R_Plus - Gamma_R_Minus);
            end
            
        end
        
        if k <= NumberOf_VgSweep_Tests/2
            FullVg(k) = Vg;
            Full_Potential_U(k) = U;
            
        end
        
        if k > NumberOf_VgSweep_Tests/2
            FullVg_2(k-NumberOf_VgSweep_Tests/2) = Vg;
            Full_Potential_U_2(k-NumberOf_VgSweep_Tests/2) = U;

        end
        
        
        
    end
    
    Qn
    SumPropabilities = 1;
    if k <= NumberOf_VgSweep_Tests/2
        plot(FullVg,Full_Potential_U,'-bs')
    end
    if k > NumberOf_VgSweep_Tests/2
        plot(FullVg,Full_Potential_U,'-bs')
        hold on
        plot(FullVg_2,Full_Potential_U_2,'-gs')
        hold off
    end
    title(['Potential en electrode with ' num2str(n) ' charges on the dot']);
    getframe(gcf);
    
end


