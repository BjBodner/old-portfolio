
clear

Do_Single_Class_Classification = 0;
Do_Multi_Class_Classification = 1;


a = open('DataSetForDigitRecognition_binance.mat');
X = a.DigitVector;
Y = a.DigitLabel;

if Do_Single_Class_Classification == 1
    Y = Y == 1;
end

%% Converting Data into multiclass classification
if Do_Multi_Class_Classification == 1
    for sample = 1:length(Y)
        for i = 0:9
            Expanded_Y(i+1,sample) = Y(sample) == i;
        end
    end
    
    Y = Expanded_Y;
end

Number_Of_Epochs = 100;
Number_Of_Minibatches = 1;
NumberOfItterations_per_Minibatch = 50;
dt = 0.1;
t_Total = 2;



PlotProgress = 1;

NumberOfSamples = length(Y(1,:));
Size_Of_TrainingSet = 0.7;
Size_Of_CV = 0.15;
Size_Of_Test = 0.15;

FinalIndexOfTrainingSet = round(Size_Of_TrainingSet*NumberOfSamples);
InitialIndexOfCV = FinalIndexOfTrainingSet+1;
FinalIndexOfCV = InitialIndexOfCV + round(Size_Of_CV*NumberOfSamples);
InitialIndexOf_Test = FinalIndexOfCV+1;
FinalIndexOf_Test = NumberOfSamples;

MiniBatch_Index(1,1) = 1;
for minibatch = 1:Number_Of_Minibatches
    if minibatch == 1
        MiniBatch_Index(minibatch,2) = round(FinalIndexOfTrainingSet/10);
    end
    if minibatch ~= 1
        MiniBatch_Index(minibatch,1) = MiniBatch_Index(minibatch-1,2) + 1;
        MiniBatch_Index(minibatch,2) = round(minibatch*FinalIndexOfTrainingSet/10);
    end
end
X1 = X(:,MiniBatch_Index(1,1):MiniBatch_Index(1,2));
Y1 = Y(:,MiniBatch_Index(1,1):MiniBatch_Index(1,2));

Ntot = t_Total/dt + 1;
CostFunction_track = zeros(1,NumberOfItterations_per_Minibatch*Number_Of_Minibatches*Number_Of_Epochs);
CostFunction = zeros(Ntot,1);



% initialize Weights and biases
[W1_prev,W2_prev,W3_prev,b1_prev,b2_prev,b3_prev] = Generate_Random_Vectors(X1,Y1);


b1 = zeros([size(b1_prev),Ntot]);
b2 = zeros([size(b2_prev),Ntot]);
b3 = zeros([size(b3_prev),Ntot]);
W1 = zeros([size(W1_prev),Ntot]);
W2 = zeros([size(W2_prev),Ntot]);
W3 = zeros([size(W3_prev),Ntot]);

tic
for epoc = 1:Number_Of_Epochs
    for minibatch = 1:Number_Of_Minibatches
        X1 = X(:,MiniBatch_Index(minibatch ,1):MiniBatch_Index(minibatch ,2));
        Y1 = Y(:,MiniBatch_Index(minibatch ,1):MiniBatch_Index(minibatch ,2));
        for itteration = 1:NumberOfItterations_per_Minibatch
            
            [RandomVector_W1,RandomVector_W2,RandomVector_W3,RandomVector_b1,RandomVector_b2,RandomVector_b3] = Generate_Random_Vectors(X1,Y1);
            n = 1;
            %% Random Vector Optimization;
            for t = 0:dt:t_Total
                % Advance Along Random Vector
                [b1(:,:,n),b2(:,:,n),b3(:,:,n),W1(:,:,n),W2(:,:,n),W3(:,:,n)] = Advance_Wb_Along_Vector(W1_prev,W2_prev,W3_prev,b1_prev,b2_prev,b3_prev,RandomVector_W1,RandomVector_W2,RandomVector_W3,RandomVector_b1,RandomVector_b2,RandomVector_b3,t);
                
                %% ForwardProp
                [A3] = ForwardProp(X1,W1(:,:,n),W2(:,:,n),W3(:,:,n),b1(:,:,n),b2(:,:,n),b3(:,:,n));
                
                %% Use Least Squares Cost Function
                %CostFunction(n) = (1/2*NumberOfSamples)*sum((A3 - Y).^2);
                
                %% Use Logistic Regression Cost Function
                CostFunction(n) = (1/2*NumberOfSamples)*sum(sum(-Y1.*log(A3) - (1-Y1).*log(1-A3)));
                n = n+1;
                
            end
            
            % Update Weights and biases
            Total_Itteration = itteration + (minibatch-1)*NumberOfItterations_per_Minibatch + (epoc-1)*NumberOfItterations_per_Minibatch*Number_Of_Minibatches;
            [CostFunction_track(Total_Itteration ),I] = min(CostFunction);
            [W1_prev,W2_prev,W3_prev,b1_prev,b2_prev,b3_prev] = Update_WB(W1,W2,W3,b1,b2,b3,I);
            
            
            
            
        end
        %% Plot Progress
        if PlotProgress == 1
            plot(nonzeros(CostFunction_track));
            s = strcat('Cost Function through optimization');
            title(s)
            xlabel('Itterations of optimizer')
            ylabel('Cost Function')
            ylim([0 1.1*max(CostFunction_track)])
            getframe(gcf);
        end
    end
end
toc

InitialIndexOfCV = FinalIndexOfTrainingSet+1;
FinalIndexOfCV = InitialIndexOfCV + round(Size_Of_CV*NumberOfSamples);
InitialIndexOf_Test = FinalIndexOfCV+1;
FinalIndexOf_Test = NumberOfSamples;

X1 = X(:,InitialIndexOfCV:FinalIndexOfCV);
Y1 = Y(:,InitialIndexOfCV:FinalIndexOfCV);
[A3] = ForwardProp(X1,W1_prev,W2_prev,W3_prev,b1_prev,b2_prev,b3_prev);
Predictions = zeros(length(Y1(:,1)),length(Y1(1,:)));
if length(Y1(:,1)) > 1
    for sample = 1:length(Y1(1,:))
        [~,I] = max(A3(:,sample));
        Predictions(I,sample) = 1;
    end
end
if length(Y1(:,1)) == 1
    Predictions = A3>0.5;
end
Percent_Error_CV = 100*sum(sum((Predictions ~= Y1))/(max(length(Y1(:,1)),2)*length(Y1(1,:))));

X1 = X(:,InitialIndexOf_Test:FinalIndexOf_Test);
Y1 = Y(:,InitialIndexOf_Test:FinalIndexOf_Test);
[A3] = ForwardProp(X1,W1_prev,W2_prev,W3_prev,b1_prev,b2_prev,b3_prev);
Predictions = zeros(length(Y1(:,1)),length(Y1(1,:)));
if length(Y1(:,1)) > 1
    for sample = 1:length(Y1(1,:))
        [~,I] = max(A3(:,sample));
        Predictions(I,sample) = 1;
    end
end
if length(Y1(:,1)) == 1
    Predictions = A3>0.5;
end
Percent_Error_test = 100*sum(sum((Predictions ~= Y1))/(max(length(Y1(:,1)),2)*length(Y1(1,:))));

X1 = X(:,1:FinalIndexOfTrainingSet);
Y1 = Y(:,1:FinalIndexOfTrainingSet);
[A3] = ForwardProp(X1,W1_prev,W2_prev,W3_prev,b1_prev,b2_prev,b3_prev);
Predictions = zeros(length(Y1(:,1)),length(Y1(1,:)));
if length(Y1(:,1)) > 1
    for sample = 1:length(Y1(1,:))
        [~,I] = max(A3(:,sample));
        Predictions(I,sample) = 1;
    end
end
if length(Y1(:,1)) == 1
    Predictions = A3>0.5;
end
Train_Error = 100*sum(sum((Predictions ~= Y1))/(max(length(Y1(:,1)),2)*length(Y1(1,:))));


plot(CostFunction_track)
s = strcat('Train Error=',num2str(Train_Error), '%, CV Error=',num2str(Percent_Error_CV),'%, Test set Error=',num2str(Percent_Error_test),'%');
title(s)
xlabel('Itterations of optimizer')
ylabel('Cost Function')
ylim([0 1.1*max(CostFunction_track)])