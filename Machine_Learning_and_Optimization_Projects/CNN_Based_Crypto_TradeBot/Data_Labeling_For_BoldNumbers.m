clear
repeat = 0;
k = 1;

import java.awt.Robot;
import java.awt.event.*;
mouse = Robot;


%% this is for the bold letters in Binance at 133% zoom

while repeat ~= 1
robo = java.awt.Robot;
t = java.awt.Toolkit.getDefaultToolkit();
rectangle = java.awt.Rectangle(t.getScreenSize());
image = robo.createScreenCapture(rectangle);
filehandle = java.io.File('screencapture.jpg');
javax.imageio.ImageIO.write(image,'jpg',filehandle);
%imageview('screencapture.jpg');

d = imread('screencapture.jpg');

GreyImage = rgb2gray(d);

BTC_and_USDImage = GreyImage(320:340,430:670,1);

imshow(BTC_and_USDImage)
%for n = 10:14
%imshow(BTC_and_USDImage(:,165 + (n-9)*10 + (n>12)*5 + floor(n/3):175 +(n-9)*10 + (n>12)*5 + floor(n/3)))
%n
%pause(0.2)
%end

%BitcoinImage = GreyImage(615:650,720:815,1);
%imshow(BitcoinImage);

%LTCImage = GreyImage(615:650,815:900,1);
%imshow(LTCImage);

for n = 1:14
    n
  if n <= 9
      Digit(:,:,n) = BTC_and_USDImage(:,10+(n-1)*10 + (n>1)*5 + floor(n/3): 20+(n-1)*10 +(n>1)*5 + floor(n/3));
  end
  if n > 9
      if n<=14
      Digit(:,:,n) = BTC_and_USDImage(:,165 + (n-9)*10 + (n>12)*5 + floor(n/3):175 +(n-9)*10 + (n>12)*5 + floor(n/3));
      end
  end

    %if n <= 5
    %Digit(:,:,n) = BitcoinImage(20:34,12 + (n-1)*7:20 +(n-1)*7);
    %end
    %if n >= 6
    %    if n <= 8
    %Digit(:,:,n) = BitcoinImage(20:34,14 + (n-1)*7:22 +(n-1)*7);
    %    end
    %end
    
    %if n > 8
    %    if n <= 11
    %Digit(:,:,n) = LTCImage(20:34,3 + (n-8)*7:11 +(n-8)*7);            
    %    end
    %end
    
    imshow(Digit(:,:,n));
    
    %% Creating Shifted Images
    a = Digit(:,:,n);
    a1(:,2:length(a(1,:))) = a(:,1:length(a(1,:))-1);
    a1(:,1) = a(:,length(a(1,:)));
    a2(:,1:length(a(1,:))-1) = a(:,2:length(a(1,:)));
    a2(:,length(a(1,:))) = a(:,1);
    
    a3(1:length(a(:,1))-1,:) = a(2:length(a(:,1)),:);
    a3(length(a(:,1)),:) = a(1,:);
    a4(2:length(a(:,1)),:) = a(1:length(a(:,1))-1,:);
    a4(1,:) = a(length(a(:,1)),:);
    
    
        
        X(:,1) = im2double(reshape(a, length(Digit(:,1,n))*length(Digit(1,:,n)) ,1));
        X(:,2) = im2double(reshape(a1, length(Digit(:,1,n))*length(Digit(1,:,n)) ,1));
        X(:,3) = im2double(reshape(a2, length(Digit(:,1,n))*length(Digit(1,:,n)) ,1));
        X(:,4) = im2double(reshape(a3, length(Digit(:,1,n))*length(Digit(1,:,n)) ,1));
        X(:,5) = im2double(reshape(a4, length(Digit(:,1,n))*length(Digit(1,:,n)) ,1));
        
        X(:,6) = X(:,1).^2;
        X(:,7) = X(:,1).^3;
        X(:,8) = X(:,1).^0.7;
        X(:,9) = X(:,1) + 0.1*rand(size(X(:,1)));
        X(:,10) = X(:,1) + 0.05*rand(size(X(:,1)));
        X(:,11) = X(:,1) + 0.1*rand(size(X(:,1)));
        X(:,12) = X(:,1) + 0.05*rand(size(X(:,1)));
        X(:,13) = X(:,1) + 0.05*rand(size(X(:,1)));
        X(:,14) = X(:,1) + 0.05*rand(size(X(:,1)));
        X(:,15) = X(:,1).^0.8;
        
            imshow(Digit(:,:,n));
            prompt = 'What is the true Number? ';
            Input = input(prompt);

    for j = 1:15
    DigitVector(:,j + 15*(n-1) + 15*14*(k-1)) = X(:,j);
    DigitLabel(:,j + 15*(n-1) + 15*14*(k-1)) = Input;
    end
   
end
k = k+1;
Labels = [0 1 2 3 4 5 6 7 8 9]
NumberOfLabelsOfEachKind = [sum(DigitLabel==0) sum(DigitLabel==1) sum(DigitLabel==2)...
    sum(DigitLabel==3) sum(DigitLabel==4) sum(DigitLabel==5) sum(DigitLabel==6)...
    sum(DigitLabel==7) sum(DigitLabel==8) sum(DigitLabel==9)]


%% Refresh page
import java.awt.Robot;
import java.awt.event.*;
mouse = Robot;

%% Click on the picture
mouse.mouseMove(600, 220); % this needs to be theleft side of the bar below
mouse.mousePress(InputEvent.BUTTON1_MASK); 
mouse.mouseRelease(InputEvent.BUTTON1_MASK);

mouse.mouseMove(80, 50);
mouse.mousePress(InputEvent.BUTTON1_MASK); 
mouse.mouseRelease(InputEvent.BUTTON1_MASK);

pause(6)

%% move the left screen all the way to the right
mouse.mouseMove(640, 720); % this needs to be theleft side of the bar below
mouse.mousePress(InputEvent.BUTTON1_MASK); 
mouse.mouseRelease(InputEvent.BUTTON1_MASK);%%left click release
mouse.mouseMove(640, 720); % this needs to be theleft side of the bar below
mouse.mousePress(InputEvent.BUTTON1_MASK); 
mouse.mouseRelease(InputEvent.BUTTON1_MASK); 

%% Click on the picture
mouse.mouseMove(700, 220); % this needs to be theleft side of the bar below
mouse.mousePress(InputEvent.BUTTON1_MASK); 
mouse.mouseRelease(InputEvent.BUTTON1_MASK);

%% Click on the prompt
mouse.mouseMove(1000, 680); % this needs to be theleft side of the bar below
mouse.mousePress(InputEvent.BUTTON1_MASK); 
mouse.mouseRelease(InputEvent.BUTTON1_MASK);
end
repeat = 1;

BitcoinDigitVector(:,n + 8*(k-1)) = reshape(Digit(:,:,n), length(Digit(:,1,n))*length(Digit(1,:,n)) ,1);
BitcoinDigitVector1 = im2double(BitcoinDigitVector(:,1:480))
t = datetime('now');
DateString = datestr(t);
NameOfFile = strcat('DataSetForDigitRecognition','__',DateString)
save('DataSetForBoldDigits_binance','DigitVector','DigitLabel')