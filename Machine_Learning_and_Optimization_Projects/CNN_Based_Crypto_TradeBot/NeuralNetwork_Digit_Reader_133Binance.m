function   [ChosenDigit,Confidence] = NeuralNetwork_Digit_Reader_133Binance(Digit)




CertantySum_For_Number = zeros(10,1);
a = Digit;
w = im2double(reshape(Digit(:,:), length(Digit(:,1))*length(Digit(1,:)) ,1));
Expanded_X = zeros(length(w),8);
Y_Vector = zeros(10,78);
%imshow(BitcoinDigit);

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


Expanded_X(:,1) = im2double(reshape(Digit(:,:), length(Digit(:,1))*length(Digit(1,:)) ,1));
Expanded_X(:,2) = im2double(reshape(a1, length(Digit(:,1))*length(Digit(1,:)) ,1));
Expanded_X(:,3) = im2double(reshape(a2, length(Digit(:,1))*length(Digit(1,:)) ,1));
Expanded_X(:,4) = im2double(reshape(a3, length(Digit(:,1))*length(Digit(1,:)) ,1));
Expanded_X(:,5) = im2double(reshape(a4, length(Digit(:,1))*length(Digit(1,:)) ,1));
Expanded_X(:,6) = Expanded_X(:,1).^2;
Expanded_X(:,7) = Expanded_X(:,1).^3;
Expanded_X(:,8) = Expanded_X(:,1).^4;

%imshow(BitcoinDigit(:,:,n));
q = 100;

for k = 1:78
    if k <=8
        [Y,~,~] = NN_133Binance_10Neurons(Expanded_X(:,k),1,1);
    end
    if k > 8
        if k <=16
            [Y,~,~] = NN_133Binance_12Neurons(Expanded_X(:,k-8),1,1);
        end
    end
    
    if k > 16
        if k <= 24
            [Y,~,~] = NN_133Binance_14Neurons(Expanded_X(:,k-16),1,1);
        end
    end
    if k > 24
        if k <= 32
            [Y,~,~] = NN_133Binance_16Neurons(Expanded_X(:,k-24),1,1);
        end
    end
    if k > 32
        if k <= 40
            [Y,~,~] = NN_133Binance_18Neurons(Expanded_X(:,k-32),1,1);
        end
    end
    if k > 40
        if k <= 48
            [Y,~,~] = NN_133Binance_20Neurons(Expanded_X(:,k-40),1,1);
        end
    end
    
    if k >48
        q = k-48;
    end
    
    if q <=5
        [Y,~,~] = NN_133Binance_22Neurons(Expanded_X(:,q),1,1);
    end
    if q > 5
        if q <=10
            [Y,~,~] = NN_133Binance_24Neurons(Expanded_X(:,q-5),1,1);
        end
    end
    
    if q > 10
        if q <= 15
            [Y,~,~] = NN_133Binance_26Neurons(Expanded_X(:,q-10),1,1);
        end
    end
    if q > 15
        if q <= 20
            [Y,~,~] = NN_133Binance_28Neurons(Expanded_X(:,q-15),1,1);
        end
    end
    if q > 20
        if q <= 25
            [Y,~,~] = NN_133Binance_30Neurons(Expanded_X(:,q-20),1,1);
        end
    end
    if q > 25
        if q <= 30
            [Y,~,~] = NN_133Binance_10Neurons(Expanded_X(:,q-25),1,1);
        end
    end
    
    
    
    
    Y_Vector(:,k) = Y;
    
  %  [M,I] = max(Y);
  %  vote(k) = I-1;
  %  temp = Y;
  %  temp(I) = 0;
  %  Certainty(k) = ((1 - max(temp)/M)^20)*10^10*(var(Y)^10);
end

SumY = sum((Y_Vector.^2).');
[M,I1] = max(SumY);

SumY(I1) = 0;

Confidence = 1-mean(nonzeros(SumY))/M;
% Weighted Certanty
%for num = 0:9
  %  CertantySum_For_Number(num+1) = sum((vote == num).*Certainty);
  
 %   CertantySum_For_Number(num+1) = SumY(num+1);
%end
%[~,I1] = max(CertantySum_For_Number);
ChosenDigit = I1-1;

% this helps is a rule of thumb to find the hard cases
%CertantySum_For_Number(I1) = 0;
%[M2,I2] = max(CertantySum_For_Number);
%if M2/M1 > 0.5
  %  ChosenDigit = max(I1,I2)-1;
%end
