import java.awt.Robot;
import java.awt.event.*;
mouse = Robot;
pause(5)

Buy_Sell = 1;


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

if SuccessIndicator == 0
    [SuccessIndicator] = Check_If_Trade_Was_Successful;
end

if SuccessIndicator == 0
    [SuccessIndicator] = Check_If_Trade_Was_Successful;
end

SuccessIndicator