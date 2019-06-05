function [Different_Transformation_Vector] = Generate_Different_Transformations_Vector(Z)

% total of 12 transformations
Different_Transformation_Vector = cat(3,exp(Z),sin(Z),cos(Z),Z,Z.^2,Z.^3,Z.^(0.5),Z.^(-0.5),Z.^(-1),Z.^(-2),log(Z),tanh(Z));
