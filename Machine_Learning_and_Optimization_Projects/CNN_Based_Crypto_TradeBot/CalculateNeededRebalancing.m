function [TradeIndexesForRefill,AmountToTrade_ForRebalancing,IndexOfTradeRatio_ForRebalancing,Excecute_Rebalance_Trade] = CalculateNeededRebalancing(BTC_Amount,ETH_Amount,TeatherUSDT_Amount,LTC_Amount,BNB_Amount,BTC_USDT,ETH_USDT,LTC_USDT,BNB_USDT,TradeAmountInUSD)

    TradeIndexes(1,1) = 4;
    TradeIndexes(1,2) = 1;
    TradeIndexes(2,1) = 4;
    TradeIndexes(2,2) = 2;
    TradeIndexes(3,1) = 2;
    TradeIndexes(3,2) = 1;
    TradeIndexes(4,1) = 3;
    TradeIndexes(4,2) = 1;
    TradeIndexes(5,1) = 3;
    TradeIndexes(5,2) = 4;
    TradeIndexes(6,1) = 3;
    TradeIndexes(6,2) = 2;


Excecute_Rebalance_Trade = 0;

BTC_Dollar_Amount = BTC_Amount*BTC_USDT;
ETH_Dollar_Amount= ETH_Amount*ETH_USDT;
LTC_Dollar_Amount = LTC_Amount*LTC_USDT;
BNB_Dollar_Amount = BNB_Amount*BNB_USDT;

NumberOfTradeAmounts = [(BTC_Dollar_Amount - mod(BTC_Dollar_Amount,TradeAmountInUSD))/TradeAmountInUSD ;...
    (ETH_Dollar_Amount - mod(ETH_Dollar_Amount,TradeAmountInUSD))/TradeAmountInUSD;...
    (LTC_Dollar_Amount - mod(LTC_Dollar_Amount,TradeAmountInUSD))/TradeAmountInUSD;...
    (BNB_Dollar_Amount - mod(BNB_Dollar_Amount,TradeAmountInUSD))/TradeAmountInUSD];

TotalNumberOfTradeAmounts = sum(NumberOfTradeAmounts);

NeededAmounts_ForThose_ThatHave_LessThan2_TradeAmounts = (NumberOfTradeAmounts < 2).*(NumberOfTradeAmounts-2);
IndexesOfAmountsThatNeedRefill = find(NeededAmounts_ForThose_ThatHave_LessThan2_TradeAmounts<0)
%% Checking ig it can all come out of the maximal value amount

 SellIndex = 1;
 BuyIndex = 1;
 AmountToTrade_ForRebalancing = 0;
 %NumberOfTradeAmounts = 0;
    for k = 1:length(IndexesOfAmountsThatNeedRefill)
        for j = 1:length(NumberOfTradeAmounts)
            if NumberOfTradeAmounts(j) >= 2 - NeededAmounts_ForThose_ThatHave_LessThan2_TradeAmounts(IndexesOfAmountsThatNeedRefill(k))
                SellIndex(k) = j;
                break
            end
        end
        
        BuyIndex(k) = IndexesOfAmountsThatNeedRefill(k);
        AmountToTrade_ForRebalancing(k) = NeededAmounts_ForThose_ThatHave_LessThan2_TradeAmounts(IndexesOfAmountsThatNeedRefill(k))
        NumberOfTradeAmounts(j) = NumberOfTradeAmounts(j) - abs(AmountToTrade_ForRebalancing(k))
    end

%if length(SellIndex) == length(BuyIndex)
TradeIndexesForRefill = [ SellIndex ; BuyIndex(1:length(SellIndex))].';
%end
%if length(SellIndex) ~= length(BuyIndex)
%TradeIndexesForRefill = [ 0 ; 0].';
%end
IndexOfTradeRatio_ForRebalancing = zeros(1,length(AmountToTrade_ForRebalancing));

for k = 1:length(SellIndex)
    if    max(sum(TradeIndexesForRefill(k,:).' == TradeIndexes.')) <= 1
        AmountToTrade_ForRebalancing(k) = -AmountToTrade_ForRebalancing(k);
        [~,IndexOfTradeRatio_ForRebalancing(k)] = max(sum(flipud(TradeIndexesForRefill(k,:).') == TradeIndexes.') == 2);
    end
    
   if    max(sum(TradeIndexesForRefill(k,:).' == TradeIndexes.')) > 1
        AmountToTrade_ForRebalancing(k) = AmountToTrade_ForRebalancing(k);
        [~,IndexOfTradeRatio_ForRebalancing(k)] = max(sum(TradeIndexesForRefill(k,:).' == TradeIndexes.') == 2);
    end
end

if sum(NeededAmounts_ForThose_ThatHave_LessThan2_TradeAmounts) < 0
Excecute_Rebalance_Trade = 1;
end
if length(SellIndex) ~= length(BuyIndex)
Excecute_Rebalance_Trade = 0;
end