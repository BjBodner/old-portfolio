function [BNB_BTC,BNB_ETH,ETH_BTC,LTC_BTC,LTC_BNB,LTC_ETH] = GetCurrent_Favorites_Ratios()



%BTC_USDT = 9515;
%ETH_USDT = 1100;
%LTC_USDT = 152;
%BNB_USDT = 9.7;


%% Click On the USDT Tab on the right screen
import java.awt.Robot;
import java.awt.event.*;
mouse = Robot;

RefreshNeeded = 0;
if RefreshNeeded == 1
    mouse.mouseMove(760, 75); % this needs to be 
    mouse.mousePress(InputEvent.BUTTON1_MASK);    %%left click press
    mouse.mouseRelease(InputEvent.BUTTON1_MASK);
    pause(5)
end



%% Move to right of screen
mouse.mouseMove(1320, 715); % this needs to be 
mouse.mousePress(InputEvent.BUTTON1_MASK);    %%left click press
mouse.mouseRelease(InputEvent.BUTTON1_MASK);   %%left click release
pause(1)

%% Click on Favorites
mouse.mouseMove(1070, 255); % this needs to be 
mouse.mousePress(InputEvent.BUTTON1_MASK);    %%left click press
mouse.mouseRelease(InputEvent.BUTTON1_MASK);   %%left click release
pause(1)

%% Take Screen Capture
        robo = java.awt.Robot;
        t = java.awt.Toolkit.getDefaultToolkit();
        rectangle = java.awt.Rectangle(t.getScreenSize());
        image = robo.createScreenCapture(rectangle);
        filehandle = java.io.File('screencapture.jpg');
        javax.imageio.ImageIO.write(image,'jpg',filehandle);
        
        
        
        %% Chop into slices for each ratio
            d = imread('screencapture.jpg');
    
    GreyImage = rgb2gray(d);
        UseOldPixelCooredinates = 0;
        if UseOldPixelCooredinates == 1
        BNB_BTC_Image = GreyImage(353:367,1060:1250,1);
        BNB_ETH_Image = GreyImage(380:394,1060:1250,1);
        ETH_BTC_Image = GreyImage(407:421,1060:1250,1);
        LTC_BTC_Image = GreyImage(433:447,1060:1250,1);
        LTC_BNB_Image = GreyImage(459:473,1060:1250,1);
        LTC_ETH_Image = GreyImage(486:500,1060:1250,1);
        end
        
        UseNewPixelCooredinates = 1;
        if UseNewPixelCooredinates == 1
        BNB_BTC_Image = GreyImage(346:360,1060:1250,1);
        BNB_ETH_Image = GreyImage(374:388,1060:1250,1);
        ETH_BTC_Image = GreyImage(400:414,1060:1250,1);
        LTC_BTC_Image = GreyImage(426:440,1060:1250,1);
        LTC_BNB_Image = GreyImage(452:466,1060:1250,1);
        LTC_ETH_Image = GreyImage(478:492,1060:1250,1);
        end
  %  imshow(BNB_BTC_Image)
  %  imshow(BNB_ETH_Image)
  %  imshow(ETH_BTC_Image)
  %  imshow(LTC_BTC_Image)
  %  imshow(LTC_BNB_Image)
  %  imshow(LTC_ETH_Image)
    
    
    %% Reading the Values Of USDT Ratios
        TotalConfidence = 0;
    
    % Reading the image of the BNB_BTC Ratio
    [BNB_BTCRatio(1),TotalConfidence(1)] = USD_DigitReader_1_10(BNB_BTC_Image);
    [~,I] = max(TotalConfidence);
    BNB_BTC = BNB_BTCRatio(I)/10^7;
    
        TotalConfidence = 0;
    
    % Reading the image of the BNB_ETH Ratio
    [BNB_ETHRatio(1),TotalConfidence(1)] = USD_DigitReader_1_10(BNB_ETH_Image);
    [~,I] = max(TotalConfidence);
    BNB_ETH = BNB_ETHRatio(I)/10^7;
    
    TotalConfidence = 0;
    
    % Reading the image of the ETH_BTC Ratio
    [ETH_BTCRatio(1),TotalConfidence(1)] = USD_DigitReader_1_10(ETH_BTC_Image);
    [~,I] = max(TotalConfidence);
    ETH_BTC = ETH_BTCRatio(I)/10^7;
    
    TotalConfidence = 0;
    
    % Reading the image of the LTC_BTC Ratio
    [LTC_BTCatio(1),TotalConfidence(1)] = USD_DigitReader_1_10(LTC_BTC_Image);
    [~,I] = max(TotalConfidence);
    LTC_BTC = LTC_BTCatio(I)/10^7;
    
    TotalConfidence = 0;
    
    % Reading the image of the LTC_BNB Ratio
    [LTC_BNBRatio(1),TotalConfidence(1)] = USD_DigitReader_1_10(LTC_BNB_Image);
    [LTC_BNBRatio(2),TotalConfidence(2)] = USD_DigitReader_10_100(LTC_BNB_Image);
    [~,I] = max(TotalConfidence);
    LTC_BNB = LTC_BNBRatio(I)/10^7;
    
    TotalConfidence = 0;
    
    % Reading the image of the LTC_ETH Ratio
    [LTC_ETHRatio(1),TotalConfidence(1)] = USD_DigitReader_1_10(LTC_ETH_Image);
    [~,I] = max(TotalConfidence);
    LTC_ETH = LTC_ETHRatio(I)/10^7;
    
    ExamineOutput = 1;
    
    if ExamineOutput == 1
    imshow(BNB_BTC_Image)
    BNB_BTC
    imshow(BNB_ETH_Image)
    BNB_ETH
    imshow(ETH_BTC_Image)
    ETH_BTC
    imshow(LTC_BTC_Image)
    LTC_BTC
    imshow(LTC_BNB_Image)
   LTC_BNB
   imshow(LTC_ETH_Image)
    LTC_ETH
    end
    
    
%mouse.mouseMove(1070, 255); % this needs to be 
%mouse.mousePress(InputEvent.BUTTON1_MASK);    %%left click press
%mouse.mouseRelease(InputEvent.BUTTON1_MASK);   %%left click release
%pause(1)
    