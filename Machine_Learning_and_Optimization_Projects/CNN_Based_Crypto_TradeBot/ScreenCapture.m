clear

%% This program looks at btc-alpha.com, at a zoom of 125%
p = 1;
disagreement = 0;
while p <= 700
    
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
    
    BitcoinImage = GreyImage(615:655,720:805,1);
    imshow(BitcoinImage);
    ChosenDigit = zeros(1,5);
    
    for n = 1:5
        
        
        
        % BitcoinDigit(:,:,n) = BitcoinImage(17:27,7 + (n-1)*6:12 +(n-1)*6);
        % BitcoinDigit1 = BitcoinImage(17:27,7 + (n-1)*6:12 +(n-1)*6);
        
        if n <= 5
            BitcoinDigit(:,:,n) = BitcoinImage(20:34,12 + (n-1)*7:20 +(n-1)*7);
        end
        if n >= 6
            if n <= 8
                BitcoinDigit(:,:,n) = BitcoinImage(20:34,14 + (n-1)*7:22 +(n-1)*7);
            end
        end
        
        [ChosenDigit(n)] = NeuralNetwork_Digit_Reader(BitcoinDigit(:,:,n));
        [ChosenDigit(n)] = NeuralNetwork_Digit_Reader2(BitcoinDigit(:,:,n));
        
        tryOldWay = 0;
        if tryOldWay == 1
        
        a = BitcoinDigit(:,:,n);
        
        imshow(BitcoinDigit(:,:,n));
        
        % permutating the image left and right
        a1(:,2:length(a(1,:))) = a(:,1:length(a(1,:))-1);
        a1(:,1) = a(:,length(a(1,:)));
        a2(:,1:length(a(1,:))-1) = a(:,2:length(a(1,:)));
        a2(:,length(a(1,:))) = a(:,1);
        
        % permutating the image up and down
        a3(1:length(a(:,1))-1,:) = a(2:length(a(:,1)),:);
        a3(length(a(:,1)),:) = a(1,:);
        a4(2:length(a(:,1)),:) = a(1:length(a(:,1))-1,:);
        a4(1,:) = a(length(a(:,1)),:);
        
        Expanded_X(:,1) = im2double(reshape(BitcoinDigit(:,:,n), length(BitcoinDigit(:,1,n))*length(BitcoinDigit(1,:,n)) ,1));
        Expanded_X(:,2) = im2double(reshape(a1, length(BitcoinDigit(:,1,n))*length(BitcoinDigit(1,:,n)) ,1));
        Expanded_X(:,3) = im2double(reshape(a2, length(BitcoinDigit(:,1,n))*length(BitcoinDigit(1,:,n)) ,1));
        Expanded_X(:,4) = im2double(reshape(a3, length(BitcoinDigit(:,1,n))*length(BitcoinDigit(1,:,n)) ,1));
        Expanded_X(:,5) = im2double(reshape(a4, length(BitcoinDigit(:,1,n))*length(BitcoinDigit(1,:,n)) ,1));
        
        
        imshow(BitcoinDigit(:,:,n));
        
        %Expanded_X = Expanded_X.^2;
        
        for k = 1:25
            if k <=5
                [Y,Xf,Af] = NN_DigitRecognizer_Zoom_125(Expanded_X(:,k),1,1);
            end
            if k > 5
                if k <=10
                    [Y,Xf,Af] = NN_DigitRecognizer_Zoom_125_25Neurons(Expanded_X(:,k-5),1,1);
                end
            end
            
            if k > 10
                if k <= 15
                    [Y,Xf,Af] = NN_DigitRecognizer_Zoom_125_20Neurons(Expanded_X(:,k-10),1,1);
                end
            end
            if k > 15
                if k <= 20
                    [Y,Xf,Af] = NN_DigitRecognizer_Zoom_125_15Neurons(Expanded_X(:,k-15),1,1);
                end
            end
            if k > 20
                if k <= 25
                    [Y,Xf,Af] = NN_DigitRecognizer_Zoom_125_10Neurons(Expanded_X(:,k-20),1,1);
                end
            end
            Y_Vector(:,k) = Y;
            
            [M,I] = max(Y);
            vote(k) = I-1;
            temp = Y;
            temp(I) = 0;
            Certainty(k) = ((1 - max(temp)/M)^200)*10^5*(var(Y)^5);
        end
        
        % Weighted Certanty
        for num = 0:9
            CertantySum_For_Number(num+1) = sum((vote == num).*Certainty);
        end
        [M1,I1] = max(CertantySum_For_Number);
        ChosenDigit(n) = I1-1
        
        % this helps is a rule of thumb to find the hard cases
        CertantySum_For_Number(I) = 0;
        [M2,I2] = max(CertantySum_For_Number);
            if M2/M1 > 0.7
                ChosenDigit(n) = max(I1,I2)-1
            end
   
        end
            ChosenDigit(n)
    end
    
        t = datetime('now');
        DateNumber = datenum(t)
        
        DateTime_Char_Vector(p) = t;
        DateTime_Number_Vector(p) = DateNumber;
        BTC_USD(p) = ChosenDigit(1)*10^4 + ChosenDigit(2)*10^3 + ChosenDigit(3)*10^2 + ChosenDigit(4)*10^1 + ChosenDigit(5)
        p = p+1;
        
        pause(30);
        
end



save('BitcoinData_1_1','DateTime_Char_Vector','DateTime_Number_Vector','BTC_USD')

a = load('BitcoinData_1_1.mat')


DoLiteCoinToo = 0;

if DoLiteCoinToo == 1
    LiteCoinImage = GreyImage(515:545,785:855,1);
    imshow(LiteCoinImage);
    for n = 1:8
        LiteCoinDigit(:,:,n) = LiteCoinImage(17:27,7 + (n-1)*6:12 +(n-1)*6);
        LiteCoinDigit1 = LiteCoinImage(17:27,7 + (n-1)*6:12 +(n-1)*6);
        imshow(LiteCoinDigit1);
    end
end
%save('Number8','BitcoinDigit1')

