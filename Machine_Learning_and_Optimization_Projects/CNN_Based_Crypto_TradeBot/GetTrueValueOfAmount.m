function [TotalUSD,TotalBTC] = GetTrueValueOfAmount


import java.awt.Robot;
import java.awt.event.*;
mouse = Robot;

%% Click On the Funds
mouse.mouseMove(1000, 235); % this needs to be 
%% Click On The Balances
mouse.mouseMove(1000, 235); % this needs to be 

pause(3)
%% Click on the zoom up to 125 percent


%% Take picture of screen
        robo = java.awt.Robot;
        t = java.awt.Toolkit.getDefaultToolkit();
        rectangle = java.awt.Rectangle(t.getScreenSize());
        image = robo.createScreenCapture(rectangle);
        filehandle = java.io.File('screencapture.jpg');
        javax.imageio.ImageIO.write(image,'jpg',filehandle);
            d = imread('screencapture.jpg');
    GreyImage = rgb2gray(d);
    
    
% Read the Amount of USD I have
TotalUSDImage = GreyImage(353:367,1060:1250,1); % I need to change these
TotalUSD = BNB_ETH_DigitReader(TotalUSDImage);
% Read the amount Of Total BTCValue I have
TotalBTCImage = GreyImage(353:367,1060:1250,1); % I need to change these
TotalBTC = BNB_ETH_DigitReader(TotalBTCImage);

