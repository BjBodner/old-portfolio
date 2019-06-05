function [SizeAndDisorder_parameters] = Menu_Default_SizeAndDisorder_parameters_Generator()
%NumberOfDotsInXDirrection = 7;
%NumberOfDotsInYDirrection = 7;


NumberOfDotsInXDirrection = 7;
NumberOfDotsInYDirrection = 7;

                        Nx = NumberOfDotsInXDirrection;
                        Ny = NumberOfDotsInYDirrection;

                DNI =      round(10000*rand(1,1));                  
               % InitialSystem = rand(NumberOfDotsInXDirrection,NumberOfDotsInYDirrection);
                EverythingTheSameAsLastTime = 0;
                
                NumberOfDots = NumberOfDotsInXDirrection;
                
                    Charge_Disorder_Amplitude = 1;
                    InterDot_Capaciatance_Disorder_Amplitude = 0.2;
                    Gate_Capaciatance_Disorder_Amplitude = 0.2;
                    TransitionPropability_Disorder_Amplitude = 0.2;
                                        InitialSystem = Charge_Disorder_Amplitude*rand(Nx,Ny);
                       % Cg_Disorder = Gate_Capaciatance_Disorder_Amplitude*rand(NumberOfDots^2,1);
                       % C_Disorder = (rand(NumberOfDots^2)-0.5)*InterDot_Capaciatance_Disorder_Amplitude;
                       % TransitionDisorder = 1 + 2*TransitionPropability_Disorder_Amplitude*(rand(4*NumberOfDots^2 - 2*NumberOfDots,1) - 0.5);
                        
                        Cg_Disorder = Gate_Capaciatance_Disorder_Amplitude*(rand(Nx*Ny,1)-0.5);
                        C_Disorder = (rand(Nx*Ny)-0.5)*InterDot_Capaciatance_Disorder_Amplitude;
                        for i = 1:length(C_Disorder)
                            for j = 1:length(C_Disorder)
                            C_Disorder(i,j) = C_Disorder(j,i);
                            end
                        end
                       % TransitionDisorder = 1 + 2*TransitionPropability_Disorder_Amplitude*(rand(4*Nx*Ny - 2*Nx,1) - 0.5);
                      %  TransitionDisorder = 1 + 2*TransitionPropability_Disorder_Amplitude*(rand(4*Nx*Ny - Nx,1) - 0.5);
                        
                                                TransitionDisorder = 1 + 2*TransitionPropability_Disorder_Amplitude*(rand(6*Nx*Ny +2*Ny - 2*Nx,1) - 0.5);
                        % Special Transition Rate for 
                        Ratio_Rc_Rg = 0.001;
                        TransitionDisorder(4*Nx*Ny +Ny - 2*Nx+1:6*Nx*Ny +Ny - 2*Nx) = Ratio_Rc_Rg*TransitionDisorder(4*Nx*Ny +Ny - 2*Nx+1:6*Nx*Ny +Ny - 2*Nx);
                        
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