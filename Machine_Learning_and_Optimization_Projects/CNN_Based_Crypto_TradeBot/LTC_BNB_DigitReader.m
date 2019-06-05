function [LTC_BNB_Multiplied_by_10_2] = LTC_BNB_DigitReader(BNB_ETH)


    
   % Minimized_Cropped_GreyImage = GreyImage(510:545,710:1100,1);
    
   % imshow(Minimized_Cropped_GreyImage);
    
   % BNB_BTC = GreyImage(353:367,1060:1250,1);
   % BNB_ETH = GreyImage(380:394,1060:1250,1);
    
   % imshow(BNB_ETH);
    ChosenDigit = zeros(1,7);
    
    for n = 1:4
       % if n <= 5
            Digit = BNB_ETH(:,105 +5*floor(n/3)+ (n-1)*(8):113 +5*floor(n/3)+(n-1)*(8));
            %imshow(Digit);
       % end
       % [ChosenDigit(n)] = NeuralNetwork_Digit_Reader(BitcoinDigit(:,:,n));
     %   [ChosenDigit(n)] = NeuralNetwork_Digit_Reader3(Digit);
        [ChosenDigit(n)] = NeuralNetwork_Digit_Reader4(Digit);
         if n == 1
             ChosenDigit(n) = 1;
         end
        %imshow(BitcoinDigit(:,:,n));  
        %ChosenDigit(n)
    end

    %BNB_BTC = vpa(ChosenDigit(1)*10^-1 + ChosenDigit(2)*10^-2 + ChosenDigit(3)*10^-3 + ChosenDigit(4)*10^-4 + ChosenDigit(5)*10^-5+ChosenDigit(6)*10^-6+ChosenDigit(7)*10^-7,5);
    
LTC_BNB_Multiplied_by_10_2 = (ChosenDigit(1)*10^-1 + ChosenDigit(2)*10^-2 + ChosenDigit(3)*10^-3 + ChosenDigit(4)*10^-4 + ChosenDigit(5)*10^-5+ChosenDigit(6)*10^-6)*10^9;