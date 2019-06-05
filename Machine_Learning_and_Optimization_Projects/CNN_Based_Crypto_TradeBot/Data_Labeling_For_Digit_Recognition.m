clear
repeat = 0;
k = 1;
%% this is for btc-alpha at 125% zoom

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
Minimized_Cropped_GreyImage = GreyImage(510:545,710:1100,1);

imshow(Minimized_Cropped_GreyImage);

BNB_BTC = GreyImage(353:367,1060:1250,1);
BNB_ETH = GreyImage(380:394,1060:1250,1);
ETH_BTC = GreyImage(407:421,1060:1250,1);
LTC_BTC = GreyImage(433:447,1060:1250,1);
LTC_BNB = GreyImage(460:474,1060:1250,1);
LTC_ETH = GreyImage(486:500,1060:1250,1);

imshow(LTC_ETH)
%BitcoinImage = GreyImage(615:650,720:815,1);
%imshow(BitcoinImage);

%LTCImage = GreyImage(615:650,815:900,1);
%imshow(LTCImage);

for n = 1:23
    n
  if n <= 7
      Digit(:,:,n) = BNB_BTC(:,118 + (n-1)*8:126 +(n-1)*8);
  end
  if n > 7
      if n<=13
      Digit(:,:,n) = BNB_ETH(:,118 + (n-8)*8:126 +(n-8)*8);
      end
  end
  if n > 13
      if n <=18
      Digit(:,:,n) = ETH_BTC(:,118 + (n-14)*8:126 +(n-14)*8);
      end
  end
  if n > 18
      if n<=23
      Digit(:,:,n) = LTC_BTC(:,118 + (n-19)*8:126 +(n-19)*8);
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
        
            imshow(Digit(:,:,n));
            prompt = 'What is the true Number? ';
            Input = input(prompt);

    for j = 1:10
    DigitVector(:,j + 10*(n-1) + 10*23*(k-1)) = X(:,j);
    DigitLabel(:,j + 10*(n-1) + 10*23*(k-1)) = Input;
    end
   
end
k = k+1;
Labels = [0 1 2 3 4 5 6 7 8 9]
NumberOfLabelsOfEachKind = [sum(DigitLabel==0) sum(DigitLabel==1) sum(DigitLabel==2)...
    sum(DigitLabel==3) sum(DigitLabel==4) sum(DigitLabel==5) sum(DigitLabel==6)...
    sum(DigitLabel==7) sum(DigitLabel==8) sum(DigitLabel==9)]
end
repeat = 1;

BitcoinDigitVector(:,n + 8*(k-1)) = reshape(Digit(:,:,n), length(Digit(:,1,n))*length(Digit(1,:,n)) ,1);
BitcoinDigitVector1 = im2double(BitcoinDigitVector(:,1:480))
t = datetime('now');
DateString = datestr(t);
NameOfFile = strcat('DataSetForDigitRecognition','__',DateString)
save('DataSetForDigitRecognition_binance2','DigitVector','DigitLabel')