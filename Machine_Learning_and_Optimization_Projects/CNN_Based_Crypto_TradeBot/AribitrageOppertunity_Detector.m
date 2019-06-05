function [p,Ratio,BNB_BTC,BNB_ETH,ETH_BTC,LTC_BTC,LTC_BNB,LTC_ETH,BuySellCommand,IndexOfTradeRatio_InChosenTradeLoop,FoundGoodTrade] = AribitrageOppertunity_Detector(p,BNB_BTC,BNB_ETH,ETH_BTC,LTC_BTC,LTC_BNB,LTC_ETH,FoundGoodTrade)


Threshold_Percentage_Gain_TriggerForArbitrageTrade = 0.0035;


    TakeNewPicture = 1;
    if TakeNewPicture == 1
        robo = java.awt.Robot;
        t = java.awt.Toolkit.getDefaultToolkit();
        rectangle = java.awt.Rectangle(t.getScreenSize());
        image = robo.createScreenCapture(rectangle);
        filehandle = java.io.File('screencapture.jpg');
        javax.imageio.ImageIO.write(image,'jpg',filehandle);
    end
    
    d = imread('screencapture.jpg');
    
    GreyImage = rgb2gray(d);
    BNB_BTC_Image = GreyImage(353:367,1060:1250,1);
    BNB_ETH_Image = GreyImage(380:394,1060:1250,1);
    ETH_BTC_Image = GreyImage(407:421,1060:1250,1);
    LTC_BTC_Image = GreyImage(433:447,1060:1250,1);
    LTC_BNB_Image = GreyImage(459:473,1060:1250,1);
    LTC_ETH_Image = GreyImage(486:500,1060:1250,1);
    
    % imshow(BNB_ETH_Image)
    
    %% Gathering Data From Images
    [BNB_BTC(p)] = BNB_BTC_DigitReader(GreyImage);
    [BNB_ETH(p)] = BNB_ETH_DigitReader(BNB_ETH_Image);
    [ETH_BTC(p)] = BNB_ETH_DigitReader(ETH_BTC_Image);
    [LTC_BTC(p)] = LTC_BTC_DigitReader(LTC_BTC_Image);
    [LTC_BNB(p)] = LTC_BNB_DigitReader(LTC_BNB_Image);
    [LTC_ETH(p)] = LTC_ETH_DigitReader(LTC_ETH_Image);
    
    BNB_BTC(p)
    %% Readjusting the factors
    BNB_BTC(p) = BNB_BTC(p)*10^-7;
    BNB_ETH(p) = BNB_ETH(p)*10^-7;
    ETH_BTC(p) = ETH_BTC(p)*10^-7;
    LTC_BTC(p) = LTC_BTC(p)*10^-7;
    LTC_BNB(p) = LTC_BNB(p)*10^-7;
    LTC_ETH(p) = LTC_ETH(p)*10^-7;
    
    
    Ratio= zeros(length(nonzeros(BNB_BTC)),6);
    Ratio(:,1) = nonzeros(BNB_BTC);
    Ratio(:,2) = nonzeros(BNB_ETH);
    Ratio(:,3) = nonzeros(ETH_BTC);
    Ratio(:,4) = nonzeros(LTC_BTC);
    Ratio(:,5) = nonzeros(LTC_BNB);
    Ratio(:,6) = nonzeros(LTC_ETH);
    
    
    
    %% Building the
    
    % index alocation
    % BTC = 1
    % ETH = 2
    % LTC = 3
    % BNB = 4
    Exchange_Array = ones(4,2,4);
    Exchange_Array(1,1,4) = BNB_BTC(p)*10^0;
    Exchange_Array(1,2,4) = (1/Exchange_Array(1,1,4));
    Exchange_Array(4,1,1)= (1/Exchange_Array(1,1,4));
    Exchange_Array(4,2,1) = Exchange_Array(1,1,4);
    % TradeIndexes(1,1) = 1;
    % TradeIndexes(1,2) = 4;
    TradeIndexes(1,1) = 4;
    TradeIndexes(1,2) = 1;
    
    Exchange_Array(2,1,4) = BNB_ETH(p)*10^0;
    Exchange_Array(2,2,4) = (1/Exchange_Array(2,1,4));
    Exchange_Array(4,1,2)= (1/Exchange_Array(2,1,4));
    Exchange_Array(4,2,2) = Exchange_Array(2,1,4);
    %TradeIndexes(2,1) = 2;
    %TradeIndexes(2,2) = 4;
    TradeIndexes(2,1) = 4;
    TradeIndexes(2,2) = 2;
    
    Exchange_Array(1,1,2) = ETH_BTC(p)*10^0;
    Exchange_Array(1,2,2) = (1/Exchange_Array(1,1,2));
    Exchange_Array(2,1,1)= (1/Exchange_Array(1,1,2));
    Exchange_Array(2,2,1) = Exchange_Array(1,1,2);
    % TradeIndexes(3,1) = 1;
    % TradeIndexes(3,2) = 2;
    TradeIndexes(3,1) = 2;
    TradeIndexes(3,2) = 1;
    
    Exchange_Array(1,1,3) = LTC_BTC(p)*10^0;
    Exchange_Array(1,2,3) = (1/Exchange_Array(1,1,3));
    Exchange_Array(3,1,1)= 1/Exchange_Array(1,1,3);
    Exchange_Array(3,2,1) = Exchange_Array(1,1,3);
    %TradeIndexes(4,1) = 1;
    %TradeIndexes(4,2) = 3;
    TradeIndexes(4,1) = 3;
    TradeIndexes(4,2) = 1;
    
    Exchange_Array(4,1,3) = LTC_BNB(p)*10^0;
    Exchange_Array(4,2,3) = (1/Exchange_Array(4,1,3));
    Exchange_Array(3,1,4)= (1/Exchange_Array(4,1,3));
    Exchange_Array(3,2,4) = Exchange_Array(4,1,3);
    % TradeIndexes(5,1) = 4;
    % TradeIndexes(5,2) = 3;
    TradeIndexes(5,1) = 3;
    TradeIndexes(5,2) = 4;
    
    Exchange_Array(2,1,3) = LTC_ETH(p)*10^0;
    Exchange_Array(2,2,3) = (1/Exchange_Array(2,1,3))*10^0;
    Exchange_Array(3,1,2)= (1/Exchange_Array(2,1,3))*10^0;
    Exchange_Array(3,2,2) = Exchange_Array(2,1,3)*10^0;
    %  TradeIndexes(6,1) = 2;
    %  TradeIndexes(6,2) = 3;
    TradeIndexes(6,1) = 3;
    TradeIndexes(6,2) = 2;
    
    Exchange_Array;
    
    %% Minimized Exchange Array
    Minimized_Exchange_Array = zeros(4,2,4);
    
    
    %% Finding the best arbetrage Opertunity
    Max_Gain_Index= zeros(6,1);
    Max_Loss_Index= zeros(4,4);
    %Max_Gain_Value= zeros(4,4);
    %Max_Loss_Value = zeros(4,4);
    BuySellCommand = zeros(3,1);
    Exchange_Array1 = Exchange_Array;
    IndexOfTradeRatio_InChosenTradeLoop = zeros(6,3);
    
    for TradePossibilityNum = 1:6
        Exchange_Array = Exchange_Array1;
        i = TradeIndexes(TradePossibilityNum,1);
        j = TradeIndexes(TradePossibilityNum,2);
        IndexOfTradeRatio_InChosenTradeLoop(TradePossibilityNum,1) = TradePossibilityNum;
        
        Exchange_Array(j,1,i) = 0;
        Exchange_Array(i,1,i) = 0;
        KillingVector = Exchange_Array(:,1,i) > 0;
        % [Max_Gain_Value(TradePossibilityNum),Max_Gain_Index(TradePossibilityNum)] = max((permute(Exchange_Array(i,2,:),[3,2,1])./Exchange_Array(:,1,j) - Exchange_Array(j,1,i))/Exchange_Array(j,1,i));
        [Max_IndirectSell_Value(TradePossibilityNum),Max_Gain_Index1(TradePossibilityNum)] = max((Exchange_Array(:,1,i).*Exchange_Array(:,2,j) - Ratio(p,TradePossibilityNum)).*KillingVector/Ratio(p,TradePossibilityNum));
        

        [Max_IndirectBuy_Value(TradePossibilityNum),Max_Gain_Index2(TradePossibilityNum)] = max(-(Exchange_Array(:,1,i).*Exchange_Array(:,2,j) - Ratio(p,TradePossibilityNum)).*KillingVector/Ratio(p,TradePossibilityNum));
        
        if Max_IndirectSell_Value(TradePossibilityNum) > Max_IndirectBuy_Value(TradePossibilityNum)
            BuySellCommand(1,TradePossibilityNum) = 1; %this means buy Direct, sell indirect
            Max_Value = Max_IndirectSell_Value(TradePossibilityNum);
            Max_Gain_Index(TradePossibilityNum) = Max_Gain_Index1(TradePossibilityNum);
        end
        if Max_IndirectSell_Value(TradePossibilityNum) < Max_IndirectBuy_Value(TradePossibilityNum)
            BuySellCommand(1,TradePossibilityNum) = -1; % this means Buy indirect, sell direct
            Max_Value = Max_IndirectBuy_Value(TradePossibilityNum);
            Max_Gain_Index(TradePossibilityNum) = Max_Gain_Index2(TradePossibilityNum);
        end
        
        % First Number are the original exchange(first digitdivided by the
        % second)
        % and the Seond and Third are the indirect exchange - same concept
        % the Forrh value is the percent gain
        
        ArbitrageOpertunity(TradePossibilityNum,:) = [(10*i + j) (10*i + Max_Gain_Index(TradePossibilityNum)) (10*Max_Gain_Index(TradePossibilityNum) + j) Max_Value];
        
        Trade2 = [ floor(ArbitrageOpertunity(TradePossibilityNum,2)/10) mod(ArbitrageOpertunity(TradePossibilityNum,2),10)];
        Trade3 = [ floor(ArbitrageOpertunity(TradePossibilityNum,3)/10) mod(ArbitrageOpertunity(TradePossibilityNum,3),10) ];
        
        if max(sum(Trade2.' == TradeIndexes.')) > 1
            BuySellCommand(2,TradePossibilityNum) = -BuySellCommand(1,TradePossibilityNum);
            [~,IndexOfTradeRatio_InChosenTradeLoop(TradePossibilityNum,2)] = max(sum(Trade2.' == TradeIndexes.') == 2);
        end
        if max(sum(Trade2.' == TradeIndexes.')) <= 1
            BuySellCommand(2,TradePossibilityNum) = BuySellCommand(1,TradePossibilityNum);
            [~,IndexOfTradeRatio_InChosenTradeLoop(TradePossibilityNum,2)] = max(sum(flipud(Trade2.') == TradeIndexes.') == 2);
        end
        if max(sum(Trade3.' == TradeIndexes.')) > 1
            BuySellCommand(3,TradePossibilityNum) = -BuySellCommand(1,TradePossibilityNum);
            [~,IndexOfTradeRatio_InChosenTradeLoop(TradePossibilityNum,3)] = max(sum(Trade3.' == TradeIndexes.') == 2);
        end
        if max(sum(Trade3.' == TradeIndexes.')) <= 1
            BuySellCommand(3,TradePossibilityNum) = BuySellCommand(1,TradePossibilityNum);
            [~,IndexOfTradeRatio_InChosenTradeLoop(TradePossibilityNum,3)] = max(sum(flipud(Trade3.') == TradeIndexes.') == 2);
        end

        %a = (CoordinationVector.*permute(Exchange_Array(i,2,:),[3,2,1])./Exchange_Array(:,1,j) - Exchange_Array(j,1,i))/Exchange_Array(j,1,i);
        % [Max_Loss_Value(i,j),Max_Loss_Index(i,j)] = a;
    end
    
    
    %Max_Gain_Index
    %Max_Gain_Value
    ArbitrageOpertunity;
    %Max_Loss_Value
    [maxOppertunity,I] = max(ArbitrageOpertunity(:,4));
    BestArbitrageOpertunity(p,:) = ArbitrageOpertunity(I,:);
    BestArbitrageOpertunity(1:p,:)
    BestTradeRatios_ForChosenLoop = IndexOfTradeRatio_InChosenTradeLoop(I,:);
    BuySellCommand = BuySellCommand(:,I);
    
    ExcecuteRecomendedArbitrage = 0;
    FoundGoodTrade =0;
    
    %% Check if the Best oppertunity from this measurement is greater than the threshold
    if BestArbitrageOpertunity(p,4) > Threshold_Percentage_Gain_TriggerForArbitrageTrade 
        
        FoundGoodTrade = 1;
        MakeArbitrageTrade = 1;
        
        ExcecuteRecomendedArbitrage = 1;
        
        SellIndex(1) = (BestArbitrageOpertunity(p,1) - mod(BestArbitrageOpertunity(p,1),10))/10;
        SellIndex(2) = mod(BestArbitrageOpertunity(p,1),10);
        for i = 1:6
            if sum(TradeIndexes(i,:) == SellIndex) ==2
                ArbitrageBuy_Sell_Recomendations(i) = -1;
                break
            end
        end
        
        BuyIndex(1,1) = (BestArbitrageOpertunity(p,2) - mod(BestArbitrageOpertunity(p,2),10))/10;
        BuyIndex(2,1) = mod(BestArbitrageOpertunity(p,2),10);
        BuyIndex(1,2) = (BestArbitrageOpertunity(p,3) - mod(BestArbitrageOpertunity(p,3),10))/10;
        BuyIndex(2,2) = mod(BestArbitrageOpertunity(p,3),10);
        
        for j = 1:2
            for i = 1:6
                if sum(TradeIndexes(i,:) == BuyIndex(j,:)) ==2
                    ArbitrageBuy_Sell_Recomendations(i) = 1;
                    break
                end
            end
        end
        
    end
    
    if maxOppertunity > M
        M = maxOppertunity;
    end