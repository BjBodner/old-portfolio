function [CapacitanceMatrixChoice,GoBack] = Menu_Capacitance_Matrix()

field1 = 'Regular_Round_Matrix';
value1 = 0;
field2 = 'Eliptical1_Long_In_X_Direction';
value2 = 0;
field3 = 'Eliptical1_Long_In_Y_Direction';
value3 = 0;
field4 = 'OscliatingRowsOnly';
value4 = 0;
field5 = 'OscilatingLinesAndRows';
value5 = 0;
field6 = 'SideWays_Matrix';
value6 = 0;
field7 = 'Increasing_Screeninglength_X_Matrix';
value7 = 0;
field8 = 'Decreasing_Screeninglength_1X_Matrix';
value8 = 0;
field9 = 'Increasing_Screeninglength_X2_Matrix';
value9 = 0;
field10 = 'Y_Gradient_10timeIncrease_Matrix';
value10 = 0;
GoBack = 0;

CapacitanceMatrixChoice = struct(field1,value1,field2,value2,field3,value3,field4,value4,field5,value5,field6,value6,field7,value7,field8,value8,field9,value9,field10,value10);



Regular_Round_Matrix = 1;
Eliptical1_Long_in_X_Direction_Matrix = 0;
Eliptical1_Long_in_Y_Direction_Matrix = 0;
Oscliating_Rows_Only = 0;
Oscilating_Lines_and_Rows = 0;
SideWays_Matrix = 0;

%      if CurrentMenuNumber == 3
Selected_Capacitance_Matrix = menu('Select the Capacitance Matrix You Would Like to Run',...
    'Regular_Round_Matrix', ...
    'Eliptical1_Long_in_X_Direction_Matrix',...
    'Eliptical1_Long_in_Y_Direction_Matrix',...
    'Oscliating_Rows_Only', ...
    'Oscilating_Lines_and_Rows',...
    'SideWays_Matrix',...
    'Increasing_Screeninglength_X_Matrix',...
    'Decreasing_Screeninglength_1X_Matrix',...
    'Increasing_Screeninglength_X2_Matrix',...
    'Y_Gradient_10timeIncrease_Matrix',...
    'Go Back');


switch Selected_Capacitance_Matrix
    case 0
        disp('You Chose to Exit Pleaserun again')
        
      %  [a] = WouldYouLikeToLeaveMenu();
        
    case 1
       % Regular_Round_Matrix
        value1 = 1;

        
    case 2

       % Eliptical1_Long_in_X_Direction_Matrix = 1;
        value2 = 1;
    case 3

       % Eliptical1_Long_in_Y_Direction_Matrix = 1;
        value3 = 1;

    case 4

        %Oscliating_Rows_Only
        value4 = 1;
    case 5

        %Oscilating_Lines_and_Rows
        value5 = 1;

    case 6

         % SideWays_Matrix
        value6 = 1;
        
    case 7

        % Increasing_Screeninglength_Matrix
        value7 = 1;
        
    case 8
        
        % Decreasing_Screeninglength_Matrix
        value8 = 1;
    case 9
        value9 = 1;
    case 10
        value10 = 1;
    otherwise
        disp('Go Back (To Select a different folder)')
        GoBack = 1;
end

CapacitanceMatrixChoice = struct(field1,value1,field2,value2,field3,value3,field4,value4,field5,value5,field6,value6,field7,value7,field8,value8,field9,value9,field10,value10);
end