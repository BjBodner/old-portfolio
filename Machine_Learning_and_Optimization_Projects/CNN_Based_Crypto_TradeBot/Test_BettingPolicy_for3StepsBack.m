function [FullUSDGain,FullBitcoinChange,ChosenAction,CurrentStateNumber,p1,ActionProbabilities,OldActionProbabilities,NumberOfSpendableBitcoin,TotalGain,Reenforce_Policy] = Test_BettingPolicy_for3StepsBack(Price,Time,ActionProbabilities,Length_Of_Policy_Trial,FullUSDGain,FullBitcoinChange,ChosenAction,CurrentStateNumber,p1,OldActionProbabilities,NumberOfSpendableBitcoin,TotalGain,Reenforce_Policy)



%a = open('BettingPolicy_a_3_1.mat')

%BettingPolicy_b_3_1 works with reenforcement every 15
%BettingPolicy_a_3_1 works with reenforcement every 30

%ActionProbabilities = a.BestActionProbabilities

UseOldParameters = 1;
%if UseOldParameters == 0
%BTC_SpendingPenalty_Factor = a.Best_BTC_SpendingPenalty_Factor;
%USD_GainReward_Factor = a.Best_USD_GainReward_Factor;
%end
if UseOldParameters == 1
    BTC_SpendingPenalty_Factor = 10; %% this parameter can be optimized with TGA
    USD_GainReward_Factor = 1/600; %% this parameter can be optimized with TGA
end

%for i = 1:81
%    if max(ActionProbabilities(i,:)) <0.5
%        ActionProbabilities(i,2) = 1;
%        ActionProbabilities(i,1) = 0;
%        ActionProbabilities(i,3) = 0;
%    end
%end

%FullUSDGain = zeros(10,1);
%FullBitcoinChange = zeros(10,1);




%for TrainingRun = 1:NumberOfTrainingRuns
%% 4 step back RL


    for k = 1:3
        for j = 1:3
            for i = 1:3
                StateSpace(i + 3*(j-1) + 9*(k-1) ,:) = [(i-2) (j-2) (k-2)];
            end
        end
    end


%if TrainingRun == 1
%ActionProbabilities = (1/3)*ones(81,3);
%end
%OldActionProbabilities = ActionProbabilities;
%NumberOfSpendableBitcoin = 10*10^-3;
%Length_Of_Policy_Trial = 30;
%ChosenAction = zeros(Length_Of_Policy_Trial,1);
%CurrentStateNumber = zeros(Length_Of_Policy_Trial,1);

%TotalGain = 0;


%p = 1;

Actions = [-1 0 1];
itteration = length(Price);
%  for itteration = 1:length(Price)
if itteration>=5
    CurrentPastFourPrices = [Price(itteration) Price(itteration-1) Price(itteration-2) ];
    PreviousPastFourPrices = [Price(itteration-1) Price(itteration-2) Price(itteration-3) ];
    PastFourPriceChange = CurrentPastFourPrices - PreviousPastFourPrices;
    CurrentState = sign(PastFourPriceChange);
    [~,CurrentStateNumber(p1)] = max(sum((StateSpace == CurrentState).'));
    
    ActionProbabilities_InSequence(:,:) = ActionProbabilities(:,:);
    for i = 2:3
        ActionProbabilities_InSequence(:,i) = ActionProbabilities_InSequence(:,i) + ActionProbabilities_InSequence(:,i-1);
    end
    
    DiceRoll= rand(1,1);
    for i = 1:3
        if i == 1
            if DiceRoll <= ActionProbabilities_InSequence(CurrentStateNumber(p1),i)
                ChosenAction(p1) = i;
            end
        end
        if i~=1
            if DiceRoll >= ActionProbabilities_InSequence(CurrentStateNumber(p1),i-1)
                if DiceRoll <= ActionProbabilities_InSequence(CurrentStateNumber(p1),i)
                    ChosenAction(p1) = i;
                end
            end
        end
    end
    
    %% this is the gain in USD for buying and selling 0.001 BTC (
    % sell BTC gain dollars (that is actions -1), buy BTC loose
    % dollars( action is +1).
    
    %   TotalGain = TotalGain - (10^-3)*Actions(ChosenAction(p))*(Price(itteration));
    %   NumberOfSpendableBitcoin = (NumberOfSpendableBitcoin*10^3 + Actions(ChosenAction(p)))*10^-3;
    
    
    
    
    %   p = p+1;
    
    
     %% this Must Be Turned On So The system will work - it need realtime feedback
    
    %% Wasted all the money
    %     if NumberOfSpendableBitcoin <= 0
    %     FullUSDGain = FullUSDGain + TotalGain;
    %     FullBitcoinChange = FullBitcoinChange + NumberOfSpendableBitcoin - 10*10^-3;
    %
    %     TotalGain = 0;
    %     NumberOfSpendableBitcoin = 10*10^-3;
    %     p = 1;
    %     ActionProbabilities = OldActionProbabilities;
    %     ChosenAction = zeros(Length_Of_Policy_Trial,1);
    %     CurrentStateNumber = zeros(Length_Of_Policy_Trial,1);
    %    end
    
    TrainSysetm =1;
    if p1 >Length_Of_Policy_Trial
        Reenforce_Policy = 1;
    end
    if NumberOfSpendableBitcoin <= 0
        Reenforce_Policy = 1;
    end
    %% Reenforcement
    if TrainSysetm == 1
        if Reenforce_Policy == 1
            
            Reenforce_Policy = 0;
            
                FullUSDGain = FullUSDGain + TotalGain;
                FullBitcoinChange = FullBitcoinChange + NumberOfSpendableBitcoin - 10*10^-3;
            
            
            % BTC_SpendingPenalty_Factor = 10;
            % USD_GainReward_Factor = 1/600;
            
            Reward = TotalGain*USD_GainReward_Factor - BTC_SpendingPenalty_Factor*(10*10^-3 - NumberOfSpendableBitcoin);
            TotalGain = 0;
            NumberOfSpendableBitcoin = 10*10^-3;
            
            if TrainSysetm == 1
                for p1 = 1:Length_Of_Policy_Trial
                    if ActionProbabilities(CurrentStateNumber(p1),ChosenAction(p1)) + Reward > 0.1
                        ActionProbabilities(CurrentStateNumber(p1),ChosenAction(p1)) = ActionProbabilities(CurrentStateNumber(p1),ChosenAction(p1)) + Reward;
                    end
                    if ActionProbabilities(CurrentStateNumber(p1),ChosenAction(p1)) + Reward < 0.1
                        ActionProbabilities(CurrentStateNumber(p1),ChosenAction(p1)) = 0.1;
                    end
                    ActionProbabilities(CurrentStateNumber(p1),:) = ActionProbabilities(CurrentStateNumber(p1),:)/sum(ActionProbabilities(CurrentStateNumber(p1),:));
                end
            end
            
            OldActionProbabilities = ActionProbabilities;
            ChosenAction = zeros(Length_Of_Policy_Trial,1);
            CurrentStateNumber = zeros(Length_Of_Policy_Trial,1);
            p1 = 1;
            
            %%Ploting Learning Process
            plotLearning = 0;
            if plotLearning == 1
                bar(ActionProbabilities(:,1),'b');
                hold on
                bar(ActionProbabilities(:,2),'g');
                hold off
                hold on
                bar(ActionProbabilities(:,3),'r');
                hold off
                ylim([0 1]);
                getframe(gcf);
            end
        end
    end
    
end
%end


