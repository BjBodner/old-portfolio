function [BTC_USDT,ETH_USDT,LTC_USDT,BNB_USDT] = GetCurrentUSDT_Ratios_Full()
n = 1;

for i = 1:10
    tic
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
    if floor(BTC_USDT1(i)/10^(6-k))>1
        break
    end
end
OrderOfMagnitude_BTC(i) = 6-k;

for k = 1:8
  %  a = floor(ETH_USDT1/10^(6-k));
    if  floor(ETH_USDT1(i)/10^(6-k))>1
        break
    end
end
OrderOfMagnitude_ETH(i) = 6-k;

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
BTCFirstDigit(i) = floor(BTC_USDT1(i)/10^OrderOfMagnitude_BTC(i));
BTCSecondDigit(i) = floor(BTC_USDT1(i)/10^(OrderOfMagnitude_BTC(i)-1)) - 10*BTCFirstDigit(i);

ETHFirstDigit(i) = floor(ETH_USDT1(i)/10^OrderOfMagnitude_ETH(i));
ETHSecondDigit(i) = floor(ETH_USDT1(i)/10^(OrderOfMagnitude_ETH(i)-1)) - 10*ETHFirstDigit(i);

LTCFirstDigit(i) = floor(LTC_USDT1(i)/10^OrderOfMagnitude_LTC(i));
LTCSecondDigit(i) = floor(LTC_USDT1(i)/10^(OrderOfMagnitude_LTC(i)-1)) - 10*LTCFirstDigit(i);

BNBFirstDigit(i) = floor(BNB_USDT1(i)/10^OrderOfMagnitude_BNB(i));
BNBSecondDigit(i) = floor(BNB_USDT1(i)/10^(OrderOfMagnitude_BNB(i)-1)) - 10*BNBFirstDigit(i);
toc
end

BTCKillingVector = (OrderOfMagnitude_BTC == mode(OrderOfMagnitude_BTC)).*(BTCFirstDigit == mode(BTCFirstDigit)).*(BTCSecondDigit  == mode(BTCSecondDigit));
BTC_USDT(n) = mean(nonzeros(BTCKillingVector.*BTC_USDT1))

ETHKillingVector = (OrderOfMagnitude_ETH == mode(OrderOfMagnitude_ETH)).*(ETHFirstDigit == mode(ETHFirstDigit)).*(ETHSecondDigit  == mode(ETHSecondDigit));
ETH_USDT(n) = mean(nonzeros(ETHKillingVector.*ETH_USDT1))

LTCKillingVector = (OrderOfMagnitude_LTC == mode(OrderOfMagnitude_LTC)).*(LTCFirstDigit == mode(LTCFirstDigit)).*(LTCSecondDigit  == mode(LTCSecondDigit));
LTC_USDT(n) = mean(nonzeros(LTCKillingVector.*LTC_USDT1))

BNBKillingVector = (OrderOfMagnitude_BNB == mode(OrderOfMagnitude_BNB)).*(BNBFirstDigit == mode(BNBFirstDigit)).*(BNBSecondDigit  == mode(BNBSecondDigit));
BNB_USDT(n) = mean(nonzeros(BNBKillingVector.*BNB_USDT1))