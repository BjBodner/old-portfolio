

%% This is a matlab program that plots complex functions in 2 ways:
%% One Method - plots the real and imaginary parts of the function as two surfaces above the complex plain.
%% Second Method - plots the ral and imaginary parts of the function as a vector field on the complex plain. 
%% 
%% Press "run" and use the menu to navigate
%% Dont forget to  add a period before each devision, multiplication or power operation
%% Enjoy!


MainMenu = menu(sprintf('Welcome to the Complex Function Plotter \n \n Remember to add a period before each devision, multiplication or power operation'),'Ok I will remember that');

f = figure;
repeat =1;
while repeat == 1
prompt = {'Enter a complex function (after the @(z)):',...
    'What domain do you want for the real numbers?'...
    'What domain do you want for the imaginary numbers?'};
dlg_title = 'Complex Function Plotter';
num_lines = 1;
defaultans = {'@(z) z.^2','[-1 to 1]','[-1 to 1]'};
Answer = inputdlg(prompt,dlg_title,num_lines,defaultans);

Numerator = Answer{1};
Real_Domain1 = Answer{2};
Imaginary_Domain1 = Answer{3};



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

DomainDivisions(1) = (Real_Domain(2) - Real_Domain(1))/30;
DomainDivisions(2) = (Imaginary_Domain(2) - Imaginary_Domain(1))/30;
Domains = [Real_Domain Imaginary_Domain];


%% Reading Function
% this is for only numerator expression
    f = str2func(Numerator);


%f =@(z) 1./(z);
%Domains = [-1 1 -1 1];
%DomainDivisions = [0.1 0.1];
Plot_QuiverPlot= 0;
Plot_DoubleSurface = 0;
Plot_DoublePlot= 1;


FunctionName1 = func2str(f)
FunctionName = FunctionName1(5:length(FunctionName1));
Re_z1 = diag(Domains(1):DomainDivisions(1):Domains(2));
Im_z1 = diag(Domains(3):DomainDivisions(2):Domains(4));
Re_z = Re_z1*ones(length(Domains(1):DomainDivisions(1):Domains(2)),length(Domains(3):DomainDivisions(2):Domains(4)));
Im_z = ones(length(Domains(1):DomainDivisions(1):Domains(2)),length(Domains(3):DomainDivisions(2):Domains(4)))*Im_z1;
z = Re_z + 1i*Im_z;

RealPart_f = real(f(z));
ImaginaryPart_f = imag(f(z));

RealPart_f = RealPart_f.*(RealPart_f ~= inf);
ImaginaryPart_f = ImaginaryPart_f.*(ImaginaryPart_f ~= inf);

if Plot_DoubleSurface == 1
    figure
    
    s1 = surf(Re_z,Im_z,RealPart_f);
    s1.FaceAlpha = 0.5;
    s1.EdgeColor = 'none';
    colormap(jet);
    hold on
    
    s2 = surf(Re_z,Im_z,ImaginaryPart_f);
    s2.FaceAlpha = 0.5;
    s2.EdgeColor = 'none';
    set(s1,'CData', RealPart_f+1 );
    set(s2,'CData',ImaginaryPart_f -3)
    hold off
    
end

if Plot_QuiverPlot == 1
    figure
    quiver(Re_z,Im_z,RealPart_f,ImaginaryPart_f)
end


if Plot_DoublePlot == 1
    
    
    for t = 1:150
        ax1 = subplot(1,2,1);
        
        
        s1 = surf(ax1,Re_z,Im_z,RealPart_f);
        s1.FaceAlpha = 0.5;
        s1.EdgeColor = 'none';
        s1.FaceColor = 'interp';
        colormap(jet);
        hold on
        
        s2 = surf(ax1,Re_z,Im_z,ImaginaryPart_f);
        s2.FaceAlpha = 0.5;
        s2.EdgeColor = 'none';
        s2.FaceColor = 'interp';
        set(s1,'CData', RealPart_f+1 );
        set(s2,'CData',ImaginaryPart_f -3)
        hold off
        
        xlabel(ax1,'Re(z)')
        ylabel(ax1,'Im(z)')
        str1 = 'Double Surface Representation of: f =  ';
        str2 = FunctionName;
        str3 = strcat(str1,str2);
        title(ax1,{ str3, 'Real Part in Red, Imaginary Part in Blue'})
        
        view(ax1,45+t/3,15+10*sin(t/30))
        
        
        ax2 = subplot(1,2,2);
        quiver(ax2,Re_z,Im_z,RealPart_f,ImaginaryPart_f)
        xlabel(ax2,'Re(z)')
        ylabel(ax2,'Im(z)')
        xlim([Domains(1)-0.1 Domains(2)+0.1]);
        ylim([Domains(3)-0.1 Domains(4)+0.1]);
        str1 = 'Vector Field Representation of: f =  ';
        str2 = FunctionName;
        str3 = strcat(str1,str2);
        title(ax2,{str3, 'Real Part in X direction, Imaginary Part in Y direction'})
        
        
        %   f = getframe(gcf);
        %   f.Units='normalized';
        %   f.OuterPosition=[0 0 1 1];
        %% This Opens it to full Screen
        FullScreen = 1;
        if FullScreen == 1
            fig=gcf;
            fig.Units='normalized';
            fig.OuterPosition=[0 0 1 1];
        end
        f1(t) = getframe(gcf);
    end
end


choice4 = menu(sprintf('Do you want to save this video, as an AVI file? \n \n \n (the video will be named: "Complex Function Video.avi", and will be save in the current folder)'),'Yes','No');


    if choice4 ==1
        v = VideoWriter('Complex Function Video.avi','Uncompressed AVI');
        open(v)
        writeVideo(v,f1)
        close(v)
    end
    if choice4 ==2
        M = 0;
    end


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