function [Zeros_Vector,Order_Of_Zero,Value_of_F_at_Points] = Find_Roots_Of_denominator(f_denominator,Rmax)

f_denominator =@(z) z.^3 + 1 - z.^2
Rmax = 2;
[StringRepresentation] = Find_Roots_For_Complex_Function(f_denominator,Rmax)

%% Convert suspected points to double
StringRepresentation1 = char(StringRepresentation);
for zero = 1:length(StringRepresentation)
    for k = 1:length(StringRepresentation1(1,:))
        if StringRepresentation1(zero,k) == 'i'
            StringRepresentation1(zero,k) = '1';
            if k == length(StringRepresentation1(1,:))
                StringRepresentation2 = strcat(StringRepresentation1(zero,:),'i');
            end
            if k ~= length(StringRepresentation1(1,:))
                StringRepresentation1(zero,k+1) = 'i';
                StringRepresentation2 = StringRepresentation1(zero,:);
            end
            
            Zeros_Vector(zero) = str2num(StringRepresentation2);
        end
    end
end
Zeros_Vector = Zeros_Vector.';

Value_of_F_at_Points = f_denominator(Zeros_Vector);

f = sym(f_denominator);

Epsilon = 5*10^-3;
for zero = 1:length(Zeros_Vector)
    f = sym(f_denominator);
    for order = 1:10
        f = diff(f);
        f1 = matlabFunction(f);
        if abs(f1(Zeros_Vector(zero))) > Epsilon
            Order_Of_Zero(zero) = order;
            break
        end
    end
end

Zeros_Vector
Order_Of_Zero
Value_of_F_at_Points
a = 1;