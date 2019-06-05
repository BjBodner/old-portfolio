function [BTC_Amount,ETH_Amount,TeatherUSDT_Amount,LTC_Amount,BNB_Amount] = Get_True_Individual_Amounts

import java.awt.Robot;
import java.awt.event.*;
mouse = Robot;

%% Move the left screen to the left
%mouse.mouseMove(640, 720); % this needs to be theleft side of the bar below
 
mouse.mouseMove(40, 720);
mouse.mousePress(InputEvent.BUTTON1_MASK);
mouse.mouseRelease(InputEvent.BUTTON1_MASK);
mouse.mouseMove(40, 720);
mouse.mousePress(InputEvent.BUTTON1_MASK);
mouse.mouseRelease(InputEvent.BUTTON1_MASK);

pause(1)

[BNB_Amount,LTC_Amount,ETH_Amount,TeatherUSDT_Amount,BTC_Amount,TotalConfidence] = Individual_Amounts_Reader()

a = 1;
%% Take Picture Of Amounts
   %     robo = java.awt.Robot;
   %     t = java.awt.Toolkit.getDefaultToolkit();
   %     rectangle = java.awt.Rectangle(t.getScreenSize());
   %     image = robo.createScreenCapture(rectangle);
  %      filehandle = java.io.File('screencapture.jpg');
  %      javax.imageio.ImageIO.write(image,'jpg',filehandle);
  %      d = imread('screencapture.jpg');
  %      GreyImage = rgb2gray(d);
    
  %  imshow(GreyImage(604:629,50:540,1))
%% Read The True Values Of The amounts
  %  BNB_Image = GreyImage(435:460,50:540,1);
  %  LTC_Image = GreyImage(475:500,50:540,1);
   % ETH_Image = GreyImage(518:543,50:540,1);
  %  TeatherUSD_Image = GreyImage(561:586,50:540,1);
  %  BTC_Image = GreyImage(604:629,50:540,1);




    
    % Maybe create new digit readers that will match the decimal point
    
   % [BTC_Amount] = BNB_ETH_DigitReader(BTC_Image);
   % [ETH_Amount] = BNB_ETH_DigitReader(ETH_Image);
   % [TeatherUSDT_Amount] = LTC_BNB_DigitReader(TeatherUSD_Image);
   % [LTC_Amount] = BNB_ETH_DigitReader(LTC_Image);
   % [BNB_Amount] = LTC_BNB_DigitReader(BNB_Image);
    
    
    
%% Click on the zoom out to 80 percent
mouse.mouseMove(660, 60); % this needs to be 
mouse.mousePress(InputEvent.BUTTON1_MASK);    %%left click press
mouse.mouseRelease(InputEvent.BUTTON1_MASK);   %%left click release


pause(0.2)
mouse.mouseMove(530, 215); % this needs to be moved to the plus location
Zoom80 = 0;
k = 1;
while Zoom80 ~= 1
    mouse.mousePress(InputEvent.BUTTON1_MASK);    %%left click press
mouse.mouseRelease(InputEvent.BUTTON1_MASK);   %%left click release
pause(0.2)

robo = java.awt.Robot;
t = java.awt.Toolkit.getDefaultToolkit();
rectangle = java.awt.Rectangle(t.getScreenSize());
image = robo.createScreenCapture(rectangle);
filehandle = java.io.File('screencapture.jpg');
javax.imageio.ImageIO.write(image,'jpg',filehandle);
pause(0.2)

d = imread('screencapture.jpg');
imshow(d(210:225,550:600,1))
sum(sum(d(210:225,550:600,1)))

if sum(sum(d(210:225,550:600,1))) >186540
    if sum(sum(d(210:225,550:600,1))) <186560
        Zoom80 = 1;
        break
    end
end

k = k+1;
if k > 15
    error =[1 2]
    a = error(3)
end
end


%% Return to Market
% press market
    mouse.mouseMove(200, 135); % this needs to be 
pause(0.2)

%press Basic
mouse.mouseMove(200, 120);
pause(0.2)
%    mouse.mousePress(InputEvent.BUTTON1_MASK);    %%left click press
%mouse.mouseRelease(InputEvent.BUTTON1_MASK);   %%left click release
mouse.mouseMove(200, 150);
    mouse.mousePress(InputEvent.BUTTON1_MASK);    %%left click press
mouse.mouseRelease(InputEvent.BUTTON1_MASK);   %%left click release

pause (15)
% press the ok for translation button
mouse.mouseMove(400, 90); % this needs to be 
mouse.mousePress(InputEvent.BUTTON1_MASK);    %%left click press
mouse.mouseRelease(InputEvent.BUTTON1_MASK);   %%left click release

pause (1)
% move the left screen all the way to the right
mouse.mouseMove(640, 720); % this needs to be theleft side of the bar below
mouse.mousePress(InputEvent.BUTTON1_MASK); 
mouse.mouseRelease(InputEvent.BUTTON1_MASK);%%left click release
mouse.mouseMove(640, 720); % this needs to be theleft side of the bar below
mouse.mousePress(InputEvent.BUTTON1_MASK); 
mouse.mouseRelease(InputEvent.BUTTON1_MASK); 

pause(1)
% Press Favorites
mouse.mouseMove(505, 170);
mouse.mousePress(InputEvent.BUTTON1_MASK); 
mouse.mouseRelease(InputEvent.BUTTON1_MASK);

