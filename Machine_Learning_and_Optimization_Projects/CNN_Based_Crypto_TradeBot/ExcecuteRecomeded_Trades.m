function[Amount,Buy_Sell_Recomendations_FromRareSpikes,ArbitrageBuy_Sell_Recomendations,RebalanceNeeded] = ExcecuteRecomeded_Trades(Amount,Ratio,Buy_Sell_Recomendations_FromRareSpikes,TradeIndexes,ArbitrageBuy_Sell_Recomendations,BuySellCommand,BestTradeRatios_ForChosenLoop,MakeRareSpikesTrade,MakeArbitrageTrade,Excecute_Rebalance_Trade,AmountToTrade_ForRebalancing,IndexOfTradeRatio_ForRebalancing,RebalanceNeeded,BTC_USDT,ETH_USDT,LTC_USDT,BNB_USDT)

Failure =0;
SuccessIndicator1 = 0;

%% This is what the Ratio matrix is made of
%Ratio(:,1) = nonzeros(BNB_BTC);
%Ratio(:,2) = nonzeros(BNB_ETH);
%Ratio(:,3) = nonzeros(ETH_BTC);
%Ratio(:,4) = nonzeros(LTC_BTC);
%Ratio(:,5) = nonzeros(LTC_BNB);
%Ratio(:,6) = nonzeros(LTC_ETH);
DollarTradeAmount = 21;

Re_PreallocateTheTradeAmounts = 1;
if Re_PreallocateTheTradeAmounts == 1
    
    BTC_Amount = DollarTradeAmount/BTC_USDT;
    ETH_Amount = DollarTradeAmount/ETH_USDT;
    LTC_Amount = DollarTradeAmount/LTC_USDT;
    BNB_Amount = DollarTradeAmount/BNB_USDT;
    
    TradeAmount(1) = BTC_Amount;
    TradeAmount(2) = ETH_Amount;
    TradeAmount(3) = LTC_Amount;
    TradeAmount(4) = BNB_Amount;
end


ExcecuteRareSpikesTrading = 1;
ExcecuteArbitrageTrading= 0;
ExcecuteTradeOnWebsite = 1;
PercentageOfAmout = 1;


if Excecute_Rebalance_Trade == 1
    for i = 1:length(AmountToTrade_ForRebalancing)
        %AmountToTrade = AmountToTrade_ForRebalancing(i)
        NumberOfTradeRatio = IndexOfTradeRatio_ForRebalancing(i)
        k = TradeIndexes(NumberOfTradeRatio,1);
        j = TradeIndexes(NumberOfTradeRatio,2);
        
        if AmountToTrade_ForRebalancing(i) > 0
            AmountToTrade = TradeAmount(k)*AmountToTrade_ForRebalancing(i);
            Buy_Sell = 1;
            if ExcecuteTradeOnWebsite == 1
                [SuccessIndicator] = SellOnWebsite(Buy_Sell,AmountToTrade,NumberOfTradeRatio);
                SuccessIndicator1 = SuccessIndicator1 + SuccessIndicator;
                if SuccessIndicator == 0
                    Failure = Failure + 1;
                end
            end
            Amount(j) = Amount(j) - 0.999*PercentageOfAmout*TradeAmount(k)*Ratio(length(Ratio(:,1)),NumberOfTradeRatio);
            Amount(k) = Amount(k) + PercentageOfAmout*TradeAmount(k);
        end
        
        if AmountToTrade_ForRebalancing(i) <0
            AmountToTrade = -TradeAmount(k)*AmountToTrade_ForRebalancing(i)
            Buy_Sell = -1;
            if ExcecuteTradeOnWebsite == 1
                [SuccessIndicator] = SellOnWebsite(Buy_Sell,AmountToTrade,NumberOfTradeRatio);
                SuccessIndicator1 = SuccessIndicator1 + SuccessIndicator;
                if SuccessIndicator == 0
                    Failure = Failure + 1;
                end
            end
            Amount(j) = Amount(j) + 0.999*PercentageOfAmout*TradeAmount(k)*Ratio(length(Ratio(:,1)),NumberOfTradeRatio);
            Amount(k) = Amount(k) - PercentageOfAmout*TradeAmount(k);
        end
        
    end
end



if ExcecuteRareSpikesTrading == 1
    if MakeRareSpikesTrade ==1
        
        for i = 1:6
            NumberOfTradeRatio = i;
            k = TradeIndexes(NumberOfTradeRatio,1);
            j = TradeIndexes(NumberOfTradeRatio,2);
            if Buy_Sell_Recomendations_FromRareSpikes(i) == 1 % this is a sell
                AmountToTrade = PercentageOfAmout*TradeAmount(k); % assuming amount k is the one that is bought/sold
                Buy_Sell = 1;
                if ExcecuteTradeOnWebsite == 1
                    [SuccessIndicator] = SellOnWebsite(Buy_Sell,AmountToTrade,NumberOfTradeRatio);
                    SuccessIndicator1 = SuccessIndicator1 + SuccessIndicator;
                    if SuccessIndicator == 0
                        Failure = Failure + 1;
                    end
                end
                Amount(j) = Amount(j) - 1.001*PercentageOfAmout*TradeAmount(k)*Ratio(length(Ratio(:,1)),NumberOfTradeRatio);
                Amount(k) = Amount(k) + PercentageOfAmout*TradeAmount(k);
            end
            
            
            if Buy_Sell_Recomendations_FromRareSpikes(i) == -1 % this is a sell
                AmountToTrade = PercentageOfAmout*TradeAmount(k);
                Buy_Sell = -1;
                if ExcecuteTradeOnWebsite == 1
                    [SuccessIndicator] = SellOnWebsite(Buy_Sell,AmountToTrade,NumberOfTradeRatio);
                    SuccessIndicator1 = SuccessIndicator1 + SuccessIndicator;
                    if SuccessIndicator == 0
                        Failure = Failure + 1;
                    end
                end
                Amount(j) = Amount(j) + 0.999*PercentageOfAmout*TradeAmount(k)*Ratio(length(Ratio(:,1)),NumberOfTradeRatio);
                Amount(k) = Amount(k) - PercentageOfAmout*TradeAmount(k);
            end
            
        end
    end
end


if ExcecuteArbitrageTrading == 1
    if MakeArbitrageTrade == 1
        for i = 1:3
            NumberOfTradeRatio = BestTradeRatios_ForChosenLoop(i);
            k = TradeIndexes(NumberOfTradeRatio,1);
            j = TradeIndexes(NumberOfTradeRatio,2);
            BuySellCommand
            
            
            
            %  if ArbitrageBuy_Sell_Recomendations(i) ~= 0
            
            if BuySellCommand(i) == 1
                %% Buy 0.2 of the initial amount
                
                
                NumberOfTradeRatio = BestTradeRatios_ForChosenLoop(i);
                %AmountToTrade = 0.2*Amount(k); % assuming amount k is the one that is bought/sold
                AmountToTrade = PercentageOfAmout*TradeAmount(k) % assuming amount k is the one that is bought/sold
                Buy_Sell = 1;
                if ExcecuteTradeOnWebsite == 1
                    [SuccessIndicator] = SellOnWebsite(Buy_Sell,AmountToTrade,NumberOfTradeRatio);
                    SuccessIndicator1 = SuccessIndicator1 + SuccessIndicator;
                    if SuccessIndicator == 0
                        Failure = Failure + 1;
                    end
                end
                %   Amount(j) = Amount(j) + 0.99*PercentageOfAmout*Amount(k)/Ratio(length(Ratio(:,1)),i);
                %   Amount(k) = Amount(k) - PercentageOfAmout*Amount(k);
                
                
                % if TradeMethod == 1
                Amount(j) = Amount(j) - 1.001*PercentageOfAmout*TradeAmount(k)*Ratio(length(Ratio(:,1)),NumberOfTradeRatio);
                Amount(k) = Amount(k) + PercentageOfAmout*TradeAmount(k);
            end
            
            
            
            if BuySellCommand(i) == -1
                %% Buy 0.2 of the initial amount
                NumberOfTradeRatio = BestTradeRatios_ForChosenLoop(i);
                AmountToTrade = PercentageOfAmout*TradeAmount(k);
                %AmountToTrade = 0.2*Amount(j)*Ratio(length(Ratio(:,1)),i); % assuming amount k is the one that is bought/sold
                Buy_Sell = -1;
                if ExcecuteTradeOnWebsite == 1
                    [SuccessIndicator] = SellOnWebsite(Buy_Sell,AmountToTrade,NumberOfTradeRatio);
                    SuccessIndicator1 = SuccessIndicator1 + SuccessIndicator;
                    if SuccessIndicator == 0
                        Failure = Failure + 1;
                    end
                end
                
                
                Amount(j) = Amount(j) + 0.999*PercentageOfAmout*TradeAmount(k)*Ratio(length(Ratio(:,1)),NumberOfTradeRatio);
                Amount(k) = Amount(k) - PercentageOfAmout*TradeAmount(k);
                
            end
            
            
            %          Amount(k) = Amount(k) + 0.1998*Amount(j)*Ratio(length(Ratio(:,1)),i)
            %   Amount(j) = Amount(j) - 0.2*Amount(j);
            %  Amount(k) = Amount(k) - 0.2*Amount(k);
            
            
            %  Amount(j) = Amount(j) + 0.2*Amount(k)*Ratio(length(Ratio(:,1)),i) - 0.002*0.2*Amount(k)*Ratio(length(Ratio(:,1)),i);
            %end
        end
    end
end
Buy_Sell_Recomendations_FromRareSpikes = zeros(6,1);
ArbitrageBuy_Sell_Recomendations= zeros(6,1);




if Failure >=2
    RebalanceNeeded = RebalanceNeeded + 1;
end

