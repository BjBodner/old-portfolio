function [SuccessIndicator] = Check_If_Trade_Was_Successful

robo = java.awt.Robot;
t = java.awt.Toolkit.getDefaultToolkit();
rectangle = java.awt.Rectangle(t.getScreenSize());
image = robo.createScreenCapture(rectangle);
filehandle = java.io.File('screencapture1.jpg');
javax.imageio.ImageIO.write(image,'jpg',filehandle);
pause(0.2)

robo = java.awt.Robot;
t = java.awt.Toolkit.getDefaultToolkit();
rectangle = java.awt.Rectangle(t.getScreenSize());
image = robo.createScreenCapture(rectangle);
filehandle = java.io.File('screencapture2.jpg');
javax.imageio.ImageIO.write(image,'jpg',filehandle);
pause(0.2)

robo = java.awt.Robot;
t = java.awt.Toolkit.getDefaultToolkit();
rectangle = java.awt.Rectangle(t.getScreenSize());
image = robo.createScreenCapture(rectangle);
filehandle = java.io.File('screencapture3.jpg');
javax.imageio.ImageIO.write(image,'jpg',filehandle);
pause(0.2)

robo = java.awt.Robot;
t = java.awt.Toolkit.getDefaultToolkit();
rectangle = java.awt.Rectangle(t.getScreenSize());
image = robo.createScreenCapture(rectangle);
filehandle = java.io.File('screencapture4.jpg');
javax.imageio.ImageIO.write(image,'jpg',filehandle);
pause(0.1)

robo = java.awt.Robot;
t = java.awt.Toolkit.getDefaultToolkit();
rectangle = java.awt.Rectangle(t.getScreenSize());
image = robo.createScreenCapture(rectangle);
filehandle = java.io.File('screencapture5.jpg');
javax.imageio.ImageIO.write(image,'jpg',filehandle);
pause(0.2)

robo = java.awt.Robot;
t = java.awt.Toolkit.getDefaultToolkit();
rectangle = java.awt.Rectangle(t.getScreenSize());
image = robo.createScreenCapture(rectangle);
filehandle = java.io.File('screencapture6.jpg');
javax.imageio.ImageIO.write(image,'jpg',filehandle);
pause(0.2)

robo = java.awt.Robot;
t = java.awt.Toolkit.getDefaultToolkit();
rectangle = java.awt.Rectangle(t.getScreenSize());
image = robo.createScreenCapture(rectangle);
filehandle = java.io.File('screencapture7.jpg');
javax.imageio.ImageIO.write(image,'jpg',filehandle);
pause(0.2)

robo = java.awt.Robot;
t = java.awt.Toolkit.getDefaultToolkit();
rectangle = java.awt.Rectangle(t.getScreenSize());
image = robo.createScreenCapture(rectangle);
filehandle = java.io.File('screencapture8.jpg');
javax.imageio.ImageIO.write(image,'jpg',filehandle);
pause(0.2)

robo = java.awt.Robot;
t = java.awt.Toolkit.getDefaultToolkit();
rectangle = java.awt.Rectangle(t.getScreenSize());
image = robo.createScreenCapture(rectangle);
filehandle = java.io.File('screencapture9.jpg');
javax.imageio.ImageIO.write(image,'jpg',filehandle);
pause(0.2)

robo = java.awt.Robot;
t = java.awt.Toolkit.getDefaultToolkit();
rectangle = java.awt.Rectangle(t.getScreenSize());
image = robo.createScreenCapture(rectangle);
filehandle = java.io.File('screencapture10.jpg');
javax.imageio.ImageIO.write(image,'jpg',filehandle);
pause(0.5)

%d(:,:,:,1) = imread('screencapture1.jpg');
%d(:,:,:,2) = imread('screencapture2.jpg');
%d(:,:,:,3) = imread('screencapture3.jpg');
%d(:,:,:,4) = imread('screencapture4.jpg');
%d(:,:,:,5) = imread('screencapture5.jpg');
%d(:,:,:,6) = imread('screencapture6.jpg');
%d(:,:,:,7) = imread('screencapture7.jpg');
%d(:,:,:,8) = imread('screencapture8.jpg');
%d(:,:,:,9) = imread('screencapture9.jpg');
%d(:,:,:,10) = imread('screencapture1.jpg');

%for i = 1:4
%    imshow(d(380:400,250:430,2,3));
%    getframe(gcf);
%    pause(1)
%end

%imshow(d(380:405,255:280,2,3))

%sum(sum(d(380:405,255:280,2,3)))
%sum(sum(d(380:405,255:280,1,3)))
%imshow(d4(380:400,250:430,2))
% Green should be the second index

d = imread('screencapture1.jpg');
GreenSumFunction(1) = sum(sum(d(380:405,255:280,2)));
RedSumFunction(1) = sum(sum(d(380:405,255:280,1)));
%pause(0.2)

d = imread('screencapture2.jpg');
GreenSumFunction(2) = sum(sum(d(380:405,255:280,2)));
RedSumFunction(2) = sum(sum(d(380:405,255:280,1)));
%pause(0.2)

d = imread('screencapture3.jpg');
GreenSumFunction(3) = sum(sum(d(380:405,255:280,2)));
RedSumFunction(3) = sum(sum(d(380:405,255:280,1)));
%pause(0.2)

d = imread('screencapture4.jpg');
GreenSumFunction(4) = sum(sum(d(380:405,255:280,2)));
RedSumFunction(4) = sum(sum(d(380:405,255:280,1)));
%pause(0.2)

d = imread('screencapture5.jpg');
GreenSumFunction(5) = sum(sum(d(380:405,255:280,2)));
RedSumFunction(5) = sum(sum(d(380:405,255:280,1)));
%pause(0.2)

d = imread('screencapture6.jpg');
GreenSumFunction(6) = sum(sum(d(380:405,255:280,2)));
RedSumFunction(6) = sum(sum(d(380:405,255:280,1)));
%pause(0.2)

d = imread('screencapture7.jpg');
GreenSumFunction(7) = sum(sum(d(380:405,255:280,2)));
RedSumFunction(7) = sum(sum(d(380:405,255:280,1)));
%pause(0.2)

d = imread('screencapture8.jpg');
GreenSumFunction(8) = sum(sum(d(380:405,255:280,2)));
RedSumFunction(8) = sum(sum(d(380:405,255:280,1)));
%pause(0.2)

d = imread('screencapture9.jpg');
GreenSumFunction(9) = sum(sum(d(380:405,255:280,2)));
RedSumFunction(9) = sum(sum(d(380:405,255:280,1)));
%pause(0.2)

d = imread('screencapture10.jpg');
GreenSumFunction(10) = sum(sum(d(380:405,255:280,2)));
RedSumFunction(10) = sum(sum(d(380:405,255:280,1)));
%pause(0.2)

GreenKillingVector = (GreenSumFunction > 160560).*(GreenSumFunction < 160590);
RedKillingVector = (RedSumFunction > 155190).*(RedSumFunction < 155230);

%MinMax_Green = max(GreenSumFunction) - min(GreenSumFunction);
%MinMax_Red = max(RedSumFunction) - min(RedSumFunction);

SuccessIndicator = 0;
if sum((GreenKillingVector).*RedKillingVector) >= 1
        SuccessIndicator = 1;
end
SuccessIndicator
if SuccessIndicator == 0
    a = 1;
end