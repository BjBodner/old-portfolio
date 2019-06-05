function [RationalNumber_ForRealPart,RationalNumber_ForimagPart,abs_value_with_zero_order_in_pi] = Find_RationalRepresentation(UniqueZeros,Highest_Integer,Expanded_Absolute_Function,pi_order)



RationalNumbers = (diag(1:Highest_Integer)*ones(Highest_Integer))./(ones(Highest_Integer)*diag(1:Highest_Integer));
RationalNumbers_vector = reshape(RationalNumbers,Highest_Integer^2,1);
n1 = 1;
n2 = 1;

for k = 1:length(UniqueZeros)
    RealPart_UniqueZeros_Times_RationalNumber = RationalNumbers_vector*real(UniqueZeros(k));
    ImagPart_UniqueZeros_Times_RationalNumber = RationalNumbers_vector*imag(UniqueZeros(k));
    
    [M,I] = min(abs(abs(RealPart_UniqueZeros_Times_RationalNumber)-1));
    for i = 1:Highest_Integer
        if abs(M-1) >0.5
            if abs(RationalNumbers_vector(I)*i - round(RationalNumbers_vector(I)*i)) < 10^-4
                RationalNumber_ForRealPart(n1,:) = [sign(real(UniqueZeros(k)))*i RationalNumbers_vector(I)*i];
                n1 = n1+1;
                break
            end
        end
    end
    
    [M,I] = min(abs(abs(ImagPart_UniqueZeros_Times_RationalNumber)-1));
    for i = 1:Highest_Integer
        if abs(M-1) >0.5
            if abs(RationalNumbers_vector(I)*i - round(RationalNumbers_vector(I)*i)) < 10^-4
                RationalNumber_ForimagPart(n2,:) = [sign(imag(UniqueZeros(k)))*i RationalNumbers_vector(I)*i];
                n2 = n2+1;
                break
            end
        end
    end
    
end

if n2>n1 %% this means that one solution is only imaginary
    RationalNumber_ForRealPart(n2-1,:) = [0 1];
end
if n1>n2 %% this means that one solution is only real
    RationalNumber_ForimagPart(n1-1,:) = [0 1];
end


%% Calculating The result for the approximated zeros - zero order in pi
for k = 1:n1-1
    abs_value_with_zero_order_in_pi(k) = Expanded_Absolute_Function((pi^pi_order)*RationalNumber_ForRealPart(k,1)/RationalNumber_ForRealPart(k,2),(pi^pi_order)*RationalNumber_ForimagPart(k,1)/RationalNumber_ForimagPart(k,2));
end