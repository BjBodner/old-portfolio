function [StringRepresentation] = Find_Roots_For_Complex_Function(f,Rmax,Radial_Density,Azimuthal_Density)

%clear

%f =@(z) z.^5 + 3*z.^2 - z + 1;
%Rmax = 2

Azimuthal_Density = 18; %number of initialization points per 360 degrees
Radial_Density = 2; % number of initialization points per lenght 1 in the radial direction;
NumberOf_Initializations_In_Disc = Azimuthal_Density*Radial_Density;
NumberOfRadial_itteratons = ceil(Rmax);
%% 1 initialize points in a grid, between r1 and r2
for i = 1:NumberOfRadial_itteratons
    RandomRadius = i-1 + rand(NumberOf_Initializations_In_Disc,1);
    RandomAzimuth = 2*pi*rand(NumberOf_Initializations_In_Disc,1);
    InitiationPoints(i,:) = RandomRadius.*cos(RandomAzimuth) + 1i*RandomRadius.*sin(RandomAzimuth);
end
InitiationPoints = reshape(InitiationPoints,NumberOf_Initializations_In_Disc*NumberOfRadial_itteratons,1);


%% 2 run 20 itteration newton raphson on all those points

Number_Of_NR_itterations = 20;
Epsilon = 10^-5;
MaxValue_For_F = 10^4;
MaxValue_For_x = Rmax;

syms z x y
f_syms = sym(f);
f_subs = subs(f,z,x+1i*y);
f_andjoint = subs(f_subs,1i,-1i);
AbsoluteFunction = f_subs*f_andjoint;

Expanded_Absolute_Function = matlabFunction (expand(AbsoluteFunction));
Derrivative_x = matlabFunction (diff(Expanded_Absolute_Function,x));
Derrivative_y = matlabFunction(diff(Expanded_Absolute_Function,y));



%% a
InitiationPoints_Vectors = [real(InitiationPoints) ,imag(InitiationPoints)]

KillingVector = zeros(size(InitiationPoints_Vectors));
ZeroLocation = zeros(size(InitiationPoints_Vectors));
for k = 1:length(InitiationPoints)
    x_prev = real(InitiationPoints_Vectors(k,:));
    for i = 1:Number_Of_NR_itterations
        x_new = x_prev - Expanded_Absolute_Function(x_prev(1),x_prev(2))*[1/Derrivative_x(x_prev(1),x_prev(2)) 1/Derrivative_y(x_prev(1),x_prev(2))];
        Expanded_Absolute_Function(x_new(1),x_new(2))
        if Expanded_Absolute_Function(x_new(1),x_new(2)) < Epsilon
            KillingVector(k) = 1;
            ZeroLocation(k,:) = x_new;
        end
        
        if Expanded_Absolute_Function(x_new(1),x_new(2))>MaxValue_For_F
            break
        end
        if sqrt(x_new*x_new.')>MaxValue_For_x
            break
        end
        
        x_prev = x_new;
    end
end

%% 3 save all the zeros the zeros
Z_of_Zeros = ZeroLocation(:,1) + 1i*ZeroLocation(:,2);
Zeros = nonzeros(Z_of_Zeros)

n = 1;
for i = 1:length(Zeros)
    if i == 1
        UniqueZeros(n) = Zeros(1);
        n = n+1;
        continue
    end
    
    for j = 1:length(UniqueZeros)
        if min(abs(UniqueZeros.' - Zeros(i))) >(10^-2)*abs(Zeros(i))
            UniqueZeros(n) = Zeros(i);
            n = n+1;
        end
    end
end
UniqueZeros = UniqueZeros.'

%% find a rational number representation for the roots - Zeroth order in pi

Highest_Integer = 50; % this is the highest integer for rational number representation
pi_order = 0;
[RationalNumber_ForRealPart(:,:,1),RationalNumber_ForimagPart(:,:,1),abs_value_with_zero_order_in_pi] = Find_RationalRepresentation(UniqueZeros,Highest_Integer,Expanded_Absolute_Function,pi_order)

%% Divide By pi and find a rational number representation for the roots - First order in pi
pi_order = 1;
[RationalNumber_ForRealPart(:,:,2),RationalNumber_ForimagPart(:,:,2),abs_value_with_first_order_in_pi] = Find_RationalRepresentation(UniqueZeros/pi,Highest_Integer,Expanded_Absolute_Function,pi_order)
a = 1;

%%  Divide By pi^2 and find a rational number representation for the roots - Second order in pi\
pi_order = 2;
[RationalNumber_ForRealPart(:,:,3),RationalNumber_ForimagPart(:,:,3),abs_value_with_second_order_in_pi] = Find_RationalRepresentation(UniqueZeros/(pi^2),Highest_Integer,Expanded_Absolute_Function,pi_order)

AbsValueArray = [abs_value_with_zero_order_in_pi ;abs_value_with_first_order_in_pi ;abs_value_with_second_order_in_pi];

for zero = 1:length(UniqueZeros)
    [m,I] = min(AbsValueArray(:,zero))
    Best_RationalRepresention_OfZero(:,:,zero) = [RationalNumber_ForRealPart(zero,:,I); RationalNumber_ForimagPart(zero,:,I)];
    Best_OrderOf_Pi(zero) = I-1;
end

a = 1;
for zero = 1:length(UniqueZeros)
    s1 = strcat(num2str(Best_RationalRepresention_OfZero(1,1,zero)),'/',num2str(Best_RationalRepresention_OfZero(1,2,zero)),' +_',num2str(Best_RationalRepresention_OfZero(2,1,zero)),'/',num2str(Best_RationalRepresention_OfZero(2,2,zero)),'*i');
    if sum(s1 == '-')*sum(s1 == '+') == 1
        [~,I] = max(s1 == '-');
        if I~= 1
        s1 = strcat(s1(1:I-1),s1(I+1:length(s1)));
        
        [~,I] = max(s1 == '+');
        s1(I) = '-';
        end
    end
    [~,I] = max(s1 == '_');
    s1(I) = ' ';
    StringRepresentation(zero,:) = {s1};
end

%% return the results of the different zeros - after the analysic representation
%%

