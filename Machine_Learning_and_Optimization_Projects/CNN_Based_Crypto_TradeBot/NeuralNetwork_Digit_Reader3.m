function   [ChosenDigit] = NeuralNetwork_Digit_Reader3(BitcoinDigit)


a = BitcoinDigit;

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

Expanded_X(:,1) = im2double(reshape(BitcoinDigit(:,:), length(BitcoinDigit(:,1))*length(BitcoinDigit(1,:)) ,1));
Expanded_X(:,2) = im2double(reshape(a1, length(BitcoinDigit(:,1))*length(BitcoinDigit(1,:)) ,1));
Expanded_X(:,3) = im2double(reshape(a2, length(BitcoinDigit(:,1))*length(BitcoinDigit(1,:)) ,1));
Expanded_X(:,4) = im2double(reshape(a3, length(BitcoinDigit(:,1))*length(BitcoinDigit(1,:)) ,1));
Expanded_X(:,5) = im2double(reshape(a4, length(BitcoinDigit(:,1))*length(BitcoinDigit(1,:)) ,1));


%imshow(BitcoinDigit(:,:,n));

for k = 1:30
    if k <=5
        [Y,Xf,Af] = NN_for_BN_10Neurons(Expanded_X(:,k),1,1);
    end
    if k > 5
        if k <=10
            [Y,Xf,Af] = NN_for_BN_15Neurons(Expanded_X(:,k-5),1,1);
        end
    end
    
    if k > 10
        if k <= 15
            [Y,Xf,Af] = NN_for_BN_20Neurons(Expanded_X(:,k-10),1,1);
        end
    end
    if k > 15
        if k <= 20
            [Y,Xf,Af] = NN_for_BN_25Neurons(Expanded_X(:,k-15),1,1);
        end
    end
    if k > 20
        if k <= 25
            [Y,Xf,Af] = NN_for_BN_30Neurons(Expanded_X(:,k-20),1,1);
        end
    end
    if k > 25
        if k <= 30
            [Y,Xf,Af] = NN_for_BN_35Neurons(Expanded_X(:,k-25),1,1);
        end
    end
    Y_Vector(:,k) = Y;
    
    [M,I] = max(Y);
    vote(k) = I-1;
    temp = Y;
    temp(I) = 0;
    Certainty(k) = ((1 - max(temp)/M)^20)*10^5*(var(Y)^5);
end

% Weighted Certanty
for num = 0:9
    CertantySum_For_Number(num+1) = sum((vote == num).*Certainty);
end
[M1,I1] = max(CertantySum_For_Number);
ChosenDigit = I1-1;

% this helps is a rule of thumb to find the hard cases
CertantySum_For_Number(I1) = 0;
[M2,I2] = max(CertantySum_For_Number);
if M2/M1 > 0.5
    ChosenDigit = min(I1,I2)-1;
end
