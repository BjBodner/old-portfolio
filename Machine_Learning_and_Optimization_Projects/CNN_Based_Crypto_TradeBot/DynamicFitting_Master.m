clear
UseDB1=  0;
if UseDB1 == 1
Db = open('BitcoinData_12_29.mat')

Total_y = Db.BTC_USD;
TotleTime = Db.DateTime_Number_Vector;
%plot(TotleTime(72:180),Total_y(72:180))
M(:,1) = TotleTime(72:180);
M(:,2) = Total_y(72:180);
end


UseDB2=  1;
if UseDB2 == 1
a = load('BitcoinData_1_1.mat');
Price = a.BTC_USD;
Time = a.DateTime_Number_Vector;

plot(Time,Price)

%% smoothing ou data

for l = 1:2
for k = 1:5
for smoothing = 1:10
for i = 1+k:length(Price)-k
    if abs(Price(i)-Price(i-k)) > 5*abs(Price(i-k)-Price(i+k))
    Price(i) = (Price(i+k) + Price(i-k))/2;
    end
end
end
plot(Time,Price)
getframe(gcf)
end
end
end


M(:,1) = Time;
M(:,2) = Price;

LengthOfSection = 30;
JumpAtEachItteration = 1;

q = 1;
LengthOfSection = 10;
LengthOfSection2 = 20;
LengthOfSection3 = 30;
LengthOfSection4 = 40;
LengthOfSection5 = 50;

JumpAtEachItteration = 1;
LengthOfPrediction = 10; %% measured in data points

TimeForwardFactor = 0.5;
InitialIndex = 1;
FinalIndex = InitialIndex + LengthOfSection;
InitialIndex2 = 1;
FinalIndex2 = InitialIndex2 + LengthOfSection2;
InitialIndex3 = 1;
FinalIndex3 = InitialIndex3 + LengthOfSection3;
InitialIndex4 = 1;
FinalIndex4 = InitialIndex4 + LengthOfSection4;
InitialIndex5 = 1;
FinalIndex5 = InitialIndex5 + LengthOfSection5;



Full_TrueY = zeros(10^5,1);
Full_TrueTime= zeros(10^5,1);
PredictionsYVector= zeros(10^5,1);
PredictionsTimeVector= zeros(10^5,1);

for itteration = LengthOfSection + 1:length(M(:,1))
    CurrentIndex = itteration
    % itteration
    
    Z = zeros(1,1,1);
    
    if CurrentIndex > LengthOfSection
        FinalIndex = CurrentIndex;
        InitialIndex = FinalIndex - LengthOfSection;
        Time = M(InitialIndex:FinalIndex,1);
        y = M(InitialIndex:FinalIndex,2);
        [Extended_Time,WeightedPrediction,ConfidenceIn_Fit,Calculated_Y2,x1,y1,z1,FitPrediction] = FittingFunction(TimeForwardFactor,y,Time,LengthOfPrediction);
        Z = zeros(length(z1(:,1)),length(z1(1,:)),5);
        FullFitPrediction = zeros(length(z1(:,1)),length(z1(1,:)),5,5);
        
        Z(:,:,1) = z1;
        FullFitPrediction(:,:,:,1) = FitPrediction;
        %Fit_Prediction(:,1:length(Calculated_Y2(1,:)),1) = Calculated_Y2;
        %Fit_Prediction(:,length(Calculated_Y2(1,:))+1,1) = WeightedPrediction;
        % InitialIndex = InitialIndex + JumpAtEachItteration;
        % FinalIndex = InitialIndex + LengthOfSection;
    end
    
    if CurrentIndex > LengthOfSection2
        FinalIndex = CurrentIndex;
        InitialIndex2 = FinalIndex - LengthOfSection2;
        Time = M(InitialIndex2:FinalIndex,1);
        y = M(InitialIndex2:FinalIndex,2);
        [Extended_Time,WeightedPrediction,ConfidenceIn_Fit,Calculated_Y2,x1,y1,z2,FitPrediction] = FittingFunction(TimeForwardFactor,y,Time,LengthOfPrediction);
        Z(:,:,2) = z2;
        FullFitPrediction(:,:,:,2) = FitPrediction;
        % Fit_Prediction(:,1:length(Calculated_Y2(1,:)),2) = Calculated_Y2;
        % Fit_Prediction(:,length(Calculated_Y2(1,:))+1,2) = WeightedPrediction;
        % InitialIndex2 = InitialIndex2 + JumpAtEachItteration;
        % FinalIndex2 = InitialIndex2 + LengthOfSection2;
    end
    
    if CurrentIndex > LengthOfSection3
        FinalIndex = CurrentIndex;
        InitialIndex3 = FinalIndex - LengthOfSection3;
        Time = M(InitialIndex3:FinalIndex,1);
        y = M(InitialIndex3:FinalIndex,2);
        [Extended_Time,WeightedPrediction,ConfidenceIn_Fit,Calculated_Y2,x1,y1,z3,FitPrediction] = FittingFunction(TimeForwardFactor,y,Time,LengthOfPrediction);
        Z(:,:,3) = z3;
        FullFitPrediction(:,:,:,3) = FitPrediction;
        % Fit_Prediction(:,1:length(Calculated_Y2(1,:)),3) = Calculated_Y2;
        % Fit_Prediction(:,length(Calculated_Y2(1,:))+1,3) = WeightedPrediction;
        % InitialIndex3 = InitialIndex3 + JumpAtEachItteration;
        % FinalIndex3 = InitialIndex3 + LengthOfSection3;
    end
    
    if CurrentIndex > LengthOfSection4
        FinalIndex = CurrentIndex;
        InitialIndex4 = FinalIndex - LengthOfSection4;
        Time = M(InitialIndex4:FinalIndex,1);
        y = M(InitialIndex4:FinalIndex,2);
        [Extended_Time,WeightedPrediction,ConfidenceIn_Fit,Calculated_Y2,x1,y1,z4,FitPrediction] = FittingFunction(TimeForwardFactor,y,Time,LengthOfPrediction);
        Z(:,:,4) = z4;
        FullFitPrediction(:,:,:,4) = FitPrediction;
        % Fit_Prediction(:,1:length(Calculated_Y2(1,:)),4) = Calculated_Y2;
        % Fit_Prediction(:,length(Calculated_Y2(1,:))+1,4) = WeightedPrediction;
        %  InitialIndex2 = InitialIndex4 + JumpAtEachItteration;
        %  FinalIndex2 = InitialIndex4 + LengthOfSection4;
    end
    
    if CurrentIndex > LengthOfSection5
        FinalIndex = CurrentIndex;
        InitialIndex5 = FinalIndex - LengthOfSection5;
        Time = M(InitialIndex5:FinalIndex,1);
        y = M(InitialIndex5:FinalIndex,2);
        [Extended_Time,WeightedPrediction,ConfidenceIn_Fit,Calculated_Y2,x1,y1,z5,FitPrediction] = FittingFunction(TimeForwardFactor,y,Time,LengthOfPrediction);
        Z(:,:,5) = z5;
        FullFitPrediction(:,:,:,5) = FitPrediction;

    end
    

        Discount = 0.95;
    for j = 1:5
        for i = 1:length(Z(1,:,1))
            if sum(Z(:,i,j)) ~= 0
                Z(:,i,j) = (Z(:,i,j)/max(Z(:,i,j)))*Discount^i;
            end
        end
    end
    %% Summing all predictions
    a = permute(Z,[3 1 2]);
    Z_ = sum(a);
    z1 = permute(Z_,[2 3 1]);
    
    % Creating Realtime weights
    if itteration > LengthOfSection + 3
        for i = 1:5
            if Accuracy_Of_Fit_Sum(i) > 0.1
            Z(:,:,i) = Z(:,:,i)*Accuracy_Of_Fit_Sum(i);
            end
        end
        a = permute(Z,[3 1 2]);
        Z_ = sum(a);
        z1 = permute(Z_,[2 3 1]);
    end
    
    
    if itteration  == LengthOfSection + 1
    FuturePredictionWeights = ones(min(size(x1)),1);
    end
    %normalizing predictions and multiplying by future prediction weights
    
    for i = 1:length(z1(1,:))
        z1(:,i) = (z1(:,i)/sum(z1(:,i)))*FuturePredictionWeights(i);
    end
    
    
    
    if itteration == LengthOfSection + 1
        Full_TrueTime = Time;
        Full_TrueY = y;
        Old_Z1 = z1;
        Old_Y1 = y1;
        Old_X1 = x1;
    end
    if itteration ~= LengthOfSection + 1

        [~,I] = min(abs(Full_TrueTime - min(Time)));
        Full_TrueTime(I+1:I + length(Time)) = Time;
        Full_TrueY(I+1:I + length(y)) = y;
        
        Full_Z = zeros(length(Old_Z1(:,1)),length(Old_Z1(1,:))+1);
        Full_Z(:,1:length(Old_Z1(1,:)))= Old_Z1;
        Full_Z(:,q:length(Old_Z1(1,:))+1) = Full_Z(:,q:length(Old_Z1(1,:))+1) + z1;
        Old_Z1 = Full_Z;
        
        Full_X = zeros(length(Old_X1(:,1)),length(Old_X1(1,:))+1);
        Full_X(:,1:length(Old_X1(1,:)))= Old_X1;
        Full_X(:,length(Old_X1(1,:))+1) = x1(:,length(x1(1,:)));
        Old_X1 = Full_X;
        
        Full_Y = zeros(length(Old_Y1(:,1)),length(Old_Y1(1,:))+1);
        Full_Y(:,1:length(Old_Y1(1,:)))= Old_Y1;
        Full_Y(:,length(Old_Y1(1,:))+1) = y1(:,length(y1(1,:)));
        Old_Y1 = Full_Y;
        
    end
    
    plot(Full_TrueTime(max(1,itteration-50):itteration),Full_TrueY(max(1,itteration-50):itteration),'-ks','LineWidth',6)
    if sum(sum(z1)) ~= 0
        if itteration > LengthOfSection + 3
        hold on
       % s = surf(x1,y1,z1);
        
           % s = surf(x1,y1,z1*TotalAccuracy);
        s = surf(Full_X(:,max(1,itteration-50):itteration),Full_Y(:,max(1,itteration-50):itteration),Full_Z(:,max(1,itteration-50):itteration));
        s.EdgeColor = 'none';
        s.FaceAlpha = 0.5;
        s.FaceColor =  'interp';
        ylim([(min(Full_TrueY(max(1,itteration-50):itteration))-50) max(Full_TrueY(max(1,itteration-50):itteration)+50)])
        %  plot(PredictionsTimeVector,PredictionsYVector,'-gs')
        hold off
        end
    end
    
    title('Predicted Price Of Bitcoin')
    if itteration > LengthOfSection + 3
        title(['Predicted Price Of Bitcoin, with an accuracy of:  ' num2str(TotalAccuracy*100) ' percent for predictions 30 sec ahead'])
    end
    xlim([min(Full_TrueTime) max(Extended_Time)])
    f = getframe(gcf);
    
    UseDynamicAccuracy = 1;
    if UseDynamicAccuracy == 1
        
        %% Make the z divided by the sum,
        % then when measuring accuracy, sum of the actual price, ancluding
        % up or down 2 bitcoin, this will give a larger propability.
        
        %% also make the sum continuous so that i some over old predictions as well,
        % this will automatically take into consideration the larger
        % strength of long term predictions
        
        if itteration > LengthOfSection + 2
            %% Measuring Accuracy of prediction
            % Total accuracy
            [~,I] = min(abs(y(length(y)) - y1(:,2)));
            TotalAccuracy = previous_z1(I,2);
            % combination of fits accuracy
            Accuracy_Of_Fit_Sum = zeros(1,5);
            for i = 1:5
                %[I,I] = min(abs(y(length(y)) - previous_Z(2,:,i)));
                Accuracy_Of_Fit_Sum(1,i) = previous_Z(I,2,i);
            end
            % Single Fit accuracy
            Accuracy_Of_Single_Fit_Prediction = zeros(5,5);
            for i = 1:5 % Number of fiting algorithm inside a time sequence
                for j = 1:5 % Number of time sequence
                    if sum(FullFitPrediction(:,2,i,j)) ~= 0
                        %[Accuracy_Of_Single_Fit_Prediction(i,j),I] = min(abs(y(length(y)) - Fit_Prediction(2,i,j)));
                        Accuracy_Of_Single_Fit_Prediction(i,j) = FullFitPrediction(I,2,i,j);
                    end
                end
            end
            
            
            %% Add in longer term predictions for example predictions up to the length of the prediction back
            % thats a total of 6 predictions
            % the further back the prediction the bigger the influence
            % do this by multiplying by a factor of 1.5^i
            
            TotalAccuracy
            Accuracy_Of_Fit_Sum
            pause(1)
        end
    end
    
    previous_z1 = z1;
    previous_Z = Z;
    q = q+1
end