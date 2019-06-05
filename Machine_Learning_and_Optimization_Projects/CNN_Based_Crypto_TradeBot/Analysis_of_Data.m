a = load('BitcoinData_1_1.mat');
Price = a.BTC_USD;
Time = a.DateTime_Number_Vector;

plot(Time,Price)

%% smoothing ou data

for l = 1:2
for k = 1:5
for smoothing = 1:10
for i = 1+k:length(Price)-k
    if abs(Price(i)-Price(i-k)) > 5*abs(Price(i-k)-Price(i+k))
    Price(i) = (Price(i+k) + Price(i-k))/2;
    end
end
end
plot(Time,Price)
getframe(gcf)
end
end

p = 1;
PriceChange = diff(Price);

for j = 1:20
for i = 1:90
    PriceChange(i) = Price(j*(i+1))-Price(j*i); 
end
%PriceChange = PriceChange(1:500);

for CorrelationLength = 1:30
for i = 1:length(PriceChange) - CorrelationLength
A = PriceChange(1:length(PriceChange) - CorrelationLength-1);
B = PriceChange(CorrelationLength:length(PriceChange)-2);
CorrelationMatrix = corrcoef(A,B);
CorrelationVector(p) = CorrelationMatrix(2,1);
p = p+1;
end
p = 1;
CorrelationFunction(CorrelationLength) = mean(CorrelationVector);
end
if j ==1
CorrelationFunction1 = CorrelationFunction;
end
if j ~=1
CorrelationFunction1 = CorrelationFunction1 + CorrelationFunction;
end
plot(1:CorrelationLength,CorrelationFunction)
%ylim([-0.3 0])
xlim([0 20])
getframe(gcf)
end

p = 1;
plot(Time,Price)
Label = zeros(3,length(101:length(Price)-5));
Samples = zeros(9,length(101:length(Price)-5));
Samples_Of_Price = zeros(101,length(101:length(Price)-5));
for i = 101:length(Price)-5
        i
Y = real(fft(Price(i-100:i)));
Samples(:,p) = Y(2:10);
Samples_Of_Price(:,p) = Price(i-100:i);
Plotfft = 0;
if Plotfft == 1
ax1 = subplot(2,1,1);
plot(ax1,Y)
ylim([0 1000]);
xlim([0 10]);
ax2 = subplot(2,1,2);
PriceChange = Price(i) - Price(i-1);

bar(ax2,PriceChange)
ylim([-30 30])
getframe(gcf)
end
PriceChange = Price(i+1) - Price(i);
C = 1
if PriceChange < -10*C
Label(1,p) = 1;
end
if PriceChange >= -10*C
    if PriceChange <=10*C
        Label(2,p) = 1;
    end
end

if PriceChange > 10*C
        Label(3,p) = 1;
end
p = p+1;
end
Label

%% Note this NN is very good at detecting when the price will not change more than 10, but bad at detecting changes
