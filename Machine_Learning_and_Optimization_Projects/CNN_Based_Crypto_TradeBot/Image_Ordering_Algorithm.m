function [Ordered_Image] = Image_Ordering_Algorithm(GreyImage,d)



PixelVector(1,:) = 441:457;
PixelVector(2,:) = 482:498;
PixelVector(3,:) = 524:540;
PixelVector(4,:) = 565:581;
PixelVector(5,:) = 605:621;
PixelVector(6,:) = 645:661;

BNB_Image = GreyImage(441:457,50:540,1);
LTC_Image = GreyImage(482:498,50:540,1);
ETH_Image = GreyImage(524:540,50:540,1);
TeatherUSD_Image = GreyImage(565:581,50:540,1);
BTC_Image = GreyImage(605:621,50:540,1);


for i = 1:6
    Un_Ordered_Image(:,:,i) = GreyImage(PixelVector(i,:),:,1);
    Red_Un_Ordered_Image(:,:,i) = d(PixelVector(i,:),:,1);
    Green_Un_Ordered_Image(:,:,i) = d(PixelVector(i,:),:,2);
    Blue_Un_Ordered_Image(:,:,i) = d(PixelVector(i,:),:,3);
end


for i = 1:6
    imshow(Red_Un_Ordered_Image(:,10:50,i))
 Red_Sum_Vector(i) = sum(sum(Red_Un_Ordered_Image(:,10:50,i)));
 Green_Sum_Vector(i) =  sum(sum(Green_Un_Ordered_Image(:,10:50,i)));
 Blue_Sum_Vector(i) = sum(sum(Blue_Un_Ordered_Image(:,10:50,i)));
end



%index 1 is the lower bound, and index 2 is the upper bound
%% BNB Limits
RedLimit(1,1) = 174100;
RedLimit(2,1) = 174550;
GreenLimit(1,1) = 168400;
GreenLimit(2,1) = 169540;
BlueLimit(1,1) = 149500;
BlueLimit(2,1) = 151020;


%% LTC Limits
RedLimit(1,2) = 153790;
RedLimit(2,2) = 154400;
GreenLimit(1,2) = 153840;
GreenLimit(2,2) = 154400;
BlueLimit(1,2) = 153300;
BlueLimit(2,2) = 154150;



%% ETH Limits
RedLimit(1,3) = 157500;
RedLimit(2,3) = 157810;
GreenLimit(1,3) = 157610;
GreenLimit(2,3) = 157900;
BlueLimit(1,3) = 157120;
BlueLimit(2,3) = 157430;


%% Tether USD Limits
RedLimit(1,4) = 120160;
RedLimit(2,4) = 121050;
GreenLimit(1,4) = 151950;
GreenLimit(2,4) = 152250;
BlueLimit(1,4) = 142200;
BlueLimit(2,4) = 142710;


%% BTC Limits
RedLimit(1,5) = 172610;
RedLimit(2,5) = 172820;
GreenLimit(1,5) = 153160;
GreenLimit(2,5) = 153360;
BlueLimit(1,5) = 124870;
BlueLimit(2,5) = 125100;



for i = 1:5
RedKillingVector = (Red_Sum_Vector>RedLimit(1,i)).*(Red_Sum_Vector<RedLimit(2,i));
GreenKillingVector = (Green_Sum_Vector>GreenLimit(1,i)).*(Green_Sum_Vector<GreenLimit(2,i));
BlueKillingVector = (Blue_Sum_Vector>BlueLimit(1,i)).*(Blue_Sum_Vector<BlueLimit(2,i));

[M,I] = max(RedKillingVector.*GreenKillingVector.*BlueKillingVector);
True_Index(i) = I;
if M == 0
    a = error;
end
end
for i = 1:5
    Ordered_Image(:,:,i) = Un_Ordered_Image(:,50:540,True_Index(i));
end


% i = 1: BNB
%i = 2: LTC
%i = 3: ETH
%i = 4 Tether USD
%i = 5: BTC