%{
MainMenu = menu(sprintf('Welcome to the Complex Function Plotter \n \n Remember to add a period before each devision, multiplication or power operation'),'Ok I will remember that');

%% Choose Default initial templates

%% exp(x)

function1 = 'x.^k'
function2 = '1./factorial(k)'


%% cos(x)

function1 = 'x.^(2*k)'
function2 = '((-1).^2*k)*1./factorial(2*k)'

%% sin(x)

function1 = 'x.^(2*k+1)'
function2 = '((-1).^k)*1./factorial(2*k+1)'



prompt = {'Enter a complex function (after the @(z)):',...
    'What domain do you want for the real numbers?'...
    'What domain do you want for the imaginary numbers?'};
dlg_title = 'Complex Function Plotter';
num_lines = 1;
defaultans = {'@(z) z.^2','[-1 to 1]','[-1 to 1]'};
Answer = inputdlg(prompt,dlg_title,num_lines,defaultans);


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
    %}
Real_Domain(1) = -3;
Real_Domain(2) = 3;

function1 = 'x.^(2*k+1)';
function2 = '((-1).^k)*1./factorial(2*k+1)';
    DomainDivisions(1) = (Real_Domain(2) - Real_Domain(1))/20;
    
    HighestPowerOfK = 10;
    x = diag(Real_Domain(1):DomainDivisions(1):Real_Domain(2));
    k = diag(0:HighestPowerOfK);
    x = ones(length(k),length(x))*x;
    k = k*ones(length(k),length(x));
Function_of_x = str2func(strcat('@(x,k) ',function1));
Coefficients_of_Function_of_x = str2func(strcat('@(k) ',function2));

SeriesFunction = sum(Coefficients_of_Function_of_x(k).*Function_of_x(x,k));

plot(x,SeriesFunction)
