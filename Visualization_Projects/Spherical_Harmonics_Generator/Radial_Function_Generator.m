function [R_nl] = Radial_Function_Generator(NumberOfRadialSurfaces,n,l,Z)

ComputationalFactor = 10^10;

a = 5.291*(10^-11);
a = a*ComputationalFactor
NumberOfRadialSurfaces = 100;
Rmax = 10;
r = 0:Rmax/NumberOfRadialSurfaces:Rmax
n = 2
l = 0
Z = 1

Normalization = - sqrt( (((2*Z)/(n*a))^3) * (factorial(n-l-1)/((2*n)*(factorial(n+l)))) );

RegularPart = exp(-((Z*r)/(n*a))).*(((2*Z*r/n*a)).^l)

x = ((2*Z*r)/(n*a));
Laguerre_n = n-l-1;
k = 2*l+1;

for m = 0:Laguerre_n
Laguerre_Polynomial_m_Vector(m+1,:) = (((-1)^m)*((factorial(Laguerre_n+k))/(factorial(Laguerre_n-m)*factorial(k+m)*factorial(m))))*(x.^m)
end

if n >= 2
L_nk = sum(Laguerre_Polynomial_m_Vector);
end
if n == 1
    L_nk = 1;
end

%ScaleFactor = 2/5.1966;
minus_Rnl = -Normalization*RegularPart.*L_nk*ScaleFactor;
minus_r_times_Rnl = r.*minus_Rnl;

%Fudged_Rnl = minus_Rnl/(minus_Rnl(1)/0.7071);
%Fudged_Rnl.'
ProbabilityDensity = minus_r_times_Rnl.^2;


minus_Rnl(1:5).'
plot(r,minus_Rnl,'-r',r,minus_r_times_Rnl,'-b',r,ProbabilityDensity,'-g');
grid on
%% side note probability density = r^2*Rnl
