function[SuccessIndicator] = SellOnWebsite(Buy_Sell,AmountToTrade,NumberOfTradeRatio)

%0.302 LTC
%Buy with 0.09 LTC - Buy BNB
      %  NumberOfTradeRatio = 4;
      %  AmountToTrade = 0.08;
      %  Buy_Sell = -1;
%% Select the Trading Ratio
% MoveMouseTo select the 1 Trade Ratio
import java.awt.Robot;
import java.awt.event.*;
mouse = Robot;



% MoveMouseTo select the 1 Trade Ratio
if NumberOfTradeRatio == 1
    mouse.mouseMove(500, 235);
end
% MoveMouseTo select the 2 Trade Ratio
if NumberOfTradeRatio == 2
    mouse.mouseMove(500, 255);
end
% MoveMouseTo select the 3 Trade Ratio
if NumberOfTradeRatio == 3
    mouse.mouseMove(500, 270);
end
% MoveMouseTo select the 4 Trade Ratio
if NumberOfTradeRatio == 4
    mouse.mouseMove(500, 285);
end
% MoveMouseTo select the 5 Trade Ratio
if NumberOfTradeRatio == 5
    mouse.mouseMove(500, 300);
end
% MoveMouseTo select the 6 Trade Ratio
if NumberOfTradeRatio == 6
    mouse.mouseMove(500, 315);
end

mouse.mousePress(InputEvent.BUTTON1_MASK);    %%left click press
mouse.mouseRelease(InputEvent.BUTTON1_MASK);   %%left click release

%% Click on the Buy/sell input Amount window
if Buy_Sell == 1 %% this clicks the buy input box
mouse.mouseMove(110, 610);
end

if Buy_Sell == -1 %% this the clicks sell input box
mouse.mouseMove(310, 610);
end
mouse.mousePress(InputEvent.BUTTON1_MASK);    %%left click press
mouse.mouseRelease(InputEvent.BUTTON1_MASK);   %%left click release
%mouse.mousePress(InputEvent.BUTTON1_MASK);    %%left click press
%mouse.mouseRelease(InputEvent.BUTTON1_MASK);   %%left click release


%% Input the amount to sell into the window

robot = java.awt.Robot;
for k = 1:5
    if k == 3
        robot.keyPress(java.awt.event.KeyEvent.VK_DECIMAL);
        robot.keyRelease(java.awt.event.KeyEvent.VK_DECIMAL);
    end  
    PressDigit(floor(mod(AmountToTrade/10^(2-k),10)),robot);
end

% this waits for website to take the input
pause(1.5 + 0.5*rand(1,1))


%% Clock on the sell button
if Buy_Sell == 1 % this clicks the buy button
    
    mouse.mouseMove(110, 700);
end

if Buy_Sell == -1 % this clicks the sell button
mouse.mouseMove(310, 700);
end


mouse.mousePress(InputEvent.BUTTON1_MASK);    %%left click press
mouse.mouseRelease(InputEvent.BUTTON1_MASK);   %%left click release


%% The Best thing will be if this does a screen capture to verify the "
% "Sucess" in the middle of the screen

%pause(2+0.5*rand(1,1))
%SuccessIndicator = 1;

[SuccessIndicator] = Check_If_Trade_Was_Successful;

if SuccessIndicator == 0
    [SuccessIndicator] = Check_If_Trade_Was_Successful;
end

%if SuccessIndicator == 0
%    [SuccessIndicator] = Check_If_Trade_Was_Successful;
%end

%if SuccessIndicator == 0
%    [SuccessIndicator] = Check_If_Trade_Was_Successful;
%end
