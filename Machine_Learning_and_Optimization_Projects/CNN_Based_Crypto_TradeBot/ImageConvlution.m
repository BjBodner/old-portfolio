
u = [1 5 3 1 1];
v = [3 7 1 2 4];
C = conv2(u,v);
plot(n,C)
Ch = conv2(u,v,A);



b = open('Number9.mat')
Number(:,:,1) = (b.Number9).^1
Number(:,:,1) = Number(:,:,1)/(max(max(Number(:,:,1))))
b = open('Number7.mat')
Number(:,:,2) = (b.Number7).^1
Number(:,:,2) = Number(:,:,2)/(max(max(Number(:,:,2))))
b = open('Number3.mat')
Number(:,:,3) = (b.Number3).^1
Number(:,:,3) = Number(:,:,3)/(max(max(Number(:,:,3))))

TrueNumberOf = zeros(3,1);
for i = 1:3
    for j = 1:i
        i
        j
        %% Costum Convolution algorithm
       
       Conv = zeros(length(Number(:,1,1)),16);
        for k = 1:4
            for t = 1:4
            Conv(:,t + 4*(k-1)) = sum(abs(Number(:,k:k+2,i) - Number(:,t:t+2,j)).');
            end
        end
        Correlation = sum(sum(Conv < 0.05))/(4*length(Number(:,1,1)));

        if Correlation > 0.95
            TrueNumberOf(j) = i
        end
    end
end