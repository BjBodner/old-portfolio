function [TotalUSD,TotalBTC] = Get_True_Total_Amount()


import java.awt.Robot;
import java.awt.event.*;
mouse = Robot;

%% Click On the Funds
mouse.mouseMove(270, 105);
pause(0.2)
mouse.mouseMove(270, 125);% this needs to be 
mouse.mousePress(InputEvent.BUTTON1_MASK);    %%left click press
mouse.mouseRelease(InputEvent.BUTTON1_MASK);   %%left click release

pause(8)
%% Click on the zoom up to 133 percent
mouse.mouseMove(660, 60); % this needs to be 
mouse.mousePress(InputEvent.BUTTON1_MASK);    %%left click press
mouse.mouseRelease(InputEvent.BUTTON1_MASK);   %%left click release

pause(0.2)
mouse.mouseMove(620, 215); % this needs to be moved to the plus location
Zoom133= 0;
k= 0;
while Zoom133 ~= 1
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
%imshow(d(210:225,550:600,1))
%sum(sum(d(210:225,550:600,1)))

if sum(sum(d(210:225,550:600,1))) >186220
    if sum(sum(d(210:225,550:600,1))) <186250
        Zoom133 = 1;
        break
    end
end
k = k+1;
if k > 15
    error =[1 2]
    a = error(3)
end
end

%% move the left screen all the way to the right
mouse.mouseMove(640, 720); % this needs to be theleft side of the bar below
mouse.mousePress(InputEvent.BUTTON1_MASK); 
mouse.mouseRelease(InputEvent.BUTTON1_MASK);%%left click release
mouse.mouseMove(640, 720); % this needs to be theleft side of the bar below
mouse.mousePress(InputEvent.BUTTON1_MASK); 
mouse.mouseRelease(InputEvent.BUTTON1_MASK); 

pause(1)
%% Take picture of screen
        robo = java.awt.Robot;
        t = java.awt.Toolkit.getDefaultToolkit();
        rectangle = java.awt.Rectangle(t.getScreenSize());
        image = robo.createScreenCapture(rectangle);
        filehandle = java.io.File('screencapture.jpg');
        javax.imageio.ImageIO.write(image,'jpg',filehandle);
        d = imread('screencapture.jpg');
        GreyImage = rgb2gray(d);
        
   % Digit = GreyImage(442:456,241:249,1);
   % imshow(Digit)
    BTC_and_USDImage = GreyImage(320:340,430:670,1);

imshow(BTC_and_USDImage)

%Get Total USD and BTC Amount
[TotalBTC,TotalUSD,TotalConfidence] = Total_BTC_USD_Reader(BTC_and_USDImage)

