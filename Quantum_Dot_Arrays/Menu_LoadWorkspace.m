function [NumberOfDotsInXDirrection,NumberOfDotsInYDirrection,InitialSystem,EverythingTheSameAsLastTime] = Menu_LoadWorkspace()
repeat = 1;
EverythingTheSameAsLastTime = 0;
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
                        'Enter The Disorder Identifying Number (0 for new disorder)'};
                    dlg_title = 'System Parameters';
                    num_lines = 1;
                    defaultans = {'7','7','0'};
                    Answer = inputdlg(prompt,dlg_title,num_lines,defaultans);
                    
                    NumberOfDotsInXDirrection = str2num(Answer{1});
                    NumberOfDotsInYDirrection = str2num(Answer{2});
                    if strcmp(Answer(3),'0') == 1
                        InitialSystem = rand(NumberOfDotsInXDirrection,NumberOfDotsInYDirrection);
                        DisorderNumberId = round(10000*rand(1,1));
                    end
                    WorkSpaceSelection = 2
                end
                
                
                if WorkSpaceSelection == 2
               Nx =   int2str(NumberOfDotsInXDirrection);
               Ny =   int2str(NumberOfDotsInYDirrection);
               DNI = int2str(DisorderNumberId);
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
                
end