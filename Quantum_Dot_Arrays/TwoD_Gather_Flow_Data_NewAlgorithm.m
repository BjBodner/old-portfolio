function[Ix_front,Ix_back,Iy_up,Iy_down] = TwoD_Gather_Flow_Data_NewAlgorithm(Ix_front,Ix_back,Iy_up,Iy_down,ExcecutedMoves,EnergyDifference,IndexOfRemovedCharge,NumberOfDots)

%% Front Steps + Draining Steps
%(MoveNumber= 1:NumberOfDots(1)*NumberOfDots(2) - NumberOfDots(2))
%(MoveNumber= 1:NumberOfDots^2)
for n = 1:max(size(ExcecutedMoves))
    if ExcecutedMoves(n) >= 1
        if ExcecutedMoves(n) <= NumberOfDots(1)*NumberOfDots(2)
            Ix_front(IndexOfRemovedCharge(1,ExcecutedMoves(n)),IndexOfRemovedCharge(2,ExcecutedMoves(n))) = Ix_front(IndexOfRemovedCharge(1,ExcecutedMoves(n)),IndexOfRemovedCharge(2,ExcecutedMoves(n))) + 1;
        end
        
        
        % NextMoveArray(:,:,ChosenStep)
        
        %% Back Steps
        %(MoveNumber= NumberOfDots(1)*NumberOfDots(2)+1 : 2*NumberOfDots(1)*NumberOfDots(2) - NumberOfDots(2))

        if ExcecutedMoves(n) >= NumberOfDots(1)*NumberOfDots(2) +1
            if ExcecutedMoves(n) <= 2*NumberOfDots(1)*NumberOfDots(2)- NumberOfDots(2)
                Ix_back(IndexOfRemovedCharge(1,ExcecutedMoves(n)),IndexOfRemovedCharge(2,ExcecutedMoves(n))) = Ix_back(IndexOfRemovedCharge(1,ExcecutedMoves(n)),IndexOfRemovedCharge(2,ExcecutedMoves(n))) - 1;
            end
        end
        % Draining Moves
                %(MoveNumber= 4*NumberOfDots(1)*NumberOfDots(2) -2*NumberOfDots(1) + 1 : 4*NumberOfDots(1)*NumberOfDots(2) + NumberOfDots(2) -2*NumberOfDots(1))
        if ExcecutedMoves(n) >= 4*NumberOfDots(1)*NumberOfDots(2) -2*NumberOfDots(1) + 1
            if ExcecutedMoves(n) <= 4*NumberOfDots(1)*NumberOfDots(2) + NumberOfDots(2) -2*NumberOfDots(1)
                Ix_back(IndexOfRemovedCharge(1,ExcecutedMoves(n)),IndexOfRemovedCharge(2,ExcecutedMoves(n))) = Ix_back(IndexOfRemovedCharge(1,ExcecutedMoves(n)),IndexOfRemovedCharge(2,ExcecutedMoves(n))) - 1;
            end
        end
        %% Up Steps
        %(MoveNumber= 2*NumberOfDots(1)*NumberOfDots(2) - NumberOfDots(2) + 1 : 3*NumberOfDots(1)*NumberOfDots(2) - NumberOfDots(2)-NumberOfDots(1))
        if ExcecutedMoves(n)  >= 2*NumberOfDots(1)*NumberOfDots(2) - NumberOfDots(2) + 1
            if ExcecutedMoves(n)  <= 3*NumberOfDots(1)*NumberOfDots(2) - NumberOfDots(2)-NumberOfDots(1)
                Iy_up(IndexOfRemovedCharge(1,ExcecutedMoves(n)),IndexOfRemovedCharge(2,ExcecutedMoves(n))) = Iy_up(IndexOfRemovedCharge(1,ExcecutedMoves(n)),IndexOfRemovedCharge(2,ExcecutedMoves(n))) + 1;
            end
        end
        
        
        %% Down Steps
        %(MoveNumber= 3*NumberOfDots(1)*NumberOfDots(2) - NumberOfDots(2)-NumberOfDots(1) + 1 : 4*NumberOfDots(1)*NumberOfDots(2) - NumberOfDots(2)-2*NumberOfDots(1)
        if ExcecutedMoves(n)  >= 3*NumberOfDots(1)*NumberOfDots(2) - NumberOfDots(2)-NumberOfDots(1) + 1
            if ExcecutedMoves(n)  <= 4*NumberOfDots(1)*NumberOfDots(2) - NumberOfDots(2)-2*NumberOfDots(1)
                if IndexOfRemovedCharge(1,ExcecutedMoves(n)) ~= 0
                Iy_down(IndexOfRemovedCharge(1,ExcecutedMoves(n)),IndexOfRemovedCharge(2,ExcecutedMoves(n))+1) = Iy_down(IndexOfRemovedCharge(1,ExcecutedMoves(n)),IndexOfRemovedCharge(2,ExcecutedMoves(n))+1) - 1;
                end
            end
        end
    end
end
