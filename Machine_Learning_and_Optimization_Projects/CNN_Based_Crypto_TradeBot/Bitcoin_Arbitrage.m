clear
M = 0
%figure
pause(5)
%% This program looks at binance.com, at a zoom of 125%

%% Openning Coin/USDT values
BTC_USDT = 9515;
ETH_USDT = 1100;
LTC_USDT = 152;
BNB_USDT = 9.7;


BTC_Amount = 0.002966
ETH_Amount = 0.03207
LTC_Amount = 0.3709
BNB_Amount = 2.06


%BTC_Amount = 20/BTC_USDT;
%ETH_Amount = 20/ETH_USDT;
%LTC_Amount = 20/LTC_USDT;
%BNB_Amount = 20/BNB_USDT;
AmountOfDollarsToTrade = 25;

%BTC_Amount = AmountOfDollarsToTrade/BTC_USDT
%ETH_Amount = AmountOfDollarsToTrade/ETH_USDT
%LTC_Amount = AmountOfDollarsToTrade/LTC_USDT
%BNB_Amount = AmountOfDollarsToTrade/BNB_USDT



Amount(1) = BTC_Amount;
Amount(2) = ETH_Amount;
Amount(3) = LTC_Amount;
Amount(4) = BNB_Amount;

OpenCases = zeros(1,6);
p = 1;


    Total_USDT_Equivalent(p) = Amount(1)*BTC_USDT + Amount(2)*ETH_USDT  + Amount(3)*LTC_USDT + Amount(4)*BNB_USDT;
    Total_USDT_Equivalent(p)
    plot(Total_USDT_Equivalent);
    title(['Totla Amount in USDT: ' num2str(Total_USDT_Equivalent(p)) 'Dollars'])


PreAlocate = 1;
disagreement = 0;
Buy_Sell_Recomendations = zeros(1,6);
ArbitrageBuy_Sell_Recomendations = zeros(1,6);
NumberOfMeasurements = 1800;
AverageSlope = zeros(6,NumberOfMeasurements);
PossitiveAverageSlopes= zeros(6,NumberOfMeasurements);
NegativeAverageSlopes= zeros(6,NumberOfMeasurements);
if PreAlocate == 1
    BestArbitrageOpertunity = zeros(NumberOfMeasurements,4);
    BNB_BTC = zeros(NumberOfMeasurements,1);
    BNB_ETH = zeros(NumberOfMeasurements,1);
    ETH_BTC = zeros(NumberOfMeasurements,1);
    LTC_BTC = zeros(NumberOfMeasurements,1);
    LTC_BNB = zeros(NumberOfMeasurements,1);
    LTC_ETH = zeros(NumberOfMeasurements,1);
    DateTime_Number_Vector = zeros(NumberOfMeasurements,1);
end
while p <= 1800
    tic
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
    if BestArbitrageOpertunity(p,4) > 0.0035
        
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
    %% Marking the time of the measurement
    t = datetime('now');
    DateNumber = datenum(t);
    
    DateTime_Char_Vector(p) = t;
    DateTime_Number_Vector(p) = DateNumber;
    
    toc
    %% Three types of arbitrage - insite arbitrage and between site arbitrage, and both
    
    %% In-site trading:
    % create NN for reading the digits of all ratios of exchanges and look
    % for indirect trading between coins, to see if it is possible to make
    % a profit for a 2,3,4 step conversion between coins.
    
    % The key factor here is the exchange fee which only makes trading
    % profitable above a certain value of trade
    % Another factor is how much time is that arbitrage window open - if it
    % closes before the final transaction is closed then, it sucks
    
    % Highly varying coins will b good for this kind of arbitrage, as they
    % may have large margins, which will not equalize very quickly because
    % they are low value
    
    
    %% Between site trading:
    % Create NN for multiple sites and find margins that open up between
    % exchanges in the Far east and in the US. make a vector with all the
    % values, and just do max-min. Because of the screen capture - probably
    % about 10 sites can be viewed simultaniously, 5 in the east, and 5 in
    % the west. the money will be made on a single coin, and the
    % differences in it between different exchanges
    
    % The main difficulty with this strategy is that to make a trade, one
    % needs to teach the computer all the digits in all the sites. as well
    % as the buy/sell mouse sequence for each site
    
    
    %% Multi-Coin Multi-Site (both in site and between site trading)
    % this is pretty straight forward, but a lot of work. Make NN to read
    % multiple coin values on mltiple sites. then collect these values into
    % vectors for each coin. this will be a matrix.
    % I can then calculate the best single coin trade between different
    % exchanges
    % Better yet I can then calculate the best 2 step Trade between
    % exchanges
    % this can also be expanded to 3 step trades - which may provide the
    % best profit - because it is the most comptationally expensive and
    % thus will not be accessable to most people without such algorithms
    
    
    [OpenCases,Buy_Sell_Recomendations_FromRareSpikes,FoundGoodTrade,MakeRareSpikesTrade,AverageSlope,PossitiveAverageSlopes,NegativeAverageSlopes] = RareSpikesDetector(Ratio,OpenCases,FoundGoodTrade,AverageSlope,PossitiveAverageSlopes,NegativeAverageSlopes);
    Buy_Sell_Recomendations_FromRareSpikes
    
    % it will be best to combine the recomendationa from the arbitrage and
    % from the RareSpikesDetector, that way I won't have to pay fees twice.
    
    
    if FoundGoodTrade == 1
    [Amount,Buy_Sell_Recomendations,ArbitrageBuy_Sell_Recomendations] = ExcecuteRecomeded_Trades(Amount,Ratio,Buy_Sell_Recomendations_FromRareSpikes,TradeIndexes,ArbitrageBuy_Sell_Recomendations,BuySellCommand,BestTradeRatios_ForChosenLoop,MakeRareSpikesTrade,MakeArbitrageTrade);
    Amount
    pause(30);
    end
    Total_USDT_Equivalent(p) = Amount(1)*BTC_USDT + Amount(2)*ETH_USDT  + Amount(3)*LTC_USDT + Amount(4)*BNB_USDT;
    Total_USDT_Equivalent(p)
    plot(Total_USDT_Equivalent),'-s';
    title(['Totla Amount in USDT: ' num2str(Total_USDT_Equivalent(p)) 'Dollars'])
    getframe(gcf);
    p = p+1;
    pause(5)
    
end



save('Binance_Data_Every5Sec_0930_13_1_18','DateTime_Char_Vector','DateTime_Number_Vector','BNB_BTC',...
    'BNB_ETH','ETH_BTC','ETH_BTC',...
    'LTC_BTC','LTC_BNB','LTC_ETH','BestArbitrageOpertunity')

%a = load('BitcoinData_4_1.mat')

%save('Number8','BitcoinDigit1')

