function [FunctionVector] = Function_Generator1(FreeParameterRange,SlopeRange,CurvatureRange,Xvector)


%% Generating  quadradic function
RangeDivision = 5
FreeParameterVector = FreeParameterRange(1):(FreeParameterRange(2)-FreeParameterRange(1))/RangeDivision:FreeParameterRange(2);
SlopeVector = SlopeRange(1):(SlopeRange(2)-SlopeRange(1))/RangeDivision:SlopeRange(2);
CurvatureVector = CurvatureRange(1):(CurvatureRange(2)-CurvatureRange(1))/RangeDivision:CurvatureRange(2);


FullArray(1:length(FreeParameterVector),1) = FreeParameterVetcor;
FullArray(1:length(FreeParameterVector),2) = SlopeVector;
FullArray(1:length(FreeParameterVector),3) = CurvatureVector;


