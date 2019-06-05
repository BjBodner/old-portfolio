function [TotalBTC,TotalUSD,TotalConfidence] = Total_BTC_USD_Reader(BTC_and_USDImage)

    ChosenDigit = zeros(1,14);
    Confidence = zeros(1,14);
    
for n = 1:14
    n
  if n <= 9
      Digit(:,:,n) = BTC_and_USDImage(:,10+(n-1)*10 + (n>1)*5 + floor(n/3): 20+(n-1)*10 +(n>1)*5 + floor(n/3));
  end
  if n > 9
      if n<=14
      Digit(:,:,n) = BTC_and_USDImage(:,165 + (n-9)*10 + (n>12)*5 + floor(n/3):175 +(n-9)*10 + (n>12)*5 + floor(n/3));
      end
  end
  
  [ChosenDigit(n),Confidence(n)] = NeuralNetwork_Digit_Reader_BoldDigits(Digit(:,:,n))
  
end

TotalConfidence(1) = mean(Confidence(1:9));
TotalConfidence(2) = mean(Confidence(10:14));   

TotalBTC = ChosenDigit(1) + ChosenDigit(2)*10^-1 + ChosenDigit(3)*10^-2 + ChosenDigit(4)*10^-3 + ChosenDigit(5)*10^-4 + ChosenDigit(6)*10^-5 + ChosenDigit(7)*10^-6 + ChosenDigit(8)*10^-7 + ChosenDigit(9)*10^-8;
TotalUSD = ChosenDigit(10)*10^2 + ChosenDigit(11)*10^1 + ChosenDigit(12)*10^0 + ChosenDigit(13)*10^-1 + ChosenDigit(14)*10^-2;
