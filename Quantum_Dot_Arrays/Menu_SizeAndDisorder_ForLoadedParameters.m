function [SizeAndDisorder_parameters] = Menu_SizeAndDisorder_ForLoadedParameters(SizeAndDisorder_parameters)
repeat = 1;
EverythingTheSameAsLastTime = 0;

%[SizeAndDisorder_parameters] = Menu_Default_SizeAndDisorder_parameters_Generator()

while repeat == 1
    repeat = 0;
                WorkSpaceSelection = menu('Select Workspace (Number of dots, Disorder Configuration',...
                'Enter New Parameters',...
                'Same As Last Time',...
                'Load Workspace',...
                'Everything The Same As Last Experiment(And Start Experiment)',...
                'Go Back');
                
                if WorkSpaceSelection == 0
                end
                
                if WorkSpaceSelection == 1
                    prompt = {'Enter The Number of dots in X direction (Array Legnth)',...
                        'Enter The Number of dots in Y direction (Array Width):',...
                        'ChargeDisorder_Amlitude',...
                        'InterDot_Capaciatance_Disorder_Amplitude',...
                        'Gate_Capaciatance_Disorder_Amplitude',...
                        'TransitionPropability_Disorder_Amplitude',...
                        'Enter The Disorder Identifying Number (0 for new disorder)'};
                    dlg_title = 'System Parameters';
                    num_lines = 1;
                    defaultans = {'7','7','1','0.2','0.2','0.2','0'};
                    Answer = inputdlg(prompt,dlg_title,num_lines,defaultans);
                    
                    

                    NumberOfDotsInXDirrection = str2num(Answer{1});
                    NumberOfDotsInYDirrection = str2num(Answer{2});
                    NumberOfDots = NumberOfDotsInXDirrection;
                    Charge_Disorder_Amplitude = str2num(Answer{3});
                    InterDot_Capaciatance_Disorder_Amplitude = str2num(Answer{4});
                    Gate_Capaciatance_Disorder_Amplitude = str2num(Answer{5});
                    TransitionPropability_Disorder_Amplitude = str2num(Answer{6});
                    
                    
                    SizeAndDisorder_parameters
                    
                    InitialSystem = SizeAndDisorder_parameters.InitialSystem*(Charge_Disorder_Amplitude/SizeAndDisorder_parameters.Charge_Disorder_Amplitude);
                    Cg_Disorder = SizeAndDisorder_parameters.Cg_Disorder*(Gate_Capaciatance_Disorder_Amplitude/SizeAndDisorder_parameters.Gate_Capaciatance_Disorder_Amplitude);
                    
                    
              %      Cg_Disorder = zeros(length(InitialSystem)^2,1);
              %      n = 1;
              %      while n <= length(Cg_Disorder)
              %          index = ceil(rand(1,1)*(length(Cg_Disorder)));
              %          if Cg_Disorder(index) == 0
              %          Cg_Disorder(index) = exp(-3*((n-round(length(Cg_Disorder)/2))/length(Cg_Disorder))^2)-1;
              %          n = n + 1;
              %          end
              %      end
              %      for i = 1:round(length(Cg_Disorder)/2)
              %          Cg_Disorder(i) = - Cg_Disorder(i);
              %      end
              
                    %hist(Cg_Disorder)
                    %Cg_Disorder = exp(-(1*(SizeAndDisorder_parameters.Cg_Disorder)*((Gate_Capaciatance_Disorder_Amplitude/SizeAndDisorder_parameters.Gate_Capaciatance_Disorder_Amplitude)) - Gate_Capaciatance_Disorder_Amplitude).^2);
                    C_Disorder = 2*SizeAndDisorder_parameters.C_Disorder*(InterDot_Capaciatance_Disorder_Amplitude/SizeAndDisorder_parameters.InterDot_Capaciatance_Disorder_Amplitude);
                    TransitionDisorder = 1 + (SizeAndDisorder_parameters.TransitionDisorder-1)*(TransitionPropability_Disorder_Amplitude/SizeAndDisorder_parameters.TransitionPropability_Disorder_Amplitude);
                    
                    
                    
                  %  if strcmp(Answer(7),'0') == 1
                  %      InitialSystem = Charge_Disorder_Amplitude*rand(NumberOfDotsInXDirrection,NumberOfDotsInYDirrection);
                  %      Cg_Disorder = Gate_Capaciatance_Disorder_Amplitude*rand(NumberOfDots^2,1);
                  %      C_Disorder = (rand(size(CM))-0.5)*InterDot_Capaciatance_Disorder_Amplitude;
                  %      TransitionDisorder = 1 + 2*TransitionPropability_Disorder_Amplitude*(rand(4*NumberOfDots^2 - 2*NumberOfDots,1) - 0.5);
                        
                  %      DisorderNumberId = round(10000*rand(1,1));
                  %  end
                    WorkSpaceSelection = 2
                end
                
                
                if WorkSpaceSelection == 2
               Nx =   int2str(NumberOfDotsInXDirrection);
               Ny =   int2str(NumberOfDotsInYDirrection);
               DNI = SizeAndDisorder_parameters.DNI;
                ParametersDisplay = menu(['Nx = ',Nx,'  Ny = ',Ny,'  DisorderNumberId = ',DNI],'Ok','Change Parameters');
                if ParametersDisplay == 1
                end
                if ParametersDisplay == 2
                                        repeat = 1;
                end
                
                end
                
                if WorkSpaceSelection == 3
                    NameOfDataFile = uigetdir
                    disp(NameOfDataFile)
                    filename = uigetfile;
                    disp(filename)
                    SeperationSlash = '\';
                    FullFileName = strcat(NameOfDataFile,SeperationSlash,filename) ;
                    disp(FullFileName)
                    load(FullFileName)
                    
                    disp('Go Back (To Select a different folder)')
                    
                    CurrentMenuNumber = CurrentMenuNumber - 2
                    GoBack = 1;
                end
                
                if WorkSpaceSelection == 4
                    EverythingTheSameAsLastTime = 1;
                end
                
                
                if WorkSpaceSelection ~= 5
                field1 = 'Nx';
                value1 = Nx;
                field2 = 'Ny';
                value2 = Ny;
                field3 = 'DNI';
                value3 = DNI;
                field5 = 'Charge_Disorder_Amplitude';
                value5 = Charge_Disorder_Amplitude;
                field6 = 'InterDot_Capaciatance_Disorder_Amplitude';
                value6 = InterDot_Capaciatance_Disorder_Amplitude;
                field7 = 'Gate_Capaciatance_Disorder_Amplitude';
                value7 = Gate_Capaciatance_Disorder_Amplitude;
                field8 = 'TransitionPropability_Disorder_Amplitude';
                value8 = TransitionPropability_Disorder_Amplitude;
                field9 = 'InitialSystem';
                value9 =InitialSystem;
                field10 ='Cg_Disorder' ;
                value10 =Cg_Disorder;
                field11 ='C_Disorder';
                value11 =C_Disorder;
                field12 ='TransitionDisorder' ;
                value12 =TransitionDisorder  ;
                field13 = 'EverythingTheSameAsLastTime';
                value13 = EverythingTheSameAsLastTime;
                SizeAndDisorder_parameters = struct(field1,value1,field2,value2,field3,value3,...
                    field5,value5,field6,value6,field7,value7,field8,value8,...
                    field9,value9,field10,value10,field11,value11,field12,value12,field13,value13);
                end
end