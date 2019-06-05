function [Root_Vector] = Newton_Raphson(f,x_previous)

syms x
f_derrivative = matlabFunction( diff(f(x)) );
Root_Vector = x_previous - f(x_previous)/f_derrivative(x_previous);
