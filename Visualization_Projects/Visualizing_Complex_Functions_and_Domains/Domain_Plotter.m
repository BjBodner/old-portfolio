clear

%% This is a matlab program that plots complex Domains:

%% Press "run" and use the menu to navigate
%% Dont forget to  add a period before each devision, multiplication or power operation
%% Enjoy!


MainMenu = menu(sprintf('Welcome to the Complex Domain Plotter \n \n Remember to add a period before each devision, multiplication or power operation'),'Ok I will remember that');

f = figure;
repeat =1;
while repeat == 1
    prompt = {'What domain do you want for the real numbers?',...
        'What domain do you want for the imaginary numbers?',...
        'What is the condiion on these points?'};
    dlg_title = 'Complex Function Plotter';
    num_lines = 1;
    defaultans = {'[-2 to 2]','[-2 to 2]','|z-1|=|2*z.^3+1|'};
    Answer = inputdlg(prompt,dlg_title,num_lines,defaultans);
    
    
    Real_Domain1 = Answer{1};
    Imaginary_Domain1 = Answer{2};
    Condition1 = Answer{3};
    
    %% Reading the Domains
    for k = 1:2
        if k == 1
            TF1 = isspace(Real_Domain1);
        end
        if k == 2
            TF1 = isspace(Imaginary_Domain1);
        end
        p = 1;
        find_lower_limit = 1;
        find_upper_limit = 0;
        for i = 2:length(TF1)-1
            if find_lower_limit == 1
                LowerLimit_string(p) = Real_Domain1(i);
                p = p+1;
            end
            
            if TF1(i) == 1
                if find_lower_limit ==1
                    find_lower_limit = 0;
                    
                    p = 1;
                    continue
                end
            end
            
            if TF1(i) == 1
                if find_lower_limit == 0
                    find_upper_limit = 1;
                    continue
                end
            end
            
            if find_upper_limit == 1
                
                UpperLimit_string(p) = Real_Domain1(i)
                p = p+1;
            end
        end
        
        if k == 1
            Real_Domain = [str2num(LowerLimit_string) str2num(UpperLimit_string)];
        end
        
        if k == 2
            Imaginary_Domain = [str2num(LowerLimit_string) str2num(UpperLimit_string)];
        end
    end
    
    DomainDivisions(1) = (Real_Domain(2) - Real_Domain(1))/200;
    DomainDivisions(2) = (Imaginary_Domain(2) - Imaginary_Domain(1))/200;
    Domains = [Real_Domain Imaginary_Domain];
    
    
    %% Reading Function
    % this detects all the absolute value terms
    q = 0;
    Asolute_Value_term_found = 0;
    
    for i = 1:length(Condition1)
        if Condition1(i) == '|'
            
            
            if q == 1
                Condition1(i) = ')';
                
                Asolute_Value_index(Asolute_Value_term_found,2) = i;
                q = 0;
                continue
            end
            if q == 0
                Condition1(i) = '(';
                q = 1;
                Asolute_Value_term_found = Asolute_Value_term_found + 1;
                Asolute_Value_index(Asolute_Value_term_found,1) = i;
            end
        end
        
    end
    
    
    % Adding "abs" string
    abs_String = 'abs';
    for t = 1:Asolute_Value_term_found 
        if Asolute_Value_term_found >1
            Abs_term = Asolute_Value_term_found -t + 1;
        end
        for i = 1:length(Condition1)
            if i == Asolute_Value_index(Abs_term,1)
                
                if i == 1
                                    Part2_of_string = i:length(Condition1);
                NewString_Condition1 = strcat(abs_String,Condition1(Part2_of_string));
                Condition1 = NewString_Condition1;
                end
                
                if i ~= 1
                Part1_of_string = 1:i-1;
                Part2_of_string = i:length(Condition1);
                NewString_Condition1 = strcat(Condition1(Part1_of_string),abs_String,Condition1(Part2_of_string));
                Condition1 = NewString_Condition1;
                end
            end
        end
    
    end
    
    
        %% For equals sign - use an epsilon
        epsilon = max(DomainDivisions(1),DomainDivisions(2));
    for i = 1:length(Condition1)
        if Condition1(i) == '='
            if Condition1(i-1) ~= '<'
                if Condition1(i-1) ~= '>'
            String1 = Condition1;
            String1(i) = '>';
            String1 = strcat('(',String1,'-',num2str(epsilon),').*')
            
            String2 = Condition1;
            String2(i) = '<';
             String2 = strcat('(',String2,'+',num2str(epsilon),')');
             Condition1 = strcat(String1,String2);
                end
            end
        end
    end
    
    
    Condition1_function1 = strcat('@(z) ',Condition1);
    
    
    
    
    Condition1_function = str2func(Condition1_function1);
    
    

   
    
    
    Condition_1_Name = Condition1;
    %Condition_2_Name = Condition2;
    
    
    Re_z1 = diag(Domains(1):DomainDivisions(1):Domains(2));
    Im_z1 = diag(Domains(3):DomainDivisions(2):Domains(4));
    Re_z = Re_z1*ones(length(Domains(1):DomainDivisions(1):Domains(2)),length(Domains(3):DomainDivisions(2):Domains(4)));
    Im_z = ones(length(Domains(1):DomainDivisions(1):Domains(2)),length(Domains(3):DomainDivisions(2):Domains(4)))*Im_z1;
    z = Re_z + 1i*Im_z;
    
    %Condition1_Output = Condition1_function(z);
    
    

    [x,y] = meshgrid(Domains(1):DomainDivisions(1):Domains(2),Domains(3):DomainDivisions(2):Domains(4));

    z = x+1i*y;
    Condition1_Output = Condition1_function(z);
    
   s1 = surf(x,y,double(Condition1_Output));
   s1.EdgeColor = 'none';
        s1.FaceColor = 'interp';
    view(0,90);
    colormap(copper)
    MainMenu = menu('Want to see another one?','Hell yeah!',' no thanks');
    if MainMenu == 0
        repeat = 0;
        break
    end
    if MainMenu == 2
        repeat = 0;
        break
    end
end