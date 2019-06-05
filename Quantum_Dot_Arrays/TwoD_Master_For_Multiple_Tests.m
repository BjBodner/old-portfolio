

initial_C = 1;
Cg = 10;
%NumberOfDots = 7;
%InitialSystem = rand(NumberOfDots,NumberOfDots);
Loaded_Preset = 0;
OldLength = 1;
RecordPlotSystemVideo = 0;
RecordVideo = 1;


[MainMenu_Choice,Loaded_Preset] = Menu_Main(Loaded_Preset);
%[~,I] = max(MainMenu_Choice.ChoiceVector)
%[NumberOfDotsInXDirrection,NumberOfDotsInYDirrection,InitialSystem,EverythingTheSameAsLastTime] = Menu_LoadWorkspace()
%if EverythingTheSameAsLastTime == 0
%end
CCg_Averaging_Parameters = MainMenu_Choice.CCg_Averaging_Parameters;

Cg = CCg_Averaging_Parameters.Cg;
Cg = 100;
Initial_C = CCg_Averaging_Parameters.Initial_C;
Final_C = CCg_Averaging_Parameters.Final_C;
SizeAndDisorder_parameters = MainMenu_Choice.SizeAndDisorder_parameters;
%NumberOfDots = SizeAndDisorder_parameters.Nx;
a = SizeAndDisorder_parameters.Nx;
b = SizeAndDisorder_parameters.Ny;
if strcmp(class(a),'char') == 0
    NumberOfDots(1,1) = SizeAndDisorder_parameters.Nx;
    NumberOfDots(2,1) = SizeAndDisorder_parameters.Ny;
end
if strcmp(class(a),'char') == 1
    %   NumberOfDots = str2double(SizeAndDisorder_parameters.Nx);
    NumberOfDots(1,1) = str2double(SizeAndDisorder_parameters.Nx);
    NumberOfDots(2,1) = str2double(SizeAndDisorder_parameters.Ny);
end
InitialSystem = SizeAndDisorder_parameters.InitialSystem;
%InitialSystem
%InitialSystem(1:5)
%SizeAndDisorder_parameters.Cg_Disorder(1:5).'
%SizeAndDisorder_parameters.C_Disorder(1:5)
SizeAndDisorder_parameters.TransitionDisorder

%TransitionDisorder = SizeAndDisorder_parameters.TransitionDisorder;
%TransitionDisorder(2*NumberOfDots(1)*NumberOfDots(2) - NumberOfDots(2) + 1 : 3*NumberOfDots(1)*NumberOfDots(2) - NumberOfDots(2)-NumberOfDots(1)) = 0;
%TransitionDisorder(3*NumberOfDots(1)*NumberOfDots(2) - NumberOfDots(2)-NumberOfDots(1) + 1 : 4*NumberOfDots(1)*NumberOfDots(2) - NumberOfDots(2)-2*NumberOfDots(1)) = 0;
%TransitionDisorder(1:4) = 0.01;
%SizeAndDisorder_parameters.TransitionDisorder = TransitionDisorder;
%(MoveNumber= 2*NumberOfDots(1)*NumberOfDots(2) - NumberOfDots(2) + 1 : 3*NumberOfDots(1)*NumberOfDots(2) - NumberOfDots(2)-NumberOfDots(1))
SizeAndDisorder_parameters.TransitionDisorder
%SizeAndDisorder_parameters

Vg = 2;
DynamicStateframe = 1;
Dynamic_State_Movie = getframe(gcf);


for disorder = 1:1
    
    for RRg = 1:1
        if RRg == 1
        Ratio_Rc_Rg = 0;
        end
        if RRg == 2
            Ratio_Rc_Rg = 0.001;
        end
        if RRg == 3
            Ratio_Rc_Rg = 0.01;
        end
        if RRg == 4
            Ratio_Rc_Rg = 0.1;
        end
        
        Vg = 0;
    for Power = -8:-8
        Rg = 10^Power;
        TransitionDisorder = exp(SizeAndDisorder_parameters.TransitionDisorder - 1);
        Nx =  NumberOfDots(1);
        Ny =  NumberOfDots(2);
        
        TransitionDisorder(4*Nx*Ny +Ny - 2*Nx+1:6*Nx*Ny +Ny - 2*Nx) = Ratio_Rc_Rg*TransitionDisorder(4*Nx*Ny +Ny - 2*Nx+1:6*Nx*Ny +Ny - 2*Nx);
        
        SizeAndDisorder_parameters.TransitionDisorder = TransitionDisorder;
        
        %C_Disorder,Cg_Disorder
        
        %%CCg Changing Loop
        for TestNumber = 1:CCg_Averaging_Parameters.Number_Of_Logarithmic_Steps
            C = Initial_C*((Final_C/Initial_C)^(TestNumber/CCg_Averaging_Parameters.Number_Of_Logarithmic_Steps));
            % C = initial_C*(10^((TestNumber-1)/2))
            %% AveragingLoop
            for AveragingRun = 1:CCg_Averaging_Parameters.Number_of_Averaging_runs_at_Each_CCg
                SizeAndDisorder_parameters;
                SizeAndDisorder_parameters.TransitionDisorder;
                
                [Dynamic_State_Movie,DynamicStateframe,PlotSystemMovie] = TwoD_Full_Run(MainMenu_Choice,C,Cg,Vg,Rg,NumberOfDots,InitialSystem,DynamicStateframe,Dynamic_State_Movie,SizeAndDisorder_parameters);
            end
        end
        
        
    end
    
    if RecordPlotSystemVideo == 1
        v = VideoWriter('PlotSystemMovie High Voltage.avi','Uncompressed AVI');
        open(v)
        writeVideo(v,PlotSystemMovie)
        close(v)
    end
    
    
    

    
        if RRg == 1
        Ratio_Rc_Rg = 0;
            v = VideoWriter('Vg Sweep on One Dot System RRg 0.avi','Uncompressed AVI');
        end
        if RRg == 2
           % Ratio_Rc_Rg = 0.0001;
            v = VideoWriter('Vg Sweep on One Dot System RRg 0001.avi','Uncompressed AVI');
        end
        if RRg == 3
           % Ratio_Rc_Rg = 0.001;
            v = VideoWriter('Vg Sweep on One Dot System RRg 001.avi','Uncompressed AVI');
        end
        if RRg == 4
        %    Ratio_Rc_Rg = 0.01;
            v = VideoWriter('Vg Sweep on One Dot System RRg 01.avi','Uncompressed AVI');
        end
    
    
    
    
    Disordersweep = 0;
    if Disordersweep == 1
        
        SizeAndDisorder_parameters.TransitionDisorder
        SizeAndDisorder_parameters.TransitionDisorder = log(SizeAndDisorder_parameters.TransitionDisorder) + 1
        
        if disorder == 1
            v = VideoWriter('Energies Dominant.avi','Uncompressed AVI');
            SizeAndDisorder_parameters.InitialSystem = (0.1/SizeAndDisorder_parameters.Charge_Disorder_Amplitude)*SizeAndDisorder_parameters.InitialSystem;
            SizeAndDisorder_parameters.C_Disorder = (1/SizeAndDisorder_parameters.InterDot_Capaciatance_Disorder_Amplitude)*SizeAndDisorder_parameters.C_Disorder;
            SizeAndDisorder_parameters.Cg_Disorder = (0.1/SizeAndDisorder_parameters.Gate_Capaciatance_Disorder_Amplitude)*SizeAndDisorder_parameters.Cg_Disorder;
            SizeAndDisrorder_parameters.TransitionDisorder = (0.1/SizeAndDisorder_parameters.TransitionPropability_Disorder_Amplitude)*(SizeAndDisorder_parameters.TransitionDisorder-1) + 1;
        end
        
        if disorder == 2
            v = VideoWriter('Interdot C Dominant.avi','Uncompressed AVI');
            SizeAndDisorder_parameters.InitialSystem = (0.1/SizeAndDisorder_parameters.Charge_Disorder_Amplitude)*SizeAndDisorder_parameters.InitialSystem;
            SizeAndDisorder_parameters.C_Disorder = (0.1/SizeAndDisorder_parameters.InterDot_Capaciatance_Disorder_Amplitude)*SizeAndDisorder_parameters.C_Disorder;
            SizeAndDisorder_parameters.Cg_Disorder = (1/SizeAndDisorder_parameters.Gate_Capaciatance_Disorder_Amplitude)*SizeAndDisorder_parameters.Cg_Disorder;
            SizeAndDisorder_parameters.TransitionDisorder = (0.1/SizeAndDisorder_parameters.TransitionPropability_Disorder_Amplitude)*(SizeAndDisorder_parameters.TransitionDisorder-1) + 1;
        end
        if disorder == 3
            v = VideoWriter('Gate Cg Dominant.avi','Uncompressed AVI');
            SizeAndDisorder_parameters.InitialSystem = (0.1/SizeAndDisorder_parameters.Charge_Disorder_Amplitude)*SizeAndDisorder_parameters.InitialSystem;
            SizeAndDisorder_parameters.C_Disorder = (0.1/SizeAndDisorder_parameters.InterDot_Capaciatance_Disorder_Amplitude)*SizeAndDisorder_parameters.C_Disorder;
            SizeAndDisorder_parameters.Cg_Disorder = (0.1/SizeAndDisorder_parameters.Gate_Capaciatance_Disorder_Amplitude)*SizeAndDisorder_parameters.Cg_Disorder;
            SizeAndDisorder_parameters.TransitionDisorder = (2/SizeAndDisorder_parameters.TransitionPropability_Disorder_Amplitude)*(SizeAndDisorder_parameters.TransitionDisorder-1) + 1;
            SizeAndDisorder_parameters.TransitionDisorder = SizeAndDisorder_parameters.TransitionDisorder - max(SizeAndDisorder_parameters.TransitionDisorder) + 1;
        end
        if disorder == 4
            v = VideoWriter('Transition Dominant.avi','Uncompressed AVI');
        end
        
    end
    NewLength = length(Dynamic_State_Movie);
    
    
    open(v)
    writeVideo(v,Dynamic_State_Movie(OldLength:NewLength))
    close(v)
    
    OldLength = length(Dynamic_State_Movie);
    end
end