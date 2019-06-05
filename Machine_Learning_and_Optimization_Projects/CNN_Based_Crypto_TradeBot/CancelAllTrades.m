function CancelAllTrades

import java.awt.Robot;
import java.awt.event.*;
mouse = Robot;

%% Cancel All Trades
pause(2)
mouse.mouseMove(675, 700); % this needs to be 
for i = 1:3
mouse.mousePress(InputEvent.BUTTON1_MASK);    %%left click press
mouse.mouseRelease(InputEvent.BUTTON1_MASK);
pause(0.2)
end


pause(0.2)
mouse.mouseMove(610, 640); 
mouse.mousePress(InputEvent.BUTTON1_MASK);    %%left click press
mouse.mouseRelease(InputEvent.BUTTON1_MASK);

pause(2)
robo = java.awt.Robot;
t = java.awt.Toolkit.getDefaultToolkit();
rectangle = java.awt.Rectangle(t.getScreenSize());
image = robo.createScreenCapture(rectangle);
filehandle = java.io.File('screencapture1.jpg');
javax.imageio.ImageIO.write(image,'jpg',filehandle);
pause(0.2)

d = imread('screencapture1.jpg');

GreenSumFunction(1) = sum(sum(d(405:430,255:325,2)));
RedSumFunction(1) = sum(sum(d(405:430,255:325,1)));
BlueSumFunction(1) = sum(sum(d(405:430,255:325,3)));




Green_Go = (GreenSumFunction > 336860)*(GreenSumFunction < 336890);
Red_Go = (RedSumFunction > 429000)*(RedSumFunction < 429800);
Blue_Go = (BlueSumFunction > 108610)*(BlueSumFunction < 108660);

if Green_Go+Red_Go+Blue_Go >= 1
    mouse.mouseMove(300, 420);
    pause(0.2)
    mouse.mousePress(InputEvent.BUTTON1_MASK);    %%left click press
    mouse.mouseRelease(InputEvent.BUTTON1_MASK);
    pause(0.2)
    mouse.mousePress(InputEvent.BUTTON1_MASK);    %%left click press
    mouse.mouseRelease(InputEvent.BUTTON1_MASK);
end

pause(5)

mouse.mouseMove(675, 80); % this needs to be 
for i = 1:4
mouse.mousePress(InputEvent.BUTTON1_MASK);    %%left click press
mouse.mouseRelease(InputEvent.BUTTON1_MASK);
pause(0.2)
end