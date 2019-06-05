function [BTC_USDT,ETH_USDT,LTC_USDT,BNB_USDT] = GetCurrentUSDT_Ratios()

%BTC_USDT = 9515;
%ETH_USDT = 1100;
%LTC_USDT = 152;
%BNB_USDT = 9.7;


%% Click On the USDT Tab on the right screen
import java.awt.Robot;
import java.awt.event.*;
mouse = Robot;
mouse.mouseMove(1320, 255); % this needs to be 
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
        BCC_USDT_Image = GreyImage(353:367,1060:1250,1);
        BNB_USDT_Image = GreyImage(380:394,1060:1250,1);
        BTC_USDT_Image = GreyImage(407:421,1060:1250,1);
        ETH_USDT_Image = GreyImage(433:447,1060:1250,1);
        LTC_USDT_Image = GreyImage(459:473,1060:1250,1);
        NEO_USDT_Image = GreyImage(486:500,1060:1250,1);
        end
        
        UseNewPixelCooredinates = 1;
        if UseNewPixelCooredinates == 1
        BCC_USDT_Image = GreyImage(346:360,1060:1250,1);
        BNB_USDT_Image = GreyImage(374:388,1060:1250,1);
        BTC_USDT_Image = GreyImage(400:414,1060:1250,1);
        ETH_USDT_Image = GreyImage(426:440,1060:1250,1);
        LTC_USDT_Image = GreyImage(452:466,1060:1250,1);
        NEO_USDT_Image = GreyImage(478:492,1060:1250,1);
        end
  %  imshow(BCC_USDT_Image)
  %  imshow(BNB_USDT_Image)
  %  imshow(BTC_USDT_Image)
  %  imshow(ETH_USDT_Image)
  %  imshow(LTC_USDT_Image)
  %  imshow(NEO_USDT_Image)
    
    
    %% Reading the Values Of USDT Ratios
    % Reading the image of the BTC Ratio
    [BTC_USDTRatio(1),TotalConfidence(1)] = USD_DigitReader_1000_10000(BTC_USDT_Image);
    [BTC_USDTRatio(2),TotalConfidence(2)] = USD_DigitReader_10000_100000(BTC_USDT_Image);
    [~,I] = max(TotalConfidence);
    BTC_USDT = BTC_USDTRatio(I)/10^7;
    
    % Reading the image of the ETH Ratio
    [ETH_USDTRatio(1),TotalConfidence(1)] = USD_DigitReader_100_1000(ETH_USDT_Image);
    [ETH_USDTRatio(2),TotalConfidence(2)] = USD_DigitReader_1000_10000(ETH_USDT_Image);
    [~,I] = max(TotalConfidence);
    ETH_USDT = ETH_USDTRatio(I)/10^7;
    
    % Reading the image of the LTC Ratio
    %[LTC_USDTRatio(1),TotalConfidence(1)] = USD_DigitReader_10_100(LTC_USDT_Image);
    [LTC_USDTRatio(2),TotalConfidence(2)] = USD_DigitReader_100_1000(LTC_USDT_Image);
    [LTC_USDTRatio(3),TotalConfidence(3)] = USD_DigitReader_1000_10000(LTC_USDT_Image);
    [~,I] = max(TotalConfidence);
    LTC_USDT = LTC_USDTRatio(I)/10^7;
    
    TotalConfidence = 0;
    
    [BNB_USDTRatio(1),TotalConfidence(1)] = USD_DigitReader_1_10(BNB_USDT_Image);
    [BNB_USDTRatio(2),TotalConfidence(2)] = USD_DigitReader_10_100(BNB_USDT_Image);
    [~,I] = max(TotalConfidence);
    BNB_USDT = BNB_USDTRatio(I)/10^7;
    
    ExamineOutput = 0;
    
    if ExamineOutput == 1
    imshow(BTC_USDT_Image)
    BTC_USDT
    imshow(ETH_USDT_Image)
    ETH_USDT 
    imshow(LTC_USDT_Image)
   LTC_USDT 
   imshow(BNB_USDT_Image)
BNB_USDT
    end
    
    
mouse.mouseMove(1070, 255); % this needs to be 
mouse.mousePress(InputEvent.BUTTON1_MASK);    %%left click press
mouse.mouseRelease(InputEvent.BUTTON1_MASK);   %%left click release
pause(1)
    