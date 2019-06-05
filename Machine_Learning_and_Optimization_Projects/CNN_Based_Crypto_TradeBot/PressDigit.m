function [] = PressDigit(Digit,robot)

if Digit == 0
    robot.keyPress(java.awt.event.KeyEvent.VK_0);
    robot.keyRelease(java.awt.event.KeyEvent.VK_0);
end

if Digit == 1
    robot.keyPress(java.awt.event.KeyEvent.VK_1);
    robot.keyRelease(java.awt.event.KeyEvent.VK_1);
end

if Digit == 2
    robot.keyPress(java.awt.event.KeyEvent.VK_2);
    robot.keyRelease(java.awt.event.KeyEvent.VK_2);
end

if Digit == 3
    robot.keyPress(java.awt.event.KeyEvent.VK_3);
    robot.keyRelease(java.awt.event.KeyEvent.VK_3);
end

if Digit == 4
    robot.keyPress(java.awt.event.KeyEvent.VK_4);
    robot.keyRelease(java.awt.event.KeyEvent.VK_4);
end

if Digit == 5
    robot.keyPress(java.awt.event.KeyEvent.VK_5);
    robot.keyRelease(java.awt.event.KeyEvent.VK_5);
end

if Digit == 6
    robot.keyPress(java.awt.event.KeyEvent.VK_6);
    robot.keyRelease(java.awt.event.KeyEvent.VK_6);
end

if Digit == 7
    robot.keyPress(java.awt.event.KeyEvent.VK_7);
    robot.keyRelease(java.awt.event.KeyEvent.VK_7);
end

if Digit == 8
    robot.keyPress(java.awt.event.KeyEvent.VK_8);
    robot.keyRelease(java.awt.event.KeyEvent.VK_8);
end

if Digit == 9
    robot.keyPress(java.awt.event.KeyEvent.VK_9);
    robot.keyRelease(java.awt.event.KeyEvent.VK_9);
end