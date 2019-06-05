function [BNB_BTC,BNB_ETH,ETH_BTC,LTC_BTC,LTC_BNB,LTC_ETH] = GetCurrent_Favorites_Ratios_Full()
n = 1;

[BNB_BTC,BNB_ETH,ETH_BTC,LTC_BTC,LTC_BNB,LTC_ETH] = GetCurrent_Favorites_Ratios();

ExcecutePostAuthentication = 0;
if ExcecutePostAuthentication == 1
for i = 1:3
    tic
    [BNB_BTC1(i),BNB_ETH(i),ETH_BTC(i),LTC_BTC(i),LTC_BNB(i),LTC_ETH(i)] = GetCurrent_Favorites_Ratios();
[BTC_USDT1(i),ETH_USDT1(i),LTC_USDT1(i),BNB_USDT1(i)] = GetCurrentUSDT_Ratios();
% A Way to improve the algorithm will be to run this 100 times.
% then filter out all the results that are of the wrong order of magnitude
% (the compared to the mode of magnitude which occurs the most

% then filter out the ones then find the modes of the first two digits
% (meaning they occur most often)
% filter out the ones that get the first two digits wrong

%% finding the order of magnitude
for k = 1:8
  %  a = floor(BTC_USDT1/10^(6-k));
    if floor(BNB_BTC1(i)/10^(6-k))>1
        break
    end
end
OrderOfMagnitude_BNB_BTC1(i) = 6-k;

for k = 1:8
  %  a = floor(ETH_USDT1/10^(6-k));
    if  floor(BNB_ETH(i)/10^(6-k))>1
        break
    end
end
OrderOfMagnitude_BNB_ETH1(i) = 6-k;

for k = 1:8
  %  a = floor(LTC_USDT1/10^(6-k));
    if floor(LTC_USDT1(i)/10^(6-k))>1
        break
    end
end
OrderOfMagnitude_LTC(i) = 6-k;

for k = 1:8
  %  a = floor(BNB_USDT1/10^(6-k));
    if floor(BNB_USDT1(i)/10^(6-k))>1
        break
    end
end
OrderOfMagnitude_BNB(i) = 6-k;


%% Finding the first two digits
BTCFirstDigit(i) = floor(BNB_BTC1(i)/10^OrderOfMagnitude_BNB_BTC1(i));
BTCSecondDigit(i) = floor(BNB_BTC1(i)/10^(OrderOfMagnitude_BNB_BTC1(i)-1)) - 10*BTCFirstDigit(i);

ETHFirstDigit(i) = floor(ETH_USDT1(i)/10^OrderOfMagnitude_BNB_ETH1(i));
ETHSecondDigit(i) = floor(ETH_USDT1(i)/10^(OrderOfMagnitude_BNB_ETH1(i)-1)) - 10*ETHFirstDigit(i);

LTCFirstDigit(i) = floor(LTC_USDT1(i)/10^OrderOfMagnitude_LTC(i));
LTCSecondDigit(i) = floor(LTC_USDT1(i)/10^(OrderOfMagnitude_LTC(i)-1)) - 10*LTCFirstDigit(i);

BNBFirstDigit(i) = floor(BNB_USDT1(i)/10^OrderOfMagnitude_BNB(i));
BNBSecondDigit(i) = floor(BNB_USDT1(i)/10^(OrderOfMagnitude_BNB(i)-1)) - 10*BNBFirstDigit(i);
toc
end

BTCKillingVector = (OrderOfMagnitude_BNB_BTC1 == mode(OrderOfMagnitude_BNB_BTC1)).*(BTCFirstDigit == mode(BTCFirstDigit)).*(BTCSecondDigit  == mode(BTCSecondDigit));
BTC_USDT(n) = mean(nonzeros(BTCKillingVector.*BTC_USDT1))

ETHKillingVector = (OrderOfMagnitude_BNB_ETH1 == mode(OrderOfMagnitude_BNB_ETH1)).*(ETHFirstDigit == mode(ETHFirstDigit)).*(ETHSecondDigit  == mode(ETHSecondDigit));
ETH_USDT(n) = mean(nonzeros(ETHKillingVector.*ETH_USDT1))

LTCKillingVector = (OrderOfMagnitude_LTC == mode(OrderOfMagnitude_LTC)).*(LTCFirstDigit == mode(LTCFirstDigit)).*(LTCSecondDigit  == mode(LTCSecondDigit));
LTC_USDT(n) = mean(nonzeros(LTCKillingVector.*LTC_USDT1))

BNBKillingVector = (OrderOfMagnitude_BNB == mode(OrderOfMagnitude_BNB)).*(BNBFirstDigit == mode(BNBFirstDigit)).*(BNBSecondDigit  == mode(BNBSecondDigit));
BNB_USDT(n) = mean(nonzeros(BNBKillingVector.*BNB_USDT1))

end