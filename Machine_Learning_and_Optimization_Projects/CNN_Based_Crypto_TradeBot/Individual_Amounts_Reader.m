function [BNB_Amount,LTC_Amount,ETH_Amount,USDT_Amount,BTC_Amount,TotalConfidence] = Individual_Amounts_Reader()






    ChosenDigit = zeros(1,14);
    Confidence = zeros(1,14);
    
        robo = java.awt.Robot;
    t = java.awt.Toolkit.getDefaultToolkit();
    rectangle = java.awt.Rectangle(t.getScreenSize());
    image = robo.createScreenCapture(rectangle);
    filehandle = java.io.File('screencapture.jpg');
    javax.imageio.ImageIO.write(image,'jpg',filehandle);
    %imageview('screencapture.jpg');
    
    d = imread('screencapture.jpg');
    
    GreyImage = rgb2gray(d);
    
    BNB_Image = GreyImage(441:457,50:540,1);
    LTC_Image = GreyImage(482:498,50:540,1);
    ETH_Image = GreyImage(524:540,50:540,1);
    TeatherUSD_Image = GreyImage(565:581,50:540,1);
    BTC_Image = GreyImage(605:621,50:540,1);
    
    
  %  imshow(BNB_Image)
  %  for n = 1:9
  %      imshow(BNB_Image(:,400 + (n-1)*9 + (n>1)*4 :409 + (n-1)*9 + (n>1)*4 ))
   %     n
    %    pause(0.2)
    %end
    
    
    %BitcoinImage = GreyImage(615:650,720:815,1);
    %imshow(BitcoinImage);
    
    %LTCImage = GreyImage(615:650,815:900,1);
    %imshow(LTCImage);
    
    for n = 1:54
        
        if n <= 9
            Digit(:,:,n) = BNB_Image(:,400 + (n-1)*9 + (n>1)*4 :409 + (n-1)*9 + (n>1)*4 );% this is for 10^0 regime
        end
        if n > 9
            if n<=18
                Digit(:,:,n) = LTC_Image(:,400 + (n-10)*9 + (n>10)*4 :409 + (n-10)*9 + (n>10)*4 );
            end
        end
        if n > 18
            if n<=27
                Digit(:,:,n) = ETH_Image(:,400 + (n-19)*9 + (n>19)*4 :409 + (n-19)*9 + (n>19)*4 );
            end
        end
        if n > 27
            if n<=36
                Digit(:,:,n) = BNB_Image(:,400 + (n-29)*9 + (n>29)*4 :409 + (n-29)*9 + (n>29)*4 ); % this is for 10^1 regime
            end
        end
        if n > 36
            if n<=45
                Digit(:,:,n) = TeatherUSD_Image(:,400 + (n-37)*9 + (n>37)*4 :409 + (n-37)*9 + (n>37)*4 );
            end
        end
        if n > 45
            if n<=54
                Digit(:,:,n) = BTC_Image(:,400 + (n-46)*9 + (n>46)*4 :409 + (n-46)*9 + (n>46)*4 );
            end
        end
        
        [ChosenDigit(n),Confidence(n)] = NeuralNetwork_Digit_Reader_133Binance(Digit(:,:,n));
    end

%% Choosing The Best
BNB_10_0_regime_Confidence = mean(Confidence(1:9));
BNB_10_1_regime_Confidence = mean(Confidence(28:36));
    
    
if    BNB_10_0_regime_Confidence > BNB_10_1_regime_Confidence + 0.02
TotalConfidence(1) = BNB_10_0_regime_Confidence; %this is for BNB
end
if    BNB_10_0_regime_Confidence <= BNB_10_1_regime_Confidence + 0.02
TotalConfidence(1) = BNB_10_1_regime_Confidence; %this is for BNB
end
TotalConfidence(2) = mean(Confidence(10:18));   % this is for LTC
TotalConfidence(3) = mean(Confidence(19:27));   % this is for ETH
TotalConfidence(4) = mean(Confidence(37:45));   % this is for USDT
TotalConfidence(5) = mean(Confidence(45:54));   % this is for BTC

if    BNB_10_0_regime_Confidence > BNB_10_1_regime_Confidence + 0.02
BNB_Amount = ChosenDigit(1) + ChosenDigit(2)*10^-1 + ChosenDigit(3)*10^-2 + ChosenDigit(4)*10^-3 + ChosenDigit(5)*10^-4 + ChosenDigit(6)*10^-5 + ChosenDigit(7)*10^-6 + ChosenDigit(8)*10^-7 + ChosenDigit(9)*10^-8;
end
if    BNB_10_0_regime_Confidence <= BNB_10_1_regime_Confidence + 0.02
BNB_Amount = ChosenDigit(28)*10 + ChosenDigit(29) + ChosenDigit(30)*10^-1 + ChosenDigit(31)*10^-2 + ChosenDigit(32)*10^-3 + ChosenDigit(33)*10^-4 + ChosenDigit(34)*10^-5 + ChosenDigit(35)*10^-6 + ChosenDigit(36)*10^-7;
end
LTC_Amount = ChosenDigit(10) + ChosenDigit(11)*10^-1 + ChosenDigit(12)*10^-2 + ChosenDigit(13)*10^-3 + ChosenDigit(14)*10^-4 + ChosenDigit(15)*10^-5 + ChosenDigit(16)*10^-6 + ChosenDigit(17)*10^-7 + ChosenDigit(18)*10^-8;
ETH_Amount = ChosenDigit(19) + ChosenDigit(20)*10^-1 + ChosenDigit(21)*10^-2 + ChosenDigit(22)*10^-3 + ChosenDigit(23)*10^-4 + ChosenDigit(24)*10^-5 + ChosenDigit(25)*10^-6 + ChosenDigit(26)*10^-7 + ChosenDigit(27)*10^-8;
USDT_Amount = ChosenDigit(37) + ChosenDigit(38)*10^-1 + ChosenDigit(39)*10^-2 + ChosenDigit(40)*10^-3 + ChosenDigit(41)*10^-4 + ChosenDigit(42)*10^-5 + ChosenDigit(43)*10^-6 + ChosenDigit(44)*10^-7 + ChosenDigit(45)*10^-8;
BTC_Amount = ChosenDigit(46) + ChosenDigit(47)*10^-1 + ChosenDigit(48)*10^-2 + ChosenDigit(49)*10^-3 + ChosenDigit(50)*10^-4 + ChosenDigit(51)*10^-5 + ChosenDigit(52)*10^-6 + ChosenDigit(53)*10^-7 + ChosenDigit(54)*10^-8;


