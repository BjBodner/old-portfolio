function [NextMoveArray,IndexOfRemovedCharge,TransitionProbabilityVector] = TwoD_NextMoveArray_Generator(NumberOfDots,SizeAndDisorder_parameters)

TransitionProbabilityVector = SizeAndDisorder_parameters.TransitionDisorder;
%% Creating Next Step "Slides"
       % TotalNumberOFMoves = 4*NumberOfDots^2 - 2*NumberOfDots;
	%	NextMoveArray = zeros(NumberOfDots,NumberOfDots,TotalNumberOFMoves);
    
    % Not including Back Draining
       % TotalNumberOFMoves = 4*NumberOfDots(1)*NumberOfDots(2) - 2*NumberOfDots(1);
        
     % Including Back Draining
   %  TotalNumberOFMoves = 4*NumberOfDots(1)*NumberOfDots(2) + NumberOfDots(2) -2*NumberOfDots(1);
     TotalNumberOFMoves = 6*NumberOfDots(1)*NumberOfDots(2) + NumberOfDots(2) -2*NumberOfDots(1);
     NextMoveArray = zeros(NumberOfDots(1),NumberOfDots(2),TotalNumberOFMoves);
     MoveNumber = 1;
     IndexOfRemovedCharge = zeros(2,TotalNumberOFMoves);
        
        
		%% Front Steps 
        %(MoveNumber= 1:NumberOfDots(1)*NumberOfDots(2) - NumberOfDots(2))
        
        %for i = 1:NumberOfDots-1
        %    for j = 1:NumberOfDots
        for i = 1:NumberOfDots(1)-1
            for j = 1:NumberOfDots(2)
                NextMoveArray(i+1,j,MoveNumber) = 1;
                NextMoveArray(i,j,MoveNumber) = -1;  
                IndexOfRemovedCharge(1,MoveNumber) = i;
                IndexOfRemovedCharge(2,MoveNumber) = j;   
                %% New Indexes
                              %  IndexOfRemovedCharge(1,MoveNumber) = i;
                               % IndexOfRemovedCharge(2,MoveNumber) = j;   
                MoveNumber = MoveNumber +1;
            end
        end

        %% Draining Moves
        %(MoveNumber= NumberOfDots(1)*NumberOfDots(2) - NumberOfDots(2)+1 : NumberOfDots(1)*NumberOfDots(2))
        

            
     for j = 1:NumberOfDots(2)
         NextMoveArray(NumberOfDots(1),j,MoveNumber) = -1;
         IndexOfRemovedCharge(1,MoveNumber) = NumberOfDots(1);
         IndexOfRemovedCharge(2,MoveNumber) = j;
         %     IndexOfRemovedCharge(1,MoveNumber) = i;
         %    IndexOfRemovedCharge(2,MoveNumber) = j;
         MoveNumber = MoveNumber +1;
     end
            
            
		%% Back Steps 
        %(MoveNumber= NumberOfDots(1)*NumberOfDots(2)+1 : 2*NumberOfDots(1)*NumberOfDots(2) - NumberOfDots(2))
        
    %    for i = 1:NumberOfDots-1
    %        for j = 1:NumberOfDots
    for i = 1:NumberOfDots(1)-1
        for j = 1:NumberOfDots(2)
            NextMoveArray(i,j,MoveNumber) = 1;
            NextMoveArray(i+1,j,MoveNumber) = -1;
            IndexOfRemovedCharge(1,MoveNumber) = i+1;
            IndexOfRemovedCharge(2,MoveNumber) = j;
            %    IndexOfRemovedCharge(1,MoveNumber) = i;
            %IndexOfRemovedCharge(2,MoveNumber) = j;
            MoveNumber = MoveNumber +1;
        end
    end
        
        

		%% Up Steps 
        %(MoveNumber= 2*NumberOfDots(1)*NumberOfDots(2) - NumberOfDots(2) + 1 : 3*NumberOfDots(1)*NumberOfDots(2) - NumberOfDots(2)-NumberOfDots(1))

       for i = 1:NumberOfDots(1)
           for j = 1:NumberOfDots(2)-1
               NextMoveArray(i,j+1,MoveNumber) = 1;
               NextMoveArray(i,j,MoveNumber) = -1;
               %IndexOfRemovedCharge(1,MoveNumber) = i;
               % IndexOfRemovedCharge(2,MoveNumber) = j+1;
               
               %New Indexes
               IndexOfRemovedCharge(1,MoveNumber) = i;
               IndexOfRemovedCharge(2,MoveNumber) = j;
               MoveNumber = MoveNumber +1;
           end
       end
        

		%% Down Steps 
        %(MoveNumber= 3*NumberOfDots(1)*NumberOfDots(2) - NumberOfDots(2)-NumberOfDots(1) + 1 : 4*NumberOfDots(1)*NumberOfDots(2) - NumberOfDots(2)-2*NumberOfDots(1)
      %  for i = 1:NumberOfDots
      %      for j = 1:NumberOfDots-1
      for i = 1:NumberOfDots(1)
          for j = 1:NumberOfDots(2)-1
              NextMoveArray(i,j+1,MoveNumber) = -1;
              NextMoveArray(i,j,MoveNumber) = 1;
              IndexOfRemovedCharge(1,MoveNumber) = i;
              IndexOfRemovedCharge(2,MoveNumber) = j+1;
              
              % New Down Steps
              IndexOfRemovedCharge(1,MoveNumber) = i;
              IndexOfRemovedCharge(2,MoveNumber) = j;
              MoveNumber = MoveNumber +1;
          end
      end
        

        
		%% Charging Steps 
        %(MoveNumber= 4*NumberOfDots(1)*NumberOfDots(2) - NumberOfDots(2)-2*NumberOfDots(1) + 1 : 4*NumberOfDots(1)*NumberOfDots(2) -2*NumberOfDots(1))
      %  for j = 1:NumberOfDots
      for j = 1:NumberOfDots(2)
          NextMoveArray(1,j,MoveNumber) = 1;
          MoveNumber = MoveNumber +1;
          IndexOfRemovedCharge(1,MoveNumber) = 1;
          IndexOfRemovedCharge(2,MoveNumber) = j;
          %                                IndexOfRemovedCharge(1,MoveNumber) = i;
          %                IndexOfRemovedCharge(2,MoveNumber) = j;
      end
        
        
        		%% Back Draining Steps 
        %(MoveNumber= 4*NumberOfDots(1)*NumberOfDots(2) -2*NumberOfDots(1) + 1 : 4*NumberOfDots(1)*NumberOfDots(2) + NumberOfDots(2) -2*NumberOfDots(1))
      %  for j = 1:NumberOfDots
      for j = 1:NumberOfDots(2)
          NextMoveArray(1,j,MoveNumber) = -1;
          MoveNumber = MoveNumber +1;
          IndexOfRemovedCharge(1,MoveNumber) = 1;
          IndexOfRemovedCharge(2,MoveNumber) = j;
          %                                IndexOfRemovedCharge(1,MoveNumber) = i;
          %                IndexOfRemovedCharge(2,MoveNumber) = j;
      end
        
        
%% Gate Draining Moves
%MoveNumber= (4*NumberOfDots(1)*NumberOfDots(2) + NumberOfDots(2) -2*NumberOfDots(1))+1:5*NumberOfDots(1)*NumberOfDots(2) + NumberOfDots(2) -2*NumberOfDots(1)
for i = 1:NumberOfDots(1)
      for j = 1:NumberOfDots(2)
          NextMoveArray(i,j,MoveNumber) = -1;
          MoveNumber = MoveNumber +1;
          IndexOfRemovedCharge(1,MoveNumber) = i;
          IndexOfRemovedCharge(2,MoveNumber) = j;
      end
end
%% Gate Charging Moves
%MoveNumber= 5*NumberOfDots(1)*NumberOfDots(2) + NumberOfDots(2) -2*NumberOfDots(1))+1:6*NumberOfDots(1)*NumberOfDots(2) + NumberOfDots(2) -2*NumberOfDots(1))
for i = 1:NumberOfDots(1)
      for j = 1:NumberOfDots(2)
          NextMoveArray(i,j,MoveNumber) = 1;
          MoveNumber = MoveNumber +1;
          IndexOfRemovedCharge(1,MoveNumber) = i;
          IndexOfRemovedCharge(2,MoveNumber) = j;
      end
end



     %% Right Lead Charging Moves
        %(MoveNumber= 6*NumberOfDots(1)*NumberOfDots(2) + NumberOfDots(2) -2*NumberOfDots(1))+1 : 6*NumberOfDots(1)*NumberOfDots(2) + 2*NumberOfDots(2) -2*NumberOfDots(1))

     for j = 1:NumberOfDots(2)
         NextMoveArray(NumberOfDots(1),j,MoveNumber) = 1;
         IndexOfRemovedCharge(1,MoveNumber) = NumberOfDots(1);
         IndexOfRemovedCharge(2,MoveNumber) = j;
         %     IndexOfRemovedCharge(1,MoveNumber) = i;
         %    IndexOfRemovedCharge(2,MoveNumber) = j;
         MoveNumber = MoveNumber +1;
     end

%% Making the Transitions rates inside the aray symmetric
for i = 1:4*NumberOfDots(1)*NumberOfDots(2) + NumberOfDots(2) -2*NumberOfDots(1)
    % these two loops fill in the middle movements without charging and
    % discharging
    %% Making sure that the transition amplitude is symmetric
    for j = 1:4*NumberOfDots(1)*NumberOfDots(2) + NumberOfDots(2) -2*NumberOfDots(1)
        % this means that if the moves are opposite to one another
        if sum(sum ( NextMoveArray(:,:,i) == -NextMoveArray(:,:,j))) == NumberOfDots(1)*NumberOfDots(2)
            TransitionProbabilityVector(j) = TransitionProbabilityVector(i);
        end
    end
    for j = 6*NumberOfDots(1)*NumberOfDots(2) + NumberOfDots(2) -2*NumberOfDots(1)+1 : 6*NumberOfDots(1)*NumberOfDots(2) + 2*NumberOfDots(2) -2*NumberOfDots(1)
                if sum(sum ( NextMoveArray(:,:,i) == -NextMoveArray(:,:,j))) == NumberOfDots(1)*NumberOfDots(2)
            TransitionProbabilityVector(j) = TransitionProbabilityVector(i);
                end
    end
end

%% Making the Transitions rates with the gate and the aray symmetric
for i = 4*NumberOfDots(1)*NumberOfDots(2) + NumberOfDots(2) -2*NumberOfDots(1) + 1:6*NumberOfDots(1)*NumberOfDots(2) + NumberOfDots(2) -2*NumberOfDots(1)
    %% Making sure that the transition amplitude is symmetric
    for j = 4*NumberOfDots(1)*NumberOfDots(2) + NumberOfDots(2) -2*NumberOfDots(1) + 1:6*NumberOfDots(1)*NumberOfDots(2) + NumberOfDots(2) -2*NumberOfDots(1)
        % this means that if the moves are opposite to one another
        if sum(sum ( NextMoveArray(:,:,i) == -NextMoveArray(:,:,j))) == NumberOfDots(1)*NumberOfDots(2)
            TransitionProbabilityVector(j) = TransitionProbabilityVector(i);
        end
    end
end


% discharging moves
%TransitionProbabilityVector = TransitionProbabilityVector + (TransitionProbabilityVector == 0).*(1 + StandardDeviationOfTransitionProbability*(rand(size(TransitionProbabilityVector)) - 0.5));

%TransitionProbabilityVector = (TransitionProbabilityVector > 0).*TransitionProbabilityVector;
%a = 1;
end
