function [invCM,CM] = TwoD_Create_Selected_invCM(C,Cg,NumberOfDots,Regular_Round_Matrix,Eliptical1_Long_in_X_Direction_Matrix,Eliptical1_Long_in_Y_Direction_Matrix,Oscilating_Lines_and_Rows,Oscliating_Rows_Only,SideWays_Matrix,Increasing_Screeninglength_Matrix,Decreasing_Screeninglength_Matrix,Y_Gradient_10timeIncrease_Matrix,X2_Increasing_Screeninglength_Matrix,SizeAndDisorder_parameters)




Cg_Disorder = SizeAndDisorder_parameters.Cg_Disorder;
C_Disorder = SizeAndDisorder_parameters.C_Disorder;

    %% Regular invCM - Round Influence
    if Regular_Round_Matrix == 1
     [invCM,CM] = TwoDim_invCM_Generator(C,Cg,NumberOfDots);
    end
    
    %% Different Lines invCM
        if Oscliating_Rows_Only == 1
    [invCM,CM] = TwoDim_Special_invCM_Generator1(C,Cg,NumberOfDots);
        end
    
    %% Oscilating Left Right invCm
        if Oscilating_Lines_and_Rows == 1
     [invCM,CM] = TwoDim_Special_invCM_Generator2(C,Cg,NumberOfDots);
        end
    
    %% Eliptic 1 invCM - long in x direction
        if Eliptical1_Long_in_X_Direction_Matrix == 1
      [invCM,CM] = TwoDim_Special_invCM_Generator3(C,Cg,NumberOfDots);
        end
    
    %% Eliptic 2 invCM - long in y direction
        if Eliptical1_Long_in_Y_Direction_Matrix == 1
    [invCM,CM] = TwoDim_Special_invCM_Generator4(C,Cg,NumberOfDots);
        end
        
    %% Sideways invCM - long in y direction        
        if SideWays_Matrix == 1
            [invCM,CM] = TwoDim_Special_invCM_Generator5(C,Cg,NumberOfDots);
        end
        
    %% Increasing Screening length invCM      
        if Increasing_Screeninglength_Matrix == 1
            [invCM,CM] = TwoDim_Special_invCM_Generator6(C,Cg,NumberOfDots);
        end
        
   %% Decreasing Screening length invCM      
        if Decreasing_Screeninglength_Matrix == 1
            [invCM,CM] = TwoDim_Special_invCM_Generator7(C,Cg,NumberOfDots);
        end
        
        
        %%
        if Y_Gradient_10timeIncrease_Matrix == 1
            [invCM,CM] = TwoDim_Special_invCM_Generator9(C,Cg,NumberOfDots);
        end
        
        
        %%
        if X2_Increasing_Screeninglength_Matrix == 1
            [invCM,CM] = TwoDim_Special_invCM_Generator8(C,Cg,NumberOfDots);
        end
        
        
        
        %% adding Disorder in interDot capacitance
        %STD_of_interdot_Capacitance = 0.5; %must be between 0 and 2;
        %CM = (CM - diag(diag(CM))) + ((CM - diag(diag(CM))) ~= 0).*(rand(size(CM))-0.5)*C*STD_of_interdot_Capacitance;
        
        
        CM = (CM - diag(diag(CM))) + C*((CM - diag(diag(CM))) ~= 0).*C_Disorder;


    %    C_Disorder = (rand(size(CM))-0.5)*C*STD_of_interdot_Capacitance;
    
        %% adding disorder in Gate capacitage
       % STD_of_Gate_Capacitance = 0.5; %must be between 0 and 2;
     %   CgVector = Cg*STD_of_Gate_Capacitance*rand(NumberOfDots^2,1);

        CgVector = Cg*Cg_Disorder;
        
        %% 
       % for i = 1:NumberOfDots^2
       for i = 1:NumberOfDots(1)*NumberOfDots(2)
           CM(i,i) = -sum(CM(i,:)) + Cg + CgVector(i);
       end
        
       %for i = 1:NumberOfDots:NumberOfDots^2 - NumberOfDots + 1
       for i = 1:NumberOfDots(1):NumberOfDots(1)*NumberOfDots(2) - NumberOfDots(1) + 1
           CM(i,i) = CM(i,i) + C;
        end
       % for i = NumberOfDots:NumberOfDots:NumberOfDots^2
       for i = NumberOfDots(1):NumberOfDots(1):NumberOfDots(1)*NumberOfDots(2)
            CM(i,i) = CM(i,i) + C;
        end
        
        invCM = inv(CM);
        
        