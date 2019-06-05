function[Ix_front,Ix_back,Iy_up,Iy_down] = TwoD_Gather_Flow_Data(Ix_front,Ix_back,Iy_up,Iy_down,ChosenStep,EnergyDifference,IndexOfRemovedCharge,NumberOfDots)

%% Front Steps + Draining Steps
%(MoveNumber= 1:NumberOfDots^2)
if ChosenStep >= 1
    if ChosenStep <= NumberOfDots^2
        Ix_front(IndexOfRemovedCharge(1,ChosenStep),IndexOfRemovedCharge(2,ChosenStep)) = Ix_front(IndexOfRemovedCharge(1,ChosenStep),IndexOfRemovedCharge(2,ChosenStep)) + EnergyDifference;
    end
    
    % NextMoveArray(:,:,ChosenStep)
    
    %% Back Steps
    %(MoveNumber= NumberOfDots^2+1 : 2*NumberOfDots^2 - NumberOfDots)
    if ChosenStep >= NumberOfDots^2 +1
        if ChosenStep <= 2*NumberOfDots^2 - NumberOfDots
            Ix_back(IndexOfRemovedCharge(1,ChosenStep),IndexOfRemovedCharge(2,ChosenStep)) = Ix_back(IndexOfRemovedCharge(1,ChosenStep),IndexOfRemovedCharge(2,ChosenStep)) - EnergyDifference;
        end
    end
    
    
    %% Up Steps
    %(MoveNumber= 2*NumberOfDots^2 - NumberOfDots + 1 : 3*NumberOfDots^2 - 2*NumberOfDots)
    if ChosenStep  >= 2*NumberOfDots^2 - NumberOfDots + 1
        if ChosenStep  <= 3*NumberOfDots^2 - 2*NumberOfDots
            Iy_up(IndexOfRemovedCharge(1,ChosenStep),IndexOfRemovedCharge(2,ChosenStep)) = Iy_up(IndexOfRemovedCharge(1,ChosenStep),IndexOfRemovedCharge(2,ChosenStep)) + EnergyDifference;
        end
    end
    
    
    %% Down Steps
    %(MoveNumber= 3*NumberOfDots^2 - 2*NumberOfDots + 1 : 4*NumberOfDots^2 - 3*NumberOfDots)
    if ChosenStep  >= 3*NumberOfDots^2 - 2*NumberOfDots + 1
        if ChosenStep  <= 4*NumberOfDots^2 - 3*NumberOfDots
            Iy_down(IndexOfRemovedCharge(1,ChosenStep),IndexOfRemovedCharge(2,ChosenStep)) = Iy_down(IndexOfRemovedCharge(1,ChosenStep),IndexOfRemovedCharge(2,ChosenStep)) - EnergyDifference;
        end
    end
end
